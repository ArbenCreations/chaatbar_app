import 'package:flutter/material.dart';

class CustomAlert {
  static void showToast({
    required BuildContext context,
    required String? message,
    Duration duration = const Duration(seconds: 5),
  }) {
    if (message != null && message.isNotEmpty && message != "null") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          Future.delayed(duration, () {
            Navigator.of(context, rootNavigator: true).pop(); // Auto close dialog
          });

          return AlertDialog(
            title: const Text("Notice"),
            content: Text(message),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }
}
