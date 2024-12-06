import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mobile_protege_meu_cerrado/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class CustomTextfield extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String? mensagemErro;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final bool obrigatorio;

  const CustomTextfield({
    super.key,
    required this.label,
    required this.controller,
    this.mensagemErro,
    this.obscureText = false,
    this.onChanged,
    this.obrigatorio = false,
  });

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Definindo o estilo para o texto da label
    TextStyle labelStyle =
        themeProvider.themeData.textTheme.bodyLarge?.copyWith(
              color: themeProvider.themeData.colorScheme.onSurface,
            ) ??
            TextStyle(color: Colors.black);

    // Definindo o estilo do asterisco (vermelho)
    TextStyle asteriscoStyle =
        labelStyle.copyWith(color: Colors.red); // Asterisco vermelho

    // A label com o asterisco vermelho, se o campo for obrigatório e ainda não preenchido
    String labelComAsterisco = widget.label;
    if (widget.obrigatorio && widget.controller.text.isEmpty) {
      labelComAsterisco = widget.label + ' *'; // Adiciona o asterisco
    }

    // Criação do decoration com a label que inclui o asterisco
    InputDecoration inputDecoration = InputDecoration(
      labelText: labelComAsterisco,
      labelStyle: labelStyle,
      hintStyle:
          themeProvider.themeData.inputDecorationTheme.hintStyle?.copyWith(
        color: themeProvider.themeData.colorScheme.onSurface.withOpacity(0.6),
      ),
      errorText: widget.mensagemErro,
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

    // Mascaradores de entrada
    var maskFormatterData = MaskTextInputFormatter(
        mask: '##/##/####', filter: {'#': RegExp(r'[0-9]')});
    var maskFormatterCpf = MaskTextInputFormatter(
        mask: '###.###.###-##', filter: {'#': RegExp(r'[0-9]')});
    var maskFormatterTelefone = MaskTextInputFormatter(
        mask: '(##)#####-####', filter: {'#': RegExp(r'[0-9]')});

    // De acordo com a label, retorna o TextField com a máscara e estilo apropriado
    if (widget.label == 'Data de Nascimento' ||
        widget.label == 'Data da Ocorrência') {
      return TextField(
        controller: widget.controller,
        decoration: inputDecoration,
        obscureText: widget.obscureText,
        onChanged: widget.onChanged,
        inputFormatters: [maskFormatterData],
        style: themeProvider.themeData.textTheme.bodyLarge?.copyWith(
          color: themeProvider.themeData.colorScheme.onSurface,
        ),
      );
    } else if (widget.label == 'CPF') {
      return TextField(
        controller: widget.controller,
        decoration: inputDecoration,
        obscureText: widget.obscureText,
        onChanged: widget.onChanged,
        inputFormatters: [maskFormatterCpf],
        style: themeProvider.themeData.textTheme.bodyLarge?.copyWith(
          color: themeProvider.themeData.colorScheme.onSurface,
        ),
      );
    } else if (widget.label == 'Telefone') {
      return TextField(
        controller: widget.controller,
        decoration: inputDecoration,
        obscureText: widget.obscureText,
        onChanged: widget.onChanged,
        inputFormatters: [maskFormatterTelefone],
        style: themeProvider.themeData.textTheme.bodyLarge?.copyWith(
          color: themeProvider.themeData.colorScheme.onSurface,
        ),
      );
    } else {
      return TextField(
        controller: widget.controller,
        decoration: inputDecoration,
        obscureText: widget.obscureText,
        onChanged: widget.onChanged,
        style: themeProvider.themeData.textTheme.bodyLarge?.copyWith(
          color: themeProvider.themeData.colorScheme.onSurface,
        ),
      );
    }
  }
}
