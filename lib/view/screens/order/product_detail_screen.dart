import 'dart:convert';

import 'package:TheChaatBar/model/database/dao.dart';
import 'package:TheChaatBar/model/response/productDataDB.dart';
import 'package:TheChaatBar/model/response/productListResponse.dart';

import 'package:TheChaatBar/view/component/toastMessage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../languageSection/Languages.dart';
import '../../../../model/apis/apiResponse.dart';
import '../../../../model/database/ChaatBarDatabase.dart';
import '../../../../model/request/markFavoriteRequest.dart';
import '../../../../model/response/bannerListResponse.dart';
import '../../../../model/response/categoryDataDB.dart';
import '../../../../model/response/categoryListResponse.dart';
import '../../../../model/response/markFavoriteResponse.dart';
import '../../../model/response/vendorListResponse.dart';
import '../../../../theme/CustomAppColor.dart';
import '../../../../model/viewModel/mainViewModel.dart';
import '../../../utils/Helper.dart';
import '../../../utils/Util.dart';
import '../../component/CustomAlert.dart';
import '../../component/connectivity_service.dart';
import '../../component/product_component.dart';
import '../../component/view_cart_container.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductData? data; // Define the 'data' parameter here

  ProductDetailScreen({Key? key, this.data}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  late double mediaWidth;
  late double screenHeight;
  late bool isDarkMode;
  bool isProductAvailable = true;
  bool isB1G1 = false;
  var imageUrl;
  String? selectedValue;
  String? theme = "";
  late List<CategoryData?> categories = [];
  late List<ProductData?> featuredProduct = [];
  late List<ProductData> menuItems = [];
  late ChaatBarDatabase database;
  late CartDataDao cartDataDao;
  late FavoritesDataDao favoritesDataDao;
  late CategoryDataDao categoryDataDao;
  late ProductsDataDao productsDataDao;
  int cartItemCount = 0;
  late int vendorId;
  late int customerId;
  VendorData? vendorData = VendorData();
  List<ProductData> cartDBList = [];
  List<BannerData> bannerList = [];

  String selectedCategory = "";
  CategoryData? selectedCategoryDetail = CategoryData();
  List<ProductData> cart = []; // Cart holds selected MenuItems
  List<ProductSize> productSizeList = [];
  List<AddOnCategory> addOnList = [];

  bool isLoading = false;
  bool isMarkFavLoading = false;
  bool isProductsLoading = false;
  bool isCategoryLoading = false;
  bool isInternetConnected = true;
  bool _isVisible = false;
  var _connectivityService = ConnectivityService();
  static const maxDuration = Duration(seconds: 2);
  late AnimationController _controller;

  Color primaryColor = AppColor.Primary;
  Color? secondaryColor = Colors.red[100];
  Color? lightColor = Colors.red[50];
  List<bool> checkedStates = [];

  @override
  void initState() {
    super.initState();
    print("vendor : ${widget.data?.vendorId}");
    Helper.getVendorDetails().then((onValue) {
      setState(() {
        vendorData = onValue;
        vendorId = int.parse("${onValue?.id}"); //?? VendorData();
      });
      // setThemeColor();
    });
    Helper.getProfileDetails().then((onValue) {
      setState(() {
        customerId = int.parse("${onValue?.id}"); //?? VendorData();
      });
      // setThemeColor();
    });
    Helper.getVendorTheme().then((onValue) {
      print("theme : $onValue");
      setState(() {
        theme = onValue;
        //setThemeColor();
      });
    });
    imageUrl = "";
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    initializeDatabase();
    print("${widget.data?.description}");
    setState(() {
      productSizeList = widget.data?.getProductSizeList() ?? [];
      checkedStates = List<bool>.filled(productSizeList.length, false);
      addOnList = widget.data?.getAddOnList() ?? [];
      addOnList.forEach((item) {
        if (item.addOnCategoryType == "single") {
          item.selectedAddOnIdInSingleType = item.addOns?[0].id;
        } else {
          item.addOns?[0].isSelected = true;
        }
      });
    });
  }

  void _toggleContainer() {
    setState(() {
      if (_isVisible) {
        _controller.forward(); // Play the animation forward
      } else {
        _controller.reverse(); // Play the animation in reverse
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mediaWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        Navigator.pushNamed(context, "/BottomNavigation");
      },
      child: Scaffold(body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return Stack(
          children: [
            widget.data?.imageUrl == "" || widget.data?.imageUrl == null
                ? Container(
                    decoration: BoxDecoration(color: primaryColor),
                    child: Image.asset(
                      "assets/appLogo.png",
                      height: screenHeight * 0.6,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: ClipRRect(
                      child: Image.network(
                        "${widget.data?.imageUrl}",
                        height: screenHeight * 0.55,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return Container(
                            child: Image.asset(
                              "assets/appLogo.png",
                              height: screenHeight * 0.55,
                              width: double.infinity,
                              fit: BoxFit.fitWidth,
                            ),
                          );
                        },
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Shimmer.fromColors(
                              baseColor: Colors.white38,
                              highlightColor: Colors.grey,
                              child: Container(
                                height: screenHeight * 0.55,
                                width: double.infinity,
                                color: Colors.white,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
            DraggableScrollableSheet(
                initialChildSize: 0.55,
                minChildSize: 0.55,
                maxChildSize: 0.9,
                builder: (context, scrollController) {
                  return Container(
                    decoration: BoxDecoration(
                      color:
                          isDarkMode ? AppColor.CardDarkColor : Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: viewportConstraints.maxHeight,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 3,
                              width: 100,
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 18.0, right: 18, top: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 8,
                                  ),
                                  widget.data?.isBuy1Get1 == true
                                      ? Text(
                                          "BUY 1 GET 1",
                                          style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red),
                                        )
                                      : SizedBox(
                                          height: 2,
                                        ),
                                  Text(
                                    capitalizeFirstLetter(
                                        "${widget.data?.title}"),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3.0),
                                    child: IntrinsicHeight(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  capitalizeFirstLetter(
                                                      "${widget.data?.shortDescription}"),
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: isDarkMode
                                                          ? Colors.white
                                                              .withOpacity(
                                                                  0.8)
                                                          : Colors.grey[800]),
                                                  overflow:
                                                      TextOverflow.visible,
                                                ),
                                                SizedBox(
                                                  height: 3,
                                                ),
                                                Text(
                                                  capitalizeFirstLetter(
                                                      "${widget.data?.description}"),
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: isDarkMode
                                                          ? Colors.white
                                                              .withOpacity(
                                                                  0.7)
                                                          : Colors.grey[500]),
                                                  overflow:
                                                      TextOverflow.visible,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          //widget.data?.productSizesList == "[]"?
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                GestureDetector(
                                                  child: Card(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            side: BorderSide(
                                                              color: widget.data
                                                                          ?.quantity ==
                                                                      0
                                                                  ? Colors.grey
                                                                  : AppColor
                                                                      .Secondary,
                                                              width: 0.8,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Icon(
                                                        Icons.remove,
                                                        size: 24,
                                                        color: widget.data
                                                                    ?.quantity ==
                                                                0
                                                            ? Colors.grey
                                                            : AppColor
                                                                .Secondary,
                                                      ),
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    setState(() {
                                                      if (int.parse(
                                                              "${widget.data?.quantity}") >
                                                          0) {
                                                        if (widget.data
                                                                ?.isBuy1Get1 ==
                                                            true) {
                                                          widget.data
                                                                  ?.quantity =
                                                              int.parse(
                                                                      "${widget.data?.quantity}") -
                                                                  2;
                                                          _updateCart(widget
                                                                  .data
                                                              as ProductData);
                                                          deleteProductInDb(
                                                              widget.data
                                                                  as ProductData);
                                                        } else {
                                                          widget
                                                              .data?.quantity--;
                                                          _updateCart(widget
                                                                  .data
                                                              as ProductData);
                                                          deleteProductInDb(
                                                              widget.data
                                                                  as ProductData);
                                                        }
                                                      }
                                                    });
                                                  },
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "${widget.data?.quantity}",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                GestureDetector(
                                                  child: Card(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            side: BorderSide(
                                                              color: AppColor
                                                                  .Secondary,
                                                              width: 0.8,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                    color: AppColor.Secondary,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Icon(
                                                        Icons.add,
                                                        size: 24,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    // if(addOnList.)
                                                    setState(() {
                                                      if (widget.data
                                                              ?.isBuy1Get1 ==
                                                          false) {
                                                        if (int.parse(
                                                                "${widget.data?.quantity}") <
                                                            int.parse(
                                                                "${widget.data?.qtyLimit}")) {
                                                          widget
                                                              .data?.quantity++;
                                                          if (widget.data?.addOn
                                                                  ?.isNotEmpty ==
                                                              true) {
                                                            List<AddOnCategory>
                                                                addOnCategories =
                                                                [];
                                                            addOnList.forEach(
                                                                (item) {
                                                              AddOnCategory
                                                                  addOnDetails =
                                                                  AddOnCategory(
                                                                      addOnCategory:
                                                                          item
                                                                              .addOnCategory,
                                                                      addOnCategoryType:
                                                                          item.addOnCategoryType);
                                                              List<AddOnDetails>
                                                                  selectedAddOns =
                                                                  [];
                                                              if (item.addOnCategoryType ==
                                                                  "multiple") {
                                                                item.addOns
                                                                    ?.forEach(
                                                                        (addOn) {
                                                                  print(
                                                                      "addOn :: ${jsonEncode(addOn)}");
                                                                  if (addOn
                                                                      .isSelected) {
                                                                    selectedAddOns
                                                                        .add(
                                                                            addOn);
                                                                  }
                                                                });
                                                              } else {
                                                                item.addOns
                                                                    ?.forEach(
                                                                        (addOn) {
                                                                  if (item.selectedAddOnIdInSingleType ==
                                                                      addOn
                                                                          .id) {
                                                                    selectedAddOns
                                                                        .add(
                                                                            addOn);
                                                                  }
                                                                });
                                                              }

                                                              print(
                                                                  "selectedAddOns :: ${jsonEncode(selectedAddOns)}");
                                                              addOnDetails
                                                                      .addOns =
                                                                  selectedAddOns;
                                                              addOnCategories.add(
                                                                  addOnDetails);
                                                              print(
                                                                  "addOnCategories :: ${jsonEncode(addOnCategories)}");
                                                            });
                                                            widget.data?.addOn =
                                                                jsonEncode(
                                                                    addOnCategories);
                                                          }
                                                          _updateCart(widget
                                                                  .data
                                                              as ProductData);
                                                          addProductInDb(widget
                                                                  .data
                                                              as ProductData);
                                                        }
                                                      } else {
                                                        if (int.parse(
                                                                "${widget.data?.quantity}") <
                                                            2 *
                                                                int.parse(
                                                                    "${widget.data?.qtyLimit}")) {
                                                          widget.data
                                                                  ?.quantity =
                                                              int.parse(
                                                                      "${widget.data?.quantity}") +
                                                                  2;
                                                          if (widget.data?.addOn
                                                                  ?.isNotEmpty ==
                                                              true) {
                                                            List<AddOnCategory>
                                                                addOnCategories =
                                                                [];
                                                            addOnList.forEach(
                                                                (item) {
                                                              AddOnCategory
                                                                  addOnDetails =
                                                                  AddOnCategory(
                                                                      addOnCategory:
                                                                          item
                                                                              .addOnCategory,
                                                                      addOnCategoryType:
                                                                          item.addOnCategoryType);
                                                              List<AddOnDetails>
                                                                  selectedAddOns =
                                                                  [];
                                                              if (item.addOnCategoryType ==
                                                                  "multiple") {
                                                                item.addOns
                                                                    ?.forEach(
                                                                        (addOn) {
                                                                  print(
                                                                      "addOn :: ${jsonEncode(addOn)}");
                                                                  if (addOn
                                                                      .isSelected) {
                                                                    selectedAddOns
                                                                        .add(
                                                                            addOn);
                                                                  }
                                                                });
                                                              } else {
                                                                item.addOns
                                                                    ?.forEach(
                                                                        (addOn) {
                                                                  if (item.selectedAddOnIdInSingleType ==
                                                                      addOn
                                                                          .id) {
                                                                    selectedAddOns
                                                                        .add(
                                                                            addOn);
                                                                  }
                                                                });
                                                              }

                                                              print(
                                                                  "selectedAddOns :: ${jsonEncode(selectedAddOns)}");
                                                              addOnDetails
                                                                      .addOns =
                                                                  selectedAddOns;
                                                              addOnCategories.add(
                                                                  addOnDetails);
                                                              print(
                                                                  "addOnCategories :: ${jsonEncode(addOnCategories)}");
                                                            });
                                                            widget.data?.addOn =
                                                                jsonEncode(
                                                                    addOnCategories);
                                                          }
                                                          _updateCart(widget
                                                                  .data
                                                              as ProductData);
                                                          addProductInDb(widget
                                                                  .data
                                                              as ProductData);
                                                        }
                                                      }
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              /*  Text(
                                                "Item Price",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),*/
                                              Text(
                                                "\$${widget.data?.price}",
                                                style: TextStyle(
                                                    fontSize: 26,
                                                    fontWeight: FontWeight.bold,
                                                    color: primaryColor),
                                              ),
                                            ],
                                          ),
                                          //: SizedBox()
                                        ],
                                      ),
                                    ],
                                  ),

                                  SizedBox(
                                    height: 20,
                                  ),
                                  /*productSizeList.isNotEmpty
                                          ? Text(
                                              "SELECT SIZE",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : SizedBox(),
                                      productSizeList.isNotEmpty
                                          ? Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 4),
                                              child: Wrap(
                                                spacing: 5,
                                                // Horizontal space between items
                                                children: List.generate(
                                                    productSizeList.length,
                                                    (index) {
                                                  return CheckboxListTile(
                                                    checkboxShape: CircleBorder(),
                                                    controlAffinity:
                                                        ListTileControlAffinity
                                                            .leading,
                                                    visualDensity: VisualDensity(
                                                        vertical: -2,
                                                        horizontal: -4),
                                                    secondary: Container(
                                                      margin: EdgeInsets.all(6),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 4,
                                                              vertical: 2),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                12),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          GestureDetector(
                                                              child: Card(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                        side:
                                                                            BorderSide(
                                                                          color:
                                                                              primaryColor,
                                                                          width:
                                                                              0.8,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                8)),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          4.0),
                                                                  child: Icon(
                                                                    Icons.remove,
                                                                    size: 16,
                                                                    color:
                                                                        primaryColor,
                                                                  ),
                                                                ),
                                                              ),
                                                              onTap: () {
                                                                if (checkedStates[
                                                                    index]) {
                                                                  setState(() {
                                                                    if (int.parse(
                                                                            "${productSizeList[index].quantity}") >
                                                                        0) {
                                                                      productSizeList[
                                                                              index]
                                                                          .quantity--;
                                                                      widget.data
                                                                          ?.quantity--;
                                                                      setState(
                                                                          () {
                                                                        widget.data
                                                                                ?.productSizesList =
                                                                            jsonEncode(
                                                                                productSizeList);
                                                                      });
                                                                      _updateCart(
                                                                          widget.data
                                                                              as ProductData);
                                                                      deleteProductInDb(
                                                                          widget.data
                                                                              as ProductData);
                                                                    }
                                                                  });
                                                                }
                                                              }),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            "${productSizeList[index].quantity}",
                                                            style: TextStyle(
                                                                fontSize: 12),
                                                          ),
                                                          SizedBox(
                                                            width: 4,
                                                          ),
                                                          GestureDetector(
                                                              child: Card(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                        side:
                                                                            BorderSide(
                                                                          color:
                                                                              primaryColor,
                                                                          width:
                                                                              0.8,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                8)),
                                                                color:
                                                                    primaryColor,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          4.0),
                                                                  child: Center(
                                                                    child: Icon(
                                                                      Icons.add,
                                                                      size: 16,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              onTap: () {
                                                                if (checkedStates[
                                                                    index]) {
                                                                  setState(() {
                                                                    if (int.parse(
                                                                            "${widget.data?.quantity}") <
                                                                        int.parse(
                                                                            "${widget.data?.qtyLimit}")) {
                                                                      productSizeList[
                                                                              index]
                                                                          .quantity++;
                                                                      widget.data
                                                                          ?.quantity++;
                                                                      setState(
                                                                          () {
                                                                        widget.data
                                                                                ?.productSizesList =
                                                                            jsonEncode(
                                                                                productSizeList);
                                                                      });
                                                                      _updateCart(
                                                                          widget.data
                                                                              as ProductData);
                                                                      addProductInDb(
                                                                          widget.data
                                                                              as ProductData);
                                                                    }
                                                                  });
                                                                }
                                                              }),
                                                        ],
                                                      ),
                                                    ),
                                                    title: Row(
                                                      children: [
                                                        Text(
                                                          capitalizeFirstLetter(
                                                              '${productSizeList[index].size}'),
                                                          style: TextStyle(
                                                              fontSize: 14),
                                                        ),
                                                        Spacer(),
                                                        Text(
                                                          '\$${productSizeList[index].price}',
                                                          style: TextStyle(
                                                              fontSize: 13),
                                                        )
                                                      ],
                                                    ),
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 6,
                                                            vertical: 0),
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        checkedStates[index] =
                                                            value ?? false;
                                                        if (!checkedStates[
                                                            index]) {
                                                          setState(() {
                                                            widget.data
                                                                ?.quantity = int
                                                                    .parse(
                                                                        "${widget.data?.quantity}") -
                                                                productSizeList[
                                                                        index]
                                                                    .quantity;
                                                            if (int.parse(
                                                                    "${widget.data?.quantity}") <
                                                                0) {
                                                              widget.data
                                                                  ?.quantity = 0;
                                                            }
                                                            productSizeList[index]
                                                                .quantity = 0;
                                                            widget.data
                                                                    ?.productSizesList =
                                                                jsonEncode(
                                                                    productSizeList);
                                                            _updateCart(widget
                                                                    .data
                                                                as ProductData);
                                                            deleteProductInDb(
                                                                widget.data
                                                                    as ProductData);
                                                          });
                                                        }
                                                      });
                                                    },
                                                    value: productSizeList[index]
                                                                .quantity >
                                                            0
                                                        ? true
                                                        : checkedStates[index],
                                                  );
                                                }).toList(),
                                              ))
                                          : SizedBox(),*/
                                  addOnList.isNotEmpty
                                      ? Row(
                                          children: [
                                            Text(
                                              "Choice of AddOn",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              width: 3,
                                            ),
                                          ],
                                        )
                                      : SizedBox(),
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 5,
                                    children: addOnList.map((result) {
                                      return Container(
                                        margin: EdgeInsets.all(5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 2.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    capitalizeFirstLetter(
                                                        "${result.addOnCategory}"),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16),
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    result.addOnCategoryType ==
                                                            "multiple"
                                                        ? "Select 1 or more add ons"
                                                        : "Select any 1 add on",
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        decorationColor:
                                                            Colors.grey[400],
                                                        color:
                                                            Colors.grey[600]),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 2,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      width: 0.2,
                                                      color: Colors.black54)),
                                              child:
                                                  result.addOnCategoryType ==
                                                          "multiple"
                                                      ? Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 10),
                                                          child: Wrap(
                                                            spacing: 5,
                                                            // Horizontal space between items
                                                            children: List.generate(
                                                                result.addOns
                                                                        ?.length ??
                                                                    0, (index) {
                                                              return Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8.0),
                                                                child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                              capitalizeFirstLetter('${result.addOns?[index].name}'),
                                                                              style: TextStyle(
                                                                                fontSize: 15,
                                                                              )),
                                                                          SizedBox(
                                                                            width:
                                                                                4,
                                                                          ),
                                                                          Text(
                                                                            capitalizeFirstLetter('(+\$${result.addOns?[index].price})'),
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 12,
                                                                              color: Colors.grey[700],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Checkbox(
                                                                        checkColor:
                                                                            Colors.white,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5)),
                                                                        side:
                                                                            BorderSide(
                                                                          color: isDarkMode
                                                                              ? Colors.white
                                                                              : Colors.black,
                                                                        ),
                                                                        visualDensity: VisualDensity(
                                                                            vertical:
                                                                                -4,
                                                                            horizontal:
                                                                                -4),
                                                                        value: result
                                                                            .addOns?[index]
                                                                            .isSelected,
                                                                        onChanged:
                                                                            (bool?
                                                                                value) {
                                                                          setState(
                                                                              () {
                                                                            result.addOns?[index].isSelected =
                                                                                value ?? false;
                                                                            widget.data?.addOn =
                                                                                jsonEncode(addOnList);
                                                                          });
                                                                        },
                                                                      ),
                                                                    ]),
                                                              );
                                                            }).toList(),
                                                          ))
                                                      : Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 10),
                                                          child: Wrap(
                                                            spacing: 5,
                                                            // Horizontal space between items
                                                            children: List.generate(
                                                                result.addOns
                                                                        ?.length ??
                                                                    0, (index) {
                                                              return RadioListTile<
                                                                  int>(
                                                                dense: true,
                                                                controlAffinity:
                                                                    ListTileControlAffinity
                                                                        .trailing,
                                                                autofocus: true,

                                                                visualDensity:
                                                                    VisualDensity(
                                                                        vertical:
                                                                            -4,
                                                                        horizontal:
                                                                            -4),
                                                                contentPadding:
                                                                    EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            12),
                                                                title: Row(
                                                                  children: [
                                                                    Text(
                                                                      capitalizeFirstLetter(
                                                                          "${result.addOns?[index].name}"),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              13),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 4,
                                                                    ),
                                                                    Text(
                                                                      capitalizeFirstLetter(
                                                                          '(+\$${result.addOns?[index].price})'),
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color: Colors
                                                                            .grey[700],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                value: int.parse(
                                                                    "${result.addOns?[index].id}"),
                                                                //optionIndex,
                                                                groupValue: result
                                                                    .selectedAddOnIdInSingleType,
                                                                // category.selectedOption,
                                                                onChanged: (int?
                                                                    newValue) {
                                                                  setState(() {
                                                                    result.selectedAddOnIdInSingleType =
                                                                        newValue;
                                                                    widget.data
                                                                            ?.addOn =
                                                                        jsonEncode(
                                                                            addOnList);
                                                                  });
                                                                },
                                                              );
                                                            }).toList(),
                                                          )),
                                            )
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  )
                                  //SizedBox(height: 20,),
                                ],
                              ),
                            ),
                            Container(
                              height: 0.3,
                              width: mediaWidth * 0.6,
                              color: Colors.grey,
                              margin: EdgeInsets.only(
                                bottom: 10,
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                margin: EdgeInsets.only(left: 20),
                                child: Text(
                                  "Recommended for you".toUpperCase(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: isDarkMode
                                          ? Colors.white.withOpacity(0.8)
                                          : Colors.grey[600]),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            isProductAvailable
                                ? isProductsLoading
                                    ? Wrap(
                                        spacing: 10,
                                        runSpacing: 5,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.start,
                                        children: menuItems.map((item) {
                                          return Card(
                                              margin: EdgeInsets.only(
                                                  top: 4.0,
                                                  right: 8,
                                                  bottom: 2,
                                                  left: 2),
                                              child: Container(
                                                  width: (MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          2) -
                                                      30,
                                                  height: screenHeight * 0.18,
                                                  //padding: EdgeInsets.only(right: 4),
                                                  child: Shimmer.fromColors(
                                                    baseColor:
                                                        Colors.grey[300]!,
                                                    highlightColor:
                                                        Colors.grey[100]!,
                                                    child: Container(
                                                      //margin: EdgeInsets.symmetric(horizontal: 16),
                                                      height:
                                                          screenHeight * 0.15,
                                                      child: Card(
                                                        color: Colors.white
                                                            .withOpacity(0.8),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.5)),
                                                        margin: EdgeInsets.zero,
                                                      ),
                                                    ),
                                                  )));
                                        }).toList())
                                    : Center(
                                        child: Wrap(
                                            spacing: 12,
                                            runSpacing: 5,
                                            children: menuItems.map((item) {
                                              //final item = menuItems[index];
                                              return item.id != widget.data?.id
                                                  ? ProductComponent(
                                                      isDarkMode: isDarkMode,
                                                      item: item,
                                                      mediaWidth: mediaWidth,
                                                      showFavIcon: true,
                                                      screenHeight:
                                                          screenHeight,
                                                      onAddTap: () {
                                                        if (/*(item.productSizesList == "[]" ||
                                                                item.productSizesList ==
                                                                    null) &&*/
                                                            (item.addOn ==
                                                                        "[]" ||
                                                                    item.addOn ==
                                                                        null) &&
                                                                item.isBuy1Get1 ==
                                                                    false) {
                                                          setState(() {
                                                            if (item.quantity <=
                                                                int.parse(
                                                                    "${item.qtyLimit}")) {
                                                              item.quantity++;
                                                              addProductInDb(
                                                                  item);
                                                            }
                                                          });
                                                        } else {
                                                          Navigator.pushNamed(
                                                              context,
                                                              "/ProductDetailScreen",
                                                              arguments: item);
                                                        }
                                                      },
                                                      onMinusTap: () {
                                                        if (/*(item.productSizesList == "[]" ||
                                                                item.productSizesList ==
                                                                    null) &&*/
                                                            (item.addOn ==
                                                                        "[]" ||
                                                                    item.addOn ==
                                                                        null) &&
                                                                item.isBuy1Get1 ==
                                                                    false) {
                                                          setState(() {
                                                            if (item.quantity >
                                                                0) {
                                                              item.quantity--;
                                                              deleteCartProductInDb(
                                                                  item);
                                                            }
                                                          });
                                                        } else {
                                                          Navigator.pushNamed(
                                                              context,
                                                              "/ProductDetailScreen",
                                                              arguments: item);
                                                        }
                                                      },
                                                      onPlusTap: () {
                                                        if (/*(item.productSizesList == "[]" ||
                                                                item.productSizesList ==
                                                                    null) &&*/
                                                            (item.addOn ==
                                                                        "[]" ||
                                                                    item.addOn ==
                                                                        null) &&
                                                                item.isBuy1Get1 ==
                                                                    false) {
                                                          setState(() {
                                                            if (item.quantity <=
                                                                int.parse(
                                                                    "${item.qtyLimit}")) {
                                                              item.quantity++;
                                                              addProductInDb(
                                                                  item);
                                                            }
                                                          });
                                                        } else {
                                                          Navigator.pushNamed(
                                                              context,
                                                              "/ProductDetailScreen",
                                                              arguments: item);
                                                        }
                                                      },
                                                      onFavoriteTap: () {
                                                        addOrRemoveFavorites(
                                                            item);
                                                      },
                                                      primaryColor:
                                                          primaryColor)
                                                  : SizedBox();
                                            }).toList()),
                                      )
                                : Center(
                                    child: Text(
                                      "No data available.",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ),
                            SizedBox(
                              height: 50,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
            SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/BottomNavigation");
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.white),
                        padding: EdgeInsets.all(9),
                        margin: EdgeInsets.all(9),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 20,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ViewCartContainer(
                cartItemCount: cartItemCount,
                theme: "${widget.data?.theme}",
                controller: _controller,
                primaryColor: primaryColor),
            /*isLoading
                    ? Stack(
                  children: [
                    // Block interaction
                    ModalBarrier(
                        dismissible: false,
                        color: Colors.black.withOpacity(0.02)),
                    // Loader indicator
                    */ /*Center(
                      child: CircularProgressIndicator(),
                    ),*/ /*
                  ],
                )
                    : SizedBox(),*/
          ],
        );
      }
          // Bottom - Cart section

          //  bottomNavigationBar: ,
          )),
    );
  }

  void _updateCart(ProductData item) {
    if (item.quantity > 0) {
      if (!cart.contains(item) &&
          item.quantity <= int.parse("${item.qtyLimit}")) {
        cart.add(item);
      }
    } else {
      cart.remove(item); // Remove item if quantity is zero
    }
  }

  void _fetchCategoryData() async {
    setState(() {
      isLoading = true;
      // isCategoryLoading = true;
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
      await Provider.of<MainViewModel>(context, listen: false)
          .fetchCategoriesList("/api/v1/app/products/get_products", vendorId);
      //.fetchCategoriesList("/api/v1/products/${widget.data?.vendorId}/customer_products");
      ApiResponse apiResponse =
          Provider.of<MainViewModel>(context, listen: false).response;
      getCategoryList(context, apiResponse);
    }
  }

  void _setFavorite(int? productId) async {
    setState(() {
      isLoading = true;
      isMarkFavLoading = true;
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
      MarkFavoriteRequest request = MarkFavoriteRequest(
          customerId: customerId,
          productId: productId ?? 0,
          vendorId: vendorId);
      await Future.delayed(Duration(milliseconds: 2));
      await Provider.of<MainViewModel>(context, listen: false)
          .markFavoriteData("/api/v1/app/products/mark_favourites", request);
      ApiResponse apiResponse =
          Provider.of<MainViewModel>(context, listen: false).response;
      getMarkFavoriteResponse(context, apiResponse);
    }
  }

  void _removeFavorite(int? productId) async {
    setState(() {
      isLoading = true;
      isMarkFavLoading = true;
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
      MarkFavoriteRequest request = MarkFavoriteRequest(
          customerId: customerId,
          productId: int.parse("${productId}"),
          vendorId: vendorId);
      await Future.delayed(Duration(milliseconds: 2));
      await Provider.of<MainViewModel>(context, listen: false)
          .removeFavoriteData(
              "/api/v1/app/products/remove_favourites", request);
      ApiResponse apiResponse =
          Provider.of<MainViewModel>(context, listen: false).response;
      getRemoveFavoriteResponse(context, apiResponse);
    }
  }

  Widget getCategoryList(BuildContext context, ApiResponse apiResponse) {
    CategoryListResponse? vendorListResponse =
        apiResponse.data as CategoryListResponse?;
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        setState(() {
          categories = vendorListResponse!.data!;
          isCategoryLoading = false;
          selectedCategory = vendorListResponse.data?[0].categoryName ?? "";
          selectedCategoryDetail =
              vendorListResponse.data?[0] ?? CategoryData();
        });
        updateCategoriesDetails(vendorListResponse?.data);
        getProductDataDB("${widget.data?.productCategoryId}");

        return Container(); // Return an empty container as you'll navigate away
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

  Widget getMarkFavoriteResponse(
      BuildContext context, ApiResponse apiResponse) {
    MarkFavoriteResponse? markFavoriteResponse =
        apiResponse.data as MarkFavoriteResponse?;
    setState(() {
      isLoading = false;
      isMarkFavLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        setState(() {
          widget.data?.favorite = true;
        });
        // _fetchFavoritesData();
        return Container(); // Return an empty container as you'll navigate away
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

  Widget getRemoveFavoriteResponse(
      BuildContext context, ApiResponse apiResponse) {
    MarkFavoriteResponse? featuredListResponse =
        apiResponse.data as MarkFavoriteResponse?;
    setState(() {
      isLoading = false;
      isMarkFavLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        setState(() {
          widget.data?.favorite = false;
        });
        return Container(); // Return an empty container as you'll navigate away
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

  int getCartItemCount() {
    return cart.fold(0, (totalCount, item) => totalCount + item.quantity);
  }

  Future<void> getCartItemCountDB() async {
    List<ProductDataDB?> productsList = await cartDataDao.findAllCartProducts();
    if (mounted) {
      int totalCount = 0;
      if (productsList.isNotEmpty &&
          productsList.length > 0 &&
          productsList != null) {
        productsList.forEach((item) {
          if (item != null) {
            totalCount = totalCount + int.parse("${item.quantity}");
          }
        });
        setState(() {
          cartItemCount = totalCount;
          if (cartItemCount == 0) {
            _isVisible = false;
          } else {
            _isVisible = true;
          }
          _toggleContainer();
        });
      } else {
        setState(() {
          cartItemCount = 0;
          if (cartItemCount == 0) {
            _isVisible = false;
          } else {
            _isVisible = true;
          }
          _toggleContainer();
        });
      }
    } else {
      setState(() {
        cartItemCount = 0;
        if (cartItemCount == 0) {
          _isVisible = false;
        } else {
          _isVisible = true;
        }
        _toggleContainer();
      });
    }
  }

  Future<void> addProductInDb(ProductData item) async {
    ProductDataDB data = ProductDataDB(
        description: item.description,
        imageUrl: item.imageUrl,
        //addOnIds: [],
        categoryName: item.categoryName,
        //addOnType: item.addOnType,
        addOn: item.addOn,
        deposit: item.deposit,
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
        vendorName: widget.data?.vendorName,
        theme: widget.data?.theme,
        addedToCartAt: "${DateFormat('yyyy-MM-dd').format(DateTime.now())}",
        addOnIdsList: '',
        productSizesList: item.productSizesList);
    print(
        "vendorId ${item.franchiseId}  :: productCategoryId  ${item.productCategoryId}  :: id   ${item.id}");
    print("quantity ${item.quantity}");

    getSpecificCartProduct("${vendorId}", "${item.productCategoryId}",
        "${item.id}", cartDataDao, data);
    getCartItemCountDB();
  }

  Future<ProductDataDB?> getSpecificCartProduct(
      String vendorId,
      String categoryId,
      String productId,
      CartDataDao cartDataDao,
      ProductDataDB data) async {
    data.theme = widget.data?.theme;
    data.vendorName = widget.data?.vendorName;
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
              if (data.vendorId != item.vendorId) {
                cartDataDao.clearAllCartProduct();
                cartDataDao.insertCartProduct(item);
                CustomAlert.showToast(
                    context: context,
                    message:
                        "Removed items from cart and added latest item because you can only order from one restaurant at once.");
              } else {
                cartDataDao.insertCartProduct(item);
              }
            }
          });
        } else {
          print("Inserting single product: $data");
          cartDataDao.clearAllCartProduct();
          await cartDataDao.insertCartProduct(data);
        }
      }
      getCartItemCountDB();

      return null;
    } else {
      print("Product exists: $product");
      await cartDataDao.updateCartProduct(data); // Update the existing product
    }
    getCartItemCountDB();

    return product;
  }

  void deleteProductInDb(ProductData item) {
    ProductDataDB data = ProductDataDB(
        description: item.description,
        imageUrl: item.imageUrl,
        //addOnIds: item.addOnIds,
        categoryName: item.categoryName,
        //addOnType: item.addOnType,
        addOn: item.addOn,
        deposit: item.deposit,
        price: item.price,
        productCategoryId: item.productCategoryId,
        productId: item.id,
        qtyLimit: item.qtyLimit,
        isBuy1Get1: item.isBuy1Get1,
        salePrice: item.salePrice,
        shortDescription: item.shortDescription,
        status: item.status,
        title: item.title,
        vendorId: vendorId,
        franchiseId: item.franchiseId,
        quantity: item.quantity,
        theme: item.theme,
        vendorName: item.vendorName,
        addedToCartAt: "${DateFormat('yyyy-MM-dd').format(DateTime.now())}",
        addOnIdsList: '',
        productSizesList: item.productSizesList);
    if (item.quantity == 0) {
      cartDataDao.deleteCartProduct(data);
    } else {
      cartDataDao.updateCartProduct(data);
    }
    getCartItemCountDB();
  }

  Future<void> initializeDatabase() async {
    database = await $FloorChaatBarDatabase
        .databaseBuilder('basic_structure_database.db')
        .build();

    cartDataDao = database.cartDao;
    favoritesDataDao = database.favoritesDao;
    categoryDataDao = database.categoryDao;
    productsDataDao = database.productDao;

    //_fetchCategoryData();
    getCartData();
    getProductDataDB("${widget.data?.productCategoryId}");
    getCategoryDataDB();
  }

  Future<void> getCartData() async {
    List<ProductDataDB?> productsList = await cartDataDao.findAllCartProducts();
    // print("getCartData");
    setState(() {
      List<ProductData> list = [];
      productsList.forEach((item) {
        if (item != null) {
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
              theme: item.theme,
              vendorName: item.vendorName,
              pst: null,
              updatedAt: "",
              vpt: null,
              addOnIdsList: '',
              productSizesList: item.productSizesList));
          cartDBList = list;
        }
      });
    });
    updateQuantity();
  }

  Future<void> getCategoryDataDB() async {
    try {
      List<CategoryDataDB?> localCategoryList = await categoryDataDao
          .getCategoriesAccToVendor(int.parse("${vendorId}"));
      if (localCategoryList.isNotEmpty) {
        setState(() {
          // Filter out null values and cast to non-nullable type
          List<CategoryData> list = [];
          localCategoryList.forEach((item) {
            if (item != null) {
              list.add(CategoryData(
                  vendorId: vendorId,
                  updatedAt: item.updatedAt,
                  id: item.id,
                  createdAt: item.createdAt,
                  categoryName: item.categoryName,
                  status: item.status,
                  categoryImage: item.categoryImage,
                  menuImgUrl: item.menuImgUrl));
              categories = list;
            }
          });
          isCategoryLoading = false;
          getProductDataDB("${widget.data?.productCategoryId}");
        });
        _fetchCategoryData();
      } else {
        setState(() {
          isLoading = true;
          isCategoryLoading = true;
        });
        _fetchCategoryData();
      }
    } catch (e) {
      _fetchCategoryData();
    }
  }

  Future<void> getProductDataDB(String categoryId) async {
    List<ProductData?> localProductList =
        await productsDataDao.getProductsAccToCategory(int.parse(categoryId));
    if (localProductList.isNotEmpty) {
      setState(() {
        isProductAvailable = true;
        menuItems = [];
        // Filter out null values and cast to non-nullable type
        menuItems.addAll(
            localProductList.where((item) => item != null).cast<ProductData>());

        getCartData();
        updateQuantity();
        isProductsLoading = false;
      });
      //_fetchProductData(categoryId);
    } else {
      setState(() {
        isProductAvailable = false;
        menuItems = [];
        //isLoading = true;
        //isProductsLoading = true;
      });
      //_fetchCategoryData();
    }
  }

  Future<void> updateQuantity() async {
    menuItems.forEach((item) {
      cartDBList.forEach((dbItem) {
        if (item.id == dbItem.id &&
            item.productCategoryId == dbItem.productCategoryId &&
            vendorId == dbItem.vendorId) {
          setState(() {
            item.quantity = dbItem.quantity;
          });
        }
      });
    });
    getCartItemCountDB();
  }

  Future<void> updateCategoriesDetails(List<CategoryData>? categoryList) async {
    if (categoryList?.isNotEmpty == true) {
      List<CategoryDataDB?> localCategoryList =
          await categoryDataDao.findAllCategories();
      if (mounted) {
        for (var categoryData in categoryList ?? []) {
          bool categoryExists = localCategoryList
              .any((localData) => localData?.id == categoryData.id);
          if (!categoryExists) {
            CategoryDataDB data = CategoryDataDB(
              menuImgUrl: categoryData.menuImgUrl,
              categoryImage: categoryData.categoryImage,
              status: categoryData.status,
              categoryName: categoryData.categoryName,
              createdAt: categoryData.createdAt,
              id: categoryData.id,
              updatedAt: categoryData.updatedAt,
              vendorId: vendorId,
              franchiseId: categoryData.vendorId,
            );
            categoryDataDao.insertCategory(data);
            updateProductsDetails(categoryData.products);
          }
        }
      }
    }
    setState(() {
      categories = categoryList as List<CategoryData>;
      isLoading = false;
    });
  }

  Future<void> updateProductsDetails(List<ProductData>? productList) async {
    if (productList?.isNotEmpty == true) {
      List<ProductData?> localProductList =
          await productsDataDao.findAllProducts();
      if (mounted) {
        for (var productsData in productList ?? []) {
          bool productExists = localProductList
              .any((localData) => localData?.id == productsData.id);
          if (!productExists) {
            productsDataDao.insertProduct(productsData);
          }
        }
      }
    }
    setState(() {
      menuItems = productList as List<ProductData>;
      isLoading = false;
    });
  }

  void deleteCartProductInDb(ProductData item) {
    ProductDataDB data = ProductDataDB(
        description: item.description,
        imageUrl: item.imageUrl,
        //addOnIds: item.addOnIds,
        categoryName: item.categoryName,
        //addOnType: item.addOnType,
        deposit: item.deposit,
        price: item.price,
        productCategoryId: item.productCategoryId,
        productId: item.id,
        qtyLimit: item.qtyLimit,
        isBuy1Get1: item.isBuy1Get1,
        salePrice: item.salePrice,
        shortDescription: item.shortDescription,
        status: item.status,
        title: item.title,
        vendorId: vendorId,
        franchiseId: item.franchiseId,
        quantity: item.quantity,
        theme: item.theme,
        vendorName: item.vendorName,
        addedToCartAt: "${DateFormat('yyyy-MM-dd').format(DateTime.now())}",
        addOnIdsList: '',
        productSizesList: '');
    if (item.quantity == 0) {
      cartDataDao.deleteCartProduct(data);
    } else {
      cartDataDao.updateCartProduct(data);
    }
    getCartItemCountDB();
  }

  Future<void> addOrRemoveFavorites(ProductData item) async {
    print("item.favorite ${item.favorite}");
    print("item.id ${item.favorite}");
    if (item.favorite == false) {
      _setFavorite(item.id);
    } else {
      _removeFavorite(item.id);
    }
    /* FavoritesDataDb data = FavoritesDataDb(
        description: item.description,
        imageUrl: item.imageUrl,
        //addOnIds: [],
        categoryName: item.categoryName,
        //addOnType: item.addOnType,
        deposit: item.deposit,
        price: item.price,
        productCategoryId: item.productCategoryId,
        productId: item.id,
        qtyLimit: item.qtyLimit,
        salePrice: "",
        shortDescription: item.shortDescription,
        status: item.status,
        title: item.title,
        vendorId: item.vendorId,
        quantity: item.quantity,
        vendorName: widget.data?.vendorName,
        theme: widget.data?.theme,
        addedToFavoritesAt: "${DateFormat('yyyy-MM-dd').format(DateTime.now())}",
        addOnIdsList: '',
        productSizesList: item.productSizesList);
    data.theme = widget.data?.theme;
    data.vendorName = widget.data?.vendorName;
    final product = await favoritesDataDao.getSpecificFavoritesProduct(
        "${item.vendorId}", "${item.productCategoryId}", "${item.id}");

    if (product == null) {
      List<FavoritesDataDb?> favoritesList =
      await favoritesDataDao.findAllFavoritesProducts();
      favoritesList.add(data);

      if (mounted) {
        if (favoritesList.isNotEmpty) {
          // Use forEach instead of map to perform an action
          favoritesList.forEach((item) {
            if (item != null) {
              print("Inserting item: $item");
              favoritesDataDao.insertFavoritesProduct(item);
            }
          });
        } else {
          print("Inserting single product: $data");
          favoritesDataDao.clearAllFavoritesProduct();
          await favoritesDataDao.insertFavoritesProduct(data);
        }
      }
      return null;
    } else {
      print("Product exists: $product");
      await favoritesDataDao.deleteFavoritesProduct(data); // Update the existing product
    }
    return product;*/
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
}
