import 'dart:convert';

import 'package:TheChaatBar/languageSection/Languages.dart';
import 'package:TheChaatBar/model/request/markFavoriteRequest.dart';
import 'package:TheChaatBar/model/response/favoriteListResponse.dart';
import 'package:TheChaatBar/model/response/markFavoriteResponse.dart';
import 'package:TheChaatBar/model/response/vendorListResponse.dart';
import 'package:TheChaatBar/view/component/ShimmerList.dart';
import 'package:TheChaatBar/view/component/category_component.dart';
import 'package:TheChaatBar/view/component/menu_screen_category_component.dart';
import 'package:TheChaatBar/view/component/no_item_available.dart';
import 'package:TheChaatBar/view/component/view_cart_container.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../model/apis/apiResponse.dart';
import '../../../model/database/ChaatBarDatabase.dart';
import '../../../model/database/DatabaseHelper.dart';
import '../../../model/database/dao.dart';
import '../../../model/request/featuredListRequest.dart';
import '../../../model/response/categoryDataDB.dart';
import '../../../model/response/categoryListResponse.dart';
import '../../../model/response/featuredListResponse.dart';
import '../../../model/response/productDataDB.dart';
import '../../../model/response/productListResponse.dart';
import '../../../model/viewModel/mainViewModel.dart';
import '../../../theme/CustomAppColor.dart';
import '../../../utils/Helper.dart';
import '../../../utils/Util.dart';
import '../../component/CustomAlert.dart';
import '../../component/all_category_shimmer.dart';
import '../../component/connectivity_service.dart';
import '../../component/my_navigator_observer.dart';
import '../../component/product_component.dart';
import '../../component/product_shimmer.dart';
import '../../component/toastMessage.dart';

class MenuScreen extends StatefulWidget {
  final VendorData? data;

  MenuScreen({Key? key, this.data}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen>
    with SingleTickerProviderStateMixin {
  late double mediaWidth;
  late double screenHeight;
  String detailType = '';
  bool isProductAvailable = true;
  bool isFeaturedProductAvailable = true;
  late int vendorId;
  VendorData? vendorData = VendorData();
  late List<CategoryData?> categories = [];
  late List<ProductData> featuredProduct = [];
  late List<ProductData> favoriteProducts = [];
  late List<ProductData> menuItems = [];
  List<ProductData> cartDBList = [];
  int cartItemCount = 0;
  int customerId = 0;
  String selectedCategory = "";
  CategoryData? selectedCategoryDetail = CategoryData();
  late ChaatBarDatabase database;
  late CartDataDao cartDataDao;
  late FavoritesDataDao favoritesDataDao;
  late CategoryDataDao categoryDataDao;
  late ProductsDataDao productsDataDao;
  var _connectivityService = ConnectivityService();
  static const maxDuration = Duration(seconds: 2);

  late AnimationController _controller;
  bool _isVisible = false;
  bool isLoading = false;
  bool isCategoryLoading = false;
  bool isProductsLoading = false;
  bool isFeaturedProductsLoading = false;
  bool isFavoriteProductsLoading = false;
  bool isMarkFavResponseLoading = false;

  Color primaryColor = AppColor.Primary;
  Color? secondaryColor = Colors.red[100];
  Color? lightColor = Colors.red[50];

  @override
  void initState() {
    super.initState();
    // setThemeColor();
    Helper.getVendorDetails().then((onValue) {
      setState(() {
        vendorData = onValue;
        vendorId = int.parse("${onValue?.id}"); //?? VendorData();
      });
      // setThemeColor();
    });

    print("aaaaabbbb");
    Helper.getProfileDetails().then((onValue) {
      setState(() {
        print("aaaaa${onValue?.id}");
        customerId = int.parse("${onValue?.id}"); //?? VendorData();
      });
      // setThemeColor();
    });

    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    setState(() {
      detailType = "${widget.data?.detailType}";
    });
    initializeDatabase();
    if (detailType == "popular food") {
      _fetchFeaturedData();
    } else if (detailType == "menu") {
      setState(() {
        selectedCategoryDetail?.id = widget.data?.selectedCategoryId;
      });
    } else if (detailType == "favorites") {
      _fetchFavoritesData();
    }
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
  void didChangeDependencies() {
    super.didChangeDependencies();

    final observer = Navigator.of(context)
        .widget
        .observers
        .whereType<MyNavigatorObserver>()
        .first;
    //observer.registerCallback('/MenuScreen');
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    mediaWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        Navigator.pushNamed(context, "/BottomNavigation");
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.BackgroundColor,
          leading: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/BottomNavigation");
            },
            child: Row(
              children: [
                SizedBox(
                  width: 8,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
          title: Text(
            capitalizeFirstLetter('${detailType}'),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed("/CartScreen");
                    },
                    icon: const Icon(
                      Icons.shopping_cart,
                      size: 24,
                      color: AppColor.Primary,
                    ),
                  ),
                  if (cartItemCount > 0) // Show badge only if cartCount > 0
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                        ),
                        child: Text(
                          '$cartItemCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
        body: LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return Stack(children: [
            SafeArea(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 2.0),
                        child: Column(
                          children: [
                            detailType == "categories"
                                ? isCategoryLoading
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: AllCategoryShimmer(),
                                      )
                                    : categories.isEmpty
                                        ? isLoading
                                            ? ShimmerList()
                                            : Container(
                                                height: screenHeight * 0.3,
                                                child: Center(
                                                  child: Text(
                                                    "No Categories Found",
                                                    style: TextStyle(
                                                        color: isDarkMode
                                                            ? Colors.white30
                                                            : Colors.grey),
                                                  ),
                                                ),
                                              )
                                        : MenuScreenCategoryComponent(
                                            categories: categories,
                                            mediaWidth: mediaWidth,
                                            screenHeight: screenHeight,
                                            isDarkMode: isDarkMode,
                                            onTap:
                                                (CategoryData? categoryData) {
                                              setState(() {
                                                VendorData? data = widget.data;
                                                data?.detailType = "menu";
                                                data?.selectedCategoryId =
                                                    categoryData?.id;
                                                Navigator.pushReplacementNamed(
                                                    context, "/MenuScreen",
                                                    arguments: data);
                                              });
                                            },
                                            primaryColor: primaryColor)
                                : SizedBox(),
                            detailType == "menu"
                                ? Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0, right: 8.0, bottom: 8),
                                      child: Text(
                                        "CATEGORIES",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                            color: Colors.black54),
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                            SizedBox(
                              height: 2,
                            ),
                            detailType == "menu"
                                ? Container(
                                    height: 45,
                                    alignment: Alignment.topCenter,
                                    constraints: BoxConstraints(
                                      maxWidth: mediaWidth,
                                    ),
                                    child: isCategoryLoading
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            child: ListView.builder(
                                                itemCount: 3,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 9, vertical: 2),
                                                itemBuilder: (context, index) {
                                                  return Shimmer.fromColors(
                                                    baseColor: Colors.white38,
                                                    highlightColor: Colors.grey,
                                                    child: Container(
                                                      margin: EdgeInsets.all(6),
                                                      decoration: BoxDecoration(
                                                        color: isDarkMode
                                                            ? AppColor
                                                                .CardDarkColor
                                                            : Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(80),
                                                      ),
                                                      height: 50,
                                                      width: 60,
                                                    ),
                                                  );
                                                }),
                                          )
                                        : CategoryComponent(
                                      categories: getReorderedCategories(),
                                      mediaWidth: mediaWidth,
                                      screenHeight: screenHeight,
                                      isDarkMode: isDarkMode,
                                      onTap: (int index) {
                                        setState(() {
                                          final reorderedCategories = getReorderedCategories();
                                          selectedCategory = "${reorderedCategories[index]?.categoryName}";
                                          selectedCategoryDetail = reorderedCategories[index];
                                          print("selectedCategory :: $selectedCategory :: ${selectedCategoryDetail?.id}");

                                          isProductsLoading = true;
                                          getProductDataDB("${selectedCategoryDetail?.id}");
                                        });
                                      },
                                      primaryColor: primaryColor,
                                      selectedCategory: selectedCategory,
                                    ))
                                : SizedBox(),
                            SizedBox(height: 10,),
                            detailType == "menu"
                                ? Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0, vertical: 8),
                                      child: Text(
                                        "$selectedCategory",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                            color: Colors.black54),
                                      ),
                                    ))
                                : SizedBox(),
                            SizedBox(
                              height: 4,
                            ),
                            detailType == "menu" ||
                                    detailType == "popular food" ||
                                    detailType == "favorites"
                                ? Container(
                                    alignment: Alignment.center,
                                    child: /*isProductAvailable
                                    ?*/
                                        isProductsLoading
                                            ? ProductShimmer()
                                            : menuItems.isNotEmpty
                                                ? Wrap(
                                                    crossAxisAlignment:
                                                        WrapCrossAlignment
                                                            .start,
                                                    alignment:
                                                        WrapAlignment.start,
                                                    runAlignment:
                                                        WrapAlignment.start,
                                                    spacing: 8,
                                                    // Horizontal space between items
                                                    runSpacing: 5,
                                                    // Vertical space between lines
                                                    children:
                                                        menuItems.map((item) {
                                                      //final item = menuItems[index];

                                                      return ProductComponent(
                                                          item: item,
                                                          mediaWidth:
                                                              mediaWidth,
                                                          screenHeight:
                                                              screenHeight,
                                                          showFavIcon:
                                                              detailType ==
                                                                      "featured"
                                                                  ? false
                                                                  : true,
                                                          onAddTap: () {
                                                            if ((item.productSizesList ==
                                                                        "[]" ||
                                                                    item.productSizesList ==
                                                                        null) &&
                                                                (item.addOn ==
                                                                        "[]" ||
                                                                    item.addOn ==
                                                                        null) &&
                                                                item.isBuy1Get1 ==
                                                                    false) {
                                                              print(
                                                                  "${item.isBuy1Get1}");
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
                                                                  arguments:
                                                                      item);
                                                            }
                                                          },
                                                          isDarkMode:
                                                              isDarkMode,
                                                          onMinusTap: () {
                                                            if ((item.productSizesList ==
                                                                        "[]" ||
                                                                    item.productSizesList ==
                                                                        null) &&
                                                                (item.addOn ==
                                                                        "[]" ||
                                                                    item.addOn ==
                                                                        null) &&
                                                                item.isBuy1Get1 ==
                                                                    false) {
                                                              print(
                                                                  "${item.isBuy1Get1}");
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
                                                                  arguments:
                                                                      item);
                                                            }
                                                          },
                                                          onPlusTap: () {
                                                            if ((item.productSizesList ==
                                                                        "[]" ||
                                                                    item.productSizesList ==
                                                                        null) &&
                                                                (item.addOn ==
                                                                        "[]" ||
                                                                    item.addOn ==
                                                                        null) &&
                                                                item.isBuy1Get1 ==
                                                                    false) {
                                                              print(
                                                                  "item.isBuy1Get1 :: ${item.isBuy1Get1}");
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
                                                                  arguments:
                                                                      item);
                                                            }
                                                          },
                                                          onFavoriteTap: () {
                                                            addOrRemoveFavorites(
                                                                item);
                                                          },
                                                          primaryColor:
                                                              primaryColor);
                                                    }).toList())
                                                : isLoading
                                                    ? ShimmerList()
                                                    : NoItemAvailable(
                                                        screenHeight:
                                                            screenHeight))
                                : SizedBox()
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ViewCartContainer(
                cartItemCount: cartItemCount,
                theme: "${widget.data?.theme}",
                controller: _controller,
                primaryColor: primaryColor),

            isMarkFavResponseLoading
                ? Stack(
                    children: [
                      // Block interaction
                      ModalBarrier(
                          dismissible: false, color: Colors.transparent),
                      // Loader indicator
                      Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      ),
                    ],
                  )
                : SizedBox()
          ]);
        }),
      ),
    );
  }

  void _fetchCategoryData() async {
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
      await Provider.of<MainViewModel>(context, listen: false)
          .fetchCategoriesList(
              "/api/v1/app/products/get_products", widget.data?.id);
      //.fetchCategoriesList("/api/v1/products/${widget.data?.id}/customer_products");
      ApiResponse apiResponse =
          Provider.of<MainViewModel>(context, listen: false).response;
      getCategoryList(context, apiResponse);
    }
  }

  Widget getCategoryList(BuildContext context, ApiResponse apiResponse) {
    CategoryListResponse? vendorListResponse =
        apiResponse.data as CategoryListResponse?;
    setState(() {
      isLoading = false;
      isMarkFavResponseLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        setState(() {
          // categories = vendorListResponse!.data!.reversed.toList();
          if (selectedCategoryDetail?.id != null) {
            for (var categoryData in categories) {
              bool categoryExists =
                  selectedCategoryDetail?.id == categoryData?.id;
              if (categoryExists) {
                selectedCategory = categoryData?.categoryName ?? "";
                selectedCategoryDetail = categoryData ?? CategoryData();
              }
            }
          } else {
            selectedCategory = categories[0]?.categoryName ?? "";
            selectedCategoryDetail = categories[0] ?? CategoryData();
          }
          isCategoryLoading = false;

          updateCategoriesDetails(vendorListResponse?.data);
          getProductDataDB("${selectedCategoryDetail?.id}");
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

  void _fetchFeaturedData() async {
    setState(() {
      isLoading = true;
      if (!isMarkFavResponseLoading) {
        isProductsLoading = false;
      }
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
      FeaturedListRequest request = FeaturedListRequest(featured: true);
      await Future.delayed(Duration(milliseconds: 2));
      await Provider.of<MainViewModel>(context, listen: false)
          .fetchFeaturedProductList(
              "/api/v1/vendors/${widget.data?.id}/featured_products", request);
      ApiResponse apiResponse =
          Provider.of<MainViewModel>(context, listen: false).response;
      getFeaturedProductList(context, apiResponse);
    }
  }

  void _setFavorite(int? productId) async {
    setState(() {
      isLoading = true;
      isMarkFavResponseLoading = true;
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
      isMarkFavResponseLoading = true;
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

  void _fetchFavoritesData() async {
    setState(() {
      isLoading = true;
      isProductsLoading = true;
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
      MarkFavoriteRequest request = MarkFavoriteRequest(vendorId: vendorId);
      await Future.delayed(Duration(milliseconds: 2));
      await Provider.of<MainViewModel>(context, listen: false)
          .fetchFavoritesProductList(
              "/api/v1/app/products/get_favourites", request);
      ApiResponse apiResponse =
          Provider.of<MainViewModel>(context, listen: false).response;
      getFavoriteProductList(context, apiResponse);
    }
  }

  Widget getFeaturedProductList(BuildContext context, ApiResponse apiResponse) {
    FeaturedListResponse? featuredListResponse =
        apiResponse.data as FeaturedListResponse?;
    setState(() {
      isLoading = false;
      isMarkFavResponseLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        setState(() {
          menuItems = featuredListResponse!.products!;
          isProductsLoading = false;
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

  Widget getMarkFavoriteResponse(
      BuildContext context, ApiResponse apiResponse) {
    MarkFavoriteResponse? markFavoriteResponse =
        apiResponse.data as MarkFavoriteResponse?;
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        if (detailType == "favorites") {
          _fetchFavoritesData();
        } else if (detailType == "popular food") {
          _fetchFeaturedData();
        } else {
          _fetchCategoryData();
        }
        /*setState(() {
          featuredProduct = featuredListResponse!.products!;
          isFeaturedProductsLoading = false;
        });*/
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
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        if (detailType == "favorites") {
          _fetchFavoritesData();
        } else if (detailType == "popular food") {
          _fetchFeaturedData();
        } else {
          _fetchCategoryData();
        }
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

  Widget getFavoriteProductList(BuildContext context, ApiResponse apiResponse) {
    FavoriteListResponse? favoriteListResponse =
        apiResponse.data as FavoriteListResponse?;
    setState(() {
      isLoading = false;
      isMarkFavResponseLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        setState(() {
          menuItems = favoriteListResponse!.products!;
          isProductsLoading = false;
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

  Future<void> initializeDatabase() async {
    database = await DatabaseHelper().database;

    cartDataDao = database.cartDao;
    favoritesDataDao = database.favoritesDao;
    categoryDataDao = database.categoryDao;
    productsDataDao = database.productDao;

    if (detailType == "menu" || detailType == "categories") {
      setState(() {
        isCategoryLoading = false;
      });
      //_fetchCategoryData();
      getCategoryDataDB();
    }
    getCartData();
  }

  Future<void> getCategoryDataDB() async {
    try {
      List<CategoryDataDB?> localCategoryList = await categoryDataDao
          .getCategoriesAccToVendor(int.parse("${widget.data?.id}"));
      if (localCategoryList.isNotEmpty) {
        setState(() {
          // Filter out null values and cast to non-nullable type
          List<CategoryData> list = [];
          localCategoryList.forEach((item) {
            if (item != null) {
              list.add(CategoryData(
                  vendorId: item.franchiseId,
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
          if (widget.data?.selectedCategoryId != null) {
            for (var categoryData in categories) {
              bool categoryExists =
                  selectedCategoryDetail?.id == categoryData?.id;
              if (categoryExists) {
                selectedCategory = categoryData?.categoryName ?? "";
                selectedCategoryDetail = categoryData ?? CategoryData();
              }
            }
          } else {
            selectedCategory = categories[0]?.categoryName ?? "";
            selectedCategoryDetail = categories[0] ?? CategoryData();
          }
          isCategoryLoading = false;
          if (detailType == "menu") {
            getProductDataDB("${selectedCategoryDetail?.id}");
          }
        });
        _fetchCategoryData();
      } else {
        setState(() {
          isLoading = true;
          isCategoryLoading = false;
        });
        _fetchCategoryData();
      }
    } catch (e) {
      _fetchCategoryData();
    }
  }

  Future<void> updateCategoriesDetails(List<CategoryData>? categoryList) async {
    if (categoryList?.isNotEmpty == true) {
      List<CategoryDataDB?> localCategoryList =
          await categoryDataDao.findAllCategories();
      if (mounted) {
        for (var categoryData in categoryList ?? []) {
          bool categoryExists = localCategoryList
              .any((localData) => localData?.id == categoryData.id);
          CategoryDataDB data = CategoryDataDB(
            menuImgUrl: categoryData.menuImgUrl,
            categoryImage: categoryData.categoryImage,
            status: categoryData.status,
            categoryName: categoryData.categoryName,
            createdAt: categoryData.createdAt,
            id: categoryData.id,
            updatedAt: categoryData.updatedAt,
            franchiseId: categoryData.vendorId,
            vendorId: vendorId,
          );
          if (!categoryExists) {
            categoryDataDao.insertCategory(data);
          } else {
            categoryDataDao.updateCategory(data);
          }
          updateProductsDetails(categoryData.products);
        }
      }
      for (var localData in localCategoryList) {
        bool? productInNewList = categoryList
            ?.any((categoryData) => categoryData.id == localData?.id);
        if (!(productInNewList == true)) {
          categoryDataDao.deleteCategory(localData ?? CategoryDataDB());
        }
      }
    }

    List<CategoryDataDB?> updatedCategories = await categoryDataDao
        .getCategoriesAccToVendor(int.parse("${widget.data?.id}"));
    if (updatedCategories.isNotEmpty) {
      setState(() {
        // Filter out null values and cast to non-nullable type
        List<CategoryData> list = [];
        updatedCategories.forEach((item) {
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
        if (widget.data?.selectedCategoryId != null) {
          for (var categoryData in categories) {
            bool categoryExists =
                selectedCategoryDetail?.id == categoryData?.id;
            if (categoryExists) {
              selectedCategory = categoryData?.categoryName ?? "";
              selectedCategoryDetail = categoryData ?? CategoryData();
            }
          }
        } else {
          selectedCategory = categories[0]?.categoryName ?? "";
          selectedCategoryDetail = categories[0] ?? CategoryData();
        }
        isCategoryLoading = false;
      });
    }
  }

  Future<void> getProductDataDB(String categoryId) async {
    List<ProductData?> localProductList =
        await productsDataDao.getProductsAccToCategory(int.parse(categoryId));
    if (localProductList.isNotEmpty) {
      setState(() {
        isProductAvailable = true;
        menuItems = [];
        menuItems.addAll(
            localProductList.where((item) => item != null).cast<ProductData>());
        getCartData();
        updateQuantity();
        isProductsLoading = false;
      });
    } else {
      setState(() {
        isProductsLoading = false;
        isProductAvailable = false;
        menuItems = [];
      });
    }
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
          } else {
            productsDataDao.updateProduct(productsData);
          }
        }
      }
      List<ProductData?> localProductListInCategory = await productsDataDao
          .getProductsAccToCategory(productList?[0].productCategoryId ?? 0);
      for (var localData in localProductListInCategory) {
        bool? productInNewList = productList
            ?.any((productsData) => productsData.id == localData?.id);
        if (!(productInNewList == true)) {
          productsDataDao.deleteProduct(localData ?? ProductData(quantity: 0));
        }
      }
    }
    getProductDataDB("${selectedCategoryDetail?.id}");
  }

  Future<void> updateQuantity() async {
    if (cartDBList.isNotEmpty) {
      menuItems.forEach((item) {
        cartDBList.forEach((dbItem) {
          if (item.id == dbItem.id &&
              item.productCategoryId == dbItem.productCategoryId &&
              vendorId == dbItem.vendorId) {
            setState(() {
              item.quantity = dbItem.quantity;
              List<ProductSize> dbProductSizes = dbItem.getProductSizeList();
              List<ProductSize> productSizes = item.getProductSizeList();
              dbProductSizes.forEach((dbSize) {
                if (dbSize.quantity > 0) {
                  productSizes.forEach((size) {
                    if (dbSize.size == size.size) {
                      size.quantity = dbSize.quantity;
                    }
                  });
                }
              });
              item.productSizesList = jsonEncode(productSizes);
            });
          }
        });
      });
    }
    getCartItemCountDB();
  }

  Future<void> getCartData() async {
    List<ProductDataDB?> productsList = await cartDataDao.findAllCartProducts();
    //print("getCartData");
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

  Future<void> getCartItemCountDB() async {
    List<ProductDataDB?> productsList = await cartDataDao.findAllCartProducts();
    if (mounted) {
      int totalCount = 0;
      if (productsList.isNotEmpty &&
          productsList.length > 0 &&
          productsList != null) {
        // Use forEach instead of map to perform an action
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
        vendorName: widget.data?.businessName,
        theme: widget.data?.theme,
        addedToCartAt: "${DateFormat('yyyy-MM-dd').format(DateTime.now())}",
        addOnIdsList: '',
        productSizesList: item.productSizesList);
    print(
        "vendorId ${item.vendorId}  :: productCategoryId  ${item.productCategoryId}  :: id   ${item.id}");
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
    data.vendorName = widget.data?.businessName;
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
        productSizesList: item.productSizesList);
    if (item.quantity == 0) {
      cartDataDao.deleteCartProduct(data);
    } else {
      cartDataDao.updateCartProduct(data);
    }
    getCartItemCountDB();
  }

  Future<void> addOrRemoveFavorites(ProductData item) async {
    print("item.favorite ${item.favorite}");
    print("item.id ${item.id}");
    if (item.favorite == false) {
      _setFavorite(item.id);
    } else {
      _removeFavorite(item.id);
    }

    /*  FavoritesDataDb data = FavoritesDataDb(
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
        vendorName: widget.data?.businessName,
        theme: widget.data?.theme,
        addedToFavoritesAt: "${DateFormat('yyyy-MM-dd').format(DateTime.now())}",
        addOnIdsList: '',
        productSizesList: item.productSizesList);
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

  List<CategoryData?> getReorderedCategories() {
    if (selectedCategory == null) return categories;

    List<CategoryData?> reordered = List.from(categories);
    int selectedIndex = reordered.indexWhere((cat) => cat?.categoryName == selectedCategory);

    if (selectedIndex != -1) {
      final selectedItem = reordered.removeAt(selectedIndex);
      reordered.insert(0, selectedItem);
    }

    return reordered;
  }


  void setThemeColor() {
    if (widget.data?.theme == "blue") {
      setState(() {
        primaryColor = Colors.blue.shade900;
        secondaryColor = Colors.blue[100];
        lightColor = Colors.blue[50];
      });
    }
  }
}
