import 'package:flutter/material.dart';

class CustomButtonComponent extends StatelessWidget {
  late bool isClickable = true;
  late final String text;
  late final bool isDarkMode;
  late final Color buttonColor;
  late final Color textColor;
  late final double mediaWidth;
  late final double verticalPadding;
  final Function() onTap;

  CustomButtonComponent(
      {this.isClickable = true,
      required this.text,
      required this.mediaWidth,
      required this.textColor,
      required this.buttonColor,
      required this.isDarkMode,
      required this.verticalPadding,
      required this.onTap});

  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: isClickable ? onTap : null,
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: verticalPadding),
        width: mediaWidth,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
            color: isDarkMode
                ? isClickable
                    ? Colors.white
                    : Colors.grey
                : isClickable
                    ? buttonColor
                    : Colors.grey),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: isDarkMode ? Colors.white : textColor),
          ),
        ),
      ),
    );
  }
}
