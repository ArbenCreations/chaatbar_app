import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../languageSection/Languages.dart';
import '../view/component/toastMessage.dart';

/// Validate password using regex pattern
bool validatePassword(String password) {
  final pattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$&*~]).{8,}$';
  return RegExp(pattern).hasMatch(password);
}

/// Extract first or last name from a full name
String extractNames(String fullName, bool isFirst) {
  final nameParts = fullName.trim().split(' ');
  return isFirst ? nameParts.first : nameParts.length > 1 ? nameParts.last : '';
}

/// Check if the keyboard is open
bool isKeyboardOpen(BuildContext context) {
  return MediaQuery.of(context).viewInsets.bottom != 0;
}

/// Capitalize the first letter of a string
String capitalizeFirstLetter(String input) {
  if (input.isEmpty) return input;
  return input.contains("_")
      ? input.replaceAll("_", " ")[0].toUpperCase() + input.substring(1)
      : input[0].toUpperCase() + input.substring(1);
}

/// Convert string to lowercase
String nonCapitalizeString(String input) => input.isEmpty ? input : input.toLowerCase();

/// Convert UTC date to local time and format as 'dd-MM-yyyy'
String convertDateFormat(String input) {
  if (input.isEmpty) return input;
  return DateFormat('dd-MM-yyyy').format(DateTime.parse(convertUtcDateToLocal(input)));
}

/// Convert UTC time to local time
String convertUtcDateToLocal(String utcTime) {
  return utcTime.isEmpty ? utcTime : DateTime.parse(utcTime).toLocal().toString();
}

/// Convert UTC date to local time and format as 'dd-MM-yyyy hh:mm a'
String convertDateTimeFormat(String input) {
  if (input.isEmpty) return input;
  return DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.parse(convertUtcDateToLocal(input)));
}

/// Format date in 'dd-MM-yyyy' format
String convertedDateTimeFormat(String input) {
  if (input.isEmpty) return input;
  return DateFormat('dd-MM-yyyy').format(DateTime.parse(input).toLocal());
}

/// Format date in 'dd-MM-yyyy' format
String convertedDateMonthFormat(String input) {
  if (input.isEmpty) return input;
  try {
    DateTime date = DateTime.parse(input);
    return DateFormat("MMM,dd yyyy").format(date);  // Output in 29Jan2025 format
  } catch (e) {
    return 'Invalid date format';
  }
}

/// Convert UTC time to local time and format as 'hh:mm a'
String convertTime(String input) {
  if (input.isEmpty) return input;
  return DateFormat('hh:mm a').format(DateTime.parse(convertUtcDateToLocal(input)));
}

/// Format currency based on the country
String currencyFormat(String symbol, String input, String country) {
  if (input.isEmpty) return input;
  double value;
  try {
    value = double.parse(input);
  } catch (e) {
    return "$symbol$input";
  }
  final locale = _getLocaleByCountry(country);
  final formatter = NumberFormat.currency(
    locale: locale,
    symbol: symbol,
    decimalDigits: 2,
  );
  return formatter.format(value);
}

/// Get locale based on the country
String _getLocaleByCountry(String country) {
  switch (country) {
    case 'India':
      return 'en_IN';
    case 'Bangladesh':
      return 'bn_BD';
    case 'Saudi Arabi':
      return 'ar_SA';
    default:
      return 'en_US';
  }
}

/// Convert date to day and month format ('d\nMMM')
String convertDateMonthFormat(String input) {
  if (input.isEmpty) return input;
  DateTime date = DateTime.parse(input);
  return '${DateFormat('d').format(date)}\n${DateFormat('MMM').format(date)}';
}

/// Add currency symbol to the input amount
String addCurrencySymbol(String? currencySymbol, String input) {
  if (input.isEmpty || currencySymbol == null || currencySymbol == "null") return input;
  try {
    return "$currencySymbol${double.parse(input).toStringAsFixed(2)}";
  } catch (e) {
    return "$currencySymbol$input";
  }
}

/// Check if balance is more than the amount
bool isBalanceMoreThanAmount(String balance, String amt, BuildContext context) {
  if (extractFloat(balance) <= extractFloat(amt)) {
    CustomToast.showToast(context: context, message: 'You do not have enough balance.');
    return false;
  }
  return true;
}

/// Extract float value from a string
double extractFloat(String str) {
  final regex = RegExp(r'-?\d+(\.\d+)?');
  final match = regex.firstMatch(str);
  if (match != null) return double.parse(match.group(0)!);
  throw FormatException('No floating-point number found in the string');
}

/// Check if the transaction allows money to be withdrawn or transferred
bool checkMoneyOut(String transactionType, int? senderId, int? userId) {
  if (transactionType.toLowerCase() == 'transfer' && userId != 0) {
    return senderId == userId;
  }
  return transactionType.toLowerCase() == 'withdraw';
}

/// Add currency symbol based on transaction type
String addCurrencySymbolTransaction(String? currencySymbol, String input, String requestType, int? userId, int? senderId) {
  if (input.isEmpty) return input;
  String amount = addCurrencySymbol(currencySymbol, input);
  if (checkMoneyOut(requestType, senderId, userId)) {
    amount = "-$amount";
  } else {
    amount = "+$amount";
  }
  return amount;
}

/// Determine the color for transaction status
Color colorStatus(String status, BuildContext context) {
  if (status == Languages.of(context)!.labelPending) return Colors.orange;
  if (status == Languages.of(context)!.labelSuccess) return Colors.green;
  return status == Languages.of(context)!.labelRejected || status == Languages.of(context)!.labelInComplete
      ? Colors.red
      : Colors.black;
}

/// Hide the keyboard
void hideKeyBoard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

/// Get the unique device ID based on platform (Android or iOS)
Future<String?> getDeviceId() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    final androidInfo = await deviceInfo.androidInfo;
    return androidInfo.id;
  } else if (Platform.isIOS) {
    final iosInfo = await deviceInfo.iosInfo;
    return iosInfo.identifierForVendor;
  }
  return null;
}



bool hasMinLength(String value) {
  return value.length >= 8;
}

bool hasUppercase(String value) {
  return value.contains(RegExp(r'[A-Z]'));
}

bool hasDigit(String value) {
  return value.contains(RegExp(r'\d'));
}

bool hasSpecialCharacter(String value) {
  return value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
}


