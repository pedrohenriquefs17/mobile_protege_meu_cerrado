import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile_protege_meu_cerrado/components/my_button_login.dart';
import 'package:mobile_protege_meu_cerrado/components/my_recuperar_button.dart';
import 'package:mobile_protege_meu_cerrado/components/my_textfield.dart';
import 'package:mobile_protege_meu_cerrado/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadLoginData();
  }

  Future<void> _loadLoginData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();

    String? email = prefs.getString('email');
    String? senha = prefs.getString('senha');
    bool? remember = prefs.getBool('rememberMe');

    if (remember == true) {
      setState(() {
        emailController.text = email ?? '';
        senhaController.text = senha ?? '';
        rememberMe = true;
      });
    }
  }

  Future<void> _saveLoginData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      prefs.setString('email', emailController.text.trim());
      prefs.setString('senha', senhaController.text.trim());
      prefs.setBool('rememberMe', rememberMe);
    } else {
      prefs.remove('email');
      prefs.remove('senha');
      prefs.remove('rememberMe');
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> login() async {
    String enteredEmail = emailController.text.trim();
    String enteredPassword = senhaController.text.trim();
    await _saveLoginData();

    debugPrint('Tentando login com email: $enteredEmail');
    final dio = Dio();
    final String url = 'https://pmc.airsoftcontrol.com.br/pmc/usuario/login';

    final Map<String, dynamic> data = {
      "email": enteredEmail,
      "senha": enteredPassword,
    };

    try {
      final Response response = await dio.post(url, data: data);

      // Exibir informações da resposta
      debugPrint('Tipo da resposta: ${response.data.runtimeType}');
      debugPrint('Dados da resposta: ${response.data}');

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final responseData = response.data;

        // Verificar se tokenDTO e idUsuario estão presentes
        if (responseData['tokenDTO'] != null &&
            responseData['tokenDTO']['token'] != null &&
            responseData['idUsuario'] != null) {
          final String token = responseData['tokenDTO']['token'];

          // Garantir que idUsuario seja um int
          final int idUsuario =
              int.tryParse(responseData['idUsuario'].toString()) ?? 0;

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          await prefs.setInt('idUsuario', idUsuario);

          debugPrint(
              'Login realizado com sucesso. Token: $token, ID: $idUsuario');
          Fluttertoast.showToast(
            msg: "Login realizado com sucesso!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          WidgetsBinding.instance.addPostFrameCallback((_) {
            // Navegar para a tela principal
            Navigator.pushReplacementNamed(context, '/home');
          });
        } else {
          // Caso os dados não sejam encontrados corretamente
          Fluttertoast.showToast(msg: 'Erro ao processar os dados de login.');
        }
      } else {
        debugPrint('Erro ao fazer login: ${response.data}');
        Fluttertoast.showToast(msg: 'Erro ao fazer login.');
      }
    } catch (e) {
      debugPrint('Erro ao fazer requisição: $e');
      Fluttertoast.showToast(msg: 'Erro na requisição. Tente novamente.');
    }
  }

  @override
  Widget build(BuildContext context) {
    String versao = "Versão 1.0.0";
    return PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  const Image(
                    image: AssetImage('assets/images/logo_simples_verde.png'),
                    width: 200,
                    height: 200,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Protege Meu Cerrado",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 30),
                  MyTextField(
                    controller: emailController,
                    hintText: "E-mail",
                    isPassword: false,
                  ),
                  const SizedBox(height: 20),
                  MyTextField(
                    controller: senhaController,
                    hintText: "Senha",
                    isPassword: true,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  rememberMe = value ?? false;
                                });
                              },
                            ),
                            const Text("Lembrar de mim"),
                          ],
                        ),
                        const MyRecuperarTxtbutton(),
                      ],
                    ),
                  ),
                  //ElevatedButton(onPressed: login, child: Text("Entrar")),
                  MyButton(
                    text: "Entrar",
                    onTap: login,
                  ),
                  const SizedBox(height: 80),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        versao,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
