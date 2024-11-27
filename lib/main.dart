import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:mobile_protege_meu_cerrado/pages/on_boarding_page.dart';
=======
import 'package:mobile_protege_meu_cerrado/controller/posicao_controller.dart';
>>>>>>> d028c6bb2f94be0d712ad6302a0b359809a21018
import 'package:provider/provider.dart';
import 'package:mobile_protege_meu_cerrado/pages/home_page.dart';
import 'package:mobile_protege_meu_cerrado/themes/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeProvider = ThemeProvider();
  await themeProvider.carregarTema();

  runApp(MainApp(themeProvider: themeProvider));
}

class MainApp extends StatelessWidget {
  final ThemeProvider themeProvider;
  const MainApp({super.key, required this.themeProvider});

<<<<<<< HEAD
  Future<Widget> _getInitialPage() async {
    final prefs = await SharedPreferences.getInstance();
    final hasCompletedOnboarding = prefs.getBool('onboarding_completed') ?? false;
    return hasCompletedOnboarding ? const HomeScreen() : const OnboardingPage();
  }

 @override
=======
  @override
>>>>>>> d028c6bb2f94be0d712ad6302a0b359809a21018
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
        ChangeNotifierProvider(create: (_) => PosicaoController()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return FutureBuilder<Widget>(
            future: _getInitialPage(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Exibe um carregamento enquanto decide a tela inicial
                return const MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  ),
                );
              } else if (snapshot.hasError) {
                // Exibe um erro caso o Future falhe
                return const MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: Scaffold(
                    body: Center(child: Text('Erro ao carregar o aplicativo.')),
                  ),
                );
              }
              // Define a tela inicial
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Protege Meu Cerrado',
                theme: themeProvider.themeData,
                home: snapshot.data,
                routes: {
                  '/home': (context) => const HomeScreen(),
                },
              );
            },
          );
        },
      ),
    );
  }
}