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
        //formatando os campos
        mask: '##/##/####',
        filter: {'#': RegExp(r'[0-9]')});
    var maskFormatterCpf = MaskTextInputFormatter(
        mask: '###.###.###-##', filter: {'#': RegExp(r'[0-9]')});

    if (widget.label == 'Descrição') {
      return TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.label,
          hintStyle: themeProvider.themeData.inputDecorationTheme.hintStyle,
          enabledBorder:
              themeProvider.themeData.inputDecorationTheme.enabledBorder,
          focusedBorder:
              themeProvider.themeData.inputDecorationTheme.focusedBorder,
        ),
        style: themeProvider.themeData.textTheme.bodyLarge,
        maxLines: 5,
      );
    } else if (widget.label == 'Data de Nascimento' ||
        widget.label == 'Data da Ocorrência') {
      return TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.label,
          hintStyle: themeProvider.themeData.inputDecorationTheme.hintStyle,
          enabledBorder:
              themeProvider.themeData.inputDecorationTheme.enabledBorder,
          focusedBorder:
              themeProvider.themeData.inputDecorationTheme.focusedBorder,
        ),
        style: themeProvider.themeData.textTheme.bodyLarge,
        inputFormatters: [maskFormatterData],
      );
    } else if (widget.label == 'CPF') {
      return TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.label,
          hintStyle: themeProvider.themeData.inputDecorationTheme.hintStyle,
          enabledBorder:
              themeProvider.themeData.inputDecorationTheme.enabledBorder,
          focusedBorder:
              themeProvider.themeData.inputDecorationTheme.focusedBorder,
        ),
        style: themeProvider.themeData.textTheme.bodyLarge,
        inputFormatters: [maskFormatterCpf],
      );
    } else {
      return TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.label,
          hintStyle: themeProvider.themeData.inputDecorationTheme.hintStyle,
          enabledBorder:
              themeProvider.themeData.inputDecorationTheme.enabledBorder,
          focusedBorder:
              themeProvider.themeData.inputDecorationTheme.focusedBorder,
        ),
        style: themeProvider.themeData.textTheme.bodyLarge,
      );
    }
  }
}
