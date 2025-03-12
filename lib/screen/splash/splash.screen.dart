import 'package:bitnan/@share/utils/util.dart';
import 'package:bitnan/@share/widget/image/image.widget.dart';
import 'package:bitnan/@share/widget/scaffold.widget.dart';
import 'package:bitnan/resource/color.resource.dart';
import 'package:bitnan/resource/image.resource.dart';
import 'package:bitnan/screen/splash/splash.controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class SplashScreen extends GetWidget<SplashController> {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isShowLeading: false,
      backgroundColor: Colors.white,
      body:
          VStack([
                const Spacer(),
                SizedBox(height: 44.h),
                ImageCaches(
                  height: 80.h,
                  width: 80.w,
                  url: MyImage.logo_bit_back,
                ),
                const Spacer(),
                'HIEU'.text.bold.size(16.sp).color(MyColor.black).make(),
                SizedBox(height: 44.h),
              ], crossAlignment: CrossAxisAlignment.center).box
              .width(widthScreen(100))
              .make(),
    );
  }
}
