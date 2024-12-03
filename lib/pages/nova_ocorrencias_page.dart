import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mobile_protege_meu_cerrado/components/custom_textfield.dart';
import 'package:mobile_protege_meu_cerrado/components/my_button_login.dart';
import 'package:mobile_protege_meu_cerrado/controller/posicao_controller.dart';
import 'package:mobile_protege_meu_cerrado/pages/sel_localizacao_maps.dart';
import 'package:mobile_protege_meu_cerrado/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class NovaOcorrenciaPage extends StatefulWidget {
  const NovaOcorrenciaPage({super.key});

  @override
  _NovaOcorrenciaPageState createState() => _NovaOcorrenciaPageState();
}

class _NovaOcorrenciaPageState extends State<NovaOcorrenciaPage> {
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _dataNascimentoController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final teste = 0;
  final List<XFile> _imagens = [];
  bool isSwitched = false;

  final Dio _dio = Dio();
  List<Map<String, dynamic>> _categorias = [];
  String? _categoriaSelecionada;

  @override
  void initState() {
    super.initState();
    _fetchCategorias();

    final String dataAtual = DateFormat('dd/MM/yyy').format(DateTime.now());
    _dataController.text = dataAtual;
  }

  Future<void> _fetchCategorias() async {
    try {
      Response response = await _dio.get(
        "https://pmc.airsoftcontrol.com.br/ocorrencias/categorias",
        options: Options(
          headers: {
            "Accept": "*/*",
            "User-Agent": "Flutter App",
          },
        ),
      );

      setState(() {
        _categorias = List<Map<String, dynamic>>.from(response.data);
        print("id_categoria: $_categoriaSelecionada");
      });
    } catch (e) {
      print("Erro ao carregar categorias: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao carregar categorias")),
      );
    }
  }

  Future<void> _pegarImagem() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> imagens = await picker.pickMultiImage();
    setState(() {
      _imagens.addAll(imagens);
    });
  }

  Future<void> _formatarData() async {
    final DateFormat dataPadrao = DateFormat('dd/MM/yyyy');
    final DateFormat dataFormatar = DateFormat('yyyy-MM-dd');
    //data nascimento
    final DateTime dataMudarNascimento =
        dataPadrao.parse(_dataNascimentoController.text.trim());
    final String dataFormatadaNascimento =
        dataFormatar.format(dataMudarNascimento);
    _dataNascimentoController.text = dataFormatadaNascimento;
    //data ocorrencia
    final DateTime dataMudarOcorrencia =
        dataPadrao.parse(_dataController.text.trim());
    final String dataFormatadaOcorrencia =
        dataFormatar.format(dataMudarOcorrencia);
    _dataController.text = dataFormatadaOcorrencia;
  }

  Future<void> _enviarOcorrencia() async {
    _formatarData();
    final posicaoController =
        Provider.of<PosicaoController>(context, listen: false);
    try {
      final data = {
        "id": null,
        "id_categoria": int.tryParse(_categoriaSelecionada ?? ''),
        "nome": isSwitched ? null : _nomeController.text,
        "email": isSwitched ? null : _emailController.text,
        "cpf": isSwitched ? null : _cpfController.text,
        "telefone": null,
        "dt_nasc": isSwitched ? null : _dataNascimentoController.text,
        "descricao": _descricaoController.text,
        "is_anon": isSwitched,
        "dt_ocorrencia": _dataController.text,
        "lat": posicaoController.latitude,
        "lon": posicaoController.longitude,
      };
      debugPrint("Dados enviados: $data");

      if (_descricaoController.text.isEmpty || _dataController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text("Por favor, preencha todos os campos obrigatórios.")),
        );
        return;
      }

      Response response = await _dio.put(
        "https://pmc.airsoftcontrol.com.br/ocorrencias",
        data: data,
        options: Options(
          headers: {
            "Accept": "*/*",
            "User-Agent": "Flutter App",
          },
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ocorrência cadastrada com sucesso!")),
      );
    } catch (e) {
      debugPrint("Erro ao enviar ocorrência: $e");
      if (e is DioException) {
        debugPrint("Resposta do servidor: ${e.response?.data}");
      }
      debugPrint("Erro ao enviar ocorrência: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao enviar ocorrência")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final posicaoController = Provider.of<PosicaoController>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Cadastrar Ocorrências',
          style: themeProvider.themeData.textTheme.titleLarge?.copyWith(
            color: themeProvider.themeData.colorScheme.onSurface,
          ),
        ),
        backgroundColor: themeProvider.themeData.colorScheme.surface,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: themeProvider.themeData.colorScheme.onSurface,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Denúncia Anônima',
                  style: themeProvider.themeData.textTheme.bodyLarge?.copyWith(
                    color: themeProvider.themeData.colorScheme.onSurface,
                  ),
                ),
                Switch(
                  value: isSwitched,
                  onChanged: (value) {
                    setState(() {
                      isSwitched = value;
                    });
                  },
                ),
              ],
            ),
            if (!isSwitched) ...[
              CustomTextfield(
                  controller: _nomeController, label: 'Nome Completo'),
              const SizedBox(height: 16),
              CustomTextfield(controller: _emailController, label: 'E-mail'),
              const SizedBox(height: 16),
              CustomTextfield(controller: _cpfController, label: 'CPF'),
              const SizedBox(height: 16),
              CustomTextfield(
                  controller: _dataNascimentoController,
                  label: 'Data de Nascimento'),
            ],
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: _categoriaSelecionada,
              hint: const Text('Selecione o Tipo de Ocorrência'),
              isExpanded: true,
              items: _categorias.map((categoria) {
                return DropdownMenuItem<String>(
                  value: categoria['id'].toString(),
                  child: Text(categoria['nome_categoria']),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _categoriaSelecionada = newValue;
                });
              },
            ),
            const SizedBox(height: 16),
            CustomTextfield(
                controller: _dataController, label: 'Data da Ocorrência'),
            const SizedBox(height: 16),
            CustomTextfield(
                controller: _descricaoController, label: 'Descrição'),
            const SizedBox(height: 16),
            Consumer<PosicaoController>(
              builder: (context, posicaoController, child) {
                return Text(
                  'Latitude: ${posicaoController.latitude} - Longitude: ${posicaoController.longitude}',
                  style: themeProvider.themeData.textTheme.bodyLarge,
                );
              },
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
            const SizedBox(height: 16),
            MyButton(
              text: 'Capturar Localização',
              onTap: () async {
                final LatLng? novaPosicao = await Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => SelLocalizacaoMaps(
                            latitudeInicial: posicaoController.latitude,
                            longitudeInicial: posicaoController.longitude,
                          )),
                );
                if (novaPosicao != null) {
                  setState(() {
                    posicaoController.latitude = novaPosicao.latitude;
                    posicaoController.longitude = novaPosicao.longitude;
                  });
                }
              },
              width: 150,
              height: 40,
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
            SizedBox(height: 16),
            MyButton(
              text: 'Selecionar Imagens',
              onTap: _pegarImagem,
              width: 150,
              height: 40,
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
            const SizedBox(height: 16),
            MyButton(
              text: 'Salvar Ocorrência',
              onTap: _enviarOcorrencia,
              width: 150,
              height: 40,
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ],
        ),
      ),
    );
  }
}
