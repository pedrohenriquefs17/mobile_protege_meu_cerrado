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
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _dataNascimentoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final List<XFile> _imagens = [];

  Future<void> _pegarImagem() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> imagens = await picker.pickMultiImage();
    setState(() {
      _imagens.addAll(imagens);
    });
  }

  var maskFormatterData = MaskTextInputFormatter(
      mask: '##/##/####', filter: {'#': RegExp(r'[0-9]')});
  var maskFormatterCpf = MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {'#': RegExp(r'[0-9]')});

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
          TextField( //Nome Completo
            controller: _nomeController,
            decoration: InputDecoration(
              labelText: 'Nome Completo',
              hintStyle: themeProvider.themeData.inputDecorationTheme.hintStyle,
              enabledBorder:
                  themeProvider.themeData.inputDecorationTheme.enabledBorder,
              focusedBorder:
                  themeProvider.themeData.inputDecorationTheme.focusedBorder,
            ),
            style: themeProvider.themeData.textTheme.bodyLarge,
          ),
          SizedBox(height: 16),
          TextField(  //E-mail
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'E-mail',
              hintStyle: themeProvider.themeData.inputDecorationTheme.hintStyle,
              enabledBorder:
                  themeProvider.themeData.inputDecorationTheme.enabledBorder,
              focusedBorder:
                  themeProvider.themeData.inputDecorationTheme.focusedBorder,
            ),
            style: themeProvider.themeData.textTheme.bodyLarge,
          ),
          SizedBox(height: 16),
          TextField(  //CPF
            controller: _cpfController,
            decoration: InputDecoration(
              labelText: 'CPF',
              hintStyle: themeProvider.themeData.inputDecorationTheme.hintStyle,
              enabledBorder:
                  themeProvider.themeData.inputDecorationTheme.enabledBorder,
              focusedBorder:
                  themeProvider.themeData.inputDecorationTheme.focusedBorder,
            ),
            style: themeProvider.themeData.textTheme.bodyLarge,
            inputFormatters: [maskFormatterCpf],
          ),
          SizedBox(height: 16),
          TextField(  //Data de Nascimento
            controller: _dataNascimentoController,
            decoration: InputDecoration(
              labelText: 'Data de Nascimento',
              hintStyle: themeProvider.themeData.inputDecorationTheme.hintStyle,
              enabledBorder:
                  themeProvider.themeData.inputDecorationTheme.enabledBorder,
              focusedBorder:
                  themeProvider.themeData.inputDecorationTheme.focusedBorder,
            ),
            style: themeProvider.themeData.textTheme.bodyLarge,
            inputFormatters: [maskFormatterData],
          ),
          SizedBox(height: 16),
          TextField( //Titulo
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
          TextField( //Data da Ocorrência
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
            inputFormatters: [maskFormatterData],
          ),
          SizedBox(height: 16),
          TextField(  //Descrição
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
              ? Text('Nenhuma imagem selecionada. mamando')
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
              final nome = _nomeController.text;
              final cpf = _cpfController.text;
              final dataNascimento = _dataNascimentoController.text;
              final email = _emailController.text;

              debugPrint('Título: $titulo');
              debugPrint('Descrição: $descricao');
              debugPrint('Data: $data');
              debugPrint('Nome: $nome');
              debugPrint('CPF: $cpf');
              debugPrint('Data de Nascimento: $dataNascimento');
              debugPrint('E-mail: $email');
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
