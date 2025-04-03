import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:bitnan/@share/constants/language.constant.dart';
import 'package:bitnan/@share/utils/util.dart';
import 'package:bitnan/@share/widget/image/image.widget.dart';
import 'package:bitnan/resource/color.resource.dart';
import 'package:bitnan/resource/image.resource.dart';
import 'package:bitnan/resource/style.resource.dart';

class PopupError extends StatelessWidget {
  const PopupError({Key? key, required this.content}) : super(key: key);
  final String content;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 32.w),
      child: Container(
        padding: EdgeInsets.only(
          top: 24.h,
          bottom: 12.h,
          left: 16.w,
          right: 16.w,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: MyColor.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ImageCaches(
              url: MyImage.ic_confirm_exchange_disable,
              height: 120.h,
              width: 120.w,
            ),
            SizedBox(height: 20.h),
            Text(
              content.contains(getLocalize(kLockExchange))
                  ? getLocalize(kLockExchange)
                  : content,
              textAlign: TextAlign.center,
              style: MyStyle.typeMedium.copyWith(fontSize: 16.sp),
            ),
            SizedBox(height: 24.h),
            MaterialButton(
              color: MyColor.blueTeal,
              minWidth: Get.width,
              height: 40.h,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(21),
              ),
              onPressed: () {
                goBack();
                hideKeyboard();
              },
              child: Text(
                'OK',
                style: MyStyle.typeMedium.copyWith(color: MyColor.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
