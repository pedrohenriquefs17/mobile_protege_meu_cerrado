import 'package:flutter/material.dart';
import 'package:mobile_protege_meu_cerrado/components/custom_textfield.dart';
import 'package:mobile_protege_meu_cerrado/controller/posicao_controller.dart';
import 'package:mobile_protege_meu_cerrado/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class NovaOcorrenciaPage extends StatefulWidget {
  const NovaOcorrenciaPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NovaOcorrenciaPageState createState() => _NovaOcorrenciaPageState();
}

class _NovaOcorrenciaPageState extends State<NovaOcorrenciaPage> {
  final TextEditingController _tituloController =
      TextEditingController(); //Text Editing Controllers
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _dataNascimentoController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final List<XFile> _imagens = [];

  Future<void> _pegarImagem() async {
    //função para pegar as imagens da galeria
    final ImagePicker picker = ImagePicker();
    final List<XFile> imagens = await picker.pickMultiImage();
    setState(() {
      _imagens.addAll(imagens);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final posicaoController = Provider.of<PosicaoController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Ocorrências',
            style: themeProvider.themeData.textTheme.displayLarge),
        backgroundColor: themeProvider.themeData.colorScheme.surface,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CustomTextfield(
            controller: _nomeController,
            label: 'Nome Completo',
          ),
          SizedBox(height: 16),
          CustomTextfield(
            controller: _emailController,
            label: 'E-mail',
          ),
          SizedBox(height: 16),
          CustomTextfield(
            controller: _cpfController,
            label: 'CPF',
          ),
          SizedBox(height: 16),
          CustomTextfield(
            controller: _dataNascimentoController,
            label: 'Data de Nascimento',
          ),
          SizedBox(height: 16),
          CustomTextfield(
            controller: _tituloController,
            label: 'Título da Ocorrência',
          ),
          SizedBox(height: 16),
          CustomTextfield(
            controller: _dataController,
            label: 'Data da Ocorrência',
          ),
          SizedBox(height: 16),
          CustomTextfield(
            controller: _descricaoController,
            label: 'Descrição',
          ),
          SizedBox(height: 16),
          Text(
            'Latitude: ${posicaoController.latitude}',
            style: themeProvider.themeData.textTheme.bodyLarge,
          ),
          Text(
            'Longitude: ${posicaoController.longitude}',
            style: themeProvider.themeData.textTheme.bodyLarge,
          ),
          if (posicaoController.erro.isNotEmpty)
            Text(
              'Erro: ${posicaoController.erro}',
              style: TextStyle(color: Colors.red),
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