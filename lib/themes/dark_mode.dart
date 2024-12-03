import 'package:flutter/material.dart';

class AppColors {
  static const Color verdeClaro = Color(0xFF38B887);
  static const Color verdeEscuro = Color(0xFF127351);
  static const Color branco = Color(0xFFFFFFFF);
  static const Color cinzaEscuro = Color(0xFF5B7275);
  static const Color azulClaro = Color(0xFFBCE4ED);
}

ThemeData darkMode = ThemeData(
  fontFamily: 'MavenPro',
  colorScheme: const ColorScheme.dark(
    surface: Color(0xFF1A1A1A), // Fundo geral escuro
    primary: AppColors.verdeClaro, // Destaques em Verde Claro
    secondary: AppColors.azulClaro, // Azul Claro para elementos secundários
    tertiary: AppColors.cinzaEscuro, // Cinza suave
    inversePrimary: AppColors.branco, // Contraste (Branco)
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColors.verdeClaro, // Títulos principais em Verde Claro
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      color: AppColors.azulClaro, // Texto padrão em Azul Claro
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Color(0xFF1A1A1A), // Texto em botões com contraste
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.cinzaEscuro, // Fundo do AppBar
    foregroundColor: AppColors.verdeClaro, // Ícones e textos em Verde Claro
    elevation: 2,
  ),
  cardTheme: const CardTheme(
    color: Color(0xFF2A2A2A), // Fundo do Card
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: AppColors.verdeClaro, // Botões principais
    textTheme: ButtonTextTheme.primary,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.verdeClaro), // Borda ativa
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.azulClaro), // Borda ao focar
    ),
    hintStyle: TextStyle(color: AppColors.cinzaEscuro), // Placeholder
  ),
);
