import 'package:flutter/material.dart';
import 'package:mobile_protege_meu_cerrado/pages/home_page.dart';
//import 'package:mobile_protege_meu_cerrado/themes/theme_provider.dart';

Future<void> main() async {
  
  //final themeProvider = ThemeProvider();
  //await themeProvider.carregarTema();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Protege Meu Cerrado',
      home: BlogScreen(),
    );
  }
}