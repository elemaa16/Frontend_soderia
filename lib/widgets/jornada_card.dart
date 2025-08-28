import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JornadaCard extends StatelessWidget {
  final DateTime fecha;
  final List<String> nombres;

  const JornadaCard({
    super.key,
    required this.fecha,
    required this.nombres,
  });

  @override
  Widget build(BuildContext context) {
    final diaSemana = DateFormat.E('es_AR').format(fecha).toUpperCase();
    final numeroDia = fecha.day.toString();
    final mes = DateFormat.MMM('es_AR').format(fecha).toUpperCase();

    // Tomamos hasta 6 nombres visibles
    final visibles = nombres.take(6).toList();
    final restantes = nombres.length - visibles.length;

    // Separar en dos columnas (pares / impares)
    final columna1 = <String>[];
    final columna2 = <String>[];
    for (int i = 0; i < visibles.length; i++) {
      if (i.isEven) {
        columna1.add(visibles[i]);
      } else {
        columna2.add(visibles[i]);
      }
    }

    // Construimos filas (cada fila = 2 columnas de nombres)
    final filas = List<Widget>.generate(
      columna1.length,
      (i) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 40),
        child: Row(
          children: [
            Expanded(
              child: Text(columna1[i], style: _estiloNombre()),
            ),
            Expanded(
              child: columna2.length > i
                  ? Text(columna2[i], style: _estiloNombre())
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF3C5663),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 📅 Bloque de fecha
          SizedBox(
            width: 70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,   // centra vertical
              crossAxisAlignment: CrossAxisAlignment.center, // centra horizontal
              children: [
                Text(diaSemana, style: _estiloFechaTexto()),
                Text(numeroDia, style: _estiloFechaNumero()),
                Text(mes, style: _estiloFechaTexto()),
              ],
            ),
          ),

          // | Separador
          Container(
            width: 1,
            height: 90,
            // ignore: deprecated_member_use
            color: Colors.white.withOpacity(0.6),
            margin: const EdgeInsets.symmetric(horizontal: 12),
          ),

          // 👥 Nombres (dos columnas)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: filas,
            ),
          ),

          // ℹ️ Restantes + botón ➕ (columna derecha)
          SizedBox(
            width: 90,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (restantes > 0)
                  Text(
                    '$restantes más...',
                    style: const TextStyle(color: Colors.white70),
                    textAlign: TextAlign.right,
                  ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                  onPressed: () {
                    // TODO: acción para agregar cliente a este día
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _estiloFechaTexto() => const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      );

  TextStyle _estiloFechaNumero() => const TextStyle(
        fontSize: 44, // un poco más grande
        color: Colors.white,
        fontWeight: FontWeight.bold,
      );

  TextStyle _estiloNombre() => const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
      );
}
