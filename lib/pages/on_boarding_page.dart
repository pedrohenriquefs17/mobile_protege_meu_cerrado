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
    "Preserve e inove com tecnologia.",
    "Conecte-se ao meio ambiente.",
    "Transforme sua relação com o Cerrado."
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
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  icon: Icon(
                    themeProvider.isDarkMode
                        ? Icons.dark_mode
                        : Icons.light_mode,
                  ),
                  onPressed: () {
                    themeProvider.toggleTheme();
                  },
                ),
              ),
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

              Positioned(
                bottom: 40, // Indicadores abaixo do conteúdo principal
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    images.length,
                    (indicatorIndex) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: indicatorIndex == index ? 16 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: indicatorIndex == index
                            ? themeProvider.themeData.colorScheme.primary
                            : Colors.grey,
                      ),
                    ),
                  ),
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
                    const SizedBox(height: 80),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ResponsiveButtonLogin(
                          width: 140, // Ajuste proporcional da largura
                        ),
                        ResponsiveButtonCadastro(
                          width:
                              140, // Mesmo tamanho do outro botão para consistência
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
