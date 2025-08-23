import 'package:flutter/material.dart';

final ThemeData soderiaTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF6BBF59), // Verde base
  ),
  useMaterial3: true,
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
    contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
    labelStyle: TextStyle(fontSize: 16),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(fontSize: 18),
    titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF6BBF59),
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 18),
      textStyle: TextStyle(fontSize: 18),
      )
  )
);