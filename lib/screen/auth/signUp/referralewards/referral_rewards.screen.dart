import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bitnan/@core/router/pages.dart';
import 'package:bitnan/@share/constants/language.constant.dart';
import 'package:bitnan/@share/utils/util.dart';
import 'package:bitnan/@share/widget/box/item_dot.dart';
import 'package:bitnan/@share/widget/button/submit.button.v2.dart';
import 'package:bitnan/@share/widget/scaffold.widget.dart';
import 'package:bitnan/@share/widget/text/text_field_underline.dart';
import 'package:bitnan/resource/color.resource.dart';
import 'package:bitnan/resource/image.resource.dart';
import 'package:bitnan/resource/style.resource.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:velocity_x/velocity_x.dart';
import 'referral_reward.controller.dart';

class ReferralRewardScreen extends GetWidget<ReferralRewardController> {
  const ReferralRewardScreen({Key? key}) : super(key: key);

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
              getLocalize(kTitleReferralReward),
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
                ItemDot(),
              ],
            ),
            40.h.heightBox,
            Obx(
              () => TextFieldUnderline(
                hintText: kInputReferralReward,
                onChanged: (String value) {
                  print({value});
                  if (!validText(value) && value.contains(' ')) {
                    return;
                  }
                  controller.refCode.value = value;
                },
                enabled: controller.enableRefCode.value,
                iconLeft: MyImage.icon_reward,
                iconRight: MyImage.icon_question,
                text: controller.refCode.value,
                sizeIcRight: 18,
                actionRight: () {
                  controller.getReferralReward();
                },
              ),
            ),
            const Spacer(),
            Text(
                  getLocalize(kSkipLogin),
                  style: MyStyle.typeBold.copyWith(
                    fontSize: 16.sp,
                    color: MyColor.grayDark.withOpacity(0.5),
                  ),
                )
                .onTap(() {
                  // hideKeyboard();
                  controller.signUpRequest.referralBy = '';
                  controller.refCode.value = '';
                  goTo(
                    screen: ROUTER_CREATE_PASS_WORD,
                    argument: controller.signUpRequest,
                  );
                })
                .marginOnly(bottom: 40.h)
                .centered(),
            SubmitButton2(
              text: getLocalize(kNext),
              action: () {
                if (controller.refCode.value.trim().length < 8 ||
                    controller.refCode.value.isEmpty ||
                    controller.refCode.value.contains('@') &&
                        !validEmail(controller.refCode.value)) {
                  showModalSheet(
                    title: kInputReferralReward,
                    message: kInputReferralAgain,
                  );
                } else {
                  controller.onSubmit();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
