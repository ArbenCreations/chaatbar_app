import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../theme/CustomAppColor.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  static const maxDuration = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var mediaWidth = MediaQuery.of(context).size.width;

    return PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          if (didPop) {
            return;
          }
          SystemNavigator.pop();
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/welcomeBack.png"),
                      fit: BoxFit.fill)),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(height: 2),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          FadeInUp(
                              duration: Duration(milliseconds: 2000),
                              child: GestureDetector(
                                onTap: () => {
                                  Navigator.pushReplacementNamed(
                                      context, "/ForgotPasswordScreen")
                                },
                                child: Container(
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        child: Image.asset(
                                          "assets/appLogo.png",
                                          height: 80,
                                          width: 200,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        "Where Flavor Meets the Street.",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                          SizedBox(
                            height: 30,
                          ),
                          FadeInUp(
                              duration: Duration(milliseconds: 1900),
                              child: Center(
                                child: MaterialButton(
                                  minWidth: mediaWidth * 0.4,
                                  color: AppColor.Primary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  height: 48,
                                  onPressed: () async {
                                    Navigator.of(context)
                                        .pushReplacementNamed("/LoginScreen");
                                  },
                                  child: Text(
                                    "Get Started",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  ),
                                ),
                              )),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )));
  }
}
