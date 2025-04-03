import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bitnan/resource/color.resource.dart';
import 'package:bitnan/resource/style.resource.dart';
import 'package:velocity_x/velocity_x.dart';

class ErrorText extends StatelessWidget {
  final String? errorText;

  const ErrorText({Key? key, this.errorText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return errorText.isEmptyOrNull
        ? Container()
        : errorText!.text
            .textStyle(MyStyle.typeMedium.copyWith(color: MyColor.orangeLight))
            .make()
            .marginOnly(top: 24);
  }
}
