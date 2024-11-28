import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile_protege_meu_cerrado/components/custom_textfield.dart';
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
  final TextEditingController telefoneController = TextEditingController();

  Future<void> cadastrar() async {
    final dio = Dio();
    final String url = 'https://pmc.airsoftcontrol.com.br/pmc/usuario/cadastro';
    final Map<String, dynamic> data = {
      "email": emailController.text.trim(),
      "senha": senhaController.text.trim(),
      "nome": nomeController.text.trim(),
      "cpf": cpfController.text.trim(),
      "dataNascimento": dataNascimentoController.text.trim(),
      "telefone": telefoneController.text.trim(),
      "role": "USUARIO"
    };

    try {
      final Response response = await dio.post(url, data: data);
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        debugPrint('Cadastrado com sucesso: ${response.data}');
      } else {
        debugPrint('Erro ao cadastrar: ${response.data}');
      }
    } catch (e) {
      debugPrint('Erro ao fazer requisição: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 40),
              Image(
                image: AssetImage('assets/images/logo_simples_verde.png'),
                height: 150,
                width: 150,
              ),
              SizedBox(height: 10),
              Text(
                'Protege Meu Cerrado - Cadastro',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              CustomTextfield(
                controller: nomeController,
                label: 'Nome Completo:',
                enabled: true,
              ),
              SizedBox(height: 16),
              CustomTextfield(
                controller: cpfController,
                label: 'CPF:',
                enabled: true,
              ),
              SizedBox(height: 16),
              CustomTextfield(
                controller: dataNascimentoController,
                label: 'Data de Nascimento:',
                enabled: true,
              ),
              SizedBox(height: 16),
              CustomTextfield(
                controller: telefoneController,
                label: 'Telefone:',
                enabled: true,
              ),
              SizedBox(height: 16),
              CustomTextfield(
                controller: emailController,
                label: 'E-mail:',
                enabled: true,
              ),
              SizedBox(height: 16),
              CustomTextfield(
                label: 'Senha:',
                controller: senhaController,
                enabled: true,
              ),
              SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {
                  cadastrar();
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    themeProvider.themeData.colorScheme.primary,
                  ),
                  foregroundColor: WidgetStateProperty.all(
                    themeProvider.themeData.colorScheme.onPrimary,
                  ),
                ),
                child: Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
