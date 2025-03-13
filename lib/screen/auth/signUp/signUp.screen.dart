import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bitnan/@share/constants/language.constant.dart';
import 'package:bitnan/@share/utils/util.dart';
import 'package:bitnan/@share/widget/custom_safe_view/custom_safe_view.dart';
import 'package:bitnan/@share/widget/image/image.widget.dart';
import 'package:bitnan/resource/color.resource.dart';
import 'package:bitnan/resource/image.resource.dart';
import 'package:bitnan/resource/style.resource.dart';
import 'package:bitnan/screen/auth/signUp/signUp.controller.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUpScreen extends GetView<SignUpController> {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomSafeView(
      top: false,
      child: Container(
        color: MyColor.colorContainer,
        child: SafeArea(
          child:
              VStack(
                [
                  SizedBox(height: 32.h),
                  //TODO hide ToggleLang
                  //ToggleLang(),
                  Expanded(child: _itemLogo()),
                  GestureDetector(
                    onTap: () => controller.countPress++,
                    onLongPress: () => controller.specialEvent(),
                    child: Text(
                      getLocalize(kLoginWith),
                      style: MyStyle.typeRegular.copyWith(
                        color: MyColor.grayDark,
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h),
                  _buildListItemLogin().marginOnly(bottom: 40.h),
                  //TODO hide button skip
                  // Text(
                  //   getLocalize(kSkipLogin),
                  //   style: MyStyle.typeBold.copyWith(
                  //       fontSize: 16.sp, color: MyColor.grayDark.withOpacity(0.5)),
                  // ),
                  40.h.heightBox,
                ],
                crossAlignment: CrossAxisAlignment.center,
              ).box.color(MyColor.colorContainer).make(),
        ),
      ),
    );
  }

  Widget _buildListItemLogin() {
    if (Platform.isIOS) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _itemLogin(
            url: MyImage.ic_login_apple,
            action: () => _handleContinueAppleId(),
          ),
          52.h.widthBox,
          _itemLoginGoogle(),
          52.h.widthBox,
          _itemLogin(
            url: MyImage.ic_login_fb,
            action: () => _handleContinueFacebook(),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _itemLoginGoogle(),
          52.h.widthBox,
          _itemLogin(
            url: MyImage.ic_login_fb,
            action: () => _handleContinueFacebook(),
          ),
        ],
      );
    }
  }

  Widget _itemLoginGoogle() {
    return Container(
      height: 64.w,
      width: 64.w,
      decoration: BoxDecoration(
        color: MyColor.white,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: MyColor.grayBorder.withOpacity(0.06)),
      ),
      child: ImageCaches(
        url: MyImage.ic_login_gg,
        height: 40.w,
        width: 40.w,
      ).onTap(() => _handleContinueGoogle()),
    );
  }

  _itemLogo() =>
      VxBox(
        child: Image.asset(MyImage.logo_bit_back, height: 80.w, width: 80.w),
      ).make().centered();

  _itemLogin({required String url, VoidCallback? action}) => ImageCaches(
    url: url,
    height: 64.w,
    width: 64.w,
  ).onTap(() => action?.call());

  _handleContinueAppleId() async {
    await controller.signInAppleId();
  }

  _handleContinueGoogle() async {
    await controller.signInGoogle();
  }

  _handleContinueFacebook() async {
    await controller.signInFacebook();
  }
}
