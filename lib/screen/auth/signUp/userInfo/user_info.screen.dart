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
              () => TextFieldUnderline(
                hintText: kFullName,
                text: controller.fullName.value,
                initialValue: controller.fullName.value,
                onChanged: (String value) {
                  if (!validText(value) && value.contains(' ')) {
                    return;
                  }
                  controller.fullName.value = value;
                },
                iconLeft: MyImage.ic_profile,
              ),
            ),
            const Spacer(),
            _buttonSubmit(),
          ],
        ),
      ),
    );
  }

  _buttonSubmit() =>
      InkWell(
        splashColor: Vx.white,
        highlightColor: Vx.white,
        onTap: () {
          if (controller.fullName.value.isNotEmpty) {
            controller.signUpRequest.fullName = controller.fullName.value;
            goTo(
              screen: ROUTER_INPUT_EMAIL,
              argument: controller.signUpRequest,
            );
          }
        },
        child: Obx(
          () => Container(
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
