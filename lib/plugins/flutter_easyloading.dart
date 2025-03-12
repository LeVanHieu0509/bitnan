import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void initEasyLoading({Color? color}) =>
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 1500)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..maskType = EasyLoadingMaskType.custom
      ..loadingStyle = EasyLoadingStyle.custom
      ..toastPosition = EasyLoadingToastPosition.bottom
      ..progressColor = Colors.transparent
      ..backgroundColor = color ?? Colors.transparent
      ..indicatorColor = Colors.transparent
      ..textColor = Colors.white
      ..maskColor = Colors.transparent.withOpacity(0.5)
      ..indicatorSize = 45
      ..radius = 10
      ..fontSize = 14
      ..userInteractions = false;
