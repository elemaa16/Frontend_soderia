import 'package:flutter/material.dart';
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
      home: const LoginScreen(), // 👈 Este es el punto clave
    );
  }
}


