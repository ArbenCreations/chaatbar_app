import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:local_auth/local_auth.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../model/response/notificationOtpResponse.dart';
import '../../../model/services/PushNotificationService.dart';
import '../../../utils/Helper.dart';

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
bool isFlutterLocalNotificationsInitialized = false;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await setupFlutterNotifications();
  print('Handling a background message ${message.messageId}');
}

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) return;

  channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  isFlutterLocalNotificationsInitialized = true;
}

class SplashScreen extends StatefulWidget {
  final NotificationOtpResponse? data; // Define the 'data' parameter here

  SplashScreen({Key? key, this.data}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? token = "";
  final LocalAuthentication auth = LocalAuthentication();
  bool? isUserAuthenticated = false;
  int? vendorId;

  @override
  void initState() {
    super.initState();
    _initializeApp();
    //_getToken();
    Helper.getUserAuthenticated().then((onValue) {
      isUserAuthenticated = onValue;
    });

    Helper.getVendorDetails().then((onValue) {
      vendorId = onValue?.id;
    });
  }

  Future<void> _initializeApp() async {
    await FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await setupFlutterNotifications();
    await PushNotificationService().setupInteractedMessage();

    final permissionStatus = await Permission.notification.status;
    if (permissionStatus.isDenied) {
      await Permission.notification.request();
    }

    token = await Helper.getUserToken();
    final vendor = await Helper.getVendorDetails();
    vendorId = vendor?.id;

    await Future.delayed(const Duration(seconds: 1));
    _navigate();
  }

  void _navigate() {
    if (token == null || token!.isEmpty) {
      Navigator.pushReplacementNamed(context, "/WelcomeScreen");
    } else {
      if (vendorId != null && vendorId != 0) {
        Navigator.pushReplacementNamed(context, "/BottomNavigation");
      } else {
        Navigator.pushReplacementNamed(context, "/VendorsListScreen");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double mediaWidth = MediaQuery.of(context).size.width;
    double _opacity = 1;
    double _scale = 0.5;
    return Scaffold(
      body: GestureDetector(
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.all(0),
          child: Image(
            height: screenHeight,
            width: mediaWidth,
            image: AssetImage("assets/splash.gif"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
