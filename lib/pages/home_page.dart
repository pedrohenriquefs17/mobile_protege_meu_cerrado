import 'dart:io';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mobile_protege_meu_cerrado/components/custom_bottom_navbar.dart';
import 'package:mobile_protege_meu_cerrado/components/info_card.dart';
import 'package:mobile_protege_meu_cerrado/pages/notificacao_page.dart';
import 'package:mobile_protege_meu_cerrado/pages/nova_ocorrencias_page.dart';
import 'package:mobile_protege_meu_cerrado/pages/perfil_page.dart';
import 'package:mobile_protege_meu_cerrado/pages/config_page..dart';
import 'package:mobile_protege_meu_cerrado/pages/ocorrencias_page.dart';
import 'package:mobile_protege_meu_cerrado/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  File? _image;

  // Lista de páginas para navegação
  final List<Widget> _pages = [
    const HomeContent(),
    const OcorrenciasPage(),
    const PerfilPage(),
    const ConfiguracoesPage(),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadProfileImage(); // Recarrega a imagem sempre que a tela for carregada
  }

  // Função para carregar a imagem de perfil
  Future<void> _loadProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('profileImage');
    if (imagePath != null) {
      setState(() {
        _image = File(imagePath); // Carregar a imagem salva
      });
    } else {
      setState(() {
        _image =
            null; // Se não houver imagem, manter null ou usar uma imagem padrão
      });
    }
  }

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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Avatar do usuário
            CircleAvatar(
              radius: 20,
              backgroundImage: _image != null
                  ? FileImage(_image!)
                  : const AssetImage('assets/images/default_profile.png')
                      as ImageProvider,
            ),

            // Título do app
            Flexible(
              child: Center(
                child: Text(
                  'Protege Meu Cerrado',
                  style: const TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis, // Evita quebra de texto
                ),
              ),
            ),

            // Ícones à direita
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    themeProvider.isDarkMode
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    themeProvider.toggleTheme();
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificacaoPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        centerTitle: false, // Para ajustar o layout do título dinamicamente
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Color(0xFF5B7275),
        buttonBackgroundColor: Theme.of(context).colorScheme.primary,
        height: 60,
        items: const [
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.report, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
          Icon(Icons.settings, size: 30, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.easeInOut,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
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
                      'assets/images/animal4.jpg',
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Atalhos',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(height: 10),
                  FloatingActionButton.extended(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NovaOcorrenciaPage(),
                        ),
                      );
                    },
                    label: const Text('Nova Ocorrência'),
                    icon: const Icon(Icons.add),
                    backgroundColor:
                        themeProvider.themeData.colorScheme.primary,
                    foregroundColor:
                        themeProvider.themeData.colorScheme.onPrimary,
                    elevation: 4,
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
                  Text(
                    'Descubra mais sobre o Meio Ambiente',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF38B887),
                    ),
                  ),
                  SizedBox(height: 10),
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
