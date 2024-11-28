import 'package:flutter/material.dart';
import 'package:mobile_protege_meu_cerrado/components/custom_textfield.dart';

class CadastroUserPage extends StatelessWidget {
  const CadastroUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController cpfController = TextEditingController();
    final TextEditingController nomeController = TextEditingController();
    final TextEditingController dataNascimentoController =
        TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController senhaController = TextEditingController();
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24),
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
              SizedBox(height: 20),
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
              CustomTextfield(
                controller: emailController,
                label: 'E-mail:',
                enabled: true,
              ),
              CustomTextfield(
                label: 'Senha:',
                controller: senhaController,
                enabled: true,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {},
                child: Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
