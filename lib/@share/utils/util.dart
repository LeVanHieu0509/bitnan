import 'package:bitnan/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info/package_info.dart';

widthScreen(double? percent) =>
    percent != null ? (Get.width * percent) / 100 : Get.width;

Future<void> checkMaintenance({VoidCallback? callback}) async {
  if (!BBConfig.instance.isProd) return callback?.call();
  try {
    // await BBConfig.instance.refresh();
    // var systemMaintain = BBConfig.instance.system_maintain;
    // if (systemMaintain) {
    //   showPopupMaintain(
    //     action: () {
    //       if (Platform.isIOS) {
    //         exit(0);
    //       } else {
    //         SystemNavigator.pop();
    //       }
    //     },
    //   );
    // } else if (callback != null) {
    //   callback();
    // }

    if (callback != null) {
      callback();
    }
  } catch (e) {
    print('Error: ${e.toString()}');
    if (callback != null) {
      callback();
    }
  }
}

Future<void> checkAppVersion({VoidCallback? callback}) async {
  try {
    // await BBConfig.instance.refresh();
    // final enforcedVer = BBConfig.instance.minimum_version;
    final packageInfo = await PackageInfo.fromPlatform();
    // if (needsUpdate(packageInfo.version, enforcedVer)) {
    //   showPopupUpdateVersion(action: () {
    //     // Open PlayStore or AppStore
    //     if (Platform.isIOS) {
    //       openLink(
    //           'https://apps.apple.com/us/app/bitback-nh%E1%BA%ADn-th%C6%B0%E1%BB%9Fng-bitcoin/id1564273275');
    //     } else {
    //       openLink('https://play.google.com/store/apps/details?id=vn.trustpay');
    //     }
    //   });
    // } else if (callback != null) {
    //   callback();
    // }

    if (callback != null) {
      callback();
    }
  } catch (e) {
    print('Error: ${e.toString()}');
    if (callback != null) {
      callback();
    }
  }
}
