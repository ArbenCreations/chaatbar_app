import 'package:flutter/material.dart';

import 'package:flutter/scheduler.dart';

class CustomAlert {
  static void showToast({
    required BuildContext context,
    required String? message,
    Duration duration = const Duration(seconds: 5),
  }) {
    if (message != null && message.isNotEmpty && message != "null") {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          // Schedule dialog auto-dismiss after current frame
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Future.delayed(duration, () {
              if (Navigator.of(dialogContext, rootNavigator: true).canPop()) {
                Navigator.of(dialogContext, rootNavigator: true).pop();
              }
            });
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
                  Navigator.of(dialogContext).pop();
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
