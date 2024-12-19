import 'package:flutter/material.dart';
import 'package:mobile_protege_meu_cerrado/components/app_text.dart';
import 'package:mobile_protege_meu_cerrado/components/responsive_button_cadastro.dart';
import 'package:mobile_protege_meu_cerrado/components/responsive_button_login.dart';
import 'package:mobile_protege_meu_cerrado/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final bool onboardingCompleted =
        prefs.getBool('onboardingCompleted') ?? false;

    if (onboardingCompleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (route) => false);
      });
    }
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingCompleted', true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    });
  }

  Future<void> _entrarSemLogar(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', '');
    await prefs.setInt('idUsuario', 0);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  final List<String> images = [
    "primeira1.svg",
    "segunda2.svg",
    "terceira3.svg",
  ];

  final List<String> titles = [
    "Inovação para o nosso Cerrado",
    "Preserve o Meio Ambiente",
    "Conecte-se com a Natureza",
  ];

  final List<String> subtitles = [
    "Explore como a tecnologia pode ajudar a proteger o Cerrado.",
    "Seja parte de uma revolução ambiental com inovação e cuidado.",
    "Transforme seu impacto no meio ambiente com nossa comunidade.",
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (_, index) {
              return Stack(
                children: [
                  _buildBackground(images[index]),
                  _buildContent(screenHeight, themeProvider, index),
                  _buildSkipButton(screenHeight),
                  if (index != images.length - 1)
                    _buildNextButton(screenHeight),
                  _buildSkipButton(screenHeight),
                  if (index == images.length - 1)
                    _buildFinalButtons(screenHeight),
                ],
              );
            },
          ),
          _buildIndicators(screenHeight),
        ],
      ),
    );
  }

  Widget _buildBackground(String imagePath) {
    return Positioned(
      top: 50,
      left: 0,
      right: 0,
      child: SvgPicture.asset(
        "assets/images/$imagePath",
        fit: BoxFit.contain,
        height: 335,
        width: 335,
      ),
    );
  }

  Widget _buildContent(
      double screenHeight, ThemeProvider themeProvider, int index) {
    return Positioned(
      top: screenHeight * 0.55,
      left: 20,
      right: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppText(
            text: titles[index],
            size: 28,
            color: themeProvider.themeData.textTheme.displayLarge?.color ??
                Colors.black,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          AppText(
            text: subtitles[index],
            size: 16,
            color: themeProvider.themeData.textTheme.bodyMedium?.color ??
                Colors.black,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildIndicators(double screenHeight) {
    return Positioned(
      bottom: screenHeight * 0.11,
      left: 25,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(
          images.length,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: _currentPage == index ? 16 : 8,
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: _currentPage == index
                  ? const Color(0xFF38B887)
                  : Colors.grey.shade400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton(double screenHeight) {
    return Positioned(
      bottom: screenHeight * 0.08,
      right: 25,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 1.0, end: 1.2),
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: const Color(0xFF38B887),
                padding: const EdgeInsets.all(16),
              ),
              onPressed: () {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ),
            ),
          );
        },
        onEnd: () {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildFinalButtons(double screenHeight) {
    return Positioned(
      bottom: 70,
      left: 20,
      right: 20,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ResponsiveButtonLogin(width: 140),
              ResponsiveButtonCadastro(width: 140),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF38B887),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () async {
              await _completeOnboarding();
              _entrarSemLogar(context);
            },
            child: const Text(
              "Entrar sem logar",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkipButton(double screenHeight) {
    return _currentPage != images.length - 1
        ? Positioned(
            top: 40,
            right: 20,
            child: TextButton(
              onPressed: () async {
                _pageController.jumpToPage(images.length - 1);
                await _completeOnboarding();
              },
              child: const Text(
                "Pular",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        : const SizedBox.shrink(); // Não exibe nada na última tela
  }
}
