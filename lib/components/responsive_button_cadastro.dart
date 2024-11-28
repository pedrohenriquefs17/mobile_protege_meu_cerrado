import 'package:flutter/material.dart';
import 'package:mobile_protege_meu_cerrado/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class ResponsiveButtonCadastro extends StatelessWidget {
  final bool? isResponsive;
  final double? width;

  const ResponsiveButtonCadastro(
      {super.key, this.width, this.isResponsive = false});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return GestureDetector(
      onTap: () {
        // Navegar para a tela 'home'
        Navigator.pushReplacementNamed(context, '/cadastro');
      },
      child: Container(
        width: width,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: themeProvider.themeData.colorScheme.primary, // Cor principal
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Cadastro"),
          ],
        ),
      ),
    );
  }
}
