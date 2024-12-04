import 'package:flutter/material.dart';
import 'package:mobile_protege_meu_cerrado/pages/cadastro_user_page.dart';

class MyCadastrarTxtbutton extends StatelessWidget {
  const MyCadastrarTxtbutton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CadastroUserPage(),
                ),
              );
            },
            child: Container(
              alignment: Alignment.centerRight,
              child: Text(
                'Não possui conta? Cadastre-se',
                style: TextStyle(
                  color: Color(0xFF38B887),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
