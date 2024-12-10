import 'package:flutter/material.dart';
import 'package:mobile_protege_meu_cerrado/themes/theme_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AppText extends StatelessWidget {
  double size;
  final String text;
  final Color color;
  final TextAlign textAlign;
  AppText(
      {super.key,
      required this.text,
      required this.color,
      this.size = 16,
      this.textAlign = TextAlign.start});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Text(
      text,
      textAlign: textAlign,
      style: themeProvider.themeData.textTheme.displayLarge?.copyWith(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}
