import 'package:flutter/material.dart';
// import 'package:frontend_soderia/screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'core/theme.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const FrontendSoderiaApp());
}

class FrontendSoderiaApp extends StatelessWidget {
  const FrontendSoderiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sodería',
      debugShowCheckedModeBanner: false,
      theme: soderiaTheme,
      //home: const SplashScreen(), //👈 Este es el punto clave
      home: const HomeScreen(nombreUsuario: 'Emmanuel'),
      //home: const LoginScreen(), // 👈 Usamos esta pantalla por ahora
    );
  }


}


