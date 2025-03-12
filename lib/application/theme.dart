import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../resource/font.resource.dart';

ThemeData applicationTheme() => ThemeData(
  fontFamily: MyFont.regular,
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      // For Android (dark icons)
      statusBarIconBrightness: Brightness.dark,
      // For iOS (dark icons)
      statusBarBrightness: Brightness.light,
    ),
  ),
);
