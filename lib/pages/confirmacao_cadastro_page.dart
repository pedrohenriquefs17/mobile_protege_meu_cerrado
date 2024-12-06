import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mobile_protege_meu_cerrado/components/my_button_login.dart';
import 'package:http/http.dart' as http;

class ConfirmacaoPage extends StatelessWidget {
  final String nome;
  final String cpf;
  final String dataNascimento;
  final String telefone;
  final String email;
  final String senha;

  const ConfirmacaoPage({
    super.key,
    required this.nome,
    required this.cpf,
    required this.dataNascimento,
    required this.telefone,
    required this.email,
    required this.senha,
  });

  Future<String> _formatarData() async {
    final DateFormat dataPadrao = DateFormat('dd/MM/yyyy');
    final DateFormat dataFormatar = DateFormat('yyyy-MM-dd');
    //data nascimento
    final DateTime dataMudarNascimento = dataPadrao.parse(dataNascimento);
    final String dataFormatadaNascimento =
        dataFormatar.format(dataMudarNascimento);
    return dataFormatadaNascimento;
  }

  Future<void> cadastrar(BuildContext context) async {
    String dataNascimentoFormatada = _formatarData() as String;

    final String url = 'https://pmc.airsoftcontrol.com.br/pmc/cadastro';

    final Map<String, dynamic> data = {
      "email": email,
      "senha": senha,
      "nome": nome,
      "cpf": cpf,
      "dataNascimento": dataNascimentoFormatada,
      "telefone": telefone,
      "role": "USUARIO",
    };
    debugPrint('Data: $data');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        Fluttertoast.showToast(
          msg: "Cadastro realizado com sucesso!",
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, '/login');
        });
      } else {
        Fluttertoast.showToast(
          msg: 'Erro ao cadastrar!',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        debugPrint('Erro ao cadastrar: ${response.body}');
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Erro na requisição!",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      debugPrint('Erro na requisição: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fundonovo.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(24.0),
                margin: const EdgeInsets.symmetric(horizontal: 24.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Confirme suas informações",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.displayLarge?.color,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    buildInfoRow("Nome", nome),
                    buildInfoRow("CPF", cpf),
                    buildInfoRow("Data de Nascimento", dataNascimento),
                    buildInfoRow("Telefone", telefone),
                    buildInfoRow("E-mail", email),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: MyButton(
                            text: "Editar",
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: MyButton(
                            text: "Confirmar",
                            onTap: () => cadastrar(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF5B7275),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
