import 'dart:io';

import 'package:bitnan/@share/constants/language.constant.dart';
import 'package:bitnan/@share/constants/value.constant.dart';
import 'package:bitnan/@share/widget/loading/loading.dart';
import 'package:bitnan/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:dio/dio.dart' as dio;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';

getLocalize(String key, {List<String>? args}) =>
    args != null ? key.trArgs(args) : key.tr;

widthScreen(double? percent) =>
    percent != null ? (Get.width * percent) / 100 : Get.width;

Future<T?>? goToAndRemoveAll<T>({required String screen, dynamic argument}) =>
    Get.offAllNamed<T>(screen, arguments: argument);

Future<void> checkMaintenance({VoidCallback? callback}) async {
  print("checkMaintenance");

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

void showLoading([String? content]) async {
  EasyLoading.instance.boxShadow = <BoxShadow>[];
  await EasyLoading.show(indicator: const Loading());
}

void hideLoading() async => await EasyLoading.dismiss();

Future<dio.MultipartFile> initFile(String path) async {
  var fileName = path.split(Platform.pathSeparator).last;
  var mime = lookupMimeType(path) ?? '';
  return dio.MultipartFile.fromFileSync(
    path,
    filename: fileName,
    contentType: MediaType(mime.split('/').first, mime.split('/').last),
  );
}

int getTypeKyc(String type) {
  var result = 0;
  switch (type) {
    case kTypeIdentityCard:
      result = 1;
      break;
    case kTypeCitizenIdentity:
      result = 2;
      break;
    default:
      result = 3;
      break;
  }
  return result;
}

Future showAlert({
  String? title,
  String? content,
  String textConfirm = kConfirm,
  VoidCallback? onConfirm,
  bool dismissible = true,
}) async {
  if (content == SYSTEM_MAINTAIN) {}
}
