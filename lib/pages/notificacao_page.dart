import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificacaoPage extends StatelessWidget {
  const NotificacaoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    // Referência para as notificações do Firestore
    final notificationsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('notificacoes')
        .orderBy('timestamp', descending: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notificações',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: notificationsRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Nenhuma notificação.'));
          }

          // Lista de notificações
          final notifications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification =
                  notifications[index].data() as Map<String, dynamic>;
              final title = notification['title'];
              final body = notification['body'];
              final timestamp =
                  (notification['timestamp'] as Timestamp).toDate();

              return Card(
                margin: const EdgeInsets.all(8.0),
                elevation: 4,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12.0),
                  title: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(body),
                  trailing: Text(
                    '${timestamp.hour}:${timestamp.minute}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
