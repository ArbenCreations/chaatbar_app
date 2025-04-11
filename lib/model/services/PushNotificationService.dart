import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../utils/Helper.dart';
import '../response/notificationOtpResponse.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class PushNotificationService {
  FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> setupInteractedMessage() async {
    await Firebase.initializeApp();

    FirebaseMessaging.onMessageOpenedApp.listen(
          (RemoteMessage message) {
        print("PushNotificationService:: ${message.toString()}");
        _handleMessage(message.data);
      },
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      print("message?.data :: ${message?.toString()}");
      Map<String, dynamic> jsonData =
          message?.data ?? {}; // Assuming message?.data is the JSON data

      final notificationResponse = NotificationOtpResponse.fromJson(jsonData);

      if (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android) {
        if (navigatorKey.currentState?.context != null) {
          _showNotification(message);
          return; // Do not show the notification
        }
      }
    });
    await requestPermission();
    enableIOSNotifications();
    await getToken();
    await registerNotificationListeners();
  }

  Future<void> getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("FCM Token: $token");
    bool isSaved = await Helper.saveFirebaseToken(token);

    if (isSaved) {
      print('Token saved successfully.');
    } else {
      print('Failed to save token.');
    }
  }

  Future<void> registerNotificationListeners() async {
    final AndroidNotificationChannel channel = androidNotificationChannel;
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings("notification");
    const DarwinInitializationSettings iOSSettings =
    DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    const InitializationSettings initSettings =
    InitializationSettings(android: androidSettings, iOS: iOSSettings);
    flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        _handleNotificationClick(details.payload);
      },
    );
  }

  Future<void> enableIOSNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  AndroidNotificationChannel androidNotificationChannel =
  const AndroidNotificationChannel(
      'high_importance_channel', 'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
      playSound: true);

  Future<void> _showNotification(RemoteMessage? message) async {
    final notification = message?.notification;
    final android = message?.notification?.android;

    if (notification != null && android != null) {
      final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(androidNotificationChannel);
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification?.body,
        "by The chaatBar",
        NotificationDetails(
          android: AndroidNotificationDetails(
            androidNotificationChannel.id,
            androidNotificationChannel.name,
            channelDescription: androidNotificationChannel.description,
            icon: "notification",
            importance: Importance.max,
            // Matches channel importance
            priority: Priority.high,
            // Ensures heads-up notification
            playSound: true,
          ),
        ),
        payload: message?.data.toString(),
      );
    }
  }

  void _handleMessage(Map<String, dynamic> data) {
    final notificationResponse = NotificationOtpResponse.fromJson(data);
    print("_handleMessage :: ${notificationResponse.otp}");
  }

  void _handleNotificationClick(String? payload) {
    if (payload != null) {
      final data = _parsePayload(payload);
      // Create a NotificationOtpResponse object from parsed data
      final notificationResponse = NotificationOtpResponse.fromJson(data);
      print("_handleNotificationClick :: ${notificationResponse.otp}");
    }
  }

  Map<String, dynamic> _parsePayload(String payload) {
    final List<String> str =
    payload.replaceAll('{', '').replaceAll('}', '').split(',');
    final Map<String, dynamic> result = {};
    for (int i = 0; i < str.length; i++) {
      final List<String> s = str[i].split(':');
      result[s[0].trim()] = s[1].trim();
    }
    return result;
  }

}
