import 'package:biometric_storage/biometric_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:bitnan/@core/data/local/storage/data.storage.dart';
import 'package:bitnan/@core/data/repo/model/account_setting.model.dart';
import 'package:bitnan/@core/data/repo/model/config_bio.model.dart';
import 'package:bitnan/@core/data/repo/model/user.model.dart';
import 'package:bitnan/@core/data/repo/user.repo.dart';
import 'package:bitnan/@core/router/pages.dart';
import 'package:bitnan/@share/constants/language.constant.dart';
import 'package:bitnan/@share/constants/value.constant.dart';
import 'package:bitnan/@share/utils/util.dart';
import 'package:bitnan/config.dart';
import 'package:bitnan/resource/image.resource.dart';
import 'package:bitnan/screen/auth/signIn/widgets/modal_biometric.dart';
import 'package:bitnan/screen/main/main.controller.dart';

class PersonController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var user = UserModel().obs;
  var userRepo = Get.find<UserRepo>();
  var isAllowFaceId = false.obs;
  var isAppleReview = false.obs;
  var isAllowNotify = false.obs;
  var verifyProfile = false.obs;
  var version = ''.obs;
  var lang = ''.obs;
  var phoneNumber = ''.obs;
  var fanpage = ''.obs, zalo = ''.obs, telegram = ''.obs;
  var tiktok = ''.obs, youtube = ''.obs, twitter = ''.obs, browser = ''.obs;
  var support = true.obs;
  var kUserKyc = 0.obs;

  final _store = Get.find<DataStorage>();
  CanAuthenticateResponse? authenticateResponse;
  LocalAuthentication localAuthentication = LocalAuthentication();
  var setting = AccountSettingColor().obs;
  Animation? circleAnimation;
  late final AnimationController animationController;

  @override
  void onInit() {
    super.onInit();
    getInfo();
  }

  String getSupport({String key = ''}) {
    if (key == SUPPORT_FANPAGE) {
      return fanpage.value;
    } else if (key == SUPPORT_ZALO) {
      return zalo.value;
    } else if (key == SUPPORT_TELE) {
      return telegram.value;
    } else if (key == SUPPORT_YT) {
      return youtube.value;
    } else if (key == SUPPORT_TW) {
      return twitter.value;
    } else if (key == SUPPORT_BR) {
      return browser.value;
    } else if (key == SUPPORT_TT) {
      return tiktok.value;
    } else {
      return '';
    }
  }

  Future getInfo() async {
    showLoading();
    await getProfile();
    actionAllowNotify(_store.getNotification());
    actionChangeLanguage(_store.getLang());
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 60),
    );
    circleAnimation = AlignmentTween(
      begin: isAllowNotify.value ? Alignment.centerRight : Alignment.centerLeft,
      end: isAllowNotify.value ? Alignment.centerLeft : Alignment.centerRight,
    ).animate(
      CurvedAnimation(parent: animationController, curve: Curves.linear),
    );
    getVersion();
    fanpage.value = BBConfig.instance.support_fanpage;
    zalo.value = BBConfig.instance.support_zalo;
    telegram.value = BBConfig.instance.support_telegram;
    youtube.value = BBConfig.instance.support_youtube;
    twitter.value = BBConfig.instance.support_twitter;
    browser.value = BBConfig.instance.support_browser;
    tiktok.value = BBConfig.instance.support_tiktok;
    isAppleReview.value = await BBConfig.instance.isInReviewApple();
    checkAuthenticate();
    hideLoading();
  }

  getVersion() async {
    version.value = 'Version ${_store.getVersion()}';
  }

  void actionAllowFaceId(bool value) => isAllowFaceId.value = value;

  void actionAllowNotify(bool value) => isAllowNotify.value = value;

  void actionChangeLanguage(String value) => lang.value = value;

  Future getProfile() async {
    await userRepo.getProfile().then((value) {
      if (value.status == kSuccessApi) {
        user.value = value.data;
        phoneNumber.value = user.value.phone;
        kUserKyc.value = user.value.kycStatus;
      } else {
        printError(info: value.getErrors());
      }
    });
  }

  void actionAllowBios() {
    const FlutterSecureStorage().read(key: 'passcode').then((value) {
      if (value != null) {
        actionAllowFaceId(true);
      } else {
        actionAllowFaceId(false);
      }
    });
  }

  Future settingNotification({required bool value}) async {
    showLoading();
    var res = await userRepo.accountSetting(
      AccountSetting(
        language: user.value.setting?.language ?? 'VI',
        receiveNotify: value,
      ),
    );
    hideLoading();
    if (res.status == kSuccessApi) {
      if (res.data['status']) {
        isAllowNotify.value = value;
        if (animationController.isCompleted) {
          animationController.reverse();
        } else {
          animationController.forward();
        }
        _store.setNotification(value);
        update();
      }
    } else {
      showAlert(content: res.getErrors());
    }
  }

  Future settingLanguage(String value) async {
    showLoading();
    var res = await userRepo.accountSetting(
      AccountSetting(
        language: value,
        receiveNotify: user.value.setting?.receiveNotify ?? false,
      ),
    );
    hideLoading();
    if (res.status == kSuccessApi) {
      _store.setLang(value.toLowerCase());
      lang.value = value;
      if (value == 'VI') {
        var locale = const Locale('vi', 'VN');
        Get.updateLocale(locale);
      } else {
        var locale = const Locale('en', 'US');
        Get.updateLocale(locale);
      }
      update();
    } else {
      showAlert(content: res.getErrors());
    }
  }

  Future checkAuthenticate() async {
    final response = await BiometricStorage().canAuthenticate();
    authenticateResponse = response;
    const FlutterSecureStorage().read(key: 'passcode').then((value) {
      if (value != null) {
        actionAllowFaceId(true);
      }
    });
  }

  Future onVerifyPhone() async {
    showAlert(content: getLocalize(kMaintanceFeature));
    // showModalSheetVerifyPhone(
    //   action: (String phone) {
    //     kUserKyc.value = kKycStatus;
    //   },
    // );
  }

  void goConnectScreenMain() async {
    goBack();
    Get.find<MainController>().changePage(2);
  }

  void actionAuthenticate() async {
    if (authenticateResponse == CanAuthenticateResponse.unsupported) {
      showModalBottomSheet(
        context: Get.context!,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(4.r)),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder:
            (_) => ModalBiometric(
              url: MyImage.ic_touch_id,
              message: getLocalize(kDeviceUnSupport),
            ),
      );
      return;
    }
    if (authenticateResponse ==
        CanAuthenticateResponse.errorNoBiometricEnrolled) {
      showModalBottomSheet(
        context: Get.context!,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(4.r)),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder:
            (_) => ModalBiometric(
              url: MyImage.ic_face_id,
              message: getLocalize(kEnableTouchId),
            ),
      );
    }

    if (authenticateResponse == CanAuthenticateResponse.success ||
        authenticateResponse == CanAuthenticateResponse.statusUnknown) {
      await goTo(
        screen: ROUTER_SIGN_IN,
        argument: ConfigBioModel(
          isConfigBio: true,
          enable: isAllowFaceId.value,
        ),
      )?.then((data) {
        actionAllowBios();
      });
    }
  }

  Future logout() async {
    Get.deleteAll(force: true);
    goToAndRemoveAll(screen: ROUTER_SPLASH);
  }

  removeAccount() {
    showModalSheet(
      url: MyImage.ic_lock,
      title: getLocalize(kRemoveAccount),
      message: getLocalize(kInfoRemoveAccount),
      action: () {
        logout();
      },
    );
  }
}
