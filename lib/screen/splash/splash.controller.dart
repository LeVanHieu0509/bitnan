import 'dart:io';
import 'package:bitnan/@core/data/local/storage/data.storage.dart';
import 'package:bitnan/@core/data/repo/request/pass_code.request.dart';
import 'package:bitnan/@core/data/repo/user.repo.dart';
import 'package:bitnan/@core/router/pages.dart';
import 'package:bitnan/@core/service/dynamic_link.service.dart';
import 'package:bitnan/@share/constants/value.constant.dart';
import 'package:bitnan/@share/utils/util.dart';
import 'package:bitnan/config.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:package_info/package_info.dart';

class SplashController extends GetxController {
  var refCode = '';
  final userRepo = Get.find<UserRepo>();
  final _dynamicService = Get.find<DynamicLinkService>();
  final _storage = Get.find<DataStorage>();

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 2), () {
      print("delayed");

      checkMaintenance(
        callback: () {
          print(BBConfig.instance.isProd);
          if (BBConfig.instance.isProd) {
            checkAppVersion(callback: _jailbreakDetection);
          } else {
            print("_jailbreakDetection");
            _jailbreakDetection();
          }
        },
      );
    });
  }

  Future _getDynamicLink() async {
    if (Platform.isAndroid) {
      refCode = await _dynamicService.handleDynamicLinks();
    } else if (Platform.isIOS) {
      refCode = await _dynamicService.initUniLinks();
    }
  }

  Future<void> _jailbreakDetection() async {
    print("_jailbreakDetection");

    bool jailBroken;
    try {
      jailBroken = await FlutterJailbreakDetection.jailbroken;
    } on PlatformException {
      jailBroken = true;
    }
    if (!jailBroken) {
      _getDynamicLink();
      _validateLogin();
    } else {
      _getDynamicLink();
      _validateLogin();
      // showAlert(content: 'Please check your network configuration');
    }
  }

  Future _validateLogin() async {
    var data = Get.find<DataStorage>();
    getVersion(data);

    // final isInReview = await BBConfig.instance.isInReviewApple();
    // final pass = _storage.getPasscodeInReview();
    final pass = 2;
    if (pass == 1) {
      showLoading();
      var res = await userRepo.verifyPassCode(
        PassCodeRequest("123123", _storage.getRefreshToken()),
      );

      hideLoading();

      if (res.status == kSuccessApi) {
        await _storage.setToken(res.data);
        goToAndRemoveAll(screen: ROUTER_MAIN_TAB);
      } else {
        showAlert(content: res.getErrors());
      }
    } else {
      print({'fullname': data.getFullName().isEmpty});

      goToAndRemoveAll(
        screen: data.getFullName().isEmpty ? ROUTER_SIGN_UP : ROUTER_SIGN_IN,
        argument: data.getFullName().isEmpty ? refCode : '',
      );
    }

    // Bypass Apple Review
  }

  void getVersion(DataStorage data) {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      if (packageInfo.version != data.getVersion()) {
        data.setVersion(packageInfo.version);
      }
    });
  }
}
