import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FireBase {
  final _firebaseMessaging = FirebaseMessaging.instance;
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  // Configuração para notificações locais
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initFirebaseAnalytics() async {
    await analytics.setAnalyticsCollectionEnabled(true);
  }

  Future<void> initFirebaseMessaging() async {
    await _firebaseMessaging.requestPermission();

    // Obter o token do dispositivo
    final fCMToken = await _firebaseMessaging.getToken();
    debugPrint('TOKEN Firebase Notification: $fCMToken');
    // Inicializar notificações locais
    _initializeLocalNotifications();

    // Listener para mensagens recebidas enquanto o app está em primeiro plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Mensagem recebida em primeiro plano:');
      debugPrint('Título: ${message.notification?.title}');
      debugPrint('Corpo: ${message.notification?.body}');
      debugPrint('Dados: ${message.data}');
      _showNotification(message);
    });

    // Listener para mensagens em segundo plano
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  void _initializeLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _showNotification(RemoteMessage message) {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'high_importance_channel', // ID do canal
      'Notificações importantes', // Nome do canal
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    _flutterLocalNotificationsPlugin.show(
      0, // ID da notificação
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
    );
  }
}

// Manipulador para mensagens recebidas em background
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Mensagem recebida em background: ${message.notification?.title}');
}
