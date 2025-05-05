import 'dart:convert';

import 'package:TheChaatBar/model/request/CreateOrderRequest.dart';
import 'package:TheChaatBar/model/request/getCouponDetailsRequest.dart';
import 'package:TheChaatBar/model/response/createOrderResponse.dart';
import 'package:TheChaatBar/model/response/getCouponDetailsResponse.dart';
import 'package:TheChaatBar/model/response/productListResponse.dart';
import 'package:TheChaatBar/theme/CustomAppColor.dart';
import 'package:TheChaatBar/utils/Util.dart';
import 'package:TheChaatBar/view/component/cart_product_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/apiResponse.dart';
import '../../../model/database/ChaatBarDatabase.dart';
import '../../../model/database/DatabaseHelper.dart';
import '../../../model/database/dao.dart';
import '../../../model/request/getCouponListRequest.dart';
import '../../../model/response/couponListResponse.dart';
import '../../../model/response/productDataDB.dart';
import '../../../model/response/storeStatusResponse.dart';
import '../../../model/viewModel/mainViewModel.dart';
import '../../../utils/Helper.dart';
import '../../component/CustomAlert.dart';
import '../../component/DashedLine.dart';
import '../../component/connectivity_service.dart';
import '../../component/custom_circular_progress.dart';
import '../../component/session_expired_dialog.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late double mediaWidth;
  late double screenHeight;
  bool isDarkMode = false;
  late ChaatBarDatabase database;
  late CartDataDao cartDataDao;
  List<ProductData?> cartList = [];
  int? discountPercent = 0;
  late int vendorId;
  int gst = 0;
  int hst = 0;
  int pst = 0;
  double grandTotal = 0;
  double totalPrice = 0;
  double taxAmount = 0;
  double gstTaxAmount = 0;
  double pstTaxAmount = 0;
  double hstTaxAmount = 0;
  double discountAmount = 0;
  bool isB1G1 = false;
  bool isLoading = false;
  bool isCouponApplied = false;
  bool isStoreOnline = true;
  bool IsUpcomingAllowed = true;

  String appId = "";
  String apiKey = "";
  String? theme = "";
  String? userId = "";
  String? firstName = "";
  String? lastName = "";
  String? phoneNo = "";
  String? email = "";
  String? pickupDate = "";
  String? pickupTime = "";
  CouponDetailsResponse? couponDetails = CouponDetailsResponse();
  var _connectivityService = ConnectivityService();
  static const maxDuration = Duration(seconds: 2);
  final TextEditingController _couponController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final List<PrivateCouponDetailsResponse> couponsList = [];
  Color primaryColor = AppColor.Primary;
  Color? secondaryColor = Colors.red[100];
  Color? lightColor = Colors.red[50];
  String? storeStatus = "online";

  double _swipeProgress = 0.0; // Tracks the swipe progress

  void _onSwipeComplete() {
    // Call API after swipe is completed
    email == "guest@chaatbar.com"
        ? showGuestUserAlert(context)
        : _createOrder();
  }

  void _updateSwipeProgress(DragUpdateDetails details) {
    setState(() {
      _swipeProgress =
          (details.localPosition.dx / MediaQuery.of(context).size.width)
              .clamp(0.0, 1.0);
    });
  }

  void _resetSwipe() {
    setState(() {
      _swipeProgress = 0.0;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isStoreOnline = true;
      pickupDate = "${DateFormat('yyyy-MM-dd').format(DateTime.now())}";
      pickupTime =
          "${DateFormat('hh:mm a').format(DateTime.now().add(Duration(minutes: 20)))}";
    });
    Helper.getAddress().then((value) {
      setState(() {
        if (value != null) _addressController.text = "$value";
      });
    });
    _fetchStoreStatus(false);
    _getCouponDetails();
    Helper.getVendorDetails().then((data) {
      setState(() {
        vendorId = int.parse("${data?.id ?? 0}");
        //storeStatus = data?.status ?? "online";
        //print("Store Status ${storeStatus}");
        isStoreOnline = true;
      });
    });

    Helper.getStoreSettingDetails().then((data) {
      setState(() {
        gst = int.parse("${data?.gst ?? 0}");
        pst = int.parse("${data?.pst ?? 0}");
        hst = int.parse("${data?.hst ?? 0}");
        IsUpcomingAllowed = data?.upcomingOrReserveDay ?? false;
      });
    });

    Helper.getApiKey().then((data) {
      setState(() {
        apiKey = "12c12489-fc5f-253d-af89-270d4b68b87e"; //"${data ?? ""}";
        print("apiKey:$apiKey");
      });
    });
    Helper.getProfileDetails().then((profileDetails) {
      setState(() {
        firstName = profileDetails?.firstName;
        userId = "${profileDetails?.id}";
        lastName = profileDetails?.lastName;
        phoneNo = profileDetails?.phoneNumber;
        email = profileDetails?.email;
      });
    });
    initializeDatabase();

  }

  Widget getCreateOrderResponse(BuildContext context, ApiResponse apiResponse) {
    CreateOrderResponse? createOrderResponse =
        apiResponse.data as CreateOrderResponse?;
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        Navigator.pushNamed(
          context,
          "/PaymentCardScreen",
          arguments: {"data": "", 'orderData': createOrderResponse},
        );
        return Container();
      case Status.ERROR:
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

  @override
  Widget build(BuildContext context) {
    mediaWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        Navigator.pushNamed(context, "/BottomNavigation");
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColor.BackgroundColor,
          title: Text(
            'Check out',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          leading: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "/BottomNavigation");
              },
              child: Icon(
                Icons.arrow_back_sharp,
                color: Colors.black,
              )),
          actions: [
            Padding(
              padding: const EdgeInsets.only(
                right: 6.0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      _showUserDetailBottomSheet();
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.account_circle,
                          color: AppColor.Primary,
                          size: 24,
                        ),
                        SizedBox(width: 4),
                        Text("${firstName ?? ""}",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        SizedBox(width: 4),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
                child: cartList.length > 0 && storeStatus == "online"
                    ? Column(
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                                minHeight: screenHeight * 0.29,
                                maxHeight: screenHeight * 0.55),
                            child: Container(
                              color: AppColor.BackgroundColor,
                              child: SingleChildScrollView(
                                keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                                child: cartList.length > 0
                                    ? Wrap(
                                        spacing: 12,
                                        runSpacing: 5,
                                        children: cartList.map(
                                          (item) {
                                            List<ProductSize> productSize = [];
                                            if (item?.productSizesList !=
                                                "[]") {
                                              productSize =
                                                  item?.getProductSizeList() ??
                                                      [];
                                            }
                                            double itemTotalPrice = 0;
                                            double addOnTotalPrice = 0;
                                            // if (item?.productSizesList == "[]" || item?.productSizesList?.isEmpty == true) {
                                            if (item?.isBuy1Get1 == true) {
                                              itemTotalPrice = (double.parse(
                                                          "${item?.quantity}") /
                                                      2) *
                                                  double.parse(
                                                      "${item?.price}");
                                              item
                                                  ?.getAddOnList()
                                                  .forEach((addOnCategory) {
                                                addOnCategory.addOns
                                                    ?.forEach((addOn) {
                                                  addOnTotalPrice =
                                                      addOnTotalPrice +
                                                          int.parse(
                                                              "${addOn.price}");
                                                });
                                              });
                                              addOnTotalPrice = addOnTotalPrice *
                                                  (double.parse(
                                                          "${item?.quantity}") /
                                                      2);
                                            } else {
                                              itemTotalPrice = double.parse(
                                                      "${item?.quantity}") *
                                                  double.parse(
                                                      "${item?.price}");
                                              item
                                                  ?.getAddOnList()
                                                  .forEach((addOnCategory) {
                                                addOnCategory.addOns
                                                    ?.forEach((addOn) {
                                                  addOnTotalPrice =
                                                      addOnTotalPrice +
                                                          int.parse(
                                                              "${addOn.price}");
                                                });
                                              });
                                              addOnTotalPrice =
                                                  addOnTotalPrice *
                                                      double.parse(
                                                          "${item?.quantity}");
                                            }
                                            // }
                                            return CartProductComponent(
                                                item: item ??
                                                    ProductData(quantity: 0),
                                                mediaWidth: mediaWidth,
                                                isDarkMode: isDarkMode,
                                                itemTotalPrice: itemTotalPrice,
                                                addOnTotalPrice:
                                                    addOnTotalPrice,
                                                screenHeight: screenHeight,
                                                onAddTap: () {
                                                  setState(() {
                                                    if (item?.addOn?.isEmpty ==
                                                            true ||
                                                        item?.addOn == "[]" ||
                                                        item?.addOn == null) {
                                                      if (item?.isBuy1Get1 ==
                                                          false) {
                                                        if (int.parse(
                                                                "${item?.quantity}") <
                                                            int.parse(
                                                                "${item?.qtyLimit}")) {
                                                          item?.quantity++;
                                                          addProductInDb(item
                                                              as ProductData);
                                                        }
                                                      } else {
                                                        if (int.parse(
                                                                "${item?.quantity}") <
                                                            2 *
                                                                int.parse(
                                                                    "${item?.qtyLimit}")) {
                                                          item?.quantity =
                                                              int.parse(
                                                                      "${item.quantity}") +
                                                                  2;
                                                          addProductInDb(item
                                                              as ProductData);
                                                        }
                                                      }
                                                    } else {
                                                      Navigator.pushNamed(
                                                          context,
                                                          "/ProductDetailScreen",
                                                          arguments: item);
                                                    }
                                                  });
                                                },
                                                onMinusTap: () {
                                                  setState(() {
                                                    if (item?.addOn?.isEmpty ==
                                                            true ||
                                                        item?.addOn == "[]" ||
                                                        item?.addOn == null) {
                                                      if (item?.isBuy1Get1 ==
                                                          false) {
                                                        if (int.parse(
                                                                    "${item?.quantity}") <=
                                                                int.parse(
                                                                    "${item?.qtyLimit}") &&
                                                            int.parse(
                                                                    "${item?.quantity}") >
                                                                0) {
                                                          item?.quantity--;
                                                          itemTotalPrice = double
                                                                  .parse(
                                                                      "${item?.quantity}") *
                                                              double.parse(
                                                                  "${item?.price}");

                                                          //_updateCart(item,context);
                                                          deleteProductInDb(
                                                              item);
                                                        }
                                                      } else {
                                                        if (int.parse(
                                                                    "${item?.quantity}") <=
                                                                2 *
                                                                    int.parse(
                                                                        "${item?.qtyLimit}") &&
                                                            int.parse(
                                                                    "${item?.quantity}") >
                                                                1) {
                                                          item?.quantity =
                                                              int.parse(
                                                                      "${item.quantity}") -
                                                                  2;
                                                          itemTotalPrice = (double
                                                                      .parse(
                                                                          "${item?.quantity}") /
                                                                  2) *
                                                              double.parse(
                                                                  "${item?.price}");
                                                          deleteProductInDb(
                                                              item);
                                                        }
                                                      }
                                                    } else {
                                                      Navigator.pushNamed(
                                                          context,
                                                          "/ProductDetailScreen",
                                                          arguments: item);
                                                    }
                                                  });
                                                },
                                                onRemoveTap: () {
                                                  if (int.parse(
                                                          "${item?.quantity}") >
                                                      0) {
                                                    setState(() {
                                                      item?.quantity = 0;
                                                      if (productSize
                                                          .isNotEmpty) {
                                                        productSize
                                                            .forEach((size) {
                                                          size.quantity = 0;
                                                        });
                                                        item?.productSizesList =
                                                            jsonEncode(
                                                                productSize);
                                                      }
                                                    });
                                                    deleteProductInDb(item);
                                                  }
                                                },
                                                primaryColor: primaryColor);
                                          },
                                        ).toList(),
                                      )
                                    : Container(
                                        height: screenHeight * 0.29,
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Add item to cart",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          Container(
                            color: AppColor.BackgroundColor,
                            padding: EdgeInsets.only(bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, "/BottomNavigation",
                                          arguments: 1);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 6, horizontal: 10),
                                      margin: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add,
                                            color: Colors.black,
                                            size: 14,
                                          ),
                                          SizedBox(width: 2),
                                          Text(
                                            "Add items",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    cartDataDao.clearAllCartProduct();
                                    getCartData();
                                    getCartTotal();
                                  },
                                  child: IntrinsicWidth(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 6, horizontal: 10),
                                      margin: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        color: AppColor.Secondary,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                AppColor.Secondary.withOpacity(
                                                    0.3),
                                            blurRadius: 8,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.remove_shopping_cart_outlined,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            "Clear Cart",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          DashedLine(width: mediaWidth, height: 1.0),
                          if (IsUpcomingAllowed)
                            GestureDetector(
                              onTap: () =>
                                  _showCupertinoDateTimePicker(context),
                              child: Card(
                                elevation: 0,
                                margin: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 0),
                                shape: Border(bottom: BorderSide(width: 0.1)),
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 4),
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                            padding: EdgeInsets.only(left: 15),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.access_time_rounded,
                                                  size: 14,
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  "Pickup Time",
                                                  maxLines: 2,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            )),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        child: Center(
                                          child: Row(
                                            children: [
                                              Text(
                                                "$pickupDate $pickupTime ",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13),
                                              ),
                                              Icon(
                                                Icons.arrow_drop_down_sharp,
                                                size: 22,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          else
                            SizedBox(),
                          GestureDetector(
                            onTap: () => _showNotesDialog(),
                            child: Card(
                              elevation: 0,
                              margin: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 0),
                              shape: Border(bottom: BorderSide(width: 0.1)),
                              child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(bottom: 4),
                                padding: EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                          padding: EdgeInsets.only(left: 15),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.note_alt_rounded,
                                                size: 14,
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                "Add Notes (Optional)",
                                                maxLines: 2,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 6),
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showCouponBottomSheet(context);
                            },
                            child: Card(
                              elevation: 0,
                              shape: Border(bottom: BorderSide(width: 0.01)),
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.local_offer,
                                                color: AppColor.Primary,
                                                size: 14,
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                "Available Coupons",
                                                maxLines: 2,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 6),
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: AppColor.Primary,
                                        size: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          cartList.length > 0
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 2.0,
                                      left: 10,
                                      right: 10,
                                      top: 6.0),
                                  child: isCouponApplied
                                      ? appliedCouponWidget()
                                      : GestureDetector(
                                          onTap: () async => {
                                            if (_couponController
                                                .text.isNotEmpty)
                                              {
                                                _fetchCouponData(
                                                    "${_couponController.text}",
                                                    false)
                                              }
                                            else
                                              {
                                                CustomAlert.showToast(
                                                    context: context,
                                                    message:
                                                        "Please Enter Coupon Code",
                                                    duration: maxDuration)
                                              }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2),
                                            decoration: BoxDecoration(
                                                color: AppColor.BackgroundColor,
                                                border: Border.all(width: 0.2),
                                                borderRadius:
                                                    BorderRadius.circular(30)),
                                            width: mediaWidth * 0.85,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width: mediaWidth / 1.8,
                                                  height: 45,
                                                  margin:
                                                      EdgeInsets.only(left: 10),
                                                  child: TextField(
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                    ),
                                                    obscureText: false,
                                                    obscuringCharacter: "*",
                                                    controller:
                                                        _couponController,
                                                    onChanged: (value) {
                                                      // _isValidInput();
                                                    },
                                                    maxLength: 20,
                                                    onSubmitted: (value) {},
                                                    keyboardType: TextInputType
                                                        .name,
                                                    textInputAction:
                                                        TextInputAction.done,
                                                    decoration: InputDecoration(
                                                        counterText: "",
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        5),
                                                        enabledBorder:
                                                            InputBorder.none,
                                                        focusedBorder:
                                                            InputBorder.none,
                                                        hintText:
                                                            "Enter Coupon Code",
                                                        hintStyle: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 12)),
                                                  ),
                                                ),
                                                Container(
                                                  height: 40,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: AppColor.Secondary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    border: Border.all(
                                                        color:
                                                            AppColor.Secondary,
                                                        width: 0.5),
                                                    //color: Colors.red[100]
                                                  ),
                                                  margin: EdgeInsets.only(
                                                      left: 0,
                                                      top: 0,
                                                      right: 5,
                                                      bottom: 0),
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 6,
                                                      horizontal: 24),
                                                  child: Text(
                                                    "Apply",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                )
                              : SizedBox(),
                          /*Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 1),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Order Notes:",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          )),
                    ),*/
                          /*Container(
                        width: mediaWidth * 0.92,
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Center(
                          child: TextField(
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                            obscureText: false,
                            obscuringCharacter: "*",
                            controller: _notesController,
                            textAlign: TextAlign.justify,
                            onChanged: (value) {
                              // _isValidInput();
                            },
                            onSubmitted: (value) {},
                            maxLines: 3,
                            scrollPhysics: AlwaysScrollableScrollPhysics(),
                            maxLength: 100,
                            keyboardType: TextInputType.visiblePassword,
                            textAlignVertical: TextAlignVertical.center,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                                counterText: "",
                                counterStyle: TextStyle(fontSize: 11),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 4),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: BorderSide(
                                        color: Colors.black54, width: 0.2)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: BorderSide(
                                        color: Colors.black54, width: 0.2)),
                                hintText: "Order instructions (optional).",
                                hintStyle:
                                    TextStyle(fontSize: 13, color: Colors.grey),
                                prefixIconColor: primaryColor),
                          ),
                        ))*/
                          SizedBox(
                            height: 5,
                          ),

                          // Divider(),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              width: mediaWidth,
                              height: 0.2,
                              color: Colors.grey[400],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _buildDetailCard('Sub Total ',
                                      totalPrice.toStringAsFixed(2)),
                                  discountPercent != null &&
                                          discountPercent! > 0
                                      ? _buildDetailCard(
                                          'Discount($discountPercent%) ',
                                          "${discountAmount.toStringAsFixed(2)}")
                                      : SizedBox(),
                                  /*_buildDetailCard(
                                'Tax (10%): ', taxAmount.toStringAsFixed(2)),*/
                                  gst != 0
                                      ? _buildDetailCard('GST ($gst%) ',
                                          gstTaxAmount.toStringAsFixed(2))
                                      : SizedBox(),
                                  pst != 0
                                      ? _buildDetailCard('PST ($pst%) ',
                                          pstTaxAmount.toStringAsFixed(2))
                                      : SizedBox(),
                                  hst != 0
                                      ? _buildDetailCard('HST ($hst%) ',
                                          hstTaxAmount.toStringAsFixed(2))
                                      : SizedBox(),
                                  /* _buildDetailCard(
                                'Platform Fee: ', platformFee.toStringAsFixed(2)),*/
                                  //Divider(),
                                  SizedBox(
                                    height: 8,
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: DashedLine(
                                        width: mediaWidth * 0.9, height: 1.0),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Order Total '.toUpperCase(),
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: isDarkMode
                                                  ? Colors.white60
                                                  : Colors.black87),
                                        ),
                                        SizedBox(width: 40),
                                        Text(
                                          '\$${grandTotal.toStringAsFixed(2)}',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: isDarkMode
                                                  ? Colors.white60
                                                  : Colors.black87),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: DashedLine(
                                        width: mediaWidth * 0.9, height: 1.0),
                                  ),
                                  discountPercent != null &&
                                          discountPercent! > 0
                                      ? Container(
                                          color: Colors.yellow,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 20),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.local_offer_outlined,
                                                size: 18,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                "Saving \$${discountAmount.toStringAsFixed(2)} with promotions",
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        )
                                      : SizedBox()
                                ],
                              ),
                            ),
                          ),
                          cartList.length > 0
                              ? Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 4),
                                    child: isStoreOnline &&
                                            apiKey.isNotEmpty &&
                                            apiKey != "null"
                                        ? GestureDetector(
                                            onHorizontalDragUpdate:
                                                _updateSwipeProgress,
                                            onHorizontalDragEnd: (details) {
                                              if (_swipeProgress >= 0.8) {
                                                _onSwipeComplete();
                                              }
                                              _resetSwipe();
                                            },
                                            child: Container(
                                              height: 55,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.75,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color: AppColor.Primary,
                                              ),
                                              margin: EdgeInsets.only(
                                                  top: 12, bottom: 15),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 2, horizontal: 4),
                                              child: Stack(
                                                children: [
                                                  AnimatedPositioned(
                                                    duration: Duration(
                                                        milliseconds: 150),
                                                    left: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.75 *
                                                        _swipeProgress,
                                                    child: GestureDetector(
                                                      onTap: _onSwipeComplete,
                                                      // In case someone taps the icon
                                                      child: Container(
                                                        height: 50,
                                                        width: 50,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              _getIconBackColor(),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                        ),
                                                        child: Icon(Icons.check,
                                                            color:
                                                                _getIconColor()),
                                                      ),
                                                    ),
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      'Swipe to Process Order',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : !isStoreOnline
                                            ? Container(
                                                margin: EdgeInsets.only(
                                                    top: 10, bottom: 30),
                                                width: mediaWidth * 0.8,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 12,
                                                    horizontal: 16),
                                                decoration: BoxDecoration(
                                                  color: Colors.red.shade50,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                      color:
                                                          Colors.red.shade200),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .store_mall_directory,
                                                      color: Colors.red,
                                                      size: 20,
                                                    ),
                                                    SizedBox(width: 8),
                                                    Flexible(
                                                      child: Text(
                                                        "Store is closed at the moment!",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors
                                                              .red.shade800,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : SizedBox(),
                                  ),
                                )
                              : SizedBox(),
                        ],
                      )
                    : Container(
                        height: screenHeight * 0.7,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: ClipRRect(
                                child: Image(
                                  width: mediaWidth * 0.7,
                                  image: AssetImage("assets/empty_cart.png"),
                                ),
                              ),
                            ),
                            Text(
                              "Empty Cart",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
              ),
              isLoading
                  ? Stack(
                      children: [
                        // Block interaction
                        ModalBarrier(
                            dismissible: false, color: Colors.transparent),
                        // Loader indicator
                        Center(
                          child: CustomCircularProgress(),
                        ),
                      ],
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Color _getIconBackColor() {
    if (_swipeProgress >= 0.5) {
      return Colors.white; // Change color when swipe is halfway or more
    } else {
      return Colors.green; // Default color
    }
  }

  Color _getIconColor() {
    if (_swipeProgress >= 0.5) {
      return Colors.black; // Change color when swipe is halfway or more
    } else {
      return Colors.white; // Default color
    }
  }

  void showGuestUserAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Guest Account"),
          content: const Text(
            "You're currently using a guest account. Please create an account to place your order.",
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            ElevatedButton(
              child: const Text("Create Account"),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                Helper.clearAllSharedPreferences();
                database.favoritesDao.clearAllFavoritesProduct();
                database.cartDao.clearAllCartProduct();
                database.categoryDao.clearAllCategories();
                database.productDao.clearAllProducts();
                database.cartDao.clearAllCartProduct();
                Navigator.pushReplacementNamed(
                    context, '/RegisterScreen'); // Change route as needed
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailCard(String title, String detail) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6),
      padding: EdgeInsets.only(bottom: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$title',
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white60 : Colors.black54),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
                color: title.contains("Discount")
                    ? Colors.yellow
                    : Colors.transparent),
            child: Text(
              title.contains("Discount") && detail != "0.00"
                  ? '-\$ $detail'
                  : '\$ $detail',
              style: TextStyle(
                  fontSize: 13,
                  color: isDarkMode ? Colors.white60 : Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  double getTaxAmount(double totalPrice) {
    setState(() {
      gstTaxAmount = roundToTwoDecimal((totalPrice * gst) / 100);
      pstTaxAmount = roundToTwoDecimal((totalPrice * pst) / 100);
      hstTaxAmount = roundToTwoDecimal((totalPrice * hst) / 100);
      taxAmount = roundToTwoDecimal(gstTaxAmount + pstTaxAmount + hstTaxAmount);
    });
    return taxAmount;
  }

  double roundToTwoDecimal(double value) {
    return double.parse(value.toStringAsFixed(2));
  }

  void getGrandTotal(
      double totalPrice, double taxAmount, double discountAmount) {
    setState(() {
      grandTotal = totalPrice +
          getTaxAmount(totalPrice) /*+ platformFee*/ -
          getDiscountAmt();
    });
  }

  Future<void> getCartData() async {
    List<ProductDataDB?> productsList = await cartDataDao.findAllCartProducts();
    // print("getCartData");
    setState(() {
      List<ProductData> list = [];
      if (productsList.isNotEmpty) {
        productsList.forEach((item) {
          if (item != null) {
            print("item.vendorName : ${item.vendorName}");
            list.add(ProductData(
                quantity: int.parse("${item.quantity}"),
                vendorId: vendorId,
                franchiseId: item.franchiseId,
                title: item.title,
                status: item.status,
                shortDescription: item.shortDescription,
                salePrice: item.salePrice,
                qtyLimit: item.qtyLimit,
                isBuy1Get1: item.isBuy1Get1,
                productCategoryId: item.productCategoryId,
                price: item.price,
                deposit: item.deposit,
                // addOnType: [],
                categoryName: item.categoryName,
                // addOnIds: [],
                addOn: item.addOn,
                imageUrl: item.imageUrl,
                description: item.description,
                createdAt: "",
                environmentalFee: "",
                featured: false,
                gst: null,
                id: item.productId,
                pst: null,
                updatedAt: "",
                theme: item.theme,
                vendorName: item.vendorName,
                vpt: null,
                productSizesList: item.productSizesList));

            cartList = list;
          } else {
            //widget.theme == list[0].theme;
            cartList = list;
          }
        });
      } else {
        cartList = [];
        //Navigator.pushNamed(context, "/BottomNavigation");
      }
    });
    getCartTotal();
  }

  Future<void> initializeDatabase() async {
    database = await DatabaseHelper().database;
    cartDataDao = database.cartDao;
    getCartData();
    getCartTotal();
  }

  Future<void> addProductInDb(ProductData item) async {
    ProductDataDB data = ProductDataDB(
        description: item.description,
        imageUrl: item.imageUrl,
        //addOnIds: [],
        categoryName: item.categoryName,
        //addOnType: item.addOnType,
        deposit: item.deposit,
        addOn: item.addOn,
        price: item.price,
        productCategoryId: item.productCategoryId,
        productId: item.id,
        qtyLimit: item.qtyLimit,
        isBuy1Get1: item.isBuy1Get1,
        salePrice: "",
        shortDescription: item.shortDescription,
        status: item.status,
        title: item.title,
        vendorId: vendorId,
        franchiseId: item.franchiseId,
        quantity: item.quantity,
        addedToCartAt: "${DateFormat('yyyy-MM-dd').format(DateTime.now())}",
        productSizesList: item.productSizesList);
    print(
        "vendorId ${item.vendorId}  :: productCategoryId  ${item.productCategoryId}  :: id   ${item.id}");
    print("quantity ${item.quantity}");

    getSpecificCartProduct("${vendorId}", "${item.productCategoryId}",
        "${item.id}", cartDataDao, data);
  }

  Future<ProductDataDB?> getSpecificCartProduct(
      String vendorId,
      String categoryId,
      String productId,
      CartDataDao cartDataDao,
      ProductDataDB data) async {
    final product = await cartDataDao.getSpecificCartProduct(
        vendorId, categoryId, productId);

    if (product == null) {
      print("Product is null $product");
      List<ProductDataDB?> productsList =
          await cartDataDao.findAllCartProducts();
      print("productsList length: ${productsList.length}");
      productsList.add(data);
      if (mounted) {
        if (productsList.isNotEmpty) {
          // Use forEach instead of map to perform an action
          productsList.forEach((item) {
            if (item != null) {
              print("Inserting item: $item");
              cartDataDao.insertCartProduct(item);
            }
          });
        } else {
          print("Inserting single product: $data");
          await cartDataDao.insertCartProduct(data);
        }
      }

      return null;
    } else {
      print("Product exists: $product");
      await cartDataDao.updateCartProduct(data); // Update the existing product
    }
    getCartData();

    return product;
  }

  void deleteProductInDb(ProductData? item) {
    ProductDataDB data = ProductDataDB(
        description: item?.description,
        imageUrl: item?.imageUrl,
        /*addOnIds: item?.addOnIds*/
        categoryName: item?.categoryName,
        /*addOnType: item?.addOnType,*/
        deposit: item?.deposit,
        addOn: item?.addOn,
        price: item?.price,
        productCategoryId: item?.productCategoryId,
        productId: item?.id,
        qtyLimit: item?.qtyLimit,
        isBuy1Get1: item?.isBuy1Get1,
        salePrice: item?.salePrice,
        shortDescription: item?.shortDescription,
        status: item?.status,
        title: item?.title,
        vendorId: vendorId,
        franchiseId: item?.franchiseId,
        quantity: item?.quantity,
        addedToCartAt: "${DateFormat('yyyy-MM-dd').format(DateTime.now())}",
        productSizesList: item?.productSizesList);
    if (item?.quantity == 0) {
      cartDataDao.deleteCartProduct(data);
    } else {
      cartDataDao.updateCartProduct(data);
    }
    getCartData();
  }

  Future<void> getCartTotal() async {
    List<ProductDataDB?> productsList = await cartDataDao.findAllCartProducts();

    double totalAmount = 0;
    for (var item in productsList) {
      if (item != null) {
        double itemTotal = 0;
        double addonTotal = 0;

        item.getAddOnList().forEach((addOnCategory) {
          addOnCategory.addOns?.forEach((addOn) {
            addonTotal += double.tryParse('${addOn.price}') ?? 0.0;
          });
        });

        if (item.isBuy1Get1 == true) {
          addonTotal = ((item.quantity ?? 0.0) / 2) * addonTotal;
          itemTotal =
              (((item.quantity ?? 0.0) / 2) * (item.price ?? 0)) + addonTotal;
        } else {
          addonTotal = (item.quantity ?? 0.0) * addonTotal;
          itemTotal = ((item.quantity ?? 0.0) * (item.price ?? 0)) + addonTotal;
        }

        totalAmount += itemTotal;
      }
    }

    setState(() {
      totalPrice = totalAmount;
    });

    getTaxAmount(totalPrice);
    getDiscountAmt();
    getGrandTotal(totalPrice, taxAmount, discountAmount);
  }

  void _createOrder() async {
    setState(() {
      isLoading = true;
    });

    bool isConnected = await _connectivityService.isConnected();
    if (!isConnected) {
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('${Languages.of(context)?.labelNoInternetConnection}'),
            duration: maxDuration,
          ),
        );
      });
    } else {
      getCartData();
      List<int> addOnIdList = [];

      List<Product> productRequest = [];
      cartList.forEach((item) {
        item?.getAddOnList().forEach((addOnCategory) {
          if (addOnCategory.addOnCategoryType == "multiple") {
            addOnCategory.addOns?.forEach((addOn) {
              addOnIdList.add(int.parse("${addOn.id}"));
            });
          } else {
            addOnCategory.addOns?.forEach((addOn) {
              addOnIdList.add(int.parse("${addOn.id}"));
            });
          }
        });
        productRequest.add(Product(
            productId: int.parse("${item?.id}"),
            quantity: int.parse("${item?.quantity}"),
            addOnIds: addOnIdList,
            price: item?.price));
      });
      CreateOrderRequest request = CreateOrderRequest(
          vendorId: int.parse("$vendorId"),
          order: Order(
            customerName: "$firstName $lastName",
            customerEmail: "$email",
            phoneNumber: "$phoneNo",
            pickupDate: "${pickupDate}",
            pickupTime: "${convertTo24HrFormat("${pickupTime}")}",
            userId: 0,
            customerId: int.parse("$userId"),
            deliveryStatus: 0,
            status: 0,
            couponId: int.parse("${couponDetails?.id ?? 0}"),
            couponCode: "${couponDetails?.couponCode ?? ""}",
            totalAmount: double.parse("${grandTotal.toStringAsFixed(2)}"),
            discountAmount: discountAmount,
            payableAmount: totalPrice,
            deliveryCharges: 0,
            orderNotes: "${_notesController.text}",
            tip: 0,
            products: productRequest,
            isPaymentSuccessTrue: false,
          ));
      await Future.delayed(Duration(milliseconds: 2));
      await Provider.of<MainViewModel>(context, listen: false)
          .placeOrder("/api/v1/app/orders", request);
      ApiResponse apiResponse =
          Provider.of<MainViewModel>(context, listen: false).response;
      getCreateOrderResponse(context, apiResponse);
    }
  }

  Widget getCouponDetails(
      BuildContext context, ApiResponse apiResponse, bool isSheet) {
    var message = apiResponse.message.toString();
    CouponDetailsResponse? couponDetailsResponse =
        apiResponse.data as CouponDetailsResponse?;
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        if (isSheet) {
          Navigator.pop(context);
        }
        double minCartAmt =
            double.tryParse("${couponDetailsResponse?.minCartAmt}") ?? 0;
        double maxDiscountAmt =
            double.tryParse("${couponDetailsResponse?.maxDiscountAmt}") ?? 0;

        print('Total Price: $totalPrice');
        print('Min Cart Amount: $minCartAmt');
        print('Max Discount Amount: $maxDiscountAmt');

        if (totalPrice >= minCartAmt && totalPrice <= 200) {
          setState(() {
            couponDetails = couponDetailsResponse;
            discountPercent = couponDetailsResponse?.discount;
            discountAmount =
                double.parse("${couponDetailsResponse?.discount ?? 0}");
            isCouponApplied = true;
            _couponController.text = "";
          });
          calculateDiscount();
        } else {
          print(
              'Condition failed: Total Price: $totalPrice, Min Cart Amt: ${couponDetailsResponse?.minCartAmt}');
          CustomAlert.showToast(
              context: context,
              message:
                  "Min cart amount should be \$${couponDetailsResponse?.minCartAmt}");
        }

        //getDiscountAmt();
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("${message}")));
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

  void _fetchCouponData(String couponCode, bool isSheet) async {
    setState(() {
      isLoading = true;
    });
    hideKeyBoard();

    await Future.delayed(Duration(milliseconds: 2));
    bool isConnected = await _connectivityService.isConnected();
    if (!isConnected) {
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('${Languages.of(context)?.labelNoInternetConnection}'),
            duration: maxDuration,
          ),
        );
      });
    } else {
      GetCouponDetailsRequest request = GetCouponDetailsRequest(
          couponCode: couponCode,
          vendorId: cartList[0]?.vendorId,
          customerId: int.parse("$userId"));
      await Future.delayed(Duration(milliseconds: 2));
      await Provider.of<MainViewModel>(context, listen: false)
          .fetchCouponDetails("api/v1/coupons/get_coupon_detail", request);
      ApiResponse apiResponse =
          Provider.of<MainViewModel>(context, listen: false).response;
      getCouponDetails(context, apiResponse, isSheet);
    }
  }

  void _fetchStoreStatus(bool isOrder) async {
    setState(() {
      isLoading = true;
    });

    bool isConnected = await _connectivityService.isConnected();
    if (!isConnected) {
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('${Languages.of(context)?.labelNoInternetConnection}'),
            duration: maxDuration,
          ),
        );
      });
    } else {
      await Future.delayed(Duration(milliseconds: 2));
      await Provider.of<MainViewModel>(context, listen: false).fetchStoreStatus(
          "/api/v1/app/orders/get_store_status?vendor_id=$vendorId");
      ApiResponse apiResponse =
          Provider.of<MainViewModel>(context, listen: false).response;
      getStoreStatusResponse(context, apiResponse, isOrder);
    }
  }

  Widget getStoreStatusResponse(
      BuildContext context, ApiResponse apiResponse, bool isOrder) {
    StoreStatusResponse? storeStatusResponse =
        apiResponse.data as StoreStatusResponse?;
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        setState(() {
          if (storeStatusResponse?.storeStatus == "offline") {
            isStoreOnline = false;
            CustomAlert.showToast(
                context: context, message: "Store is Closed!");
          } else if (storeStatusResponse?.storeStatus == "online") {
            isStoreOnline = true;
            if (isOrder) {
              _createOrder();
            }
          }

          IsUpcomingAllowed = storeStatusResponse?.IsUpcomingAllowed ?? false;
        });
        return Container();
      case Status.ERROR:
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

  double getDiscountAmt() {
    double discountVal = (totalPrice * (discountPercent ?? 0)) / 100;
    if ((double.tryParse("${couponDetails?.minCartAmt}") ?? 0) <= totalPrice &&
        discountVal <=
            (double.tryParse("${couponDetails?.maxDiscountAmt}") ?? 0)) {
      setState(() {
        discountAmount = (totalPrice * (discountPercent ?? 0)) / 100;
      });
    } else if ((double.tryParse("${couponDetails?.minCartAmt}") ?? 0) <=
        totalPrice) {
      discountAmount = double.tryParse("${couponDetails?.maxDiscountAmt}") ?? 0;
    } else {
      discountAmount = 0;
    }
    return discountAmount;
  }

  void _showUserDetailBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.4,
          minChildSize: 0.3,
          maxChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[900] : Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: Text(
                        "User Details",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    _infoWidget("Name", "$firstName $lastName",
                        Icons.person_outline_outlined),
                    _infoWidget("Email Address", "$email",
                        Icons.alternate_email_outlined),
                    phoneNo != null
                        ? _infoWidget("Phone Number", "$phoneNo", Icons.call)
                        : SizedBox(),
                    SizedBox(height: 10),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          /* Uncomment to save address */
                          // Helper.saveAddress("${_addressController.text}");
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Close",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _infoWidget(String heading, String detail, IconData icon) {
    return Container(
      width: mediaWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(heading,
                    style: TextStyle(fontSize: 11, color: Colors.grey)),
                SizedBox(
                  height: 1,
                ),
                Text(detail,
                    style: TextStyle(fontSize: 13, color: Colors.black)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void setThemeColor() {
    if (theme == "blue") {
      setState(() {
        primaryColor = Colors.blue.shade900;
        secondaryColor = Colors.blue[100];
        lightColor = Colors.blue[50];
      });
    }
  }

  Future<void> _showCupertinoDateTimePicker(BuildContext context) async {
    DateTime initialDateTime = DateTime.now().add(Duration(minutes: 20));
    DateTime minimumDateTime = DateTime.now();
    DateTime maximumDateTime = DateTime.now().add(Duration(days: 1));

    DateTime tempPickedDateTime = initialDateTime;

    await showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300,
        padding: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.dateAndTime,
                use24hFormat: false,
                initialDateTime: initialDateTime,
                minimumDate: minimumDateTime,
                maximumDate: maximumDateTime,
                onDateTimeChanged: (DateTime newDateTime) {
                  tempPickedDateTime = newDateTime;
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: CupertinoButton(
                    child: Text("Cancel"),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                Expanded(
                  child: CupertinoButton.filled(
                    child: Text(
                      "Confirm",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      setState(() {
                        pickupDate =
                            convertDateFormat(tempPickedDateTime.toString());
                        pickupTime = convertTime(tempPickedDateTime.toString());
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget appliedCouponWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey, width: 0.4),
      ),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: AppColor.Secondary),
              padding: EdgeInsets.all(5),
              child: Icon(
                Icons.discount,
                color: Colors.white,
                size: 16,
              )),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Applied Coupon*",
                style: TextStyle(fontSize: 9, color: Colors.grey),
              ),
              Text("${couponDetails?.couponCode?.toUpperCase()}",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))
            ],
          ),
          Spacer(),
          GestureDetector(
              onTap: () {
                getGrandTotal(totalPrice, taxAmount, discountAmount);
                setState(() {
                  isCouponApplied = false;
                  couponDetails = CouponDetailsResponse();
                  discountPercent = 0;
                  discountAmount = 0;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: AppColor.Secondary,
                    borderRadius: BorderRadius.circular(4)),
                child: Text("Remove",
                    style: TextStyle(fontSize: 11, color: Colors.white)),
              ))
        ],
      ),
    );
  }

  Future<void> calculateDiscount() async {
    double discountValue = totalPrice * ((couponDetails?.discount ?? 0) / 100);
    if ((double.tryParse("${couponDetails?.maxDiscountAmt}") ?? 0) >=
        discountValue) {
      print(
          "Value ${(double.tryParse("${couponDetails?.maxDiscountAmt}") ?? 0) >= discountValue}");
      setState(() {
        discountAmount = discountValue;
      });
      await Future.delayed(Duration(milliseconds: 2));
      getGrandTotal(totalPrice, taxAmount, discountAmount);
    } else {
      setState(() {
        discountAmount =
            double.tryParse("${couponDetails?.maxDiscountAmt}") ?? 0;
      });
      await Future.delayed(Duration(milliseconds: 2));
      getGrandTotal(totalPrice, taxAmount, discountAmount);
    }
  }

  String convertTo24HrFormat(String time) {
    DateFormat inputFormat = DateFormat("hh:mm a");
    DateFormat outputFormat = DateFormat("HH:mm");
    DateTime dateTime = inputFormat.parse(time);

    // Convert the DateTime object to a 24-hour format string
    String time24Hour = outputFormat.format(dateTime);

    return time24Hour;
  }

  void showCouponBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            // Optionally, you can pass a function here to update setState when data changes externally
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Available Coupons",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: couponsList.isNotEmpty
                        ? ListView.builder(
                            itemCount: couponsList.length,
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.only(bottom: 10),
                            itemBuilder: (context, index) {
                              return newCouponWidget(couponsList[index]);
                            },
                          )
                        : Center(
                            child: Text(
                              "No Coupons Found",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showNotesDialog() {
    final FocusNode _focusNode = FocusNode();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
      builder: (context) {
        // Focus after the widget builds
        Future.delayed(Duration(milliseconds: 50), () {
          FocusScope.of(context).requestFocus(_focusNode);
        });
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              TextField(
                controller: _notesController,
                maxLines: 1,
                focusNode: _focusNode,
                decoration: const InputDecoration(
                  hintText: "Write your note here...",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () {
                    print("Note saved: ${_notesController.text}");
                    Navigator.pop(context);
                  },
                  child: const Text("Save"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget newCouponWidget(PrivateCouponDetailsResponse couponsResponse) {
    return Container(
      width: 340,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 0.3, color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.card_giftcard, color: Colors.green, size: 24),
                const SizedBox(width: 8),
                Text(
                  "${couponsResponse.discount}% OFF",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              "Valid until ${couponsResponse.createdAt?.toLocal().toString().split(' ')[0]}",
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "\$${couponsResponse.minCartAmt} min - \$${couponsResponse.maxDiscountAmt} max order required",
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 36,
              child: ElevatedButton(
                onPressed: () {
                  _fetchCouponData("${couponsResponse.couponCode}", true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  "Redeem",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getCouponDetails() async {
    bool isConnected = await _connectivityService.isConnected();
    print(("isConnected - ${isConnected}"));
    if (!isConnected) {
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(Languages.of(context)!.labelNoInternetConnection),
            duration: maxDuration,
          ),
        );
      });
    } else {
      GetCouponListRequest request = GetCouponListRequest(
          vendorId: int.parse("${vendorId}"), customerId: int.parse("$userId"));

      await Provider.of<MainViewModel>(context, listen: false).fetchCouponList(
          "api/v1/app/customers/get_customer_coupons", request);
      if (mounted) {
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
      isLoading = false;
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
