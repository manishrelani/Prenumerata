import 'package:flutter/material.dart';

import '../../generated/fonts.gen.dart';

final class AppTheme {
  AppTheme._();

  static final darkTheme = ThemeData(
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    fontFamily: FontFamily.inter,

    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      primary: Colors.blue,
      surface: Colors.white10,
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      centerTitle: true,
    ),
  );
}
