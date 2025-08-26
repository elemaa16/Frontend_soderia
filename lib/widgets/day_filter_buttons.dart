import 'package:flutter/material.dart';

class DayFilterButtons extends StatefulWidget {
  const DayFilterButtons({super.key});

  @override
  State<DayFilterButtons> createState() => _DayFilterButtonsState();
}

class _DayFilterButtonsState extends State<DayFilterButtons> {
  // Día seleccionado
  String selected = 'Hoy';

  final List<String> opciones = ['Hoy', 'Mañana', 'Ayer', 'Todos'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var opcion in opciones)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  selected = opcion;
                });
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: selected == opcion ? Colors.black : null,
                side: const BorderSide(color: Colors.black),
              ),
              child: Text(
                opcion,
                style: TextStyle(
                  color: selected == opcion ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        // Boton con icono "+"
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: OutlinedButton(
            onPressed: () {
              // TODO: accion del boton "+"
            },
            style: OutlinedButton.styleFrom(
              shape: const CircleBorder(),
              side: const BorderSide(color: Colors.black),
              padding: const EdgeInsets.all(12),
            ),
            child: const Icon(Icons.add, color: Colors.black),
          ),
        ),
      ],
    );
  }
}
