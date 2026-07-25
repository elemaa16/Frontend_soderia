import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';

import '../data/local/app_database.dart';
import '../data/local/daos/sync_queue_dao.dart';
import '../core/net/api_client.dart';
import 'package:flutter/foundation.dart'; // debugPrint

class SyncService {
  final AppDatabase db;
  final SyncQueueDao queueDao;
  final Dio _dio = ApiClient.dio;

  bool _isSyncing = false;

  SyncService({required this.db, required this.queueDao});

  Future<void> syncPendientes() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      await queueDao.resetHuerfanas();
      final pendientes = await queueDao.getPending();
      for (final op in pendientes) {
        await _procesarOperacion(op);
      }
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _procesarOperacion(SyncQueueData op) async {
    try {
      await queueDao.markSyncing(op.id);

      debugPrint(
        '🔄 [SYNC] op #${op.id} tipo=${op.entityType} '
        'action=${op.action} entityLocalId=${op.entityLocalId}',
      );
      debugPrint('🔄 [SYNC] payload=${op.payloadJson}');

      final payload = jsonDecode(op.payloadJson);

      switch (op.entityType) {
        case 'pago':
          await _syncPago(op, payload);
          break;
        case 'visita':
          await _syncVisita(op, payload);
          break;
        case 'pedido':
          await _syncPedido(op, payload);
          break;
        default:
          throw Exception('Tipo no soportado: ${op.entityType}');
      }

      await queueDao.markSynced(op.id);
      debugPrint('✅ [SYNC] op #${op.id} OK');
    } catch (e, st) {
      debugPrint('❌ [SYNC] op #${op.id} FALLÓ: $e');
      debugPrint('❌ [SYNC] stack: $st');
      await queueDao.markError(op.id, e.toString());
    }
  }

  // -----------------------------
  // PAGO
  // -----------------------------
  Future<void> _syncPago(SyncQueueData op, Map<String, dynamic> payload) async {
    final resp = await _dio.post(
      '/pagos',
      data: payload,
      options: Options(
        headers: {'Idempotency-Key': payload['idempotency_key']},
      ),
    );

    final serverId = resp.data['id_pago'];

    await (db.update(
      db.pagosLocales,
    )..where((t) => t.localUuid.equals(op.entityLocalId))).write(
      PagosLocalesCompanion(
        serverId: Value(serverId),
        estadoSync: const Value('SYNCED'),
      ),
    );
  }

  // -----------------------------
  // VISITA
  // -----------------------------
  Future<void> _syncVisita(
    SyncQueueData op,
    Map<String, dynamic> payload,
  ) async {
    final legajo = payload['legajo'];
    final resp = await _dio.post(
      '/visitas/$legajo',
      data: payload,
      options: Options(
        headers: {'Idempotency-Key': payload['idempotency_key']},
      ),
    );

    final serverId = resp.data['id_visita'];

    await (db.update(
      db.visitasLocales,
    )..where((t) => t.localUuid.equals(op.entityLocalId))).write(
      VisitasLocalesCompanion(
        serverId: Value(serverId),
        estadoSync: const Value('SYNCED'),
      ),
    );
  }

  // -----------------------------
  // PEDIDO
  // -----------------------------
  Future<void> _syncPedido(
    SyncQueueData op,
    Map<String, dynamic> payload,
  ) async {
    try {
      // 1) CREAR (idempotente en backend por idempotency_key: si ya existía,
      //    devuelve el mismo pedido con 200).
      debugPrint('📤 [PEDIDO] POST /pedidos/ body=${jsonEncode(payload)}');
      final respCrear = await _dio.post(
        '/pedidos/',
        data: payload,
        options: Options(
          headers: {'Idempotency-Key': payload['idempotency_key']},
        ),
      );
      final idPedido = respCrear.data['id_pedido'];
      debugPrint(
        '📥 [PEDIDO] creado id=$idPedido status=${respCrear.statusCode}',
      );

      // 2) CONFIRMAR (idempotente tras el fix del backend: si ya estaba
      //    confirmado devuelve 200 sin re-aplicar deuda/stock/envases/pago).
      final respConf = await _dio.post(
        '/pedidos/$idPedido/confirmar',
        data: {
          'id_repartodia': payload['id_repartodia'],
          if (payload['envases'] != null) 'envases': payload['envases'],
        },
      );
      debugPrint(
        '📥 [PEDIDO] confirmado id=$idPedido status=${respConf.statusCode}',
      );

      // 3) Marcar local como sincronizado
      await (db.update(
        db.pedidosLocales,
      )..where((t) => t.localUuid.equals(op.entityLocalId))).write(
        PedidosLocalesCompanion(
          serverId: Value(idPedido),
          estadoSync: const Value('SYNCED'),
        ),
      );
    } on DioException catch (e) {
      debugPrint(
        '🛑 [PEDIDO] Dio status=${e.response?.statusCode} body=${e.response?.data}',
      );
      rethrow; // que _procesarOperacion lo marque ERROR con el body visible
    }
  }
}
