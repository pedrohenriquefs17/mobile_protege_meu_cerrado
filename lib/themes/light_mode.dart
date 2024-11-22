import 'package:flutter/material.dart';

class AppColors {
  static const Color verdeClaro = Color(0xFF38B887);
  static const Color verdeEscuro = Color(0xFF127351);
  static const Color branco = Color(0xFFFFFFFF);
  static const Color cinzaEscuro = Color(0xFF5B7275);
  static const Color azulClaro = Color(0xFFBCE4ED);
}

ThemeData lightMode = ThemeData(
  fontFamily: 'MavenPro',
  colorScheme: const ColorScheme.light(
    surface: AppColors.branco, // Fundo principal
    primary: AppColors.verdeClaro, // Cor de destaque
    secondary: AppColors.azulClaro, // Elementos secundários
    tertiary: AppColors.cinzaEscuro, // Tons suaves
    inversePrimary: AppColors.verdeEscuro, // Contraste
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColors.verdeEscuro, // Títulos principais
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      color: AppColors.cinzaEscuro, // Texto padrão
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: AppColors.branco, // Botões com texto branco
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.verdeEscuro, // Fundo do AppBar
    foregroundColor: AppColors.branco, // Ícones e textos no AppBar
    elevation: 2,
  ),
  cardTheme: const CardTheme(
    color: AppColors.verdeClaro, // Fundo do Card
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
      borderSide: BorderSide(color: AppColors.verdeEscuro), // Borda ao focar
    ),
    hintStyle: TextStyle(color: AppColors.cinzaEscuro), // Placeholder
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
