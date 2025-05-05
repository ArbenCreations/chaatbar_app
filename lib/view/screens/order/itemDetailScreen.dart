import 'package:TheChaatBar/model/database/ChaatBarDatabase.dart';
import 'package:flutter/material.dart';

import '../../../model/database/DatabaseHelper.dart';
import '../../../model/response/createOrderResponse.dart';
import '../../../theme/CustomAppColor.dart';
import '../../../utils/Helper.dart';
import '../../../utils/Util.dart';

class ItemDetailScreen extends StatefulWidget {
  final OrderDetails order;

  ItemDetailScreen({Key? key, required this.order}) : super(key: key);

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  bool isLoading = false;
  bool isInternetConnected = true;
  bool isDarkMode = false;
  late double mediaWidth;
  late double screenHeight;
  double hstAmt = 0;
  double gstAmt = 0;
  double pstAmt = 0;
  bool mExpanded = false;
  OrderDetails order = OrderDetails();
  List<OrderItem> orderItems = [];
  static const maxDuration = Duration(seconds: 2);
  bool isDataLoading = false;
  late ChaatBarDatabase database;
  final TextEditingController documentNumberController =
      TextEditingController();

  String? theme = "";
  Color primaryColor = AppColor.Secondary;
  Color? secondaryColor = Colors.red[100];
  Color? lightColor = Colors.red[50];

  @override
  void initState() {
    super.initState();
    initializeDatabase();
    setState(() {
      order = widget.order;
      orderItems = widget.order.orderItems ?? [];
      hstAmt = ((double.parse("${widget.order.hst ?? 0}") *
              double.parse("${widget.order.totalAmount}")) /
          100);
      gstAmt = (double.parse("${widget.order.gst ?? 0}") *
              double.parse("${widget.order.totalAmount}")) /
          100;
      pstAmt = (double.parse("${widget.order.pst ?? 0}") *
              double.parse("${widget.order.totalAmount}")) /
          100;
    });

    isDataLoading = true;
  }

  Future<void> initializeDatabase() async {
    database = await DatabaseHelper().database;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    mediaWidth = MediaQuery.of(context).size.width;
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "#${order.orderNo}",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColor.Primary,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
            )),
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return Stack(
          children: [
            Stack(
              children: [
                SafeArea(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: viewportConstraints.maxHeight,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: AppColor.Primary,
                            width: mediaWidth,
                            padding: EdgeInsets.only(left: 12, bottom: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Order Placed",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white),
                                    ),
                                    SizedBox(
                                      height: 1,
                                    ),
                                    Text(
                                      ": ${convertDateFormat("${order.createdAt}")} At ${convertTime("${order.createdAt}")}",
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text(
                                      "Pickup Time : ",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white),
                                    ),
                                    Text(
                                      "${convertDateFormat("${order.pickupDate}")} At ${convertTime("${order.pickupTime}")}",
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Order Items",
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                    )),
                                Container(
                                  color: isDarkMode
                                      ? Colors.black38
                                      : Colors.grey[100],
                                  margin: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 2),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 12),
                                    child: Wrap(
                                        spacing: 10,
                                        // Horizontal space between items
                                        runSpacing: 5,
                                        // Vertical space between lines
                                        children: orderItems.map((item) {
                                          return _buildOrderItem(item);
                                        }).toList()),
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text("Order Status",
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                    )),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 2),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 14),
                                  color: isDarkMode
                                      ? Colors.black38
                                      : Colors.grey[100],
                                  child: Column(
                                    children: [
                                      OrderStep(
                                        icon: Icons.shopping_cart,
                                        title: 'Order Placed',
                                        description:
                                            '${convertDateTimeFormat("${order.createdAt}")}',
                                        isActive: true,
                                        iconColor: Colors.orange,
                                      ),
                                      order.status == "accepted" ||
                                              order.status == "completed" ||
                                              order.status == "new_order"
                                          ? OrderStep(
                                              icon: Icons.receipt_long,
                                              title: 'Order Confirmed',
                                              description: order.status ==
                                                      "accepted"
                                                  ? 'Order was confirmed ${convertDateTimeFormat("${order.updatedAt}")}'
                                                  : "Waiting for restaurant to confirm the order",
                                              isActive:
                                                  order.status == "new_order"
                                                      ? false
                                                      : true,
                                              iconColor: Colors.orange,
                                            )
                                          : order.status == "rejected"
                                              ? OrderStep(
                                                  icon: Icons.cancel_sharp,
                                                  title: 'Order Rejected',
                                                  description:
                                                      'Order was rejected by restaurant ${convertDateTimeFormat("${order.updatedAt}")}',
                                                  isActive: true,
                                                  iconColor: Colors.red,
                                                )
                                              : SizedBox(),
                                      order.status == "completed" ||
                                              order.status == "accepted"
                                          ? OrderStep(
                                              icon: Icons.check_circle,
                                              title: 'Order Completed',
                                              description: order.status ==
                                                      "accepted"
                                                  ? order.preparationTime ==
                                                          null
                                                      ? "Preparing Order"
                                                      : "Your order will be ready by ${order.preparationTime}"
                                                  : 'Order was completed at ${convertDateTimeFormat("${order.updatedAt}")}',
                                              isActive:
                                                  order.status == "accepted"
                                                      ? false
                                                      : true,
                                              iconColor: Colors.green,
                                            )
                                          : SizedBox(),

                                      order.status == "pending_order"
                                          ? OrderStep(
                                              icon: Icons.watch_later_sharp,
                                              title: 'Upcoming Order',
                                              description:
                                                  'Order placed for ${convertDateTimeFormat("${order.pickupTime}")}',
                                              isActive: false,
                                              iconColor: Colors.green,
                                            )
                                          : SizedBox(),
                                      // Add more steps as needed
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Text("Order Details",
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                    )),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 2),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 2),
                                  color: isDarkMode
                                      ? Colors.black38
                                      : Colors.grey[100],
                                  child: Column(
                                    children: [
                                      _buildDetailCard('Subtotal: ',
                                          order.payableAmount, false),
                                      _buildDetailCard('Discount: ',
                                          order.discountAmount, false),
                                      _buildDetailCard(
                                          'Gst (${order.gst ?? 0}%): ',
                                          "${gstAmt.toStringAsFixed(1)}",
                                          false),
                                      _buildDetailCard(
                                          'Pst (${order.pst ?? 0}%): ',
                                          "${pstAmt.toStringAsFixed(1)}",
                                          false),
                                      _buildDetailCard(
                                          'Hst (${order.hst ?? 0}%): ',
                                          "${hstAmt.toStringAsFixed(1)}",
                                          false),
                                      _buildDetailCard('Grand Total: ',
                                          order.totalAmount, true),
                                      _buildDetailCard('Transaction Id: ',
                                          order.transactionId, true),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            /*isLoading
                  ? Stack(
                      children: [
                        // Block interaction
                        ModalBarrier(
                          dismissible: false,
                        ),
                        // Loader indicator
                        Center(
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    )
                  : SizedBox(),*/
          ],
        );
      }),
    );
  }

  Widget _buildDetailCard(String? title, String? detail, bool isMain) {
    return title == null || detail == null
        ? SizedBox()
        : Container(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            padding: EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.grey, width: 0.1))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$title',
                  style: TextStyle(
                      fontSize: isMain ? 15 : 13,
                      color: isDarkMode ? Colors.white60 : Colors.black87),
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      WidgetSpan(
                        child: Transform.translate(
                          offset: const Offset(0, -4),
                          // Moves the dollar sign slightly upward
                          child: Text(
                            "\$",
                            style: TextStyle(
                              fontSize: 10,
                              // Smaller font size for the dollar sign
                              color:
                                  AppColor.Primary, // Color of the dollar sign
                            ),
                          ),
                        ),
                      ),
                      TextSpan(
                        text: "${detail}",
                        // Price value
                        style: TextStyle(
                          fontSize: isMain ? 15 : 13,
                          // Regular font size for price
                          fontWeight: FontWeight.bold,
                          color: AppColor.Primary, // Color for price
                        ),
                      ),
                    ],
                  ),
                ),
                /* Text(
            '\$$detail',
            style: TextStyle(
                fontSize:isMain ? 15 : 13,
                color: isDarkMode ? Colors.white60 : Colors.black87),
          ),*/
              ],
            ),
          );
  }

  Widget _buildOrderItem(OrderItem item) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                "${item.product?.title} ",
                style: TextStyle(),
              ),
              Text(
                "x ${item.quantity}",
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
            ],
          ),
          Text.rich(
            TextSpan(
              children: [
                WidgetSpan(
                  child: Transform.translate(
                    offset: const Offset(0, -4),
                    // Moves the dollar sign slightly upward
                    child: Text(
                      "\$",
                      style: TextStyle(
                        fontSize: 9,
                        // Smaller font size for the dollar sign
                        color: AppColor.Primary, // Color of the dollar sign
                      ),
                    ),
                  ),
                ),
                TextSpan(
                  text: "${item.product?.price}",
                  // Price value
                  style: TextStyle(
                    fontSize: 14,
                    // Regular font size for price
                    fontWeight: FontWeight.bold,
                    color: AppColor.Primary, // Color for price
                  ),
                ),
              ],
            ),
          )
        ],
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
}

class OrderStep extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isActive;
  final Color iconColor;

  OrderStep({
    required this.icon,
    required this.title,
    required this.description,
    required this.isActive,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.08,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              title == "Order Placed"
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    )
                  : Container(
                      width: 2,
                      height: MediaQuery.of(context).size.height * 0.016,
                      color: Colors.grey.shade300,
                    ),
              Icon(
                Icons.fiber_manual_record,
                color: isActive ? iconColor : Colors.grey,
                size: 12,
              ),
              title == "Order Completed" || title == "Order Rejected"
                  ? SizedBox()
                  : title == "Upcoming Order"
                      ? Container(
                          width: 2,
                          height: 20,
                          color: Colors.grey.shade300,
                        )
                      : Expanded(
                          child: Container(
                            width: 2,
                            //height: MediaQuery.of(context).size.height*0.067,
                            color: Colors.grey.shade300,
                          ),
                        ),
            ],
          ),
          SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: isActive
                ? iconColor.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
            child: Icon(icon, color: isActive ? iconColor : Colors.grey),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isActive ? iconColor : Colors.grey,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
