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
        Navigator.pushReplacementNamed(context, '/cadastroUsuario');
      },
      child: Container(
        width: width ?? double.infinity,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: themeProvider.themeData.colorScheme.primary,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 4),
              blurRadius: 10,
            ),
          ], // Cor principal
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_add,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              "Registrar",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
