import 'package:flutter/material.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> posts = [
      {
        "title": "Como proteger o Cerrado?",
        "imageUrl":
            "https://via.placeholder.com/400x200.png?text=Cerrado+Protegido",
        "description": "Aprenda as principais ações para preservar o Cerrado.",
      },
      {
        "title": "A fauna do Cerrado em perigo",
        "imageUrl":
            "https://via.placeholder.com/400x200.png?text=Fauna+do+Cerrado",
        "description":
            "Conheça os animais ameaçados de extinção e como ajudá-los.",
      },
      {
        "title": "Impactos das queimadas",
        "imageUrl":
            "https://via.placeholder.com/400x200.png?text=Queimadas",
        "description":
            "Entenda os efeitos das queimadas no meio ambiente e na fauna.",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog - Protege Meu Cerrado'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.network(
                    post["imageUrl"]!,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post["title"]!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        post["description"]!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // Navegar para a página de detalhes, se necessário
                          },
                          child: const Text(
                            'Leia Mais',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
}