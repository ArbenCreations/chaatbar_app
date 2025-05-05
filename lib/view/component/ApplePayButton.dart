import 'package:flutter/material.dart';

class ApplePayButton extends StatelessWidget {
  final VoidCallback onPressed;
  const ApplePayButton({Key ?key, required this.onPressed}) : super(key: key);
  //const ApplePayButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    var mediaWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50,
        width: mediaWidth * 0.6,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.apple, color: Colors.white, size: 24),
            const SizedBox(width: 8),
            const Text(
              'Pay with Apple Pay',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
