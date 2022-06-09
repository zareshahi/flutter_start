import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      fontFamily: 'Vazir',
      primarySwatch: Colors.blue,
      primaryColor: isDarkTheme ? Colors.black : Colors.white,
      backgroundColor: isDarkTheme ? Colors.black : const Color(0xffF1F5FB),
      indicatorColor:
          isDarkTheme ? const Color(0xff0E1D36) : const Color(0xffCBDCF8),
      hintColor: isDarkTheme
          ? const Color.fromARGB(255, 11, 31, 40)
          : const Color.fromARGB(255, 206, 224, 238),
      highlightColor: isDarkTheme
          ? const Color.fromARGB(255, 1, 29, 55)
          : const Color.fromARGB(255, 146, 179, 252),
      hoverColor:
          isDarkTheme ? const Color(0xff3A3A3B) : const Color(0xff4285F4),
      focusColor:
          isDarkTheme ? const Color(0xff0B2512) : const Color(0xffA8DAB5),
      disabledColor: Colors.grey,
      cardColor:
          isDarkTheme ? const Color.fromARGB(255, 21, 21, 21) : Colors.white,
      canvasColor:
          isDarkTheme ? const Color.fromARGB(255, 0, 0, 0) : Colors.grey[50],
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme
              ? const ColorScheme.dark()
              : const ColorScheme.light()),
      appBarTheme: const AppBarTheme(
        elevation: 0.0,
      ),
      textSelectionTheme: TextSelectionThemeData(
          selectionColor: isDarkTheme
              ? const Color.fromARGB(255, 59, 59, 59)
              : const Color(0xffF1F5FB)),
      snackBarTheme: const SnackBarThemeData(
          contentTextStyle: TextStyle(fontFamily: "Vazir", fontSize: 16),
          backgroundColor: Color(0xff495057)),
    );
  }
}
