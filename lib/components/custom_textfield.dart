import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mobile_protege_meu_cerrado/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class CustomTextfield extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  const CustomTextfield({
    super.key,
    required this.label,
    required this.controller,
  });

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    var maskFormatterData = MaskTextInputFormatter(
        mask: '##/##/####', filter: {'#': RegExp(r'[0-9]')});
    var maskFormatterCpf = MaskTextInputFormatter(
        mask: '###.###.###-##', filter: {'#': RegExp(r'[0-9]')});

    InputDecoration inputDecoration = InputDecoration(
      labelText: widget.label,
      labelStyle: themeProvider.themeData.textTheme.bodyLarge?.copyWith(
        color: themeProvider.themeData.colorScheme.onSurface,
      ),
      hintStyle:
          themeProvider.themeData.inputDecorationTheme.hintStyle?.copyWith(
        color: themeProvider.themeData.colorScheme.onSurface.withOpacity(0.6),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: themeProvider.themeData.colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: themeProvider.themeData.colorScheme.primary,
        ),
      ),
    );

    if (widget.label == 'Descrição') {
      return TextField(
        controller: widget.controller,
        decoration: inputDecoration,
        style: themeProvider.themeData.textTheme.bodyLarge?.copyWith(
          color: themeProvider.themeData.colorScheme.onSurface,
        ),
        maxLines: 5,
      );
    } else if (widget.label == 'Data de Nascimento' ||
        widget.label == 'Data da Ocorrência') {
      return TextField(
        controller: widget.controller,
        decoration: inputDecoration,
        style: themeProvider.themeData.textTheme.bodyLarge?.copyWith(
          color: themeProvider.themeData.colorScheme.onSurface,
        ),
        inputFormatters: [maskFormatterData],
      );
    } else if (widget.label == 'CPF') {
      return TextField(
        controller: widget.controller,
        decoration: inputDecoration,
        style: themeProvider.themeData.textTheme.bodyLarge?.copyWith(
          color: themeProvider.themeData.colorScheme.onSurface,
        ),
        inputFormatters: [maskFormatterCpf],
      );
    } else {
      return TextField(
        controller: widget.controller,
        decoration: inputDecoration,
        style: themeProvider.themeData.textTheme.bodyLarge?.copyWith(
          color: themeProvider.themeData.colorScheme.onSurface,
        ),
      );
    }
  }
}
