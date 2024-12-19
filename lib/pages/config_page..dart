import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_protege_meu_cerrado/components/responsive_button_cadastro.dart';
import 'package:mobile_protege_meu_cerrado/components/responsive_button_login.dart';
import 'package:mobile_protege_meu_cerrado/pages/notificacao_page.dart';
import 'package:mobile_protege_meu_cerrado/pages/sobre.page.dart';
import 'package:mobile_protege_meu_cerrado/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'perfil_page.dart'; // Importando a tela de perfil

class ConfiguracoesPage extends StatefulWidget {
  const ConfiguracoesPage({super.key});

  @override
  State<ConfiguracoesPage> createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage> {
  bool isLogado = false;
  bool isDarkMode = false;
  bool isNotificationsEnabled = false;
  File? _profileImage;

  @override
  initState() {
    super.initState();
    _estaLogado();
    _getThemePreference();
    _getNotificationPreference();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('profileImage');
    if (imagePath != null) {
      final file = File(imagePath);
      if (await file.exists()) {
        setState(() {
          _profileImage = file;
        });
      } else {
        setState(() {
          _profileImage = null; // Se a imagem não existir, usará a padrão
        });
      }
    }
  }

  Future<void> _estaLogado() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? idUsuario = prefs.getInt('idUsuario');
    setState(() {
      isLogado = idUsuario != null && idUsuario > 0;
    });
  }

  Future<void> _getThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  Future<void> _getNotificationPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isNotificationsEnabled = prefs.getBool('isNotificationsEnabled') ?? false;
    });
  }

  Future<void> _toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = !isDarkMode;
      prefs.setBool('isDarkMode', isDarkMode);
    });
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.toggleTheme();
  }

  Future<void> _toggleNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isNotificationsEnabled = !isNotificationsEnabled;
      prefs.setBool('isNotificationsEnabled', isNotificationsEnabled);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Configurações',
          style: TextStyle(fontSize: 18), // Ajuste o tamanho da fonte aqui
        ),
        backgroundColor: themeProvider
            .themeData.colorScheme.surface, // Cor igual ao fundo da tela
        elevation: 0, // Remover a sombra da AppBar
        centerTitle: true, // Centralizar o título
        titleTextStyle: TextStyle(
          color: themeProvider.themeData.brightness == Brightness.dark
              ? Colors.white // Cor preta no modo escuro
              : Colors.black, // Cor branca no modo claro
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (isLogado) ...[
              _buildUserProfile(themeProvider),
              const Divider(),
            ],
            _buildThemeSwitch(themeProvider),
            const Divider(),
            _buildNotificationsSwitch(themeProvider),
            const Divider(),
            _buildAbout(themeProvider),
            const Divider(),
            if (isLogado) ...[
              _buildLogoutButton(themeProvider),
            ],
            if (!isLogado) ...[
              _buildLoginRegisterButtons(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfile(ThemeProvider themeProvider) {
    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: _profileImage != null
            ? FileImage(_profileImage!) // Imagem salva no perfil
            : const AssetImage('assets/images/default_profile.png')
                as ImageProvider, // Imagem padrão se não houver
      ),
      title: Text(
        'Nome do Usuário',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      subtitle: Text(
        'Visualizar Perfil',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w400,
            ),
      ),
      trailing: Icon(Icons.arrow_forward_ios,
          color: themeProvider.themeData.colorScheme.inversePrimary),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PerfilPage()),
        );
      },
    );
  }

  Widget _buildThemeSwitch(dynamic themeProvider) {
    return ListTile(
      title: Text('Tema', style: Theme.of(context).textTheme.titleMedium),
      trailing: Switch(
        value: isDarkMode,
        onChanged: (value) {
          _toggleTheme();
        },
        activeColor: themeProvider.themeData.primaryColor,
        inactiveThumbColor: themeProvider.themeData.iconTheme.color,
        inactiveTrackColor: themeProvider.themeData.disabledColor,
        activeTrackColor: themeProvider.themeData.primaryColorLight,
      ),
    );
  }

  Widget _buildNotificationsSwitch(dynamic themeProvider) {
    return ListTile(
      title:
          Text('Notificações', style: Theme.of(context).textTheme.titleMedium),
      trailing: Switch(
        value: isNotificationsEnabled,
        onChanged: (value) {
          _toggleNotifications();
        },
        activeColor: themeProvider.themeData.primaryColor,
        inactiveThumbColor: themeProvider.themeData.iconTheme.color,
        inactiveTrackColor: themeProvider.themeData.disabledColor,
        activeTrackColor: themeProvider.themeData.primaryColorLight,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NotificacaoPage(),
          ),
        );
      },
    );
  }

  Widget _buildAbout(dynamic themeProvider) {
    return ListTile(
      title: Text('Sobre', style: Theme.of(context).textTheme.titleMedium),
      trailing: Icon(Icons.arrow_forward_ios,
          color: themeProvider.themeData.colorScheme.inversePrimary),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SobrePage(),
          ),
        );
      },
    );
  }

  Widget _buildLogoutButton(ThemeProvider themeProvider) {
    return ElevatedButton.icon(
      onPressed: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove('idUsuario');
        setState(() {
          isLogado = false;
        });
      },
      icon: const Icon(
        Icons.logout,
        color: Colors.white,
      ),
      label: const Text(
        'Sair da Conta',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: themeProvider.themeData.primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        elevation: 5,
        textStyle: const TextStyle(fontSize: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  Widget _buildLoginRegisterButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ResponsiveButtonLogin(width: 140),
        const SizedBox(width: 16),
        ResponsiveButtonCadastro(width: 140),
      ],
    );
  }
}
