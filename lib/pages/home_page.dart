import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mobile_protege_meu_cerrado/components/custom_bottom_navbar.dart';
import 'package:mobile_protege_meu_cerrado/components/info_card.dart';
import 'package:mobile_protege_meu_cerrado/pages/blog_page.dart';
import 'package:mobile_protege_meu_cerrado/pages/config_page..dart';
import 'package:mobile_protege_meu_cerrado/pages/nova_ocorrencias_page.dart';
import 'package:mobile_protege_meu_cerrado/pages/ocorrencias_page.dart';
import 'package:mobile_protege_meu_cerrado/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Lista de páginas para navegação
  final List<Widget> _pages = [
    const HomeContent(),
    const OcorrenciasPage(),
    const BlogPage(),
    const ConfiguracoesPage(),
  ];

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Protege Meu Cerrado'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Conteúdo principal da página
          _pages[_currentIndex],
          // flutuante
          Positioned(
            bottom: 18,
            left: 24,
            right: 24,
            child: Container(
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFF5B7275).withOpacity(0.8),
                borderRadius: const BorderRadius.all(Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF5B7275).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: CustomBottomNavBar(
                  currentIndex: _currentIndex,
                  onTap: _onNavTap,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 300,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/cerrado.jpeg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: 300,
                  color: Colors.black.withOpacity(0.4),
                ),
                Positioned(
                  bottom: 30,
                  left: 20,
                  child: Text(
                    'Protege Meu Cerrado',
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge
                        ?.copyWith(color: Colors.white, fontSize: 28),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Explore a Biodiversidade',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(height: 10),
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 200,
                      autoPlay: true,
                      enlargeCenterPage: true,
                    ),
                    items: [
                      'assets/images/animal1.jpg',
                      'assets/images/animal2.jpg',
                      'assets/images/animal3.jpg',
                    ].map((url) {
                      return Builder(
                        builder: (BuildContext context) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              url,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Informações Divididas em Blocos
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InfoCard(
                    title: 'Queimadas',
                    description:
                        'Descubra como as queimadas impactam o Cerrado e como você pode ajudar a prevenir.',
                    icon: Icons.local_fire_department,
                  ),
                  SizedBox(height: 16),
                  InfoCard(
                    title: 'Biodiversidade',
                    description:
                        'O Cerrado é lar de espécies únicas. Aprenda mais sobre sua fauna e flora.',
                    icon: Icons.pets,
                  ),
                  SizedBox(height: 16),
                  InfoCard(
                    title: 'Ações Comunitárias',
                    description:
                        'Envolva-se em iniciativas que ajudam a preservar o Cerrado e a conscientizar comunidades.',
                    icon: Icons.group,
                  ),
                ],
              ),
            ),
            // Espaço extra para evitar que a BottomNavigationBar sobreponha o conteúdo
            const SizedBox(
                height: 80), // Ajuste essa altura conforme necessário
          ],
        ),
      ),
    );
  }
}
