import '/theme/CustomAppColor.dart';
import 'package:flutter/material.dart';

class CustomNumberKeyboard extends StatelessWidget {

  final Function(String) onKeyTap;

   CustomNumberKeyboard({required this.onKeyTap});

  void _onKeyPressed(String value) {
    onKeyTap(value);
  }

  @override
  Widget build(BuildContext context) {

    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.transparent
      ),
      padding: EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildKey('1', isDarkMode),
              _buildKey('2', isDarkMode),
              _buildKey('3', isDarkMode),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildKey('4', isDarkMode),
              _buildKey('5', isDarkMode),
              _buildKey('6', isDarkMode),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildKey('7', isDarkMode),
              _buildKey('8', isDarkMode),
              _buildKey('9', isDarkMode),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                  onPressed: () {
                    _onKeyPressed("clear");
                  },
                  icon: Icon(
                    Icons.backspace_outlined,
                    size: 32,
                  )),
              _buildKey('0', isDarkMode),
              Container(
                decoration: BoxDecoration(shape: BoxShape.circle, color: AppColor.Primary ),
                child: IconButton(
                    onPressed: () {
                      _onKeyPressed("submit");
                    },
                    icon: Icon(
                      Icons.check,
                      size: 32,
                      color: Colors.white,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKey(String value, bool isDarkMode) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _onKeyPressed(value),
      child: Container(
        width: 90,
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        decoration: BoxDecoration(
          color:  AppColor.Primary ,
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white ,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
