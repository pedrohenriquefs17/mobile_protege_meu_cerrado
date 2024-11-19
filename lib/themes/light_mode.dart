import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: const ColorScheme.light(
    surface:  Color.fromARGB(255, 255, 255, 255), // Fundo branco
    primary:  Color.fromARGB(255, 6, 145, 20), 
    secondary:  Color.fromARGB(255, 245, 245, 245), // Cinza muito claro
    tertiary:  Color.fromARGB(255, 240, 240, 240), // Um pouco mais escuro que o secundário
    inversePrimary: Colors.black, // Texto escuro para contraste
  ),
  cardTheme: const CardTheme(
    color: Color.fromARGB(255, 255, 255, 255), // Cartões brancos
    elevation: 4,
  ),
);