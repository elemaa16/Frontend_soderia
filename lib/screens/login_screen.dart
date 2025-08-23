import 'dart:math';
import 'package:frontend_soderia/services/auth_service.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Clave del formulario
  final _formKey = GlobalKey<FormState>();

  //Controlador para el campo del usuario
  final _usuarioController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _loading = false; 
  bool _mostrarPassword = false; 


  @override
  void Dispose() {
    _usuarioController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Lado izquierdo (fondo verde)
          Expanded(
            flex: 1,
            child: Container(
              color: const Color(0xFF6BBF59), // Verde suave
              child: const Center(
                child: Text(
                  'SAN MIGUEL',
                  style: TextStyle(
                    fontSize: 36,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          // Lado derecho (fondo blanco)
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Campo usuario (próximo paso)
                      TextFormField(
                        controller: _usuarioController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre de usuario',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Por favor ingresa tu nombre de usuario';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_mostrarPassword, // 👈 Alterna según el estado
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _mostrarPassword ? Icons.visibility_off : Icons.visibility,
                            ),

                            onPressed: () {
                              setState(() {
                                _mostrarPassword = !_mostrarPassword;
                              });
                            },
                          ),
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Por favor ingresa tu contraseña';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.login),
                          label: const Text('Iniciar sesión'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () async {
                            final isValid = _formKey.currentState?.validate() ?? false;
                            if (!isValid) return;

                            setState(() => _loading = true);

                            final usuario = _usuarioController.text.trim();
                            final password = _passwordController.text.trim();

                            final success = await _authService.login(usuario, password);

                            setState(() => _loading = false);

                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('¡Login exitoso, $usuario!')),
                              );
                              //TODO: Navegar al HOME
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Credenciales inválidas')),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
