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

class CreatePasswordScreen extends GetWidget<CreatePasswordController> {
  final formKey = GlobalKey<FormState>();

  CreatePasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isShowLeading: true,
      appBarColor: MyColor.white,
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              passwordConfirmInput(context),
              const Spacer(),
              SubmitButton2(text: kConfirm, action: controller.handleSubmit),
              // _itemNumericKeyboard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _passwordInput(BuildContext context) => BBPasswordInput(
    appContext: context,
    autoFocus: true,
    controller: controller.passwordEditingController,
    onChanged: (v) => controller.passWord.value = v,
    onCompleted: (v) => controller.passwordConfirmNode.requestFocus(),
  );

  Widget passwordConfirmInput(BuildContext context) => BBPasswordInput(
    appContext: context,
    focusNode: controller.passwordConfirmNode,
    controller: controller.passwordConfirmEditingController,
    onChanged: (v) => controller.confirmPass.value = v,
    onCompleted: (v) => controller.handleSubmit(),
  );
}
