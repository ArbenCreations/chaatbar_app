import 'package:TheChaatBar/model/database/ChaatBarDatabase.dart';
import 'package:TheChaatBar/model/request/getCouponListRequest.dart';
import 'package:TheChaatBar/model/response/couponListResponse.dart';
import 'package:TheChaatBar/view/component/ShimmerList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/apiResponse.dart';
import '../../../model/viewModel/mainViewModel.dart';
import '../../../theme/CustomAppColor.dart';
import '../../../utils/Helper.dart';
import '../../../utils/Util.dart';
import '../../component/connectivity_service.dart';
import '../../component/session_expired_dialog.dart';

class CouponsScreen extends StatefulWidget {
  CouponsScreen();

  @override
  _CouponsScreenState createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<CouponsScreen> {
  bool isLoading = false;
  bool isInternetConnected = true;
  bool isDarkMode = false;
  bool editProfile = false;
  late double mediaWidth;
  late double screenHeight;

  int? customerId = 0;

  static const maxDuration = Duration(seconds: 2);
  bool isDataLoading = false;
  late ChaatBarDatabase database;
  var _connectivityService = ConnectivityService();

  String? theme = "";
  String? vendorId = "";
  Color primaryColor = AppColor.Secondary;
  Color? secondaryColor = Colors.red[100];
  Color? lightColor = Colors.red[50];
  List<PrivateCouponDetailsResponse>? couponsResponse;
  final GlobalKey _buttonKey = GlobalKey();
  bool mExpanded = false;
  String mSelectedText = "";
  final List<String> themeType = ["Light", "Dark", "Default"];
  final List<PrivateCouponDetailsResponse> couponsList = [];
  String selectedValue = "";

  @override
  void initState() {
    super.initState();
    Helper.getProfileDetails().then((onValue) {
      setState(() {
        customerId = int.parse("${onValue?.id ?? 0}"); //?? VendorData();
      });
    });

    Helper.getVendorDetails().then((onValue) {
      print("theme : $onValue");
      setState(() {
        vendorId = "${onValue?.id}";
      });
    });

    isDataLoading = true;
    _getCouponDetails();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    mediaWidth = MediaQuery.of(context).size.width;
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Coupons",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          backgroundColor: AppColor.BackgroundColor,
        ),
        body: SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: 5),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        !isDataLoading && couponsList.length != 0
                            ? ListView.builder(
                                itemCount: couponsList.length ?? 0,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.only(bottom: 10),
                                itemBuilder: (context, index) {
                                  return Card(
                                    elevation: 1,
                                    shadowColor: AppColor.Secondary,
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: isDarkMode
                                            ? AppColor.CardDarkColor
                                            : Colors.white,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          appliedCouponWidget(
                                              couponsList[index]),
                                          // Your existing widget
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0, right: 10.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        "\"\$${couponsList[index].minCartAmt} - \$${couponsList[index].maxDiscountAmt} order amount required\"",
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal)),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : !isDataLoading && couponsList.length == 0
                                ? Container(
                                    height: screenHeight / 2,
                                    child: Text(
                                      "No Coupons Found",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 14),
                                    ),
                                    alignment: Alignment.center,
                                  )
                                : ShimmerList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget appliedCouponWidget(PrivateCouponDetailsResponse couponsResponse) {
    return Container(
      width: mediaWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isDarkMode ? AppColor.CardDarkColor : Colors.white,
      ),
      padding: EdgeInsets.only(left: 10, right: 0, top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 2,
          ),
          Text("${couponsResponse.description}",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Use Code: ",
                      style: TextStyle(
                          fontSize: 11, fontWeight: FontWeight.normal)),
                  Text("${couponsResponse.couponCode}",
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Icon(
                  Icons.discount,
                  color: AppColor.Primary,
                  size: 32,
                ),
              ),
            ],
          ),
          Text(
            "Use by ${convertedDateMonthFormat("${couponsResponse.createdAt?.toString().toUpperCase()}")}",
            style: TextStyle(fontSize: 11),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Future<void> _getCouponDetails() async {
    bool isConnected = await _connectivityService.isConnected();
    print(("isConnected - ${isConnected}"));
    if (!isConnected) {
      setState(() {
        isDataLoading = false;
        isInternetConnected = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(Languages.of(context)!.labelNoInternetConnection),
            duration: maxDuration,
          ),
        );
      });
    } else {
      if (mounted) {
        GetCouponListRequest request = GetCouponListRequest(
            vendorId: int.parse("${vendorId}"), customerId: customerId);
        await Future.delayed(Duration(milliseconds: 2));
        await Provider.of<MainViewModel>(context, listen: false)
            .fetchCouponList(
                "api/v1/app/customers/get_customer_coupons", request);
        ApiResponse apiResponse =
            Provider.of<MainViewModel>(context, listen: false).response;
        getCouponResponse(context, apiResponse);
      }
    }
  }

  Future<Widget> getCouponResponse(
      BuildContext context, ApiResponse apiResponse) async {
    CouponListResponse? coupons = apiResponse.data as CouponListResponse?;
    print("apiResponse${apiResponse.status}");
    setState(() {
      isDataLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        setState(() {
          coupons?.couponsResponse?.forEach((value) {
            couponsList.add(value);
          });
        });
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        print("Message : ${apiResponse.message}");
        if (nonCapitalizeString("${apiResponse.message}") ==
            nonCapitalizeString(
                "${Languages.of(context)?.labelInvalidAccessToken}")) {
          SessionExpiredDialog.showDialogBox(context: context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Something went wrong.'),
              duration: maxDuration,
            ),
          );
        }
        print(apiResponse.message);
        return Center(
          child: Text('Please try again later!!!'),
        );
      case Status.INITIAL:
      default:
        return Center(
          child: Text(''),
        );
    }
  }
}
