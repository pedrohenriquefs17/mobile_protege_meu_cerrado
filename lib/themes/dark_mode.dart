import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  colorScheme: const ColorScheme.dark(
    surface: Color.fromARGB(255, 24, 24, 24),
    primary: Color(0xFFF9E547), 
    secondary: Color.fromARGB(255, 30, 30, 30), 
    tertiary: Color.fromARGB(255, 47, 47, 47), 
    inversePrimary: Color.fromARGB(255, 255, 255, 255), 
  ),
  cardTheme: const CardTheme(
    color: Color.fromARGB(255, 40, 40, 40),
    elevation: 4,
  ),
);