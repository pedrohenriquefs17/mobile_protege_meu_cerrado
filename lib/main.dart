import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_protege_meu_cerrado/pages/home_page.dart';
import 'package:mobile_protege_meu_cerrado/themes/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeProvider = ThemeProvider();
  await themeProvider.carregarTema();

  runApp(MainApp(themeProvider: themeProvider));
}

class MainApp extends StatelessWidget {
  final ThemeProvider themeProvider;
  const MainApp({super.key, required this.themeProvider});

 @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: themeProvider,
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Protege Meu Cerrado',
            theme: themeProvider.themeData, // Tema dinâmico
            home: const HomeScreen(), // Sua tela inicial
          );
        },
      ),
    );
  }
}
