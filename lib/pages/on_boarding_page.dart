import 'package:flutter/material.dart';
import 'package:mobile_protege_meu_cerrado/components/app_large_text.dart';
import 'package:mobile_protege_meu_cerrado/components/app_text.dart';
import 'package:mobile_protege_meu_cerrado/components/pulsing_button.dart';
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
  // Inicializando o PageController
  final PageController _pageController = PageController();

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
    "Transformação",
  ];

  List text2 = [
    "para o nosso Cerrado",
    "do nosso Meio Ambiente",
    "Conecte-se com a natureza",
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
        controller: _pageController, // Passando o controlador para o PageView
        scrollDirection: Axis.horizontal, // Mudando para scroll horizontal
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

              // Indicadores de página
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
              Positioned(
                top: 150, // Ajustando a posição do conteúdo
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppLargeText(
                      text: text[index],
                      color: themeProvider
                              .themeData.textTheme.displayLarge?.color ??
                          Colors.black,
                    ),
                    AppText(
                      text: text2[index],
                      size: 30,
                      color: themeProvider
                              .themeData.textTheme.displayLarge?.color ??
                          Colors.black,
                    ),
                    SizedBox(height: 20),
                    AppText(
                      text: text3[index],
                      color:
                          themeProvider.themeData.textTheme.bodyLarge?.color ??
                              Colors.black,
                      size: 18,
                    ),
                    SizedBox(height: 40),
                    if (index == 0)
                      AppText(
                        text:
                            "O nosso app visa proteger o meio ambiente do Cerrado com o uso de tecnologia.",
                        color: themeProvider
                                .themeData.textTheme.bodyMedium?.color ??
                            Colors.black,
                        size: 16,
                      ),
                    if (index == 1)
                      AppText(
                        text:
                            "Através de inovações, buscamos transformar como as pessoas interagem com a natureza.",
                        color: themeProvider
                                .themeData.textTheme.bodyMedium?.color ??
                            Colors.black,
                        size: 16,
                      ),
                    if (index == 2)
                      AppText(
                        text:
                            "Junte-se a nós para um futuro mais sustentável e conectado com o meio ambiente.",
                        color: themeProvider
                                .themeData.textTheme.bodyMedium?.color ??
                            Colors.black,
                        size: 16,
                      ),
                  ],
                ),
              ),

              // Botão de navegação (setinha)
              if (index != images.length - 1)
                Positioned(
                  bottom: 450,
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.center,
                    child: PulsingButton(
                      onPressed: () {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: themeProvider.themeData.colorScheme.primary,
                        size: 40,
                      ),
                    ),
                  ),
                ),

              // Botões no final (se for a última tela)
              Positioned(
                bottom: 400,
                left: 0,
                right: 0,
                child: index == images.length - 1
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ResponsiveButtonLogin(width: 140),
                          ResponsiveButtonCadastro(width: 140),
                        ],
                      )
                    : SizedBox
                        .shrink(), // Não exibe os botões de login e cadastro
              ),
            ],
          );
        },
      ),
    );
  }
}
