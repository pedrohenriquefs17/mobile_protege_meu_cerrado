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
  File? _imageToSave; // Armazenará a imagem selecionada, antes de salvar

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
        _imageToSave = File(pickedFile.path);
        _image = _imageToSave; // Atualiza a visualização imediatamente
      });
    }
  }

// Função para salvar a imagem selecionada
  Future<void> _saveImage() async {
    if (_imageToSave != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('profileImage', _imageToSave!.path);
      print('Imagem salva: ${_imageToSave!.path}'); // Debugging
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Imagem de perfil salva com sucesso!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
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
            const SizedBox(height: 20),
            // Botão para salvar a imagem selecionada
            ElevatedButton(
              onPressed: _saveImage,
              child: const Text('Salvar Imagem'),
            ),
          ],
        ),
      ),
    );
  }
}
