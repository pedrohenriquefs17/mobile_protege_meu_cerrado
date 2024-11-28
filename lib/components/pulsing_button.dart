import 'package:flutter/material.dart';

class PulsingButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;

  const PulsingButton({
    super.key,
    required this.child,
    required this.onPressed,
  });

  @override
  _PulsingButtonState createState() => _PulsingButtonState();
}

class _PulsingButtonState extends State<PulsingButton>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _moveAnimation;

  @override
  void initState() {
    super.initState();

    // Criação do controller para a animação de movimento
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true); // Faz o movimento ir e voltar

    // Definindo a animação de movimento
    _moveAnimation = Tween(begin: 0.0, end: 20.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut, // Animação suave
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // Movendo o botão para a esquerda e para a direita
          return Transform.translate(
            offset: Offset(_moveAnimation.value, 0), // Movimento horizontal
            child: widget.child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
