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

// SignUpScreen kế thừa từ GetView<SignUpController>,
// nghĩa là màn hình này sẽ tự động truy cập controller SignUpController mà không cần phải gọi Get.find().
class SignUpScreen extends GetView<SignUpController> {
  // GetView giúp đơn giản hóa việc kết nối controller và widget trong GetX.
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Đây là một widget tùy chỉnh bao bọc toàn bộ giao diện để đảm bảo rằng nó sẽ hoạt động tốt trên các thiết bị với SafeArea
    // (khoảng an toàn cho UI để tránh bị che bởi các yếu tố hệ thống như notch, status bar, hoặc navigation bar).
    return CustomSafeView(
      top: false,
      child: Container(
        color: MyColor.colorContainer,
        child: SafeArea(
          child:
              // Sử dụng VelocityX để tạo một Column với các widget xếp theo chiều dọc.
              VStack(
                [
                  SizedBox(height: 32.h),
                  //TODO hide ToggleLang
                  //ToggleLang(),
                  Expanded(child: _itemLogo()),
                  // Dùng để nhận các hành động tap và long press trên văn bản.
                  GestureDetector(
                    onTap: () => controller.countPress++,
                    // onLongPress sẽ gọi specialEvent() trong controller khi người dùng nhấn lâu
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

  // Hiển thị các nút đăng nhập với Apple ID, Google, và Facebook
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

  // Hiển thị logo của ứng dụng từ MyImage.logo_bit_back. Sử dụng VelocityX để căn giữa logo trong màn hình.
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

/*
Tóm tắt:
  1. SignUpScreen sử dụng GetX để truy cập và điều khiển trạng thái của SignUpController.
  2. VStack và VelocityX được sử dụng để sắp xếp các widget theo chiều dọc.
  3. Các nền tảng xác thực như Apple ID, Google, và Facebook được tích hợp vào giao diện với các biểu tượng đăng nhập.
  4. Các sự kiện tap và long press được xử lý trong các widget như GestureDetector.
  5. CustomSafeView bảo vệ giao diện khỏi các phần bị che khuất do các yếu tố hệ thống như status bar.
 */
