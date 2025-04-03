import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:bitnan/@share/constants/language.constant.dart';
import 'package:bitnan/@share/utils/util.dart';
import 'package:bitnan/@share/widget/scaffold.widget.dart';
import 'package:bitnan/@share/widget/text/error_text.widget.dart';
import 'package:bitnan/resource/color.resource.dart';
import 'package:bitnan/resource/style.resource.dart';
import 'package:velocity_x/velocity_x.dart';

import 'otp.transfer.controller.dart';

// Màn hình này sẽ hiển thị các thông tin như tiêu đề, số điện thoại người nhận,
// trường OTP và cho phép người dùng gửi lại mã OTP khi hết thời gian.
class OtpTransferScreen extends GetWidget<OtpTransferController> {
  const OtpTransferScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Tiêu đề của AppBar được lấy từ controller.title.value, qua đó sử dụng getLocalize để lấy bản dịch của tiêu đề.
    return CustomScaffold(
      titleAppBar: getLocalize(controller.title.value),
      body: ZStack([_itemSubBody(), _itemBody(context: context)]),
    );
  }

  _itemSubBody() => VxBox().withDecoration(boxDecorationAppbar()).make();

  _itemBody({required BuildContext context}) =>
      // Dùng VxBox của VelocityX để tạo các widget layout với chiều rộng và chiều cao chiếm toàn bộ màn hình
      VxBox(
            child: VStack([
              // Hiển thị văn bản lấy từ controller.content.value, sử dụng getLocalize để lấy bản địa hóa của văn bản.
              _itemText(),
              // Hiển thị số điện thoại người nhận, sau khi qua xử lý với replacePhone()
              _itemID(),
              // Hiển thị trường nhập OTP với widget PinCodeTextField
              _itemOTP(context: context),
              // Hiển thị thông báo cho phép gửi lại OTP khi người dùng có thể gửi lại mã sau khi thời gian đếm ngược hết.
              Obx(() => ErrorText(errorText: controller.error.value)),
              32.heightBox,
              Obx(() => _itemResend()),
            ], crossAlignment: CrossAxisAlignment.center),
          )
          .width(widthScreen(100))
          .height(heightScreen(100))
          .withDecoration(
            const BoxDecoration(
              color: Vx.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
          )
          .color(Vx.white)
          .make();

  // Hiển thị thông báo như "Nhập mã OTP" hoặc một thông điệp liên quan đến OTP.
  _itemText() => getLocalize(controller.content.value)
      .toString()
      .text
      .textStyle(MyStyle.typeRegular.copyWith(fontSize: 15))
      .make()
      .pOnly(top: 48);

  // Hiển thị số điện thoại người nhận, được xử lý qua hàm
  _itemID() => replacePhone(controller.iD.value)
      .toString()
      .text
      .textStyle(MyStyle.typeBold.copyWith(fontSize: 15))
      .make()
      .pOnly(top: 8, bottom: 24);

  _itemOTP({required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: PinCodeTextField(
        appContext: context,
        length: 6,
        animationType: AnimationType.fade,
        obscuringCharacter: '1',
        pinTheme: PinTheme(
          borderWidth: 1,
          inactiveColor: MyColor.blueSteel,
          inactiveFillColor: MyColor.white,
          borderRadius: BorderRadius.circular(16),
          shape: PinCodeFieldShape.box,
          selectedColor: MyColor.blueSteel,
          selectedFillColor: MyColor.white,
          activeColor: MyColor.blueSteel,
          fieldHeight: 48,
          fieldWidth: 48,
          activeFillColor: MyColor.white,
        ),
        cursorColor: MyColor.blueTeal,
        animationDuration: const Duration(milliseconds: 150),
        textStyle: MyStyle.typeRegular.copyWith(color: MyColor.blueSteel),
        enableActiveFill: true,
        controller: controller.textEditingController,
        keyboardType: TextInputType.number,
        onCompleted: (v) => controller.verifyOtp(),
        onChanged: (s) => controller.setError(clear: true),
      ),
    );
  }

  // Quan sát giá trị của controller.isResend.
  // Nếu có thể gửi lại OTP, sẽ hiển thị dòng chữ "Gửi lại mã OTP" với màu sắc đặc biệt
  _itemResend() {
    return controller.isResend.value
        ? getLocalize(kResendOtp)
            .toString()
            .text
            .textStyle(
              MyStyle.typeBold.copyWith(
                color: MyColor.orangeLight,
                fontSize: 16,
              ),
            )
            .make()
            .onTap(controller.reSendOtp)
        : getLocalize(kResendOtpWithNum, args: [controller.timeText.value])
            .toString()
            .text
            .textStyle(
              MyStyle.typeRegular.copyWith(
                color: MyColor.blueSteel,
                fontSize: 16,
              ),
            )
            .make();
  }
}
