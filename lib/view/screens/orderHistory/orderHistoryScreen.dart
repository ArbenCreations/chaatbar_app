import 'package:TheChaatBar/model/request/getHistoryRequest.dart';
import 'package:TheChaatBar/model/response/bannerListResponse.dart';
import 'package:TheChaatBar/model/response/createOrderResponse.dart';
import 'package:TheChaatBar/model/response/getHistoryResponse.dart';
import 'package:TheChaatBar/model/response/vendorListResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/apiResponse.dart';
import '../../../model/viewModel/mainViewModel.dart';
import '../../../theme/CustomAppColor.dart';
import '../../../utils/Util.dart';
import '../../component/ShimmerList.dart';
import '../../component/connectivity_service.dart';
import '../../component/session_expired_dialog.dart';

class OrderHistoryScreen extends StatefulWidget {
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen>
    with SingleTickerProviderStateMixin {
  String token = "";
  late double mediaWidth;
  late double screenHeight;
  late bool isActive;
  bool isInternetConnected = true;
  late bool isDarkMode;
  bool isLoading = true;
  var _connectivityService = ConnectivityService();
  static const maxDuration = Duration(seconds: 2);
  List<VendorData> vendorList = [];
  List<BannerData> bannerList = [];
  List<OrderDetails> activeOrders = [];
  List<OrderDetails> upcomingOrders = [];
  final TextEditingController queryController = TextEditingController();
  late TabController _tabController;

  final _scrollController = ScrollController();
  Future<void>? _fetchDataFuture;
  bool _isLoadingMore = false;
  int _currentPage = 1;

  List<OrderDetails> historyOrders = [];
  String selectedValue = 'Past';
  String? theme = "";
  Color primaryColor = AppColor.Primary;
  Color? secondaryColor = Colors.red[100];
  Color? lightColor = Colors.red[50];

  int activeType = 0;
  int upcomingType = 5;
  int pastType = 2;
  int selectedOrderType = 2;
  int? _totalRows = 0;

  @override
  void initState() {
    super.initState();
    historyOrders.clear();
    setState(() {
      isActive = true;
    });
    _tabController = TabController(length: 2, vsync: this);

    _scrollController.addListener(_LoadMore);
    _fetchDataFuture = _fetchData(_currentPage, false, selectedOrderType);
  }

  void _LoadMore() async {
    final currentList =
        selectedOrderType == activeType ? activeOrders : upcomingOrders;

    if (!_isLoadingMore &&
        _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        currentList.length < _totalRows!) {
      setState(() {
        _isLoadingMore = true;
      });

      _currentPage++;
      await _fetchData(_currentPage, true, selectedOrderType);

      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    mediaWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        Navigator.pushReplacementNamed(context, "/BottomNavigation");
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColor.BackgroundColor,
            centerTitle: false,
            title: Text(
              "Orders",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: isDarkMode ? Colors.white : AppColor.TextColor),
            ),
            leadingWidth: 0,
            leading: SizedBox(),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 10.0),
                child: IntrinsicWidth(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.grey.shade100],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 5),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedValue,
                        dropdownColor: Colors.white,
                        isExpanded: true,
                        icon: Icon(Icons.keyboard_arrow_down_rounded,
                            color: Colors.black87, size: 24),
                        onChanged: (String? newValue) {
                          setState(() {
                            if (newValue == "Active") {
                              selectedOrderType = activeType;
                            } else if (newValue == "Upcoming") {
                              selectedOrderType = upcomingType;
                            } else {
                              selectedOrderType = pastType;
                            }
                            selectedValue = newValue!;
                            runApi();
                          });
                        },
                        items: <String>['Past', 'Active', 'Upcoming']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              children: [
                                Icon(
                                  getIcon(value),
                                  size: 20,
                                  color: Colors.blueGrey,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  value,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              // Scrollable Content Below
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Container(
                        height: screenHeight * 0.86,
                        child: LayoutBuilder(
                          builder: (BuildContext context,
                              BoxConstraints viewportConstraints) {
                            return Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: _buildSelectedWidget(),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Widget _buildSelectedWidget() {
    switch (selectedValue) {
      case 'Past':
        return _buildHistory();
      case 'Active':
        return _buildActive();
      case 'Upcoming':
        return _buildUpcoming();
      default:
        return Container();
    }
  }

  runApi() {
    setState(() {
      isLoading = true;
    });
    setState(() {
      activeOrders.clear();
      historyOrders.clear();
      upcomingOrders.clear();
    });
    _currentPage = 1;
    _scrollController.addListener(_LoadMore);
    _fetchDataFuture = _fetchData(_currentPage, false, selectedOrderType);
  }

  Widget _buildHistory() {
    return Container(
      height: screenHeight * 0.85,
      child: isInternetConnected && !isLoading
          ? checkListEmpty(historyOrders)
              ? FutureBuilder(
                  future: _fetchDataFuture,
                  builder:
                      (BuildContext context, AsyncSnapshot<void> snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error loading data'));
                    } else {
                      // Group transactions by date
                      Map<String, List<OrderDetails>> groupedOrders =
                          groupOrdersByDate(historyOrders);
                      List<String> dates = groupedOrders.keys.toList();

                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: dates.length + (_isLoadingMore ? 1 : 0),
                        itemBuilder: (BuildContext context, int index) {
                          if (index == dates.length) {
                            return Center(
                                child: CircularProgressIndicator(
                              color:
                                  isDarkMode ? Colors.white : AppColor.Primary,
                            ));
                          }
                          String date = dates[index];
                          List<OrderDetails> ordersForDate =
                              groupedOrders[date]!;

                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 3.0),
                                  child: Text(
                                    date,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12),
                                  ),
                                ),
                                ...ordersForDate.asMap().entries.map((order) {
                                  return OrderCard(
                                    order: order.value,
                                  );
                                }).toList(),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 100,
                        child: SvgPicture.asset(
                          "assets/emptyList.svg",
                        ),
                      ),
                      Text(
                        "No Past Orders",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                )
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              child: ShimmerList(),
            ),
    );
  }

  Widget _buildActive() {
    return Container(
      height: screenHeight,
      margin: EdgeInsets.only(top: 0),
      child: isInternetConnected && !isLoading
          ? checkListEmpty(activeOrders)
              ? FutureBuilder(
                  future: _fetchDataFuture,
                  builder:
                      (BuildContext context, AsyncSnapshot<void> snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error loading data'));
                    } else {
                      // Group transactions by date
                      Map<String, List<OrderDetails>> groupedOrders =
                          groupOrdersByDate(activeOrders);
                      List<String> dates = groupedOrders.keys.toList();

                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: dates.length + (_isLoadingMore ? 1 : 0),
                        itemBuilder: (BuildContext context, int index) {
                          if (index == dates.length) {
                            return Center(
                                child: CircularProgressIndicator(
                              color:
                                  isDarkMode ? Colors.white : AppColor.Primary,
                            ));
                          }
                          String date = dates[index];
                          List<OrderDetails> ordersForDate =
                              groupedOrders[date]!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 8.0),
                                child: Text(
                                  date,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11,
                                      color: Colors.grey[600]),
                                ),
                              ),
                              ...ordersForDate.asMap().entries.map((order) {
                                return OrderCard(
                                  order: order.value,
                                );
                              }).toList(),
                            ],
                          );
                        },
                      );
                    }
                  },
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 100,
                        child: SvgPicture.asset(
                          "assets/emptyList.svg",
                        ),
                      ),
                      Text(
                        "No Active Orders",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                )
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 18),
              child: ShimmerList(),
            ),
    );
  }

  Widget _buildUpcoming() {
    return Container(
      height: screenHeight,
      margin: EdgeInsets.only(top: 4),
      child: isInternetConnected && !isLoading
          ? checkListEmpty(upcomingOrders)
              ? FutureBuilder(
                  future: _fetchDataFuture,
                  builder:
                      (BuildContext context, AsyncSnapshot<void> snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error loading data'));
                    } else {
                      // Group transactions by date
                      Map<String, List<OrderDetails>> groupedOrders =
                          groupOrdersByDate(upcomingOrders);
                      List<String> dates = groupedOrders.keys.toList();

                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: dates.length + (_isLoadingMore ? 1 : 0),
                        itemBuilder: (BuildContext context, int index) {
                          if (index == dates.length) {
                            return Center(
                                child: CircularProgressIndicator(
                              color:
                                  isDarkMode ? Colors.white : AppColor.Primary,
                            ));
                          }
                          String date = dates[index];
                          List<OrderDetails> ordersForDate =
                              groupedOrders[date]!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 8.0),
                                child: Text(
                                  date,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[600],
                                      fontSize: 11),
                                ),
                              ),
                              ...ordersForDate.asMap().entries.map((order) {
                                return OrderCard(
                                  order: order.value,
                                );
                              }).toList(),
                            ],
                          );
                        },
                      );
                    }
                  },
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 100,
                        child: SvgPicture.asset(
                          "assets/emptyList.svg",
                        ),
                      ),
                      Text(
                        "No Upcoming Orders",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                )
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 18),
              child: ShimmerList(),
            ),
    );
    ;
  }

  bool checkListEmpty(List<OrderDetails> list) {
    bool isListEmpty = false;

    isListEmpty = list.isNotEmpty;

    return isListEmpty;
  }

  Map<String, List<OrderDetails>> groupOrdersByDate(List<OrderDetails> orders) {
    Map<String, List<OrderDetails>> groupedData = {};

    for (var order in orders) {
      String date = convertDateFormat("${order.createdAt}");
      if (!groupedData.containsKey(date)) {
        groupedData[date] = [];
      }
      groupedData[date]!.add(order);
    }
    return groupedData;
  }

  Future<void> _fetchData(int pageKey, bool isScroll, int selectionType) async {
    try {
      setState(() {
        //isLoading = true;
      });
      bool isConnected = await _connectivityService.isConnected();
      if (!isConnected) {
        setState(() {
          isLoading = false;
          isInternetConnected = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('${Languages.of(context)?.labelNoInternetConnection}'),
              duration: maxDuration,
            ),
          );
        });
      } else {
        GetHistoryRequest request = GetHistoryRequest(
            pageNumber: pageKey, pageSize: 10, status: selectedOrderType);
        await Provider.of<MainViewModel>(context, listen: false)
            .getHistoryData("/api/v1/app/orders/cust_order_history", request);
        ApiResponse apiResponse =
            Provider.of<MainViewModel>(context, listen: false).response;
        await getHistoryData(context, apiResponse, pageKey, isScroll);
      }
    } catch (error) {
      print("No Past Orders: $error");
    }
  }

  Future<void> getHistoryData(BuildContext context, ApiResponse apiResponse,
      int pageKey, bool isScroll) async {
    GetHistoryResponse? getHistoryResponse =
        apiResponse.data as GetHistoryResponse?;
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return;
      case Status.COMPLETED:
        final newItems = getHistoryResponse?.orders ?? [];
        _totalRows = getHistoryResponse?.totalRows ?? 0;
        setState(() {
          print(
              "getHistoryResponse?.orders :: ${getHistoryResponse?.orders?.length}");
          if (selectedOrderType == pastType) {
            if (pageKey == 1) {
              historyOrders.clear();
            }
            historyOrders.addAll(newItems);
          } else if (selectedOrderType == activeType) {
            if (pageKey == 1) {
              activeOrders.clear();
            }
            activeOrders.addAll(newItems);
          } else if (selectedOrderType == upcomingType) {
            if (pageKey == 1) {
              upcomingOrders.clear();
            }
            upcomingOrders.addAll(newItems);
          } else {
            if (pageKey == 1) {
              historyOrders.clear();
            }
            historyOrders.addAll(newItems);
          }
          print("historyOrders.length :: ${historyOrders.length}");
        });
        return;
      case Status.ERROR:
        if (nonCapitalizeString("${apiResponse.message}") ==
            nonCapitalizeString(
                "${Languages.of(context)?.labelInvalidAccessToken}")) {
          SessionExpiredDialog.showDialogBox(context: context);
        }
        return;
      case Status.INITIAL:
      default:
        return;
    }
  }

  IconData? getIcon(value) {
    if (value == "Past")
      return Icons.history;
    else if (value == "Active")
      return Icons.ac_unit_rounded;
    else
      return Icons.upcoming_outlined;
  }
}

class OrderCard extends StatelessWidget {
  final OrderDetails order;

  const OrderCard({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/ItemDetailScreen', arguments: order);
        },
        child: Stack(
          children: [
            Card(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 5,
              // Increased elevation for a more modern look
              shadowColor: Colors.black.withOpacity(0.1),
              // Subtle shadow for better depth
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                // Increased padding for spacing
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 12),
                              Text("${order.orderNo}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      // Slightly larger for emphasis
                                      color: Colors.black)),
                              SizedBox(height: 2),
                              Text(
                                '${convertDateTimeFormat("${order.createdAt}")}',
                                style: TextStyle(
                                    fontSize: 11, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.store_mall_directory,
                              color: AppColor.Secondary,
                              size: 14,
                            ),
                            SizedBox(width: 2),
                            Text(
                              capitalizeFirstLetter("${order.locality}"),
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 9),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    order.rejectNote != null
                        ? Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              "${order.rejectNote}",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                  fontStyle: FontStyle.italic),
                            ),
                          )
                        : SizedBox(),
                    SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: order.orderItems?.isNotEmpty == true
                                  ? order.orderItems!.take(3).map((item) {
                                      return Text(
                                        "${item.quantity} x ${capitalizeFirstLetter("${item.product?.title}")}",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      );
                                    }).toList()
                                  : [SizedBox()],
                            ),
                            if (order.orderItems!.length > 3)
                              Text(
                                "...",
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey[600]),
                              ),
                          ],
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              '\$${order.payableAmount}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColor.Primary,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 12,
              child: CustomPaint(
                painter: TagPainter(text: '${order.status}'),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Text(
                    order.status == "pending_order"
                        ? "Upcoming Order"
                        : capitalizeFirstLetter(
                            "${order.status}".replaceAll('_', ' '),
                          ),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

class TagPainter extends CustomPainter {
  final String text;

  const TagPainter({required this.text});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = text == "completed"
          ? Colors.green
          : text == "accepted"
              ? Colors.blue
              : text == "new_order"
                  ? Colors.blue
                  : text == "pending_order" || text == "upcoming order"
                      ? Colors.purple
                      : Colors.red;

    const borderRadius = 4.0;

    final roundedRect = RRect.fromRectAndCorners(
      Rect.fromLTWH(0, 0, size.width, size.height),
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
      bottomRight: Radius.circular(borderRadius),
      bottomLeft: Radius.zero, // Keep the bottom-left corner sharp
    );

    canvas.drawRRect(roundedRect, paint);

    final path = Path();
    path.moveTo(13, size.height);
    path.lineTo(13, size.height + 8);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
