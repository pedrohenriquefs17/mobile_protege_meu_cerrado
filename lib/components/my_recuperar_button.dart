import 'package:flutter/material.dart';

class MyRecuperarTxtbutton extends StatelessWidget {
  const MyRecuperarTxtbutton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {},
            child: Container(
              alignment: Alignment.centerRight,
              child: Text(
                'Recuperar Senha',
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
