import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mobile_protege_meu_cerrado/pages/nova_ocorrencias_page.dart';
import 'package:mobile_protege_meu_cerrado/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class OcorrenciasPage extends StatefulWidget {
  const OcorrenciasPage({super.key});

  @override
  State<OcorrenciasPage> createState() => _OcorrenciasPageState();
}

class _OcorrenciasPageState extends State<OcorrenciasPage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ocorrências Populares',
          style: themeProvider.themeData.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: themeProvider.themeData.colorScheme.onSurface,
          ),
        ),
        backgroundColor: themeProvider.themeData.colorScheme.surface,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Botão "Nova Ocorrência"
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
                  backgroundColor: themeProvider.themeData.colorScheme.primary,
                  foregroundColor:
                      themeProvider.themeData.colorScheme.onPrimary,
                  elevation: 4,
                ),
                const SizedBox(width: 16), // Espaço entre os botões
                // Spacer para empurrar o próximo botão para a direita
                const Spacer(),
                // Botão "Minhas Ocorrências"
                FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NovaOcorrenciaPage(),
                      ),
                    );
                  },
                  label: const Text('Minhas Ocorrências'),
                  icon: const Icon(Icons.list),
                  backgroundColor: themeProvider.themeData.colorScheme.primary,
                  foregroundColor:
                      themeProvider.themeData.colorScheme.onPrimary,
                  elevation: 4,
                ),
              ],
            ),
            const SizedBox(height: 16), // Espaço entre os botões e a lista
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Exemplo: 5 ocorrências
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: themeProvider.themeData.colorScheme.onSurface
                        .withOpacity(0.2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Carrossel de Imagens
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 200.0,
                            autoPlay: true,
                            enlargeCenterPage: true,
                            aspectRatio: 16 / 9,
                            viewportFraction: 0.8,
                          ),
                          items: [
                            'https://via.placeholder.com/400x200.png?text=Imagem+1',
                            'https://via.placeholder.com/400x200.png?text=Imagem+2',
                            'https://via.placeholder.com/400x200.png?text=Imagem+3',
                          ].map((url) {
                            return Builder(
                              builder: (BuildContext context) {
                                return ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                  child: Image.network(
                                    url,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ocorrência ${index + 1}',
                                style: themeProvider
                                    .themeData.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: themeProvider
                                      .themeData.colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Descrição breve da ocorrência aqui. Local: Parque Nacional do Cerrado.',
                                style: themeProvider
                                    .themeData.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: themeProvider
                                      .themeData.colorScheme.onSurface
                                      .withOpacity(0.7),
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.thumb_up_alt_outlined,
                                          color: themeProvider
                                              .themeData.colorScheme.primary,
                                        ),
                                        onPressed: () {
                                          // Lógica para curtir
                                        },
                                      ),
                                      const Text('123'),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.comment_outlined,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () {
                                          // Lógica para comentar
                                        },
                                      ),
                                      const Text('45'),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
