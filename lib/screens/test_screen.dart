import 'package:flutter/material.dart';
import 'package:frontend_soderia/widgets/jornada_card.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFAFC2E5),
      appBar: AppBar(
        title: const Text('Test JornadaCard'),
        backgroundColor: Colors.blueGrey.shade900,
      ),
      body: ListView(
        padding: const EdgeInsets.all(70),
        children: [
          JornadaCard(
            fecha: DateTime(2025, 5, 1),
            nombres: const [
              'Silva Tamara',
              'Kreitzer Bernardo',
              'Brondani Gaston',
              'Quintana Emmanuel',
              'Luna Tristan',
              'Abasto Facundo',
              'Cliente Extra 1',
              'Cliente Extra 2',
              'Cliente Extra 3',
              'Cliente Extra 4',
              'Cliente Extra 5',
              'Cliente Extra 6',
            ],
          ),
          JornadaCard(
            fecha: DateTime(2025, 5, 2),
            nombres: const [
              'Emilio Fouces',
              'Ernesto Zapata',
              'Franco Colaspinto',
              'Fernando Filipuzzi',
              'Francisco Rodriguez',
              'Facundo Fumaneri',
              'Cliente 7',
              'Cliente 8',
            ],
          ),
        ],
      ),
    );
  }
}
