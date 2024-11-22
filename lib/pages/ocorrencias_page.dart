import 'package:flutter/material.dart';

class OcorrenciasPage extends StatefulWidget {
  const OcorrenciasPage({super.key});

  @override
  State<OcorrenciasPage> createState() => _OcorrenciasPageState();
}

class _OcorrenciasPageState extends State<OcorrenciasPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ocorrencias'),
      ),
     
    );
  }
}
