import 'dart:async';

import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../model/services/PushNotificationService.dart';
import '../../../utils/Helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? token = "";
  final LocalAuthentication auth = LocalAuthentication();
  bool? isUserAuthenticated = false;
  int? vendorId;

  @override
  void initState() {
    super.initState();
    _initializeWithTimeout();
  }

  Future<void> _initializeWithTimeout() async {
    try {
      final initFuture = _initializeApp();
      await initFuture.timeout(const Duration(seconds: 10));
    } catch (e) {
      print("Initialization timeout or error: $e");
      _navigate(); // fallback
    }
  }

  Future<void> _initializeApp() async {
    await PushNotificationService().setupInteractedMessage();

    final permissionStatus = await Permission.notification.status;
    if (permissionStatus.isDenied || permissionStatus.isRestricted) {
      await Permission.notification.request();
    }

    token = await Helper.getUserToken();
    final vendor = await Helper.getVendorDetails();
    vendorId = vendor?.id;

    await Future.delayed(const Duration(seconds: 4)); // Optional splash delay
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
    return Scaffold(
      body: GestureDetector(
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.all(0),
          child: Container(
              height: screenHeight,
              alignment: Alignment.center,
              child: Lottie.asset('assets/burger_anim.json')),
        ),
      ),
    );
  }
}
