import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:bitnan/@share/constants/language.constant.dart';
import 'package:bitnan/@share/utils/util.dart';
import 'package:bitnan/@share/widget/image/image.widget.dart';
import 'package:bitnan/resource/color.resource.dart';
import 'package:bitnan/resource/style.resource.dart';
import 'package:velocity_x/velocity_x.dart';

class ModalBiometric extends StatelessWidget {
  final String message;
  final String url;
  final VoidCallback? action;

  const ModalBiometric({
    Key? key,
    required this.message,
    required this.url,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 375.h,
      color: MyColor.white,
      child: Column(
        children: [
          Container(
            height: 3.h,
            width: 64.w,
            margin: EdgeInsets.only(top: 16.h, bottom: 28.h),
            decoration: BoxDecoration(color: MyColor.gray.withOpacity(0.15)),
          ),
          ImageCaches(url: url, height: 80.w, width: 80.w),
          28.h.heightBox,
          Text(
            getLocalize(message),
            style: MyStyle.typeRegular.copyWith(fontSize: 16.sp),
          ),
          8.h.heightBox,
          Text(
            getLocalize(kLaterSetting),
            style: MyStyle.typeRegular.copyWith(fontSize: 16.sp),
          ),
          const Spacer(),
          InkWell(
            splashColor: Vx.white,
            highlightColor: Vx.white,
            onTap: () {
              if (WidgetsBinding.instance.window.viewInsets.bottom > 0.0) {
                FocusScope.of(context).unfocus();
              }
              goBack();
              action?.call();
            },
            child: Container(
              height: 48.h,
              width: Get.width,
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 55.w),
              decoration: getDecoration(),
              child: Text(
                'OK',
                style: MyStyle.typeBold.copyWith(
                  color: MyColor.white,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),
          56.h.heightBox,
        ],
      ),
    );
  }
}
