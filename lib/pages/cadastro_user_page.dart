import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mobile_protege_meu_cerrado/components/custom_textfield.dart';
import 'package:mobile_protege_meu_cerrado/components/my_button_login.dart';
import 'package:mobile_protege_meu_cerrado/pages/confirmacao_cadastro_page.dart';
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

  Future<void> irParaConfirmcao() async {
    if (mensagemErro != null) {
      Fluttertoast.showToast(
        msg: "Corrija os erros antes de prosseguir!",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmacaoPage(
            nome: nomeController.text.trim(),
            cpf: cpfController.text.trim(),
            dataNascimento: dataNascimentoController.text.trim(),
            telefone: telefoneController.text.trim(),
            email: emailController.text.trim(),
          ),
        ));
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
