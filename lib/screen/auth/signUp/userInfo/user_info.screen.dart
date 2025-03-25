import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bitnan/@core/router/pages.dart';
import 'package:bitnan/@share/constants/language.constant.dart';
import 'package:bitnan/@share/utils/util.dart';
import 'package:bitnan/@share/widget/box/item_dot.dart';
import 'package:bitnan/@share/widget/scaffold.widget.dart';
import 'package:bitnan/@share/widget/text/text_field_underline.dart';
import 'package:bitnan/resource/color.resource.dart';
import 'package:bitnan/resource/image.resource.dart';
import 'package:bitnan/resource/style.resource.dart';
import 'package:bitnan/screen/auth/signUp/userInfo/user_info.controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:velocity_x/velocity_x.dart';

/*
  UserInfoScreen là một stateless widget kế thừa từ GetWidget<UserInfoController>. 
  Điều này cho phép màn hình này tự động kết nối với UserInfoController mà không cần phải gọi Get.find().
*/

class UserInfoScreen extends GetWidget<UserInfoController> {
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              getLocalize(kUserInformation),
              style: MyStyle.typeBold.copyWith(
                fontSize: 18.sp,
                color: MyColor.black,
              ),
            ),
            16.h.heightBox,
            Row(
              children: const [
                ItemDot(isActive: true),
                ItemDot(),
                ItemDot(),
                ItemDot(),
              ],
            ),
            40.h.heightBox,
            Obx(
              // Được sử dụng để làm cho widget TextFieldUnderline tự động cập nhật khi controller.fullName.value thay đổi.
              () => TextFieldUnderline(
                hintText: kFullName,
                text: controller.fullName.value,
                initialValue: controller.fullName.value,
                onChanged: (String value) {
                  if (!validText(value) && value.contains(' ')) {
                    return;
                  }

                  // Widget tùy chỉnh cho trường nhập họ tên. Khi người dùng nhập, giá trị sẽ được cập nhật vào controller.fullName.
                  controller.fullName.value = value;
                },
                iconLeft: MyImage.ic_profile,
              ),
            ),
            const Spacer(),
            _buttonSubmit(), // Gọi phương thức này để tạo nút "Next" khi người dùng hoàn thành việc nhập thông tin.
          ],
        ),
      ),
    );
  }

  _buttonSubmit() =>
      // Tạo hiệu ứng khi người dùng nhấn vào nút "Next".
      InkWell(
        splashColor: Vx.white,
        highlightColor: Vx.white,
        onTap: () {
          //  Khi người dùng nhấn nút, nếu fullName không rỗng,
          // thông tin sẽ được lưu vào signUpRequest.fullName và điều hướng người dùng đến màn hình ROUTER_INPUT_EMAIL.
          if (controller.fullName.value.isNotEmpty) {
            controller.signUpRequest.fullName = controller.fullName.value;
            goTo(
              screen: ROUTER_INPUT_EMAIL,
              argument: controller.signUpRequest,
            );
          }
        },
        child: Obx(
          // Đảm bảo rằng giao diện nút sẽ được cập nhật khi controller.fullName.value thay đổi.
          () => Container(
            height: 48.h,
            width: 263.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.r),
              // Nút được tạo với hiệu ứng gradient và kiểu chữ Next.
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  const Color(
                    0xFFF54351,
                  ).withOpacity(controller.fullName.value.isEmpty ? 0.2 : 1),
                  const Color(
                    0xFFD0008F,
                  ).withOpacity(controller.fullName.value.isEmpty ? 0.2 : 1),
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
        ),
      ).centered();
}

/*
Tóm tắt về màn hình UserInfoScreen:
1. UserInfoScreen là màn hình nhập thông tin người dùng (họ tên) trong quá trình đăng ký tài khoản.
2. TextFieldUnderline cho phép người dùng nhập họ tên với sự hỗ trợ cập nhật giá trị trong controller.fullName.
3. _buttonSubmit() là nút "Next", sẽ kiểm tra xem người dùng đã nhập thông tin hợp lệ chưa và sau đó chuyển đến màn hình nhập email.
4. GetX được sử dụng để quản lý trạng thái và dữ liệu người dùng, 
bao gồm việc lưu giá trị vào signUpRequest và điều hướng đến các màn hình tiếp theo.
 */
