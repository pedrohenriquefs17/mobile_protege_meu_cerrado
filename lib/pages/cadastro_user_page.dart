import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mobile_protege_meu_cerrado/components/custom_textfield.dart';
import 'package:mobile_protege_meu_cerrado/components/my_button_login.dart';
import 'package:mobile_protege_meu_cerrado/pages/confirmacao_cadastro_page.dart';
import 'package:mobile_protege_meu_cerrado/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class CadastroUserPage extends StatefulWidget {
  const CadastroUserPage({super.key});

  @override
  State<CadastroUserPage> createState() => _CadastroUserPageState();
}

class _CadastroUserPageState extends State<CadastroUserPage> {
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController dataNascimentoController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController confirmacaoSenhaController =
      TextEditingController();
  final TextEditingController telefoneController = TextEditingController();

  String? mensagemErro;

  void validarSenha() {
    setState(() {
      if (senhaController.text != confirmacaoSenhaController.text) {
        mensagemErro = 'Senhas não conferem!';
      } else {
        mensagemErro = null;
      }
    });
  }

  bool validarCampos() {
    // Verifica se todos os campos são válidos
    return nomeController.text.trim().isNotEmpty &&
        cpfController.text.trim().isNotEmpty &&
        dataNascimentoController.text.trim().isNotEmpty &&
        telefoneController.text.trim().isNotEmpty &&
        emailController.text.trim().isNotEmpty &&
        senhaController.text.trim().isNotEmpty &&
        confirmacaoSenhaController.text.trim().isNotEmpty &&
        mensagemErro == null;
  }

  Future<void> irParaConfirmcao() async {
    // Valida os campos antes de prosseguir
    if (!validarCampos()) {
      setState(() {
        mensagemErro = "Preencha todos os campos obrigatórios!";
      });
      return;
    }

    // Redireciona para a página de confirmação
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmacaoPage(
          nome: nomeController.text.trim(),
          cpf: cpfController.text.trim(),
          dataNascimento: dataNascimentoController.text.trim(),
          telefone: telefoneController.text.trim(),
          email: emailController.text.trim(),
          senha: senhaController.text.trim(),
        ),
      ),
    );
  }

  Future<void> login() async {
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> cadastrar() async {
    if (mensagemErro != null) {
      Fluttertoast.showToast(
        msg: "Corrija os erros antes de prosseguir!",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    final String url = 'https://pmc.airsoftcontrol.com.br/pmc/cadastro';

    final DateFormat dataPadrao = DateFormat('dd/MM/yyyy');
    final DateFormat dataFormatar = DateFormat('yyyy-MM-dd');
    final DateTime dataMudar =
        dataPadrao.parse(dataNascimentoController.text.trim());
    final String dataFormatada = dataFormatar.format(dataMudar);

    final Map<String, dynamic> data = {
      "email": emailController.text.trim(),
      "senha": senhaController.text.trim(),
      "nome": nomeController.text.trim(),
      "cpf": cpfController.text.trim(),
      "dataNascimento": dataFormatada,
      "telefone": telefoneController.text.trim(),
      "role": "USER"
    };

    debugPrint('Dados enviados: $data');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint('Cadastrado com sucesso: ${response.body}');
        Fluttertoast.showToast(
          msg: "Cadastro realizado com sucesso!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, '/login');
        });
      } else {
        debugPrint(
            'Erro ao cadastrar: ${response.statusCode} - ${response.body}');
        Fluttertoast.showToast(msg: 'Erro ao cadastrar: ${response.body}');
      }
    } catch (e) {
      debugPrint('Erro ao fazer requisição: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          // Imagem de fundo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/fundonovo.png'), // Caminho da imagem
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Conteúdo da tela
          Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(24.0),
                margin: const EdgeInsets.symmetric(horizontal: 24.0),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surface
                      .withOpacity(0.9), // Fundo semitransparente
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
                      'Cadastre seu usuário',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(height: 30),

                    // Formulário de cadastro
                    Column(
                      children: [
                        CustomTextfield(
                          controller: nomeController,
                          label: 'Nome Completo',
                          obrigatorio: true,
                        ),
                        const SizedBox(height: 10),
                        CustomTextfield(
                          controller: cpfController,
                          label: 'CPF',
                          obrigatorio: true,
                        ),
                        const SizedBox(height: 10),
                        CustomTextfield(
                          controller: dataNascimentoController,
                          label: 'Data de Nascimento',
                          obrigatorio: true,
                        ),
                        const SizedBox(height: 10),
                        CustomTextfield(
                          controller: telefoneController,
                          label: 'Telefone',
                          obrigatorio: true,
                        ),
                        const SizedBox(height: 10),
                        CustomTextfield(
                          controller: emailController,
                          label: 'E-mail',
                          obrigatorio: true,
                        ),
                        const SizedBox(height: 10),
                        CustomTextfield(
                          controller: senhaController,
                          label: 'Senha',
                          obrigatorio: true,
                          obscureText: true,
                          onChanged: (text) => validarSenha(),
                        ),
                        const SizedBox(height: 10),
                        CustomTextfield(
                          controller: confirmacaoSenhaController,
                          label: 'Confirmar Senha',
                          obrigatorio: true,
                          obscureText: true,
                          onChanged: (text) => validarSenha(),
                        ),
                        if (mensagemErro != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              mensagemErro!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Botão "Cadastrar"
                    MyButton(
                      text: "Cadastrar",
                      onTap: irParaConfirmcao,
                    ),
                    const SizedBox(height: 10),

                    // Botão "Login"
                    TextButton(
                      onPressed: login,
                      child: const Text(
                        "Já possui conta? Login",
                        style: TextStyle(fontSize: 14),
                      ),
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
}
