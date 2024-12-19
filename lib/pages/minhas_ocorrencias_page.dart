import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_protege_meu_cerrado/model/ocorrencias_model.dart';
import 'package:mobile_protege_meu_cerrado/pages/minhas_ocorrencias_detail_page.dart';
import 'package:mobile_protege_meu_cerrado/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Importante para decodificar a resposta JSON

class MinhasOcorrenciasPage extends StatefulWidget {
  const MinhasOcorrenciasPage({super.key});

  @override
  State<MinhasOcorrenciasPage> createState() => _MinhasOcorrenciasPageState();
}

class _MinhasOcorrenciasPageState extends State<MinhasOcorrenciasPage> {
  List<OcorrenciasModel> ocorrencias = [];
  List<dynamic> ocorrenciasFiltradas = [];
  final TextEditingController _pesquisarController = TextEditingController();
  List<dynamic> categorias = [];
  bool isLoading = true; // Adiciona a variável de controle

  @override
  void initState() {
    super.initState();
    carregarDados();
    _pesquisarController.addListener(_filtrarOcorrencias);
  }

  Future<void> carregarDados() async {
    setState(() {
      isLoading = true;
    });

    await Future.wait([
      getOcorrencias(),
      getCategorias(),
    ]);

    setState(() {
      isLoading = false;
    });
  }

  Future<void> getOcorrencias() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final idUsuario = prefs.getInt('idUsuario');
    final String url =
        'http://meu_ip:8080/ocorrencias/usuario/$idUsuario'; //colocar seu ip

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          ocorrencias = data.map((e) => OcorrenciasModel.fromJson(e)).toList();
        });
      } else {
        debugPrint('Erro: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erro ao buscar ocorrências: $e');
    }
  }

  Future<void> getCategorias() async {
    String url = 'http://meu_ip:8080/ocorrencias/categorias';
    Dio dio = Dio();

    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        setState(() {
          categorias = response.data.map((e) => e['nomeCategoria']).toList();
        });
      }
    } catch (e) {
      debugPrint('Erro ao buscar categorias: $e');
    }
  }

  void _filtrarOcorrencias() {
    String pesquisar = _pesquisarController.text.toLowerCase();
    setState(() {
      ocorrenciasFiltradas = ocorrencias.where((ocorrencia) {
        final descricao = ocorrencia.descricao.toLowerCase();
        return descricao.contains(pesquisar);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Minhas Ocorrências"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Indicador de carregamento
          : Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SizedBox(height: 16),
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
                                color: themeProvider
                                    .themeData.colorScheme.primary),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(
                                color:
                                    themeProvider.themeData.colorScheme.primary,
                                width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ocorrencias.isEmpty
                            ? const Center(
                                child: Text('Nenhuma ocorrência encontrada.'))
                            : ListView.builder(
                                itemCount: ocorrencias.length,
                                itemBuilder: (context, index) {
                                  final ocorrencia = ocorrencias[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MinhasOcorrenciasDetailPage(
                                            descricao: ocorrencia.descricao,
                                            categoria: categorias[
                                                ocorrencia.categoria - 1],
                                            dataOcorrencia:
                                                ocorrencia.dataOcorrencia,
                                            latitude: ocorrencia.latitude,
                                            longitude: ocorrencia.longitude,
                                            imagem: ocorrencia.imagem,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Card(
                                      elevation: 4,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          categorias[ocorrencia.categoria - 1],
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                'Descrição: ${ocorrencia.descricao}',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                )),
                                            Text(
                                                'Data: ${ocorrencia.dataOcorrencia}',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                )),
                                            Text(
                                                'Coordenadas de Localização: ${ocorrencia.latitude} - ${ocorrencia.longitude}',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                )),
                                          ],
                                        ),
                                        trailing: const Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.all(16),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
