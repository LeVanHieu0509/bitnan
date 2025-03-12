import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'color.resource.dart';
import 'font.resource.dart';

class MyStyle {
  static TextStyle typeLight = TextStyle(
      fontSize: 14.sp, color: MyColor.grayDark, fontFamily: MyFont.light);

  static TextStyle typeRegular = TextStyle(
      fontSize: 14.sp,
      color: MyColor.grayDark_29.withOpacity(0.85),
      fontFamily: MyFont.regular);

  static TextStyle typeRegularWhite = TextStyle(
      fontSize: 14.sp, color: MyColor.white, fontFamily: MyFont.regular);

  static TextStyle typeMedium = TextStyle(
      fontSize: 14.sp,
      color: MyColor.grayDark_29.withOpacity(0.85),
      fontFamily: MyFont.medium);

  static TextStyle typeMediumSeeMore = TextStyle(
      fontSize: 14.sp,
      color: MyColor.grayDark_29.withOpacity(0.85),
      fontFamily: MyFont.medium,
      decoration: TextDecoration.underline);

  static TextStyle typeBold = TextStyle(
      fontSize: 14.sp,
      color: MyColor.grayDark_29.withOpacity(0.85),
      fontFamily: MyFont.bold);

  static TextStyle typeSemiBold = TextStyle(
      fontSize: 14.sp,
      color: MyColor.grayDark_29.withOpacity(0.85),
      fontFamily: MyFont.semiBold);

  static TextStyle typeORC = TextStyle(
      fontSize: 14.sp,
      color: MyColor.grayDark_29.withOpacity(0.85),
      fontFamily: MyFont.orc);

  static TextStyle typeRegularSmall = TextStyle(
      fontSize: 12.sp,
      color: MyColor.grayDark_29.withOpacity(0.85),
      fontFamily: MyFont.regular);

  static TextStyle typeCalis = TextStyle(
      fontSize: 14.sp,
      color: MyColor.grayDark_29.withOpacity(0.85),
      fontFamily: MyFont.calis);
  static TextStyle typePacif = TextStyle(
      fontSize: 14.sp,
      color: MyColor.grayDark_29.withOpacity(0.85),
      fontFamily: MyFont.pacif);
  static TextStyle typeProRegular = TextStyle(
      fontSize: 14.sp,
      color: MyColor.grayDark_29.withOpacity(0.85),
      fontFamily: MyFont.promptRegular);
  static TextStyle typeProMedium = TextStyle(
      fontSize: 14.sp,
      color: MyColor.grayDark_29.withOpacity(0.85),
      fontFamily: MyFont.promptMedium);
  static TextStyle typeProSemiBold = TextStyle(
      letterSpacing: 0.5,
      fontSize: 14.sp,
      color: MyColor.grayDark_29.withOpacity(0.85),
      fontFamily: MyFont.promptSemiBold);
  static TextStyle typeProBold = TextStyle(
      letterSpacing: 0.5,
      fontSize: 14.sp,
      color: MyColor.grayDark_29.withOpacity(0.85),
      fontFamily: MyFont.promptBold);
  static TextStyle typeProExtraBold = TextStyle(
      fontSize: 14.sp,
      color: MyColor.grayDark_29.withOpacity(0.85),
      fontFamily: MyFont.promptExtraBold);

  static double xs = 8;
  static double sm = 16;
  static double md = 24;
  static double lg = 32;
  static double xl = 48;
  static double max = 56;
}
