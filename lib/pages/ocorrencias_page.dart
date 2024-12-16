import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_protege_meu_cerrado/pages/minhas_ocorrencias_page.dart';
import 'package:mobile_protege_meu_cerrado/pages/nova_ocorrencias_page.dart';
import 'package:mobile_protege_meu_cerrado/pages/ocorrencia_detail_page.dart';
import 'package:mobile_protege_meu_cerrado/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OcorrenciasPage extends StatefulWidget {
  const OcorrenciasPage({super.key});

  @override
  State<OcorrenciasPage> createState() => _OcorrenciasPageState();
}

class _OcorrenciasPageState extends State<OcorrenciasPage> {
  bool isLogado = false;
  bool isLoading = true;
  List<dynamic> ocorrencias = [];
  List<dynamic> ocorrenciasFiltradas = [];
  final TextEditingController _pesquisarController = TextEditingController();

  @override
  initState() {
    super.initState();
    _estaLogado();
    _fetchOcorrencias();
    _pesquisarController.addListener(_filtrarOcorrencias);
  }

  Future<void> _fetchOcorrencias() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.206:8080/ocorrencias'), //colocar seu ip
      );
      if (response.statusCode == 200) {
        setState(() {
          ocorrencias = jsonDecode(response.body);
          ocorrenciasFiltradas = List.from(ocorrencias);
          isLoading = false;
        });
      } else {
        debugPrint('Erro ao carregar as ocorrências: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Erro na requisição: $e');
    }
  }

  Future<void> _estaLogado() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? idUsuario = prefs.getInt('idUsuario');
    if (idUsuario != null && idUsuario > 0) {
      setState(() {
        isLogado = true;
      });
      await _fetchOcorrencias();
    } else {
      setState(() {
        isLogado = false;
        isLoading = false;
      });
    }
  }

  void _filtrarOcorrencias() {
    String pesquisar = _pesquisarController.text.toLowerCase();
    setState(() {
      ocorrenciasFiltradas = ocorrencias.where((ocorrencia) {
        final descricao = ocorrencia['descricao']?.toLowerCase() ?? '';
        return descricao.contains(pesquisar);
      }).toList();
    });
  }

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
            // Barra de pesquisa
            TextField(
              controller: _pesquisarController,
              decoration: InputDecoration(
                labelText: 'Pesquisar',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(
                      color: themeProvider.themeData.colorScheme.primary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(
                      color: themeProvider.themeData.colorScheme.primary,
                      width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Botões
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
                // Botão "Minhas Ocorrências"
                Flexible(
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      if (isLogado) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MinhasOcorrenciasPage(),
                          ),
                        );
                      } else {
                        Fluttertoast.showToast(
                          msg:
                              "Você precisa estar logado para acessar suas ocorrências.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                    },
                    label: const Text('Minhas Ocorrências'),
                    icon: const Icon(Icons.list),
                    backgroundColor:
                        themeProvider.themeData.colorScheme.primary,
                    foregroundColor:
                        themeProvider.themeData.colorScheme.onPrimary,
                    elevation: 4,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Lista de ocorrências
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ocorrenciasFiltradas.isEmpty
                      ? const Center(
                          child: Text(
                            'Nenhuma ocorrência encontrada.',
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          itemCount: ocorrenciasFiltradas.length,
                          itemBuilder: (context, index) {
                            final ocorrencia = ocorrenciasFiltradas[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        OcorrenciaDetalhesPage(
                                      ocorrencia: ocorrencia,
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 6,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Placeholder para imagem
                                    Container(
                                      height: 180,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(16),
                                          topRight: Radius.circular(16),
                                        ),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.grey.shade400,
                                            Colors.grey.shade300,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'Sem imagens',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            ocorrencia['descricao'] ??
                                                'Sem descrição',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.calendar_today_outlined,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                'Data: ${ocorrencia['dtOcorrencia'] ?? 'Não informada'}',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.location_on_outlined,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  'Localização: ${ocorrencia['lat']}, ${ocorrencia['lon']}',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
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
