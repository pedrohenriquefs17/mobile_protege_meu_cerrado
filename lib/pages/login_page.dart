import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mobile_protege_meu_cerrado/components/my_button_login.dart';
import 'package:mobile_protege_meu_cerrado/components/my_cadastrar_text_button.dart';
import 'package:mobile_protege_meu_cerrado/components/my_recuperar_button.dart';
import 'package:mobile_protege_meu_cerrado/components/my_textfield.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    _checkLoggedIn();

    //para mudanças do token FMC
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user.uid)
            .update({'fmcToken': newToken});
      }
    });
  }

  Future<void> _checkLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    if (token != null && token.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/home');
      });
    }
  }

  Future<void> _loadLoginData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

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

  bool _isLoading = false;

  Future<void> login() async {
    setState(() {
      _isLoading = true; // Exibe o carregamento
    });

    String enteredEmail = emailController.text.trim();
    String enteredPassword = senhaController.text.trim();
    await _saveLoginData();

    final String url = 'https://pmc.airsoftcontrol.com.br/pmc/login';

    final Map<String, dynamic> data = {
      "email": enteredEmail,
      "senha": enteredPassword,
    };

    debugPrint('Dados sendo enviados: $data');

    try {
      // Faz a requisição HTTP POST
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      debugPrint('Resposta do servidor: ${response.body}');
      debugPrint('Status Code: ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['tokenDTO'] != null &&
            responseData['tokenDTO']['token'] != null &&
            responseData['idUsuario'] != null) {
          final String token = responseData['tokenDTO']['token'];
          final int idUsuario =
              int.tryParse(responseData['idUsuario'].toString()) ?? 0;

          // Login com Firebase Anônimo
          try {
            final userCredential =
                await FirebaseAuth.instance.signInAnonymously();
            debugPrint(
                "Usuário autenticado com Firebase: ${userCredential.user!.uid}");

            final String firebaseUID = userCredential.user!.uid;
            final fmcToken = await FirebaseMessaging.instance.getToken();

            await FirebaseFirestore.instance
                .collection('usuarios')
                .doc(firebaseUID)
                .set({
              'idUsuario': idUsuario,
              'email': enteredEmail,
              'tokenPMC': token,
              'fmcToken': fmcToken,
              'lastLogin': FieldValue.serverTimestamp(),
            });

            // Salva o token e o ID do usuário no SharedPreferences
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('token', token);
            await prefs.setInt('idUsuario', idUsuario);

            Fluttertoast.showToast(
              msg: "Login realizado com sucesso!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0,
            );

            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, '/home');
            });
          } catch (e) {
            debugPrint("Erro ao autenticar com Firebase: $e");
            Fluttertoast.showToast(
                msg: "Erro ao autenticar com Firebase. Tente novamente.");
          }
        } else {
          Fluttertoast.showToast(msg: 'Erro ao processar os dados de login.');
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Erro ao fazer login. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Erro na requisição. Tente novamente.');
      debugPrint('Erro na requisição: $e');
    } finally {
      setState(() {
        _isLoading = false; // Finaliza o carregamento
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagem de fundo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fundonovo.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Conteúdo centralizado
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
                    // Logo
                    const Image(
                      image: AssetImage('assets/images/logo_simples_verde.png'),
                      width: 120,
                      height: 120,
                    ),
                    const SizedBox(height: 20),
                    // Título centralizado
                    Center(
                      child: Text(
                        "Protege Meu Cerrado",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Campos de texto
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
                    // Botão "Lembrar de mim" e "Esqueci a senha"
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                      ],
                    ),

                    const SizedBox(height: 10),
                    // Botão de login
                    MyButton(
                      text: _isLoading ? "Aguarde..." : "Entrar",
                      onTap: _isLoading ? null : login,
                    ),
                    const SizedBox(height: 20),
                    const MyRecuperarTxtbutton(),
                    // Botão de cadastrar
                    const MyCadastrarTxtbutton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingCompleted', true);
  }
}
