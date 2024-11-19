import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  fontFamily: 'MavenPro',
  colorScheme: const ColorScheme.light(
    surface: Color(0xFFFFFFFF),
    primary: Color(0xFF38B887), 
    secondary: Color(0xFFBCE4ED), 
    tertiary: Color(0xFFF5F5F5), 
    inversePrimary: Color(0xFF5B7275), 
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF127351)),
    bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF5B7275)), // Texto padrão
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white), // Botões
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF38B887), // Verde claro
    foregroundColor: Colors.white, // Ícones e textos em branco
    elevation: 2,
  ),
  cardTheme: const CardTheme(
    color: Color(0xFF127351), // Verde escuro
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xFF38B887), // Verde claro
    textTheme: ButtonTextTheme.primary,
  ),
);

/*
Cores que estão no PDF:
Principais
Verde Claro: #38B887
Verde Escuro: #127351
Branco: #FFFFFF
Cores de Apoio:
Cinza Escuro: #5B7275
Azul Claro: #BCE4ED

Fontes:
Maven Pro
Daincing Script
*/
