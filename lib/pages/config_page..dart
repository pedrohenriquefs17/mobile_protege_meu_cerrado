import 'package:flutter/material.dart';
import 'package:mobile_protege_meu_cerrado/components/responsive_button_cadastro.dart';
import 'package:mobile_protege_meu_cerrado/components/responsive_button_login.dart';
import 'package:mobile_protege_meu_cerrado/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfiguracoesPage extends StatefulWidget {
  const ConfiguracoesPage({super.key});

  @override
  State<ConfiguracoesPage> createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage> {
  bool isLogado = false;

  @override
  initState() {
    super.initState();
    _estaLogado();
  }

  Future<void> _estaLogado() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? idUsuario = prefs.getInt('idUsuario');
    if (idUsuario != null && idUsuario > 0) {
      setState(() {
        isLogado = true;
      });
    } else {
      setState(() {
        isLogado = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: Column(
        children: [
          if (isLogado) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Você está logado'),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () =>
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.pushReplacementNamed(context, '/onboarding');
                      }),
                      icon: const Icon(Icons.logout),
                      label: const Text(
                        'Sair da Conta',
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        elevation: 8,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ] else ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Não Possui Login ?'),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ResponsiveButtonLogin(width: 140),
                    ResponsiveButtonCadastro(width: 140),
                  ],
                ),
              ],
            )
          ]
        ],
      ),
    );
  }
}
