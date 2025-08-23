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
