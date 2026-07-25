import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' show Value;

import '../data/local/app_database.dart';
import '../data/local/daos/sync_queue_dao.dart';

class PedidoRepository {
  final AppDatabase db;
  final SyncQueueDao queueDao;
  final Uuid _uuid = const Uuid();

  PedidoRepository({required this.db, required this.queueDao});

  Future<String> crearPedidoOffline({
    required int legajo,
    required int idCuenta,
    required int idRepartoDia,
    required int idMedioPago,
    required double montoTotal,
    required double montoAbonado,
    required List<Map<String, dynamic>> items,
    List<Map<String, dynamic>> envases = const [],
    String? observacion,
    int? userId,
    String? deviceId,
  }) async {
    final localUuid = _uuid.v4();
    final now = DateTime.now();

    // Estado local provisional. El backend lo recalcula en /confirmar;
    // esto es solo para que la UI muestre algo coherente hasta el bootstrap.
    final estadoLocal = montoAbonado <= 0
        ? 'pendiente'
        : (montoAbonado >= montoTotal ? 'abonado' : 'abonado parcialmente');

    await db.transaction(() async {
      // 1. Guardar pedido
      await db.into(db.pedidosLocales).insert(
            PedidosLocalesCompanion.insert(
              localUuid: localUuid,
              legajo: legajo,
              idCuenta: idCuenta,
              idRepartoDia: idRepartoDia,
              idMedioPago: idMedioPago,
              montoTotal: montoTotal,
              montoAbonado: Value(montoAbonado),
              estado: estadoLocal,
              fecha: now,
              observacion: Value(observacion),
            ),
          );

      // 2. Guardar items
      for (final item in items) {
        await db.into(db.pedidoItemsLocales).insert(
              PedidoItemsLocalesCompanion.insert(
                pedidoLocalUuid: localUuid,
                idProducto: Value(item['id_producto'] as int?),
                idCombo: Value(item['id_combo'] as int?),
                cantidad: (item['cantidad'] as num).toDouble(),
                precioUnitario: (item['precio_unitario'] as num).toDouble(),
              ),
            );
      }

      // 3. Deuda/saldo local (provisional; el bootstrap del cliente lo
      //    pisa con el valor real del server tras sincronizar). Replica
      //    aproximadamente lo que hace el backend al confirmar: primero
      //    carga la compra consumiendo saldo, luego aplica el pago.
      final cliente = await (db.select(db.clientesLocal)
            ..where((t) => t.legajo.equals(legajo)))
          .getSingleOrNull();

      if (cliente != null) {
        var saldo = cliente.saldo;
        var deuda = cliente.deuda;

        if (saldo >= montoTotal) {
          saldo -= montoTotal;
        } else {
          deuda += (montoTotal - saldo);
          saldo = 0;
        }
        if (montoAbonado <= deuda) {
          deuda -= montoAbonado;
        } else {
          saldo += (montoAbonado - deuda);
          deuda = 0;
        }

        await (db.update(db.clientesLocal)
              ..where((t) => t.legajo.equals(legajo)))
            .write(ClientesLocalCompanion(
          deuda: Value(deuda),
          saldo: Value(saldo),
          updatedAt: Value(now),
        ));
      }

      // 4. Encolar sync con payload COMPLETO (crear + confirmar).
      await queueDao.enqueue(
        localOperationId: _uuid.v4(),
        entityType: 'pedido',
        entityLocalId: localUuid,
        action: 'CREATE',
        payloadJson: jsonEncode({
          'client_uuid': localUuid,
          'idempotency_key': localUuid,
          'id_empresa': 1,
          'legajo': legajo,
          'id_cuenta': idCuenta,
          'id_repartodia': idRepartoDia,
          'id_medio_pago': idMedioPago,
          'fecha': now.toIso8601String(),
          'monto_total': montoTotal,
          'monto_abonado': montoAbonado,
          'observacion': observacion,
          'items': items,
          if (envases.isNotEmpty) 'envases': envases,
        }),
        idempotencyKey: localUuid,
        userId: userId,
        deviceId: deviceId,
      );
    });

    return localUuid;
  }
}