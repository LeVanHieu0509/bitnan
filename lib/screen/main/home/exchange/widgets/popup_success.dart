import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bitnan/@share/utils/util.dart';
import 'package:bitnan/@share/widget/image/image.widget.dart';
import 'package:bitnan/resource/color.resource.dart';
import 'package:bitnan/resource/image.resource.dart';
import 'package:bitnan/resource/style.resource.dart';

class PopupSuccess extends StatelessWidget {
  final VoidCallback? action;

  const PopupSuccess({Key? key, this.action}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 36.w),
      child: Container(
        padding: EdgeInsets.only(
          top: 24.h,
          bottom: 12.h,
          left: 20.w,
          right: 20.w,
        ),
        width: 280.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: MyColor.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Column(
                  children: [
                    ImageCaches(
                      url: MyImage.ic_exchange_success,
                      height: 120.h,
                      width: 120.w,
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'Quy đổi thành công',
                      style: MyStyle.typeMedium.copyWith(fontSize: 16.sp),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20.h),
            MaterialButton(
              color: MyColor.blueTeal,
              minWidth: double.infinity,
              height: 40.h,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(21),
              ),
              onPressed: () {
                goBack();
                action?.call();
              },
              child: Text(
                'Xem chi tiết',
                style: MyStyle.typeMedium.copyWith(color: MyColor.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
