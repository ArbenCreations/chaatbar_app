import 'dart:async';

import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

import '../../../../model/response/notificationOtpResponse.dart';
import '../../../utils/Helper.dart';

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
    _getToken();
    Helper.getUserAuthenticated().then((onValue) {
      isUserAuthenticated = onValue;
    });

    Helper.getVendorDetails().then((onValue) {
      vendorId = onValue?.id;
    });
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

  Future<void> _getToken() async {
    //await Helper.saveUserAuthenticated(false);
    await Future.delayed(Duration(milliseconds: 2));
    token = await Helper.getUserToken();
    print(token);
    Timer(Duration(seconds: 2), () {
      _navigation();
    });
  }

  void _navigation() {
    if (token == null || token?.isEmpty == true) {
      Navigator.pushReplacementNamed(context, "/WelcomeScreen");
    } else {
      if (vendorId != null && vendorId != 0) {
        Navigator.pushReplacementNamed(context, "/BottomNavigation");
      } else {
        Navigator.pushReplacementNamed(context, "/VendorsListScreen");
      }
    }
  }
}
