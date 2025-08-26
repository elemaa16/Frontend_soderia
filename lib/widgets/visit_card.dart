import 'package:flutter/material.dart';

class VisitCard extends StatelessWidget {
  final String nombre;
  final String direccion;
  final bool visitado;

  const VisitCard({
    super.key,
    required this.nombre,
    required this.direccion,
    required this.visitado,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: visitado ? const Color(0xFFE0F7FA) : Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: visitado ? Colors.green : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nombre,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.location_on, size: 18, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    direccion,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: visitado ? Colors.green : Colors.orange,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                visitado ? 'Visitado' : 'Pendiente',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
