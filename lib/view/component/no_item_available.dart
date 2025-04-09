import 'package:flutter/material.dart';

class NoItemAvailable extends StatelessWidget {
  final double screenHeight;

  const NoItemAvailable({
    Key? key,
    required this.screenHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: screenHeight * 0.55,
      child: Center(
        child: Text(
          "No item available.",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
    );
  }
}
