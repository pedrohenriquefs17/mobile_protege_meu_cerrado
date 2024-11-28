import 'package:flutter/material.dart';
import 'package:mobile_protege_meu_cerrado/components/app_large_text.dart';
import 'package:mobile_protege_meu_cerrado/components/app_text.dart';
import 'package:mobile_protege_meu_cerrado/components/responsive_button_cadastro.dart';
import 'package:mobile_protege_meu_cerrado/components/responsive_button_login.dart';
import 'package:mobile_protege_meu_cerrado/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  Future<void> _completeOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);

    // Navega para a tela principal
    Navigator.pushReplacementNamed(context, '/home');
  }

  List images = [
    "onBoardingF1.png",
    "onBoardingF2.png",
    "onBoardingF3.png",
  ];

  List text = [
    "Inovação",
    "Desenvolvimento",
    "blabla",
  ];

  List text2 = [
    "para o nosso Cerrado",
    "do nosso Meio Ambiente",
    "daksnda",
  ];

  List text3 = [
    "fdksnafnsanfjksnajjksaknsaiofnsakjnfknksnf",
    "aaaaafdksnafnsanfjksnajjksaknsaiofnsakjnfknksnf",
    "safafsffffffdksnafnsanfjksnajjksaknsaiofnsakjnfknksnf",
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: images.length,
        itemBuilder: (_, index) {
          return Stack(
            children: [
              // Imagem no fundo, posicionada no final da tela
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Image.asset(
                  "assets/images/" + images[index],
                  fit: BoxFit.cover, // Ajusta a largura à tela
                ),
              ),

              // Conteúdo no topo
              Container(
                margin: const EdgeInsets.only(top: 150, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppLargeText(
                      text: text[index],
                      color: themeProvider
                              .themeData.textTheme.displayLarge?.color ??
                          Colors.black, // Cor padrão se for null
                    ),
                    AppText(
                      text: text2[index],
                      size: 30,
                      color: themeProvider
                              .themeData.textTheme.displayLarge?.color ??
                          Colors.black,
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: 250,
                      child: AppText(
                        text: text3[index],
                        color: themeProvider
                                .themeData.textTheme.bodyLarge?.color ??
                            Colors.black,
                        size: 18,
                      ),
                    ),
                    Container(),
                    SizedBox(height: 40),
                    ResponsiveButtonLogin(
                      width: 120,
                    ),
                    SizedBox(height: 18),
                    ResponsiveButtonCadastro(
                      width: 120,
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 20, // Distância da borda direita
                top: MediaQuery.of(context).size.height *
                    0.4, // Centraliza verticalmente
                child: Column(
                  children: List.generate(3, (indicatorIndex) {
                    return Container(
                      margin: const EdgeInsets.only(
                          bottom: 8), // Espaço entre os indicadores
                      width: 8,
                      height: indicatorIndex == index
                          ? 25
                          : 8, // Destaque para o ativo
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: indicatorIndex == index
                            ? themeProvider.themeData.colorScheme.primary
                            : Colors.grey, // Cinza para os inativos
                      ),
                    );
                  }),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
