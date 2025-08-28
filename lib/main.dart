import 'package:flutter/material.dart';
import 'package:frontend_soderia/screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'core/theme.dart';
import 'screens/login_screen.dart';
import 'package:frontend_soderia/screens/test_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized(); // Asegura que todo esté listo
  await initializeDateFormatting('es_AR', null); // 👈 Esto inicializa el locale
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
      //home: const HomeScreen(nombreUsuario: 'Emmanuel'),
      //home: const LoginScreen(), // 👈 Usamos esta pantalla por ahora
      home: const TestScreen(),
    );
  }


}


