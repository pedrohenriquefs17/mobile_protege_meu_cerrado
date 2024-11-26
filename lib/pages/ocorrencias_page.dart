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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ocorrências Populares',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
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
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Exemplo: 5 ocorrências
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Carrossel de Imagens
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 200.0,
                            autoPlay: true,
                            enlargeCenterPage: true,
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
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
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
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Descrição breve da ocorrência aqui. Local: Parque Nacional do Cerrado.',
                                style: Theme.of(context).textTheme.labelLarge,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.thumb_up_alt_outlined,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
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
