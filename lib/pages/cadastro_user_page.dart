import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mobile_protege_meu_cerrado/components/custom_textfield.dart';
import 'package:mobile_protege_meu_cerrado/components/my_button_login.dart';
import 'package:mobile_protege_meu_cerrado/themes/theme_provider.dart';
import 'package:provider/provider.dart';

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
        print('Senhas válidas');
      }
    });
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
    final dio = Dio();
    final String url = 'https://pmc.airsoftcontrol.com.br/pmc/usuario/cadastro';

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
      "role": "USUARIO"
    };

    try {
      final Response response = await dio.post(url, data: data);
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        debugPrint('Cadastrado com sucesso: ${response.data}');
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
        debugPrint('Erro ao cadastrar: ${response.data}');
        Fluttertoast.showToast(msg: 'Erro ao cadastrar.');
      }
    } catch (e) {
      debugPrint('Erro ao fazer requisição: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            // Logo
            Center(
              child: Image.asset(
                'assets/images/logo_simples_verde.png',
                height: 120,
              ),
            ),
            const SizedBox(height: 20),
            // Título
            Text(
              'Cadastre seu usuário',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: themeProvider.themeData.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 30),

            // Formulário de cadastro
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.only(top: 10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CustomTextfield(
                      controller: nomeController,
                      label: 'Nome Completo',
                    ),
                    const SizedBox(height: 10),
                    CustomTextfield(
                      controller: cpfController,
                      label: 'CPF',
                    ),
                    const SizedBox(height: 10),
                    CustomTextfield(
                      controller: dataNascimentoController,
                      label: 'Data de Nascimento',
                    ),
                    const SizedBox(height: 10),
                    CustomTextfield(
                      controller: telefoneController,
                      label: 'Telefone',
                    ),
                    const SizedBox(height: 10),
                    CustomTextfield(
                      controller: emailController,
                      label: 'E-mail',
                    ),
                    const SizedBox(height: 10),
                    CustomTextfield(
                      controller: senhaController,
                      label: 'Senha',
                      obscureText: true,
                      onChanged: (text) => validarSenha(),
                    ),
                    const SizedBox(height: 10),
                    CustomTextfield(
                      controller: confirmacaoSenhaController,
                      label: 'Confirmar Senha',
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
              ),
            ),
            const SizedBox(height: 20),

            // Botão "Cadastrar"
            MyButton(
              text: "Cadastrar",
              onTap: cadastrar,
            ),
            const SizedBox(height: 10),

            // Botão "Login"
            MyButton(
              text: "Já possui conta? Login",
              onTap: login,
            ),
          ],
        ),
      ),
    );
  }
}
