import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mobile_protege_meu_cerrado/components/custom_textfield.dart';
import 'package:mobile_protege_meu_cerrado/controller/posicao_controller.dart';
import 'package:mobile_protege_meu_cerrado/pages/sel_localizacao_maps.dart';
import 'package:mobile_protege_meu_cerrado/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NovaOcorrenciaPage extends StatefulWidget {
  const NovaOcorrenciaPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
  final TextEditingController _telefoneController = TextEditingController();
  final List<XFile> _imagens = [];
  bool isSwitched = false;
  bool isLogado = false;

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
        "http://192.168.56.1:8080/ocorrencias/categorias", //colocar seu ip
        options: Options(
          headers: {
            "Accept": "*/*",
            "User-Agent": "Flutter App",
          },
        ),
      );

      setState(() {
        _categorias = List<Map<String, dynamic>>.from(response.data);
        debugPrint("idCategoria: $_categoriaSelecionada");
      });
    } catch (e) {
      debugPrint("Erro ao carregar categorias: $e");
      Fluttertoast.showToast(msg: 'Erro ao carregar categorias.');
    }
  }

  Future<void> _pegarImagem() async {
    final ImagePicker picker = ImagePicker();

    // Selecionando múltiplas imagens
    final List<XFile> imagens = await picker.pickMultiImage();

    if (imagens.isNotEmpty) {
      setState(() {
        _imagens.addAll(imagens);
      });
    }
  }

  Future<void> _formatarData() async {
    final DateFormat dataPadrao = DateFormat('dd/MM/yyyy');
    final DateFormat dataFormatar = DateFormat('yyyy-MM-dd');

    //data nascimento
    if (!isLogado) {
      final DateTime dataMudarNascimento =
          dataPadrao.parse(_dataNascimentoController.text.trim());
      final String dataFormatadaNascimento =
          dataFormatar.format(dataMudarNascimento);
      _dataNascimentoController.text = dataFormatadaNascimento;
    }
    //data ocorrencia
    final DateTime dataMudarOcorrencia =
        dataPadrao.parse(_dataController.text.trim());
    final String dataFormatadaOcorrencia =
        dataFormatar.format(dataMudarOcorrencia);
    _dataController.text = dataFormatadaOcorrencia;
  }

  Future<void> _enviarOcorrencia() async {
    await _formatarData();
    final posicaoController =
        // ignore: use_build_context_synchronously
        Provider.of<PosicaoController>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final dio = Dio();

    final String url = 'http://192.168.56.1:8080/ocorrencias'; //colocar seu ip

    final Map<String, dynamic> data = {
      "idUser": prefs.getInt('idUsuario'),
      "idCategoria": int.tryParse(_categoriaSelecionada ?? ''),
      "nome": isSwitched ? null : _nomeController.text.trim(),
      "email": isSwitched ? null : _emailController.text.trim(),
      "cpf": isSwitched ? null : _cpfController.text.trim(),
      "telefone": isSwitched ? null : _telefoneController.text.trim(),
      "dtNasc": isSwitched ? null : _dataNascimentoController.text.trim(),
      "descricao": _descricaoController.text.trim(),
      "isAnon": isSwitched,
      "dtOcorrencia": _dataController.text.trim(),
      "lat": posicaoController.latitude.toString(),
      "lon": posicaoController.longitude.toString(),
    };
    debugPrint('Dados enviados: $data');

    final formData = FormData.fromMap(data);

    // Adicionando imagens
    if (_imagens.isNotEmpty) {
      for (var imagem in _imagens) {
        formData.files.add(MapEntry(
          'imagem',
          await MultipartFile.fromFile(imagem.path, filename: imagem.name),
        ));
      }
    }

    try {
      final Response response = await dio.post(url, data: formData);

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        Fluttertoast.showToast(
          msg: 'Ocorrência enviada com sucesso!',
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pop();
        });
      } else {
        debugPrint('Erro ao enviar ocorrência: ${response.data}');
        Fluttertoast.showToast(msg: 'Erro ao enviar ocorrência.');
      }
    } catch (e) {
      debugPrint('Erro na requisição: $e');
      Fluttertoast.showToast(msg: 'Erro na requisição.');
    }
  }

  Future<void> _estaLogado() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? idUsuario = prefs.getInt('idUsuario');
    if (idUsuario != null && idUsuario > 0) {
      isLogado = true;
    } else {
      isLogado = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    _estaLogado();
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Denúncia Anônima',
                    style:
                        themeProvider.themeData.textTheme.bodyLarge?.copyWith(
                      color: themeProvider.themeData.colorScheme.onSurface,
                    ),
                  ),
                  if (isLogado) ...[
                    Switch(
                      value: isSwitched,
                      onChanged: (value) {
                        setState(() {
                          isSwitched = value;
                        });
                      },
                    ),
                  ],
                ],
              ),
              if (!isLogado) ...[
                CustomTextfield(
                  controller: _nomeController,
                  label: 'Nome',
                ),
                CustomTextfield(
                  controller: _emailController,
                  label: 'E-mail',
                ),
                CustomTextfield(
                  controller: _cpfController,
                  label: 'CPF',
                ),
                CustomTextfield(
                  controller: _telefoneController,
                  label: 'Telefone',
                ),
                CustomTextfield(
                  controller: _dataNascimentoController,
                  label: 'Data de Nascimento',
                ),
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
                  : GridView.builder(
                      shrinkWrap: true,
                      itemCount: _imagens.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemBuilder: (context, index) {
                        return Image.file(
                          File(_imagens[index].path),
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
              const SizedBox(height: 16),
              Container(
                width: 250,
                height: 80,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF38B887),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 10,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    shadowColor: Colors.black.withOpacity(0.4),
                  ),
                  onPressed: () async {
                    final LatLng? novaPosicao =
                        await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SelLocalizacaoMaps(
                          latitudeInicial: posicaoController.latitude,
                          longitudeInicial: posicaoController.longitude,
                        ),
                      ),
                    );
                    if (novaPosicao != null) {
                      setState(() {
                        posicaoController.latitude = novaPosicao.latitude;
                        posicaoController.longitude = novaPosicao.longitude;
                      });
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 30,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Capturar Localização',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 250,
                height: 80,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF38B887),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 10,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    shadowColor: Colors.black.withOpacity(0.4),
                  ),
                  onPressed: _pegarImagem,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image,
                        color: Colors.white,
                        size: 30,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Selecionar Imagens',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 250,
                height: 80,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF38B887),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 10,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    shadowColor: Colors.black.withOpacity(0.4),
                  ),
                  onPressed: _enviarOcorrencia,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.save,
                        color: Colors.white,
                        size: 30,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Salvar Ocorrência',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
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
