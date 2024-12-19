import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobile_protege_meu_cerrado/firebase/firebase.dart';
import 'package:mobile_protege_meu_cerrado/firebase/notification_service.dart';
import 'package:mobile_protege_meu_cerrado/pages/cadastro_user_page.dart';
import 'package:mobile_protege_meu_cerrado/pages/config_page..dart';
import 'package:mobile_protege_meu_cerrado/pages/login_page.dart';
import 'package:mobile_protege_meu_cerrado/pages/notificacao_page.dart';
import 'package:mobile_protege_meu_cerrado/pages/nova_ocorrencias_page.dart';
import 'package:mobile_protege_meu_cerrado/pages/ocorrencias_page.dart';
import 'package:mobile_protege_meu_cerrado/pages/on_boarding_page.dart';
import 'package:mobile_protege_meu_cerrado/controller/posicao_controller.dart';
import 'package:provider/provider.dart';
import 'package:mobile_protege_meu_cerrado/pages/home_page.dart';
import 'package:mobile_protege_meu_cerrado/themes/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeProvider = ThemeProvider();
  await themeProvider.carregarTema();

  await Firebase.initializeApp();
  await FireBase().initFirebaseMessaging();
  await NotificationService.initialize();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
    ChangeNotifierProvider(create: (_) => PosicaoController()),
  ], child: MainApp(themeProvider: themeProvider)));
}

class MainApp extends StatelessWidget {
  final ThemeProvider themeProvider;
  const MainApp({super.key, required this.themeProvider});

  Future<Widget> _getInitialPage() async {
    final prefs = await SharedPreferences.getInstance();
    final hasCompletedOnboarding =
        prefs.getBool('onboarding_completed') ?? false;
    return hasCompletedOnboarding ? const HomeScreen() : const OnboardingPage();
  }

  @override
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
                  '/login': (context) => const LoginPage(),
                  '/cadastroUsuario': (context) => const CadastroUserPage(),
                  '/onboarding': (context) => const OnboardingPage(),
                  '/ocorrencias': (context) => const OcorrenciasPage(),
                  '/novaOcorrencia': (context) => const NovaOcorrenciaPage(),
                  '/notificacao': (context) => const NotificacaoPage(),
                  '/configuracao': (context) => const ConfiguracoesPage(),
                },
              );
            },
          );
        },
      ),
    );
  }
}
