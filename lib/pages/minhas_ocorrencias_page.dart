import 'package:flutter/material.dart';

class MinhasOcorrenciasPage extends StatefulWidget {
  const MinhasOcorrenciasPage({super.key});

  @override
  State<MinhasOcorrenciasPage> createState() => _MinhasOcorrenciasPageState();
}

class _MinhasOcorrenciasPageState extends State<MinhasOcorrenciasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Minhas Ocorrências"),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Pesquisar Ocorrência',
                    labelStyle:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.tertiary),
                    ),
                    suffixIcon: const Icon(Icons.search, size: 22),
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                    child: ListView.builder(
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        title: Text("Ocorrência ${index + 1}"),
                        subtitle: Text("Descrição da ocorrência ${index + 1}"),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                    );
                  },
                ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
