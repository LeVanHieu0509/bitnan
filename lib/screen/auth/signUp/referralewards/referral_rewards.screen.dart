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

/*
- ReferralRewardScreen là một stateless widget kế thừa từ GetWidget<ReferralRewardController>, 
giúp liên kết trực tiếp với ReferralRewardController mà không cần phải gọi Get.find().
- Màn hình này cho phép người dùng nhập mã Referral Code (mã giới thiệu) và nhận thưởng sau khi nhập mã hợp lệ.
 */

class ReferralRewardScreen extends GetWidget<ReferralRewardController> {
  const ReferralRewardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Đây là một widget tùy chỉnh thay thế Scaffold của Flutter, giúp tạo các phần tử UI như app bar và body.

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
            // Lấy văn bản từ hệ thống localization (với khóa kEnterOtp) và hiển thị thông báo yêu cầu người dùng nhập OTP.
            Text(
              getLocalize(kTitleReferralReward),
              style: MyStyle.typeBold.copyWith(
                fontSize: 18.sp,
                color: MyColor.black,
              ),
            ),
            16.h.heightBox,
            Row(
              // Sử dụng ItemDot để tạo các chấm chỉ báo tiến trình trong màn hình đăng ký.
              children: const [
                ItemDot(isActive: true),
                ItemDot(isActive: true),
                ItemDot(isActive: true),
                ItemDot(),
              ],
            ),
            40.h.heightBox,
            Obx(
              // Làm cho widget này phản ứng với các thay đổi trong controller.refCode.
              // Nếu người dùng thay đổi mã giới thiệu, giá trị này sẽ được lưu vào controller.refCode.
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
                  // Khi người dùng nhấn vào văn bản "Skip Login", sẽ quay lại màn hình tạo mật khẩu (sign up).
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
            // Nút xác nhận (Next) sẽ gọi controller.onSubmit() khi người dùng nhấn vào.
            // Trước khi gửi, mã giới thiệu phải hợp lệ (8 ký tự và không chứa ký tự không hợp lệ như "@" nếu không phải email).
            SubmitButton2(
              text: getLocalize(kNext),
              action: () {
                // Nếu mã không hợp lệ (dài dưới 8 ký tự hoặc chứa ký tự không hợp lệ như "@"), hiển thị modal yêu cầu người dùng nhập lại.
                if (controller.refCode.value.trim().length < 8 ||
                    controller.refCode.value.isEmpty ||
                    controller.refCode.value.contains('@') &&
                        !validEmail(controller.refCode.value)) {
                  showModalSheet(
                    title: kInputReferralReward,
                    message: kInputReferralAgain,
                  );
                } else {
                  // Nếu hợp lệ, gọi submitReferralReward() để xử lý yêu cầu nhận thưởng.
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

/*
Tóm tắt các tính năng chính:
1. Referral Code Input: Màn hình cho phép người dùng nhập mã giới thiệu (Referral Code).
2. Chức năng xác nhận mã giới thiệu: Kiểm tra tính hợp lệ của mã giới thiệu và gửi yêu cầu nhận thưởng.
3. Các nút và hành động:
- SubmitButton2: Nút xác nhận sẽ kiểm tra tính hợp lệ của mã nhập vào.
- ItemDot: Hiển thị chỉ báo tiến trình trong quá trình nhập liệu.
 */
