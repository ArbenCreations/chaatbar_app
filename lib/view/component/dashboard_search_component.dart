import 'package:flutter/material.dart';

import '../../theme/CustomAppColor.dart';

class DashboardSearchComponent extends StatelessWidget {
  final TextEditingController queryController;
  final double mediaWidth;
  final double screenHeight;
  final Color primaryColor;
  final Function() onTap;
  final int hintIndex;

  const DashboardSearchComponent({
    Key? key,
    required this.queryController,
    required this.mediaWidth,
    required this.screenHeight,
    required this.onTap,
    required this.hintIndex,
    required this.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: mediaWidth * 0.95,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 0.5, color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.01),
                offset: Offset(0, 1),
                blurRadius: 10,
                spreadRadius: 1.0,
              ),
            ],
          ),
          height: 45,
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.only(left: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.search_outlined,
                color: AppColor.Primary,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                "Search your favourite food",
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// Helper method to build the card
}
