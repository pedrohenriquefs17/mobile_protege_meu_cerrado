import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile_protege_meu_cerrado/model/ocorrencias_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MinhasOcorrenciasPage extends StatefulWidget {
  const MinhasOcorrenciasPage({super.key});

  @override
  State<MinhasOcorrenciasPage> createState() => _MinhasOcorrenciasPageState();
}

class _MinhasOcorrenciasPageState extends State<MinhasOcorrenciasPage> {
  List<OcorrenciasModel> ocorrencias = [];

  @override
  void initState() {
    super.initState();
    getOcorrencias();
  }

  Future<void> getOcorrencias() async {
    final dio = Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final idUsuario = prefs.getInt('idUsuario');
    final String url =
        'https://pmc.airsoftcontrol.com.br/ocorrencias/usuario/$idUsuario';

    try {
      final Response response = await dio.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        ocorrencias = data.map((e) => OcorrenciasModel.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint('Erro ao buscar ocorrências: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Minhas Ocorrências"),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Pesquisar Ocorrência',
                    labelStyle:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.tertiary),
                    ),
                    suffixIcon: const Icon(Icons.search, size: 22),
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: ocorrencias.isEmpty
                      ? const Center(child: Text('Nenhum cliente encontrado.'))
                      : ListView.builder(
                          itemCount: ocorrencias.length,
                          itemBuilder: (context, index) {
                            final ocorrencia = ocorrencias[index];
                            return GestureDetector(
                              onTap: () {},
                              child: Card(
                                elevation: 4,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  title: Text(
                                    ocorrencia.categoria.toString(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Descrição: ${ocorrencia.descricao}',
                                          style: const TextStyle(fontSize: 14)),
                                      Text('Data: ${ocorrencia.data}',
                                          style: const TextStyle(fontSize: 14)),
                                      Text('Coordenadas de Localização: ${ocorrencia.latitude} - ${ocorrencia.longitude}',
                                          style: const TextStyle(fontSize: 14)),
                                    ],
                                  ),
                                  trailing: const Icon(Icons.arrow_forward_ios),
                                  contentPadding: const EdgeInsets.all(16),
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
