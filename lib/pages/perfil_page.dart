import 'dart:io';

import 'package:flutter/material.dart';
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
  File? _image; // Armazenará a imagem do perfil

  @override
  void initState() {
    super.initState();
    _loadProfileImage(); // Carrega a imagem de perfil salva, se houver
  }

  // Carregar a imagem de perfil salva
  Future<void> _loadProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('profileImage');
    if (imagePath != null) {
      final file = File(imagePath);
      if (await file.exists()) {
        setState(() {
          _image = file;
        });
      } else {
        // Se a imagem não existir no caminho salvo, reseta para a imagem padrão
        setState(() {
          _image = null;
        });
      }
    }
  }

  // Função para selecionar a imagem
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Salvar a imagem no SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('profileImage', pickedFile.path);
      print('Imagem salva: ${pickedFile.path}'); // Debugging
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          // Ícone circular da foto do perfil no AppBar
          GestureDetector(
            onTap: _pickImage, // Permite ao usuário mudar a foto do perfil
            child: CircleAvatar(
              radius: 20,
              backgroundImage: _image != null
                  ? FileImage(_image!) // Exibe a imagem do arquivo
                  : const AssetImage('assets/images/default_profile.png')
                      as ImageProvider, // Imagem padrão
            ),
          ),
          const SizedBox(width: 10), // Espaçamento entre a foto e o título
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mostrar a imagem de perfil
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
          ],
        ),
      ),
    );
  }
}
