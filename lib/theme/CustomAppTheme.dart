import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'CustomAppColor.dart';

class AppTheme {
  static TextStyle _getTextStyle(Color color,
      {double fontSize = 14, FontWeight fontWeight = FontWeight.normal}) {
    return GoogleFonts.getFont(
      'Montserrat',
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static ThemeData getAppTheme() {
    return ThemeData(
      appBarTheme: AppBarTheme(
        titleTextStyle: _getTextStyle(Colors.black, fontSize: 18),
        actionsIconTheme: const IconThemeData(color: Colors.black),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: AppColor.BackgroundColor,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.white,
      ),
      tabBarTheme: TabBarTheme(
        dividerColor: Colors.black,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.black45,
        indicatorColor: Colors.black,
        unselectedLabelStyle: TextStyle(fontSize: 12),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: Colors.white,
        dialBackgroundColor: Colors.blue,
        dialHandColor: Colors.white,
        confirmButtonStyle: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue),
        ),
        cancelButtonStyle: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.redAccent),
        ),
        hourMinuteColor: Colors.blue,
        timeSelectorSeparatorColor:
            MaterialStateProperty.all(Colors.transparent),
        entryModeIconColor: Colors.blue,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: AppColor.Primary,
      ),
      cardTheme: const CardTheme(color: Colors.white),
      primaryColor: AppColor.Primary,
      highlightColor: AppColor.Primary,
      scaffoldBackgroundColor: AppColor.BackgroundColor,
      textTheme: TextTheme(
        displayLarge: _getTextStyle(Colors.black, fontSize: 20),
        displayMedium: _getTextStyle(Colors.black, fontSize: 18),
        displaySmall: _getTextStyle(Colors.black, fontSize: 18),
        titleLarge: _getTextStyle(Colors.black, fontSize: 18),
        titleMedium: _getTextStyle(Colors.black, fontSize: 14),
        titleSmall: _getTextStyle(Colors.black, fontSize: 12),
        bodyLarge: _getTextStyle(Colors.black, fontSize: 16),
        bodyMedium: _getTextStyle(Colors.black, fontSize: 14),
        bodySmall: _getTextStyle(Colors.black, fontSize: 12),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: _getTextStyle(Colors.grey, fontSize: 14),
        iconColor: Colors.grey,
        suffixIconColor: Colors.black,
        prefixIconColor: Colors.black,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: Colors.black,
        textColor: Colors.black,
        selectedColor: AppColor.Primary,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: Colors.white,
        titleTextStyle: _getTextStyle(Colors.black, fontSize: 22),
        iconColor: Colors.black,
      ),
      datePickerTheme: DatePickerThemeData(
        dayStyle: TextStyle(color: Colors.black, fontSize: 12),
        shape: Border(),
      ),
      iconTheme: IconThemeData(color: AppColor.Primary),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
          foregroundColor: MaterialStateProperty.all<Color>(AppColor.Primary),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(AppColor.Primary),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
          ),
        ),
      ),
      toggleButtonsTheme: ToggleButtonsThemeData(
        selectedColor: AppColor.Primary,
        fillColor: AppColor.Primary.withOpacity(0.1),
        textStyle: const TextStyle(color: Colors.white),
        selectedBorderColor: AppColor.Primary,
        borderRadius: BorderRadius.circular(8.0),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: AppColor.Primary,
        onPrimary: AppColor.Primary,
        secondary: AppColor.Primary,
        onSecondary: AppColor.Primary,
        surface: Colors.black54,
        onSurface: AppColor.BackgroundColor,
        error: Colors.red,
        onError: Colors.red,
        background: Colors.black54,
        onBackground: Colors.black54,
        brightness: Brightness.light,
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: _getTextStyle(Colors.black),
      ),
    );
  }

  static ThemeData getDarkTheme() {
    return ThemeData(
      appBarTheme: AppBarTheme(
        titleTextStyle: _getTextStyle(Colors.white,
            fontSize: 18, fontWeight: FontWeight.w600),
        actionsIconTheme: const IconThemeData(color: Colors.white),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColor.BackgroundDarkColor,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: AppColor.Primary,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColor.CardDarkColor,
      ),
      datePickerTheme: DatePickerThemeData(
        dayStyle: TextStyle(color: Colors.white),
      ),
      cardTheme: const CardTheme(color: AppColor.CardDarkColor),
      primaryColor: AppColor.Primary,
      highlightColor: AppColor.Primary,
      scaffoldBackgroundColor: AppColor.BackgroundDarkColor,
      dialogTheme: DialogTheme(
        backgroundColor: AppColor.CardDarkColor,
        titleTextStyle: _getTextStyle(Colors.white, fontSize: 22),
        iconColor: Colors.white,
      ),
      tabBarTheme: TabBarTheme(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white24,
        indicatorColor: Colors.white,
        unselectedLabelStyle: TextStyle(fontSize: 12),
      ),
      textTheme: TextTheme(
        displayLarge: _getTextStyle(Colors.white, fontSize: 20),
        displayMedium: _getTextStyle(Colors.white, fontSize: 18),
        displaySmall: _getTextStyle(Colors.white, fontSize: 18),
        titleLarge: _getTextStyle(Colors.white, fontSize: 18),
        titleMedium: _getTextStyle(Colors.white, fontSize: 14),
        titleSmall: _getTextStyle(Colors.white, fontSize: 12),
        bodyLarge: _getTextStyle(Colors.white, fontSize: 16),
        bodyMedium: _getTextStyle(Colors.white, fontSize: 14),
        bodySmall: _getTextStyle(Colors.white, fontSize: 12),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: _getTextStyle(Colors.white70, fontSize: 14),
        iconColor: Colors.white70,
        suffixIconColor: Colors.white,
        prefixIconColor: Colors.white,
      ),
      iconTheme: IconThemeData(color: Colors.white),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
          foregroundColor: MaterialStateProperty.all<Color>(AppColor.Primary),
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: Colors.white,
        textColor: Colors.white,
        selectedColor: AppColor.Primary,
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(AppColor.BackgroundDarkColor),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
          ),
        ),
      ),
      toggleButtonsTheme: ToggleButtonsThemeData(
        selectedColor: AppColor.BackgroundDarkColor,
        fillColor: AppColor.BackgroundDarkColor.withOpacity(0.1),
        textStyle: const TextStyle(color: Colors.white),
        selectedBorderColor: AppColor.BackgroundDarkColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: AppColor.Primary,
        onPrimary: AppColor.Primary,
        secondary: AppColor.Secondary,
        onSecondary: AppColor.Secondary,
        surface: AppColor.BackgroundDarkColor,
        onSurface: AppColor.BackgroundDarkColor,
        error: Colors.red,
        onError: Colors.red,
        background: AppColor.BackgroundDarkColor,
        onBackground: AppColor.BackgroundDarkColor,
        brightness: Brightness.dark,
      ),
    );
  }
}
