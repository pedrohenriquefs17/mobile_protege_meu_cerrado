import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  fontFamily: 'MavenPro', // Fonte principal
  colorScheme: const ColorScheme.dark(
    surface: Color(0xFF181818), // Fundo preto suave
    primary: Color(0xFFF9E547), // Amarelo para destaques
    secondary: Color(0xFFBCE4ED), // Azul claro para elementos secundários
    tertiary: Color(0xFF2F2F2F), // Cinza para componentes (backgrounds suaves)
    inversePrimary: Color(0xFFFFFFFF), // Branco para textos
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFF9E547)),
    bodyLarge: TextStyle(fontSize: 16, color: Color(0xFFBCE4ED)), // Texto padrão em azul claro
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF181818)), // Botões
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF2F2F2F), // Fundo do AppBar
    foregroundColor: Color(0xFFF9E547), // Ícones e textos em amarelo
    elevation: 2,
  ),
  cardTheme: const CardTheme(
    color: Color(0xFF2F2F2F), // Fundo do Card em cinza escuro
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xFFF9E547), // Amarelo para botões
    textTheme: ButtonTextTheme.primary,
  ),
);
