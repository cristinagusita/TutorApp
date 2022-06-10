import 'package:flutter/material.dart';

class MyThemes {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xFF221F20),
    primaryColorDark: const Color(0xFFeec4d8),
    colorScheme: const ColorScheme.dark(primary: Color(0xFFeec4d8)),
    dividerColor: Colors.white,
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xffFCF5F6),
    primaryColor: const Color(0xFFCE5B78),
    colorScheme: const ColorScheme.light(primary: Color(0xFFCE5B78)),
    dividerColor: Colors.black,
    iconTheme: const IconThemeData(
      color: Color(0xffF39682),
      opacity: 1.0,
    ),
  );
}
