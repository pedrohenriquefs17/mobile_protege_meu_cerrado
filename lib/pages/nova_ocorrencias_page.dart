import 'package:flutter/material.dart';
import 'package:mobile_protege_meu_cerrado/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'dart:io';

class NovaOcorrenciaPage extends StatefulWidget {
  const NovaOcorrenciaPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NovaOcorrenciaPageState createState() => _NovaOcorrenciaPageState();
}

class _NovaOcorrenciaPageState extends State<NovaOcorrenciaPage> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();
  final List<XFile> _imagens = [];

  Future<void> _pegarImagem() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> imagens = await picker.pickMultiImage();
    setState(() {
      _imagens.addAll(imagens);
    });
  }

  var maskFormatter = MaskTextInputFormatter(
      mask: '##/##/####', filter: {'#': RegExp(r'[0-9]')});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Ocorrências',
            style: themeProvider.themeData.textTheme.displayLarge),
        backgroundColor: themeProvider.themeData.colorScheme.surface,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _tituloController,
            decoration: InputDecoration(
              labelText: 'Título da Ocorrência',
              hintStyle: themeProvider.themeData.inputDecorationTheme.hintStyle,
              enabledBorder:
                  themeProvider.themeData.inputDecorationTheme.enabledBorder,
              focusedBorder:
                  themeProvider.themeData.inputDecorationTheme.focusedBorder,
            ),
            style: themeProvider.themeData.textTheme.bodyLarge,
          ),
          SizedBox(height: 16),
          TextField(
            controller: _dataController,
            decoration: InputDecoration(
              labelText: 'Data da Ocorrência',
              hintStyle: themeProvider.themeData.inputDecorationTheme.hintStyle,
              enabledBorder:
                  themeProvider.themeData.inputDecorationTheme.enabledBorder,
              focusedBorder:
                  themeProvider.themeData.inputDecorationTheme.focusedBorder,
            ),
            style: themeProvider.themeData.textTheme.bodyLarge,
            inputFormatters: [maskFormatter],
          ),
          SizedBox(height: 16),
          TextField(
            controller: _descricaoController,
            decoration: InputDecoration(
              labelText: 'Descrição da Ocorrência',
              hintStyle: themeProvider.themeData.inputDecorationTheme.hintStyle,
              enabledBorder:
                  themeProvider.themeData.inputDecorationTheme.enabledBorder,
              focusedBorder:
                  themeProvider.themeData.inputDecorationTheme.focusedBorder,
            ),
            style: themeProvider.themeData.textTheme.bodyLarge,
            maxLines: 5,
          ),
          SizedBox(height: 16),
          _imagens.isEmpty
              ? Text('Nenhuma imagem selecionada.')
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _imagens.map((imagem) {
                    return Image.file(
                      File(imagem.path),
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    );
                  }).toList(),
                ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _pegarImagem,
            child: Text('Selecionar Imagens'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final titulo = _tituloController.text;
              final descricao = _descricaoController.text;
              final imagens = _imagens;
              final data = _dataController.text;

              debugPrint('Título: $titulo');
              debugPrint('Descrição: $descricao');
              debugPrint('Data: $data');
              for (var imagem in imagens) {
                debugPrint('Imagem: ${imagem.path}');
              }
            },
            child: Text('Salvar Ocorrência'),
          ),
        ],
      ),
    );
  }
}
