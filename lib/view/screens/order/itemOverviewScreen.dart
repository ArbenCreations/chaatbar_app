import 'package:TheChaatBar/model/response/createOrderResponse.dart';
import 'package:TheChaatBar/model/response/productListResponse.dart';
import 'package:TheChaatBar/theme/CustomAppColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/Util.dart';

class ItemOverviewScreen extends StatefulWidget {
  final CreateOrderResponse? data; // Define the 'data' parameter here

  ItemOverviewScreen({Key? key, this.data}) : super(key: key);

  @override
  _ItemOverviewScreenState createState() => _ItemOverviewScreenState();
}

class _ItemOverviewScreenState extends State<ItemOverviewScreen>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  bool isInternetConnected = true;
  bool isDarkMode = false;
  bool isBillingVisible = false;
  late double mediaWidth;
  late double screenHeight;
  bool isDataLoading = false;
  final TextEditingController documentNumberController =
      TextEditingController();
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    mediaWidth = MediaQuery.of(context).size.width;
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: screenHeight * 0.35,
                  child: Image(
                    alignment: Alignment.topCenter,
                    width: mediaWidth,
                    height: screenHeight * 0.35,
                    image: AssetImage("assets/appLogo.png"),
                    fit: BoxFit.cover,
                  ),
                  alignment: AlignmentDirectional.center,
                ),
                Column(
                  children: [
                    SizedBox(height: screenHeight*0.22,),
                    Container(
                      height: screenHeight,
                      child: SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: screenHeight -
                                MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: IntrinsicHeight(
                            child: Column(
                              children: [
                                Flexible(
                                  child: Container(
                                    child: Card(
                              elevation: 20,
                              margin: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(40),
                                      topRight: Radius.circular(40))),

                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 5,),
                                            /*Row(
                                              children: [
                                                GestureDetector(
                                                    onTap: () {
                                                      Navigator.pushNamed(context, "/BottomNavigation");
                                                    },
                                                    child: Icon(Icons.arrow_back)),
                                                SizedBox(
                                                  width: 14,
                                                ),
                                                Text("Order Details",
                                                    style: TextStyle(
                                                        fontSize: 18, fontWeight: FontWeight.bold)),
                                              ],
                                            ),*/
                                            Center(
                                              child: Text("Order Details",
                                                  style: TextStyle(
                                                      fontSize: 22, fontWeight: FontWeight.bold)),
                                            ),
                                            SizedBox(height: 5),
                                            Container(
                                              height: screenHeight*0.25,
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: widget.data?.order?.orderItems?.length,
                                                itemBuilder: (context, index) {
                                                  var item = widget.data?.order?.orderItems?[index];
                                                  return _buildOrderItem(item ?? OrderItem());
                                                },
                                              ),
                                            ),
                                            SizedBox(height: 40),
                                            Padding(
                                              padding: const EdgeInsets.all(6.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text("Pickup Time",
                                                      style:
                                                      TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                                  SizedBox(height: 2),
                                                  Text(
                                                      convertDateTimeFormat(
                                                          "${widget.data?.order?.pickupTime}"),
                                                      style: TextStyle(fontSize: 12)),

                                                  SizedBox(height: 8),

                                                  Text("Order Notes",
                                                      style:
                                                      TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                                  SizedBox(height: 2),
                                                  Text("${widget.data?.order?.orderNotes}",
                                                      style: TextStyle(fontSize: 12)),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Card(
                                              margin: EdgeInsets.zero,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(6)),
                                              child: Container(
                                                  padding:
                                                      EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                                  child: Column(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            isBillingVisible = !isBillingVisible;
                                                          });
                                                        },
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text("Billing Details",
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.bold)),
                                                          /*  Icon(isBillingVisible
                                                                ? Icons.arrow_drop_up_rounded
                                                                : Icons.arrow_drop_down_rounded)*/
                                                          ],
                                                        ),
                                                      ),
                                                      Column(
                                                              children: [
                                                                SizedBox(height: 2),
                                                                _buildBillingDetail("Subtotal",
                                                                    "${widget.data?.order?.totalAmount}"),
                                                                _buildBillingDetail("Delivery Charge",
                                                                    "${widget.data?.order?.deliveryCharges}"),
                                                                _buildBillingDetail("Taxes",
                                                                    "${widget.data?.order?.gst?.toStringAsFixed(1) ?? 0.0}"),
                                                                _buildBillingDetail("Tip",
                                                                    "${widget.data?.order?.tip?.toStringAsFixed(1)}"),
                                                                _buildBillingDetail("Discount",
                                                                    "${widget.data?.order?.discountAmount}"),
                                                                SizedBox(height: 2),
                                                                _buildBillingDetail("Amount Paid",
                                                                    "${widget.data?.order?.payableAmount}",
                                                                    isTotal: true),
                                                              ],
                                                            ),
                                                    ],
                                                  )),
                                            ),
                                            SizedBox(height: 18),
                                            Center(
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.pushNamed(context, "/BottomNavigation");
                                                },
                                                child: Card(
                                                    color: AppColor.Primary,
                                                    child: Container(
                                                        padding: EdgeInsets.symmetric(
                                                            horizontal: 25, vertical: 12),
                                                        child: Text(
                                                          "Go to Menu",
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.white,
                                                              fontSize: 15),
                                                        ))),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillingDetail(String title, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: isTotal ? 13 : 11,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text("\$$value",
              style: TextStyle(
                  fontSize: isTotal ? 13 : 11,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildOrderItem(OrderItem data) {
    ProductData item = data.product ?? ProductData(quantity: 0);
    return Container(
        width: mediaWidth * 0.82,
        padding: EdgeInsets.only(bottom: 4),
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 0.06, color: Colors.black87))),
        child: Padding(
          padding: const EdgeInsets.only(right: 0, left: 0),
          child: Container(
            width: mediaWidth * 0.85,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        capitalizeFirstLetter(
                          "${item.title}",
                        ),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      item.productSizesList == "[]"
                          ? Text(' (\$${(item.price)})',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[700]))
                          : SizedBox(),
                    ],
                  ),
                  Text(
                    "x ${data.quantity.toString()}",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColor.Primary),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}
