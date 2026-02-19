import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// 🔥 TOP LEVEL BACKGROUND HANDLER (REQUIRED)
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("🔥 Background message received: ${message.messageId}");
}

class PushNotificationService {
  static final PushNotificationService _instance =
      PushNotificationService._internal();

  factory PushNotificationService() => _instance;

  PushNotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// 🔥 INIT METHOD
  Future<void> init() async {
    await _requestPermission();
    await _initLocalNotification();
    await _setupFirebaseListeners();
    await _getToken();
  }

  /// 🔐 REQUEST PERMISSION (Android 13 + iOS)
  Future<void> _requestPermission() async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print("🔔 Permission status: ${settings.authorizationStatus}");
  }

  /// 📱 GET DEVICE TOKEN
  Future<void> _getToken() async {
    String? token = await _fcm.getToken();
    debugPrint("📱 FCM TOKEN: $token");
  }

  /// 🔔 INITIALIZE LOCAL NOTIFICATION + CHANNEL
  Future<void> _initLocalNotification() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidInit);

    await _localNotifications.initialize(initSettings,
        onDidReceiveNotificationResponse: (details) {
      debugPrint("🔔 Notification clicked payload: ${details.payload}");
    });

    /// 🔥 VERY IMPORTANT: CREATE CHANNEL
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications',
      importance: Importance.max,
    );

    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(channel);
  }

  /// 🔥 SHOW NOTIFICATION (FOR FOREGROUND)
  Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? "No Title",
      message.notification?.body ?? "No Body",
      details,
      payload: jsonEncode(message.data),
    );
  }

  /// 🔥 SETUP FIREBASE LISTENERS
  Future<void> _setupFirebaseListeners() async {
    /// Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("📩 Foreground message: ${message.notification?.title}");
      _showNotification(message);
    });

    /// Background click
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("📲 Notification clicked (background)");
      _handleNotificationClick(message);
    });

    /// Terminated click
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      debugPrint("🚀 App opened from terminated state");
      _handleNotificationClick(initialMessage);
    }

    /// Background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  /// 🔗 HANDLE CLICK NAVIGATION
  void _handleNotificationClick(RemoteMessage message) {
    debugPrint("👉 Notification Data: ${message.data}");

    // Example navigation
    // if (message.data['type'] == 'order') {
    //   navigatorKey.currentState!.pushNamed('/order');
    // }
  }
}
