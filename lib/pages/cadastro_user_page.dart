import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
  final TextEditingController telefoneController = TextEditingController();

  Future<void> login() async {
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> cadastrar() async {
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
        Navigator.pushReplacementNamed(context, '/login');
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
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: themeProvider.themeData.colorScheme
                .onSurface, // aqui q fica a cor do ícone de volta
          ),
          onPressed: () {
            Navigator.of(context).pop('/login');
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 20, right: 20), // Ajuste a posição
                  child: IconButton(
                    icon: Icon(
                      themeProvider.isDarkMode
                          ? Icons.dark_mode
                          : Icons.light_mode,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    onPressed: () {
                      themeProvider.toggleTheme();
                    },
                  ),
                ),
              ),
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
              MyButton(
                text: "Cadastrar",
                onTap: cadastrar,
              ),
              SizedBox(height: 25),
              MyButton(
                text: "Login",
                onTap: login,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
