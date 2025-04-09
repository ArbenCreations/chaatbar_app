import 'package:flutter/services.dart';

class CloverIntegration {
  static const platform = MethodChannel('com.thechaatbarCustomer/clover');

  Future<void> startTransaction() async {
    try {
      await platform.invokeMethod('startTransaction');
    } on PlatformException catch (e) {
      print("Failed to start transaction: ${e.message}");
    }
  }
}