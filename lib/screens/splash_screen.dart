import 'package:flutter/material.dart';
import 'package:frontend_soderia/screens/home_screen.dart';
import 'package:frontend_soderia/screens/login_screen.dart';
import 'package:frontend_soderia/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkToken();
  }
  
  Future<void> _checkToken() async {
    final token = await AuthService().getToken();

    if (token != null && token.isNotEmpty) {
      // Token valido -> ir a Home
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()), //Cambiar por HomeScreen cuando exista
      );
    } else {
      // No hay token -> Ir al inicio
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(),)
    );
  }
}