import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bitnan/@core/data/api/url.api.dart';
import 'package:bitnan/@share/constants/language.constant.dart';
import 'package:bitnan/@share/utils/util.dart';
import 'package:bitnan/@share/widget/box/item_dot.dart';
import 'package:bitnan/@share/widget/scaffold.widget.dart';
import 'package:bitnan/@share/widget/text/text_field_underline.dart';
import 'package:bitnan/resource/color.resource.dart';
import 'package:bitnan/resource/image.resource.dart';
import 'package:bitnan/resource/style.resource.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:velocity_x/velocity_x.dart';
import 'input_email.controller.dart';

// InputEmailScreen là một widget kế thừa từ GetView<InputEmailController>,
// có nghĩa là nó sẽ tự động kết nối với InputEmailController mà không cần phải gọi Get.find().
class InputEmailScreen extends GetWidget<InputEmailController> {
  const InputEmailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Tạo scaffold tùy chỉnh với SafeArea để tránh các phần bị che khuất bởi thanh trạng thái hoặc các yếu tố hệ thống.
    return CustomScaffold(
      isShowLeading: true,
      appBarColor: MyColor.white,
      body: Padding(
        padding: EdgeInsets.only(
          top: 40.h,
          left: 24.w,
          right: 24.w,
          bottom: 56.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getLocalize(kEmail),
              style: MyStyle.typeBold.copyWith(
                fontSize: 18.sp,
                color: MyColor.black,
              ),
            ),
            16.h.heightBox,
            Row(
              children: const [
                ItemDot(isActive: true),
                ItemDot(isActive: true),
                ItemDot(),
                ItemDot(),
              ],
            ),
            40.h.heightBox,
            // Khi controller.email thay đổi, widget sẽ tự động cập nhật.
            Obx(
              // Là widget tùy chỉnh cho ô nhập email với controller.email. Đây là widget nhập liệu, với kiểu dữ liệu là email.
              () => TextFieldUnderline(
                hintText: kInputEmail,
                textInputType: TextInputType.emailAddress,
                initialValue: controller.email.value,
                text: controller.email.value,
                onChanged: (String value) {
                  // Theo dõi khi người dùng thay đổi email, và cập nhật giá trị vào controller.email
                  if (!validText(value) && value.contains(' ')) {
                    return;
                  }
                  controller.email.value = value;
                },
                enabled:
                    // Nếu screenType là kApiSignInGoogle, không cho phép người dùng chỉnh sửa email.
                    controller.signUpRequest.screenType == kApiSignInGoogle
                        ? false
                        : true,
                iconLeft: MyImage.ic_email,
              ),
            ),
            const Spacer(),
            _buttonSubmit(),
          ],
        ),
      ),
    );
  }

  _buttonSubmit() => Obx(
    () =>
        InkWell(
          splashColor: Vx.white,
          highlightColor: Vx.white,
          onTap:
              controller.email.value.isEmpty
                  ? null
                  : () {
                    if (!validEmail(controller.email.value) ||
                        controller.email.value.contains(' ')) {
                      showModalSheet(title: kValidEmail, message: kInputAgain);
                      return;
                    }
                    controller.signUpRequest.email = controller.email.value;
                    controller.requestOtp();
                  },
          child: Container(
            height: 48.h,
            width: 263.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.r),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  const Color(
                    0xFFF54351,
                  ).withOpacity(controller.email.value.isEmpty ? 0.2 : 1),
                  const Color(
                    0xFFD0008F,
                  ).withOpacity(controller.email.value.isEmpty ? 0.2 : 1),
                ],
              ),
            ),
            child: Text(
              getLocalize(kNext),
              style: MyStyle.typeBold.copyWith(
                color: MyColor.white,
                fontSize: 16.sp,
              ),
            ),
          ),
        ).centered(),
  );
}


/*
Tóm tắt:
1. InputEmailScreen là một màn hình nhập email trong quá trình đăng ký hoặc đăng nhập người dùng.
2. GetView<InputEmailController> được sử dụng để tự động kết nối với InputEmailController mà không cần gọi Get.find().
3. CustomScaffold là một widget tùy chỉnh để bọc toàn bộ giao diện màn hình, giúp đảm bảo hiển thị đúng trên các thiết bị có các yếu tố hệ thống như thanh trạng thái.
4. TextFieldUnderline cung cấp một giao diện nhập liệu tùy chỉnh cho email.
5. _buttonSubmit() là nút tiếp theo, thực hiện kiểm tra tính hợp lệ của email và yêu cầu mã OTP
 */