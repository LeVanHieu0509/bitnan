import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bitnan/@share/utils/util.dart';
import 'package:bitnan/resource/color.resource.dart';
import 'package:bitnan/resource/style.resource.dart';
import 'package:velocity_x/velocity_x.dart';

class SubmitButton2 extends StatelessWidget {
  final VoidCallback? action;
  final String text;

  const SubmitButton2({Key? key, this.action, required this.text})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Vx.white,
      highlightColor: Vx.white,
      onTap: () => action?.call(),
      child: Container(
        height: 48.h,
        width: 263.w,
        alignment: Alignment.center,
        decoration: getDecoration(),
        child: Text(
          getLocalize(text),
          style: MyStyle.typeBold.copyWith(
            color: MyColor.white,
            fontSize: 16.sp,
          ),
        ),
      ),
    ).centered();
  }
}
