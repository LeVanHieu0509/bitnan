import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:bitnan/@share/constants/language.constant.dart';
import 'package:bitnan/@share/utils/util.dart';
import 'package:bitnan/@share/widget/button/submit.button.v2.dart';
import 'package:bitnan/@share/widget/scaffold.widget.dart';
import 'package:bitnan/resource/color.resource.dart';
import 'package:bitnan/resource/style.resource.dart';
import 'package:velocity_x/velocity_x.dart';
import 'otp.controller.dart';

class OtpScreen extends GetWidget<OtpController> {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isShowLeading: true,
      appBarColor: MyColor.white,
      titleAppBar: getLocalize(kOtpVerification),
      body: Column(
        children: [
          24.h.heightBox,
          _itemTextDig(),
          _itemID(),
          40.h.heightBox,
          _itemOTP(context: context),
          const Spacer(),
          Obx(() => _itemResend()),
          32.h.heightBox,
          SubmitButton2(
            text: kConfirm,
            action: () {
              controller.verifyOtp();
            },
          ),
          56.h.heightBox,
        ],
      ),
    );
  }

  _itemTextDig() => getLocalize(kEnterOtp)
      .toString()
      .text
      .textStyle(MyStyle.typeRegular.copyWith(fontSize: 14.sp))
      .make()
      .pOnly(top: 8.h);

  _itemID() => Obx(
    () => RichText(
      text: TextSpan(
        style: MyStyle.typeRegular,
        text: getLocalize(kOtpSentEmail),
        children: [
          TextSpan(style: MyStyle.typeBold, text: ' ${controller.iD.value}'),
        ],
      ),
    ).marginOnly(top: 8),
  );

  _itemOTP({required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: PinCodeTextField(
        appContext: context,
        focusNode: controller.inputNode,
        length: 4,
        animationType: AnimationType.fade,
        obscuringCharacter: '1',
        pinTheme: PinTheme(
          borderWidth: 1,
          inactiveColor: MyColor.grayDark.withOpacity(0.3),
          inactiveFillColor: MyColor.white,
          shape: PinCodeFieldShape.underline,
          selectedColor: MyColor.pinkNew,
          selectedFillColor: MyColor.white,
          activeColor: MyColor.black,
          fieldHeight: 48,
          fieldWidth: 48,
          activeFillColor: MyColor.white,
        ),
        cursorColor: MyColor.blueTeal,
        animationDuration: const Duration(milliseconds: 150),
        textStyle: MyStyle.typeBold.copyWith(
          color: MyColor.black,
          fontSize: 24.sp,
        ),
        enableActiveFill: true,
        controller: controller.textEditingController,
        keyboardType: TextInputType.number,
        onCompleted: (v) => controller.verifyOtp(),
        onChanged: (s) => controller.setError(clear: true),
      ),
    );
  }

  _itemResend() {
    return controller.isResend.value
        ? getLocalize(kResendOtp)
            .toString()
            .text
            .textStyle(
              MyStyle.typeBold.copyWith(
                color: MyColor.black,
                fontSize: 16.sp,
                decoration: TextDecoration.underline,
              ),
            )
            .make()
            .onTap(controller.reSendOtp)
        : getLocalize(kResendOtpWithNum, args: [controller.timeText.value])
            .toString()
            .text
            .textStyle(
              MyStyle.typeBold.copyWith(
                color: MyColor.grayDark.withOpacity(0.3),
                fontSize: 16.sp,
              ),
            )
            .make();
  }
}
