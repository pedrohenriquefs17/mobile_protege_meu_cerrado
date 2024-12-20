import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mobile_protege_meu_cerrado/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  File? _image;
  File? _imageToSave;
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController dataNascController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  int? idUsuario;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    _fetchUserProfile();
  }

  Future<void> _loadProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('profileImage');
    if (imagePath != null) {
      final file = File(imagePath);
      if (await file.exists()) {
        setState(() {
          _image = file;
        });
      }
    }
  }

  Future<void> _fetchUserProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      idUsuario = prefs.getInt('idUsuario');
      debugPrint('ID do usuário carregado: $idUsuario');

      if (idUsuario == null) {
        Fluttertoast.showToast(msg: 'Erro: Usuário não encontrado.');
        return;
      }

      final response = await http.get(
        Uri.parse(
            'https://pmc.airsoftcontrol.com.br/pmc/listar/usuario?usuario=$idUsuario'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Debug para verificar a resposta da API
        debugPrint('Resposta da API: $data');

        setState(() {
          nomeController.text = data['nome'] ?? '';
          emailController.text = data['email'] ?? '';
          cpfController.text = data['cpf'] ?? '';
          telefoneController.text = data['telefone'] ?? '';
          dataNascController.text = data['dataNascimento'] ?? '';
          if (data['roles'] != null && data['roles'].isNotEmpty) {
            roleController.text = data['roles'][0]['name'] ?? '';
          } else {
            roleController.text = '';
          }
        });
      } else {
        Fluttertoast.showToast(
          msg:
              'Erro ao buscar informações do perfil. Código: ${response.statusCode}',
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Erro ao conectar com a API: $e',
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> _updateUserProfile() async {
    if (idUsuario == null) {
      Fluttertoast.showToast(msg: 'Erro: Usuário não encontrado.');
      return;
    }

    debugPrint('Senha: ${senhaController.text}');
    debugPrint('Role: ${roleController.text}');

    final Map<String, dynamic> updatedData = {
      "nome": nomeController.text,
      "telefone": telefoneController.text,
      "email": emailController.text,
      "cpf": cpfController.text,
      "dataNascimento": dataNascController.text,
      "senha": "",
      "role": roleController.text, // Envia o role
    };
    debugPrint('Senha enviada: ${senhaController.text}');

    debugPrint('Dados a serem enviados para a API: ${jsonEncode(updatedData)}');

    // Debug para verificar os dados que serão enviados
    debugPrint('Dados a serem enviados para a API: ${jsonEncode(updatedData)}');

    try {
      final response = await http.put(
        Uri.parse(
            'https://pmc.airsoftcontrol.com.br/pmc/atualizar/usuario/$idUsuario'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: 'Perfil atualizado com sucesso!',
          backgroundColor: Colors.green,
        );
      } else {
        debugPrint('Erro ${response.statusCode}: ${response.body}');
        Fluttertoast.showToast(
          msg: 'Erro ao atualizar o perfil. Detalhes: ${response.body}',
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Erro ao conectar com a API: $e',
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageToSave = File(pickedFile.path);
        _image = _imageToSave;
      });
    }
  }

  Future<void> _saveImage() async {
    if (_imageToSave != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('profileImage', _imageToSave!.path);
      Fluttertoast.showToast(
        msg: 'Imagem salva com sucesso!',
        backgroundColor: Colors.green,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: themeProvider.themeData.colorScheme.surface,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: _image != null
                    ? FileImage(_image!)
                    : const AssetImage('assets/images/default_profile.png')
                        as ImageProvider,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Escolher Imagem'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'E-mail'),
                enabled: false,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: cpfController,
                decoration: const InputDecoration(labelText: 'CPF'),
                enabled: false,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: telefoneController,
                decoration: const InputDecoration(labelText: 'Telefone'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: dataNascController,
                decoration:
                    const InputDecoration(labelText: 'Data de Nascimento'),
                enabled: false,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateUserProfile,
                child: const Text('Atualizar Perfil'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
