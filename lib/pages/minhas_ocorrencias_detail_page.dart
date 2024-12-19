import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_protege_meu_cerrado/model/ocorrencias_model.dart';

class MinhasOcorrenciasDetailPage extends StatelessWidget {
  final String descricao;
  final String categoria;
  final String dataOcorrencia;
  final String latitude;
  final String longitude;
  final String imagem;

  const MinhasOcorrenciasDetailPage(
      {super.key,
      required this.descricao,
      required this.categoria,
      required this.dataOcorrencia,
      required this.latitude,
      required this.longitude,
      required this.imagem});

  @override
  Widget build(BuildContext context) {
    OcorrenciasModel ocorrencia = OcorrenciasModel(
      descricao: descricao,
      categoria: int.tryParse(categoria) ?? 0,
      dataOcorrencia: dataOcorrencia,
      latitude: latitude,
      longitude: longitude,
      imagem: imagem,
    );
    final String categoriaString = categoria;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Ocorrência'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabeçalho visual
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ocorrencia.descricao,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.white,),
                          const SizedBox(width: 8),
                          Text(
                            'Data: ${ocorrencia.dataOcorrencia}',
                            style: const TextStyle(fontSize: 16,color: Colors.white,),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: ListTile(
                  leading: const Icon(Icons.category, size: 32, color: Colors.white,),
                  title: const Text(
                    'Categoria',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white,),
                  ),
                  subtitle: Text(
                    categoriaString,
                    style: const TextStyle(fontSize: 16, color: Colors.white,),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Localização
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: ListTile(
                  leading: const Icon(Icons.location_on_outlined, size: 32, color: Colors.white,),
                  title: const Text(
                    'Localização',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white,),
                  ),
                  subtitle: Text(
                    '${ocorrencia.latitude}, ${ocorrencia.longitude}',
                    style: const TextStyle(fontSize: 16,color: Colors.white,),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Status
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: ListTile(
                  leading: const Icon(Icons.info_outline, size: 32, color: Colors.white,),
                  title: const Text(
                    'Status',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white,),
                  ),
                  subtitle: Text(
                    'Desconhecido',
                    style: const TextStyle(fontSize: 16,color: Colors.white,),
                  ),
                ),
              ),

              Image.file(
                File(ocorrencia.imagem),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Text('Imagem local não encontrada.');
                },
              ),

              const SizedBox(height: 16),
              
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Voltar'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
