import 'dart:io';
import 'package:bitnan/@core/data/local/storage/data.storage.dart';
import 'package:bitnan/@core/service/dynamic_link.service.dart';
import 'package:bitnan/@share/utils/util.dart';
import 'package:bitnan/config.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:package_info/package_info.dart';

class SplashController extends GetxController {
  var refCode = '';
  final _dynamicService = Get.find<DynamicLinkService>();

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 2), () {
      checkMaintenance(
        callback: () {
          if (BBConfig.instance.isProd) {
            checkAppVersion(callback: _jailbreakDetection);
          } else {
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

    print(data);
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
