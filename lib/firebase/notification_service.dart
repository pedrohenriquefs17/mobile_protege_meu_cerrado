import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationService {
  static Future<void> initialize() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.notification != null) {
        final userId = FirebaseAuth.instance.currentUser?.uid;

        if (userId != null) {
          // Salva a notificação no Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('notificacoes')
              .add({
            'title': message.notification!.title,
            'body': message.notification!.body,
            'timestamp': FieldValue.serverTimestamp(),
          });
        }
      }
    });
  }
}
