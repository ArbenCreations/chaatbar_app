import 'package:TheChaatBar/model/database/ChaatBarDatabase.dart';
import 'package:TheChaatBar/model/request/getCouponListRequest.dart';
import 'package:TheChaatBar/model/response/couponListResponse.dart';
import 'package:TheChaatBar/view/component/ShimmerList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  List<Color> cardColors = [
    Colors.orange.shade100,
    Colors.purple.shade100,
    Colors.teal.shade100,
    Colors.pink.shade100,
    Colors.blue.shade100,
    Colors.green.shade100,
  ];

  @override
  void initState() {
    super.initState();
    Helper.getProfileDetails().then((onValue) {
      setState(() {
        customerId = int.parse("${onValue?.id ?? 0}"); //?? VendorData();
      });
    });

    Helper.getVendorDetails().then((onValue) {
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
          //iconTheme: IconThemeData(color: Colors.white,size: 18),
        ),
        body: SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: 5),
          child: Container(
            height: screenHeight,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        !isDataLoading && couponsList.length != 0
                            ? GridView.builder(
                                itemCount: couponsList.length ?? 0,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  // 👈 2 cards per row
                                  crossAxisSpacing: 10,
                                  // horizontal space between cards
                                  mainAxisSpacing: 10,
                                  // vertical space between cards
                                  childAspectRatio:
                                      3 / 2, // width / height ratio
                                ),
                                itemBuilder: (context, index) {
                                  Color dynamicColor =
                                      cardColors[index % cardColors.length];
                                  return appliedCouponWidget(context,
                                      couponsList[index], dynamicColor);
                                },
                              )
                            : !isDataLoading && couponsList.length == 0
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 100,
                                          child: SvgPicture.asset(
                                            "assets/emptyCoupon.svg",
                                          ),
                                        ),
                                        Text(
                                          "No Coupons Available",
                                          style: TextStyle(
                                              fontSize: 14, color: Colors.grey),
                                        ),
                                      ],
                                    ),
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

  Widget appliedCouponWidget(
    BuildContext context,
    PrivateCouponDetailsResponse couponsResponse,
    Color cardColor,
  ) {
    DateTime? expiryDate = couponsResponse.expireAt != null
        ? DateTime.tryParse(couponsResponse.expireAt!.toString())
        : null;

    String expiryText = '';
    if (expiryDate != null) {
      final now = DateTime.now();
      final difference = expiryDate.difference(now).inDays;
      if (difference < 0) {
        expiryText = 'Expired';
      } else if (difference == 0) {
        expiryText = 'Expires today';
      } else {
        expiryText = 'Expires in $difference days';
      }
    }

    return GestureDetector(
      onTap: () {
        showCouponDetailsBottomSheet(context, couponsResponse);
      },
      child: IntrinsicWidth(
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                couponsResponse.description ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.discount, size: 16, color: Colors.black54),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      "Code: ${couponsResponse.couponCode ?? ''}",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              if (expiryText.isNotEmpty)
                Text(
                  expiryText,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: expiryText == 'Expired'
                        ? Colors.redAccent
                        : Colors.black45,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              const Spacer(),
              const Text(
                "Tap to see details",
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.black45,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showCouponDetailsBottomSheet(
      BuildContext context, PrivateCouponDetailsResponse coupon) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    coupon.description ?? '',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.discount, size: 20, color: Colors.black),
                      const SizedBox(width: 8),
                      Text(
                        coupon.couponCode ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 18, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      "Valid until: ${convertedDateMonthFormat("${coupon.createdAt?.toString().toUpperCase()}")}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline,
                        size: 18, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "\$${coupon.minCartAmt} minimum order • Max Discount \$${coupon.maxDiscountAmt}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.Primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    icon: const Icon(Icons.check_circle_outline,
                        size: 20, color: Colors.white),
                    label: const Text(
                      "Got it!",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
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
