import 'package:flutter/material.dart';
import 'package:mobile_protege_meu_cerrado/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class SobrePage extends StatelessWidget {
  const SobrePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sobre',
          style: TextStyle(fontSize: 18),
        ),
        backgroundColor: themeProvider.themeData.colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: themeProvider.themeData.brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildVersionInfo(),
            const Divider(),
            _buildPrivacyTerms(context),
            const Divider(),
            _buildSupport(context),
          ],
        ),
      ),
    );
  }

  Widget _buildVersionInfo() {
    return ListTile(
      title: const Text(
        'Versão 1.0.0',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildPrivacyTerms(BuildContext context) {
    return ListTile(
      title: const Text('Termos de Privacidade'),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {},
    );
  }

  Widget _buildSupport(BuildContext context) {
    return ListTile(
      title: const Text('Suporte'),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {},
    );
  }
}
