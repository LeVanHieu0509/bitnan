import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:bitnan/@core/data/repo/model/request_change_pass.dart';
import 'package:bitnan/@core/router/pages.dart';
import 'package:bitnan/@share/constants/language.constant.dart';
import 'package:bitnan/@share/constants/value.constant.dart';
import 'package:bitnan/@share/utils/util.dart';
import 'package:bitnan/@share/widget/image/image.widget.dart';
import 'package:bitnan/@share/widget/scaffold.widget.dart';
import 'package:bitnan/resource/color.resource.dart';
import 'package:bitnan/resource/image.resource.dart';
import 'package:bitnan/resource/style.resource.dart';
import 'package:bitnan/screen/main/person/person.controller.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:velocity_x/velocity_x.dart';

class PersonScreen extends GetWidget<PersonController> {
  const PersonScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      titleAppBar: getLocalize(kPerson),
      body: _buildContentLayout(),
    );
  }

  _buildContentLayout() =>
      VStack([
        ImageCaches(
          url: MyImage.ic_banner_referral,
          width: Get.width,
          height: 112.h,
          borderRadius: BorderRadius.circular(4.0),
          fit: BoxFit.cover,
        ),
        32.h.heightBox,
        _itemFirst()
            .padding(EdgeInsets.symmetric(vertical: 24.h))
            .withDecoration(_buildBoxBorder())
            .make(),
        //Secret
        _itemTitle(content: getLocalize(kSecret)),
        _itemSecret()
            .padding(EdgeInsets.symmetric(vertical: 24.h))
            .withDecoration(_buildBoxBorder())
            .make(),
        // Other
        _itemTitle(content: getLocalize(kOther)),
        _itemOther()
            .padding(EdgeInsets.symmetric(vertical: 24.h))
            .withDecoration(_buildBoxBorder())
            .make(),
        ..._listCommunity(),
        _buttonLogout(),
        _buttonRemoveAccount(),
        ImageCaches(
          url: MyImage.ic_copyright,
          height: 24.h,
          width: 100.w,
        ).centered(),
        8.h.heightBox,
        Obx(
          () =>
              Text(
                controller.version.value,
                style: MyStyle.typeRegular.copyWith(
                  fontSize: 13.sp,
                  color: MyColor.grayDark_29.withOpacity(0.6),
                ),
              ).centered(),
        ),
        (kToolbarHeight * 1.7).heightBox,
      ]).scrollVertical(physics: const BouncingScrollPhysics()).p12();

  VxBox _itemFirst() {
    return VxBox(
      child: Column(
        children: [
          _item(
            _itemBox(
              url: MyImage.ic_profile,
              title: getLocalize(kMyProfile),
              action: _gotoPersonInfo,
            ),
          ),
          Obx(
            () => controller.isAppleReview.value ? 0.heightBox : 32.h.heightBox,
          ),
          _itemBox(
            url: MyImage.icon_reward,
            title: getLocalize(kIntroFriend),
            action: () => controller.goConnectScreenMain(),
          ),
          32.h.heightBox,
          _itemBox(
            url: MyImage.ic_statistical,
            title: getLocalize(kStatistical),
            action: () => showNewFeature(),
          ),
        ],
      ),
    );
  }

  Widget _item(Widget item) {
    return Obx(
      () => controller.isAppleReview.value ? const SizedBox.shrink() : item,
    );
  }

  VxBox _itemSecret() {
    return VxBox(
      child: Column(
        children: [
          Obx(
            () => _itemBox(
              url: MyImage.ic_phone_new,
              title: getLocalize(kVerifyPhone),
              action: () {
                if (controller.kUserKyc.value != kKycStatus) {
                  controller.onVerifyPhone();
                }
              },
              icRight:
                  controller.kUserKyc.value == kKycStatus
                      ? MyImage.ic_verify_phone
                      : MyImage.ic_not_verify_phone,
            ),
          ),
          Obx(
            () => controller.isAppleReview.value ? 0.heightBox : 32.h.heightBox,
          ),
          _item(
            _itemBox(
              url: MyImage.ic_lock_new,
              title: getLocalize(kChangePass),
              action: _gotoChangePassword,
            ),
          ),
          Obx(
            () => controller.isAppleReview.value ? 0.heightBox : 32.h.heightBox,
          ),
          _item(
            _itemSwitch(
              url: MyImage.setting_face_id,
              title: getLocalize(kTouchIdFaceId),
              child: _itemTouchId(),
            ),
          ),
          32.heightBox,
          _itemSwitch(
            url: MyImage.ic_notify,
            title: getLocalize(kEnableNoti),
            child: _itemNotification(),
          ),
        ],
      ),
    );
  }

  VxBox _itemOther() {
    return VxBox(
      child: Column(
        children: [
          //TODO hide ToggleLang
          // _itemSwitch(
          //     url: MyImage.ic_change_language,
          //     title: getLocalize(kLanguage),
          //     child: Obx(() => AnimatedToggle(
          //           value: controller.lang.value,
          //           values: ['VN', 'EN'],
          //           onToggleCallback: (value) {
          //             controller.settingLanguage(value);
          //           },
          //         ))),
          // 32.h.heightBox,
          _itemBox(
            url: MyImage.ic_term,
            title: getLocalize(kTerm),
            action: _gotoTerm,
          ),
        ],
      ),
    );
  }

  _imageCommunity(String path, String key) {
    return ImageCaches(url: path, height: 40.w, width: 40.w).onTap(() {
      _gotoSupport(key);
    });
  }

  _listCommunity() {
    return [
      Text(
        getLocalize(kCommunityBitback),
        style: MyStyle.typeRegular.copyWith(fontSize: 15.sp),
      ).centered().marginOnly(top: 32.h, bottom: 20.h),
      HStack(
        [
          _imageCommunity(MyImage.ic_fb, SUPPORT_FANPAGE),
          24.w.widthBox,
          _imageCommunity(MyImage.ic_twitter, SUPPORT_TW),
          24.w.widthBox,
          _imageCommunity(MyImage.ic_telegram, SUPPORT_TELE),
          24.w.widthBox,
          _imageCommunity(MyImage.ic_zalo, SUPPORT_ZALO),
        ],
        axisSize: MainAxisSize.min,
        alignment: MainAxisAlignment.spaceAround,
      ).centered().marginOnly(bottom: 16.h),
      HStack([
        _imageCommunity(MyImage.ic_youtube, SUPPORT_YT),
        24.w.widthBox,
        _imageCommunity(MyImage.ic_tiktok, SUPPORT_TT),
        24.w.widthBox,
        _imageCommunity(MyImage.ic_brower, SUPPORT_BR),
      ]).centered(),
    ];
  }

  _gotoSupport(String key) async {
    final url = controller.getSupport(key: key);
    if (url.isNotEmpty && await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      // showNewFeature();
    }
  }

  Widget _itemTitle({required String content}) => content.text
      .size(16.sp)
      .textStyle(MyStyle.typeBold)
      .color(MyColor.black)
      .make()
      .pOnly(top: 24, bottom: 8);

  _buildBoxBorder() => BoxDecoration(
    borderRadius: BorderRadius.circular(4.r),
    border: Border.all(color: MyColor.grayDark.withOpacity(0.15)),
  );

  _gotoPersonInfo() async {
    await controller.getProfile();
    await goTo(
      screen: ROUTER_PERSON_INFO,
      argument: controller.user.value,
    )?.then((value) {
      if (value != null) {
        controller.getProfile();
        controller.kUserKyc.value = kKycStatus;
      }
    });
  }

  _gotoChangePassword() {
    RequestChangePass request = RequestChangePass(type: kTypePersonScreen);

    goTo(screen: ROUTER_PASSWORD, argument: request);
  }

  _gotoTerm() => goTo(screen: ROUTER_TERM);

  _itemTouchId() {
    return GestureDetector(
      onTap: () async {
        controller.actionAuthenticate();
      },
      child: Obx(
        () => Container(
          width: 32.0,
          height: 20.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            image:
                !controller.isAllowFaceId.value
                    ? const DecorationImage(
                      image: AssetImage(MyImage.ic_toggle_disable),
                      fit: BoxFit.fill,
                    )
                    : const DecorationImage(
                      image: AssetImage(MyImage.ic_toggle_enable),
                      fit: BoxFit.fill,
                    ),
          ),
          child: Align(
            alignment:
                controller.isAllowFaceId.value
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
            child: Container(
              width: 16.0,
              height: 16.0,
              margin: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient:
                    controller.isAllowFaceId.value
                        ? const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xFFF54351), Color(0xFFD0008F)],
                        )
                        : null,
                color:
                    controller.isAllowFaceId.value
                        ? null
                        : MyColor.grayDark.withOpacity(0.3),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _itemNotification() {
    return GestureDetector(
      onTap: () async {
        controller.settingNotification(value: !controller.isAllowNotify.value);
      },
      child: Obx(
        () => Container(
          width: 32.0,
          height: 20.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            image:
                !controller.isAllowNotify.value
                    ? const DecorationImage(
                      image: AssetImage(MyImage.ic_toggle_disable),
                      fit: BoxFit.fill,
                    )
                    : const DecorationImage(
                      image: AssetImage(MyImage.ic_toggle_enable),
                      fit: BoxFit.fill,
                    ),
          ),
          child: Align(
            alignment:
                controller.isAllowNotify.value
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
            child: Container(
              width: 16.0,
              height: 16.0,
              margin: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient:
                    controller.isAllowNotify.value
                        ? const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xFFF54351), Color(0xFFD0008F)],
                        )
                        : null,
                color:
                    controller.isAllowNotify.value
                        ? null
                        : MyColor.grayDark.withOpacity(0.3),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _itemSwitch({
    required String url,
    required String title,
    required Widget child,
  }) {
    return Row(
      children: [
        ImageCaches(
          url: url,
          height: 24.w,
          width: 24.w,
        ).marginOnly(left: 16, right: 12),
        Text(
          title,
          style: MyStyle.typeRegular.copyWith(
            fontSize: 16.sp,
            color: MyColor.black,
          ),
        ),
        const Spacer(),
        child.marginOnly(right: 16),
      ],
    );
  }

  _itemBox({
    required String url,
    required String title,
    required VoidCallback action,
    String icRight = MyImage.ic_arrow_right,
  }) {
    return GestureDetector(
      onTap: () {
        action.call();
      },
      behavior: HitTestBehavior.translucent,
      child: Row(
        children: [
          ImageCaches(
            url: url,
            height: 24.w,
            width: 24.w,
          ).marginOnly(left: 16, right: 12),
          Text(
            title,
            style: MyStyle.typeRegular.copyWith(
              fontSize: 16.sp,
              color: MyColor.black,
            ),
          ),
          const Spacer(),
          ImageCaches(
            url: icRight,
            height: 24,
            width: 24,
            color:
                icRight == MyImage.ic_arrow_right
                    ? MyColor.grayDark_29.withOpacity(0.6)
                    : null,
          ).marginOnly(right: 16),
        ],
      ),
    );
  }

  _buttonLogout() {
    return InkWell(
      splashColor: Vx.white,
      highlightColor: Vx.white,
      onTap: () {
        controller.logout();
      },
      child: Container(
        height: 48.h,
        width: 263.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: MyColor.grayDark_29.withOpacity(0.6),
        ),
        child: Text(
          getLocalize(kLogout),
          style: MyStyle.typeBold.copyWith(
            color: MyColor.white,
            fontSize: 16.sp,
          ),
        ),
      ),
    ).centered().marginOnly(top: 36.h);
  }

  _buttonRemoveAccount() {
    return InkWell(
      splashColor: Vx.white,
      highlightColor: Vx.white,
      onTap: () {
        controller.removeAccount();
      },
      child: Container(
        height: 48.h,
        width: 263.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: MyColor.grayDark_29.withOpacity(0.6),
        ),
        child: Text(
          getLocalize('Xóa tài khoản'),
          style: MyStyle.typeBold.copyWith(
            color: MyColor.white,
            fontSize: 16.sp,
          ),
        ),
      ),
    ).centered().marginOnly(top: 36.h, bottom: 24.h);
  }
}
