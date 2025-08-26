import 'package:flutter/material.dart';
import 'package:frontend_soderia/widgets/day_filter_buttons.dart';
import 'package:frontend_soderia/widgets/visit_card.dart';

class HomeScreen extends StatelessWidget {
  final String nombreUsuario;

  const HomeScreen({super.key, required this.nombreUsuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      body: Row(
        children: [
          // Menu lateral para tablets (opcional en celualres)
          if (MediaQuery.of(context).size.width >= 600) _buildDrawer(context),

          // Contenido principal
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Hola, $nombreUsuario!',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const DayFilterButtons(), // 👈 los botones que creamos
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView(
                      children: const [
                        VisitCard(
                          nombre: 'Emmanuel Quintana Fattor',
                          direccion: 'Juan de Lamadrid 1778',
                          visitado: true,
                        ),
                        VisitCard(
                          nombre: 'Gastón Brondani',
                          direccion: 'Calle Falsa 123',
                          visitado: false,
                        ),
                        VisitCard(
                          nombre: 'Tamara Silva',
                          direccion: 'Miller 1725',
                          visitado: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildDrawer(BuildContext context) {
  return Drawer(
    width: 250,
    child: ListView(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      children: [
        const Text(
          'Dashboard',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        _buildMenuItem(Icons.home, 'Inicio'),
        _buildMenuItem(Icons.calendar_today, 'Ver calendario'),
        _buildMenuItem(Icons.bar_chart, 'Reportes'),
        _buildMenuItem(Icons.group_add, 'Agregar usuarios'),
        _buildMenuItem(Icons.person_add_alt_1, 'Agregar cliente'),
        const Divider(),
        _buildMenuItem(Icons.logout, 'Cerrar sesión'),
      ],
    ),
  );
}

Widget _buildMenuItem(IconData icon, String text) {
  return ListTile(
    leading: Icon(icon),
    title: Text(text),
    onTap: () {
      // TODO: Accion al tocar el item
    },
  );
}

/* AppBar(
  title: const Text('Inicio'),
  actions: [
    IconButton(
      icon: const Icon(Icons.logout),
      onPressed: () async {
        await AuthService().logout();

        // Navegar de vuelta al login (y reemplazar el stack)
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      },
    ),
  ],
), */
