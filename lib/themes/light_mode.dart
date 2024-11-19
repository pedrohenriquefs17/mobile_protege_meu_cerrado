import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: const ColorScheme.light(
    surface: Color(0xFFFFFFFF), //fundo
    primary: Color(0xFF38B887), //cor principal
    secondary: Color.fromARGB(255, 245, 245, 245), //cor secundária
    tertiary: Color.fromARGB(255, 240, 240, 240), //cor terciária
    inversePrimary: Colors.black, //cor do texto
  ),
  cardTheme: const CardTheme(
    color: Color(0xFF127351),
    elevation: 4,
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
