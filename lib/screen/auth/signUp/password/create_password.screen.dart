import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bitnan/@share/common/password_input.dart';
import 'package:bitnan/@share/constants/language.constant.dart';
import 'package:bitnan/@share/utils/util.dart';
import 'package:bitnan/@share/widget/box/item_dot.dart';
import 'package:bitnan/@share/widget/button/submit.button.v2.dart';
import 'package:bitnan/@share/widget/scaffold.widget.dart';
import 'package:bitnan/resource/color.resource.dart';
import 'package:bitnan/resource/style.resource.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bitnan/screen/auth/signUp/password/create_password.controller.dart';
import 'package:velocity_x/velocity_x.dart';

/*
  CreatePasswordScreen kế thừa từ GetWidget<CreatePasswordController>. 
  Điều này giúp widget tự động liên kết với CreatePasswordController mà không cần phải gọi Get.find().
 */
class CreatePasswordScreen extends GetWidget<CreatePasswordController> {
  // formKey là khóa duy trì trạng thái của form, giúp xác thực các trường nhập liệu
  final formKey = GlobalKey<FormState>();

  CreatePasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isShowLeading:
          true, // Điều khiển xem có hiển thị nút quay lại (back button) hay không
      appBarColor: MyColor.white, // Màu nền cho AppBar
      body: Form(
        key:
            formKey, // Dùng để nhóm các trường nhập liệu lại với nhau, và kiểm tra tính hợp lệ của chúng
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hiển thị các văn bản yêu cầu người dùng nhập mật khẩu và xác nhận mật khẩu
              Text(
                getLocalize(kCreatePass),
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
                  ItemDot(isActive: true),
                  ItemDot(isActive: true),
                ],
              ),
              32.h.heightBox,
              Text(
                getLocalize(kNewPass),
                style: MyStyle.typeRegular.copyWith(
                  fontSize: 16.sp,
                  color: MyColor.black.withOpacity(0.5),
                ),
              ),
              16.h.heightBox,
              //  Hiển thị trường nhập mật khẩu đầu tiên
              _passwordInput(context),
              32.h.heightBox,
              Text(
                getLocalize(kInputPassAgain),
                style: MyStyle.typeRegular.copyWith(
                  fontSize: 16.sp,
                  color: MyColor.black.withOpacity(0.5),
                ),
              ),
              16.h.heightBox,
              // Hiển thị trường nhập lại mật khẩu để xác nhận
              passwordConfirmInput(context),
              const Spacer(),
              // Nút "Xác nhận" để người dùng gửi mật khẩu
              SubmitButton2(text: kConfirm, action: controller.handleSubmit),
              // _itemNumericKeyboard(),
            ],
          ),
        ),
      ),
    );
  }

  // là một widget tùy chỉnh dùng để nhập mật khẩu,
  // có thể điều chỉnh các thuộc tính như controller, onChanged, onCompleted.
  Widget _passwordInput(BuildContext context) => BBPasswordInput(
    appContext: context,
    autoFocus:
        true, // Trường mật khẩu đầu tiên sẽ tự động lấy tiêu điểm khi màn hình được mở
    controller: controller.passwordEditingController,
    onChanged:
        (v) =>
            controller.passWord.value =
                v, // Mỗi khi người dùng thay đổi mật khẩu, giá trị mới sẽ được gán vào controller.passWord.
    onCompleted: (v) => controller.passwordConfirmNode.requestFocus(),
  );

  // passwordConfirmInput: Tương tự như _passwordInput,
  // nhưng đây là trường để người dùng xác nhận mật khẩu đã nhập.
  Widget passwordConfirmInput(BuildContext context) => BBPasswordInput(
    appContext: context,
    focusNode: controller.passwordConfirmNode,
    controller: controller.passwordConfirmEditingController,
    onChanged: (v) => controller.confirmPass.value = v,
    onCompleted:
        (v) =>
            controller
                .handleSubmit(), //Khi người dùng nhập xong mật khẩu và nhấn "xác nhận", phương thức controller.handleSubmit() sẽ được gọi để xử lý.
  );
}
