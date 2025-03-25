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

/*
1. Màn hình này cho phép người dùng nhập mã OTP gửi đến email 
2. hoặc số điện thoại của họ, đồng thời có thể gửi lại mã OTP nếu cần.
3. OtpScreen là một widget kế thừa từ GetView<OtpController>. 
Điều này có nghĩa là màn hình này sẽ tự động kết nối với OtpController mà không cần phải gọi Get.find().
 */
class OtpScreen extends GetWidget<OtpController> {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Đây là một widget tùy chỉnh thay thế Scaffold mặc định trong Flutter,
    // giúp bạn tùy chỉnh các phần của giao diện như appBar, body, và các widget con.
    return CustomScaffold(
      isShowLeading: true, // Hiển thị nút quay lại (back button) nếu có
      appBarColor: MyColor.white, // Đặt màu nền của AppBar
      titleAppBar: getLocalize(
        kOtpVerification,
      ), //  Tiêu đề của AppBar, được lấy từ hệ thống localization thông qua getLocalize(kOtpVerification).
      body: Column(
        children: [
          24.h.heightBox,
          _itemTextDig(), // Hiển thị văn bản yêu cầu nhập mã OTP
          _itemID(), // Hiển thị thông tin email hoặc số điện thoại đã nhận OTP
          40.h.heightBox,
          _itemOTP(
            context: context,
          ), // Hiển thị trường nhập OTP (sử dụng PinCodeTextField).
          const Spacer(),
          Obx(
            () => _itemResend(),
          ), // Hiển thị tùy chọn gửi lại mã OTP sau một khoảng thời gian.
          32.h.heightBox,
          // Nút "Xác nhận" để người dùng gửi OTP đã nhập và gọi phương thức verifyOtp() để kiểm tra tính hợp lệ của OTP.
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

  // Lấy văn bản từ hệ thống localization (với khóa kEnterOtp) và hiển thị thông báo yêu cầu người dùng nhập OTP.
  _itemTextDig() => getLocalize(kEnterOtp)
      .toString()
      .text
      .textStyle(MyStyle.typeRegular.copyWith(fontSize: 14.sp))
      .make()
      .pOnly(top: 8.h);

  //  Đây là một widget của GetX để theo dõi sự thay đổi trong controller.iD.
  // Nếu controller.iD thay đổi, giao diện sẽ tự động cập nhật.
  _itemID() => Obx(
    // Được sử dụng để hiển thị văn bản có định dạng phong phú, với một phần là chữ in đậm.
    () => RichText(
      text: TextSpan(
        style: MyStyle.typeRegular,
        text: getLocalize(kOtpSentEmail),
        children: [
          // controller.iD.value là email hoặc số điện thoại mà mã OTP đã được gửi đến.
          TextSpan(style: MyStyle.typeBold, text: ' ${controller.iD.value}'),
        ],
      ),
    ).marginOnly(top: 8),
  );

  //  Đây là một widget nhập mã PIN (OTP). Một số tính năng quan trọng:
  _itemOTP({required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: PinCodeTextField(
        appContext: context,
        focusNode: controller.inputNode,
        length: 4,
        animationType: AnimationType.fade,
        obscuringCharacter: '1',
        // Thiết lập giao diện của trường nhập mã PIN,
        // bao gồm màu sắc, kích thước trường, và các hiệu ứng khi người dùng chọn trường.
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
    // Kiểm tra xem người dùng có thể gửi lại mã OTP không. Nếu có, hiển thị văn bản có thể nhấn để gửi lại OTP.
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
            .onTap(
              controller.reSendOtp,
            ) //Khi người dùng nhấn vào văn bản "Gửi lại mã OTP", phương thức reSendOtp sẽ được gọi.
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

/*
Tóm tắt:
1. OtpScreen là màn hình cho phép người dùng nhập mã OTP nhận được từ email hoặc điện thoại.
2. PinCodeTextField được sử dụng để nhập mã OTP.
3. controller.verifyOtp() được gọi khi người dùng nhập đủ mã OTP và nhấn "Xác nhận".
4. _itemResend() cho phép người dùng yêu cầu gửi lại mã OTP nếu cần.
 */
