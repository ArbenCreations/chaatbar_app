import 'package:TheChaatBar/theme/CustomAppColor.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../model/database/ChaatBarDatabase.dart';
import '../../../model/database/dao.dart';
import '../../../model/response/successCallbackResponse.dart';
import '../../../utils/Helper.dart';

class PaymentSuccessfulScreen extends StatefulWidget {
  final SuccessCallbackResponse? data;

  PaymentSuccessfulScreen({Key? key, this.data}) : super(key: key);

  @override
  _PaymentSuccessfulScreenState createState() =>
      _PaymentSuccessfulScreenState();
}

class _PaymentSuccessfulScreenState extends State<PaymentSuccessfulScreen>
    with SingleTickerProviderStateMixin {
  String? name = "";
  late ChaatBarDatabase database;
  late CartDataDao cartDataDao;

  @override
  void initState() {
    super.initState();
    Helper.getProfileDetails().then((profile) {
      setState(() {
        name = "${profile?.firstName} ${profile?.lastName}" ?? "";
      });
    });
    initializeDatabase();
  }

  Future<void> initializeDatabase() async {
    database = await $FloorChaatBarDatabase
        .databaseBuilder('basic_structure_database.db')
        .build();

    cartDataDao = database.cartDao;
    cartDataDao.clearAllCartProduct();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double mediaWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: mediaWidth,
        height: screenHeight,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/backone.png"), fit: BoxFit.fill)),
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 100),
                Text(
                  "YOUR ORDER",
                  style: GoogleFonts.dmSans(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColor.ButtonBackColor),
                  textAlign: TextAlign.center,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    "PLACED SUCCESSFULLY",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 26),
                FadeInLeftBig(
                  duration: Duration(milliseconds: 800),
                  child: Image.asset(
                    "assets/payment_success.gif",
                    height: 200,
                    width: 200,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(height: 26),
                Text(
                  "Hi, $name",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                widget?.data?.order?.orderNumber != null
                    ? Text(
                        "Order No - ${widget?.data?.order?.orderNumber ?? ""}",
                        style: TextStyle(fontSize: 15),
                        textAlign: TextAlign.center,
                      )
                    : SizedBox(),
                Container(
                  width: mediaWidth * 0.75,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Thanks for using ChaatBar. We are happy to serve you.",
                    style: TextStyle(fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/BottomNavigation");
                  },
                  child: Container(
                    width: mediaWidth * 0.56,
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColor.ButtonBackColor,
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            "Go To Home Screen",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Container(
                            width: mediaWidth / 3.2,
                            height: 1,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
