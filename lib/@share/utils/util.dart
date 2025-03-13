import 'dart:io';

import 'package:bitnan/@share/constants/language.constant.dart';
import 'package:bitnan/@share/constants/value.constant.dart';
import 'package:bitnan/@share/widget/image/image.widget.dart';
import 'package:bitnan/@share/widget/loading/loading.dart';
import 'package:bitnan/config.dart';
import 'package:bitnan/resource/color.resource.dart';
import 'package:bitnan/resource/image.resource.dart';
import 'package:bitnan/resource/style.resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:dio/dio.dart' as dio;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

getLocalize(String key, {List<String>? args}) =>
    args != null ? key.trArgs(args) : key.tr;
goBack({dynamic argument}) => Get.back(result: argument);
getArgument() => Get.arguments;
Future? goTo({required String screen, dynamic argument}) =>
    Get.toNamed(screen, arguments: argument);
widthScreen(double? percent) =>
    percent != null ? (Get.width * percent) / 100 : Get.width;
Future<T?>? goToAndRemove<T>({required String screen, dynamic argument}) =>
    Get.offNamed<T>(screen, arguments: argument);
Future<T?>? goToAndRemoveAll<T>({required String screen, dynamic argument}) =>
    Get.toNamed<T>(screen, arguments: argument);

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

getDecoration({BorderRadiusGeometry? borderRadius, double opacity = 1}) =>
    BoxDecoration(
      borderRadius: borderRadius ?? BorderRadius.circular(4.r),
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          const Color(0xFFF54351).withOpacity(opacity),
          const Color(0xFFD0008F).withOpacity(opacity),
        ],
      ),
    );

Future<void> showModalSheet({
  String url = MyImage.ic_error_square,
  String? title = kTitlePass,
  String message = kInputAgain,
  bool useRichText = false,
  String button = 'OK',
  Color? colorRich,
  bool dismissible = true,
  int? reward,
  double width = 64,
  String? tryAgain,
  TextStyle? styleTitle,
  double height = 64,
  VoidCallback? action,
}) {
  return showModalBottomSheet(
    context: Get.context!,
    isDismissible: dismissible,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(4.r)),
    ),
    clipBehavior: Clip.antiAliasWithSaveLayer,
    builder: (_) {
      return Container(
        color: MyColor.white,
        height: 375.h,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            Container(
              height: 3.h,
              width: 64.w,
              margin: EdgeInsets.only(top: 16.h, bottom: 28.h),
              decoration: BoxDecoration(color: MyColor.gray.withOpacity(0.15)),
            ),
            ImageCaches(
              url: url,
              height: height.w,
              width: width.w,
              fit: BoxFit.contain,
            ),
            32.h.heightBox,
            Text(
              getLocalize(title ?? kTitlePass),
              textAlign: TextAlign.center,
              style:
                  styleTitle != null
                      ? styleTitle.copyWith(fontSize: 16.sp)
                      : MyStyle.typeRegular.copyWith(fontSize: 16.sp),
            ),
            8.h.heightBox,
            useRichText
                ? RichText(
                  text: TextSpan(
                    text: getLocalize(''),
                    style: MyStyle.typeRegular.copyWith(fontSize: 16.sp),
                    children: [
                      TextSpan(
                        text: getLocalize(message, args: ['$reward']),
                        style: MyStyle.typeRegular.copyWith(fontSize: 16.sp),
                      ),
                      TextSpan(
                        text: '$reward SAT',
                        style: MyStyle.typeBold.copyWith(
                          fontSize: 16.sp,
                          color: colorRich ?? const Color(0xFFFF005D),
                        ),
                      ),
                    ],
                  ),
                )
                : Text(
                  getLocalize(message),
                  textAlign: TextAlign.center,
                  style: MyStyle.typeRegular.copyWith(fontSize: 16.sp),
                ),
            if (tryAgain != null) ...[
              8.h.heightBox,
              Text(
                getLocalize(tryAgain),
                style: MyStyle.typeRegular.copyWith(fontSize: 16.sp),
              ),
            ],
            const Spacer(),
            InkWell(
              splashColor: Vx.white,
              highlightColor: Vx.white,
              onTap: () {
                goBack();
                action?.call();
              },
              child: Container(
                height: 48.h,
                width: Get.width,
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 32.w),
                decoration: getDecoration(),
                child: Text(
                  getLocalize(button),
                  style: MyStyle.typeBold.copyWith(
                    color: MyColor.white,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
            56.h.heightBox,
          ],
        ),
      );
    },
  );
}

Future showDialogConfirm({
  String? title,
  String? content,
  bool dismissible = true,
  VoidCallback? onCancel,
  VoidCallback? onConfirm,
}) async {
  if (content == SYSTEM_MAINTAIN) {
    showPopupMaintain(
      action: () async {
        _fetchRemoteConfig();
      },
    );
  } else {
    VxDialog.showConfirmation(
      Get.context!,
      title: title ?? getLocalize(kNotify),
      content: content ?? getLocalize(kError),
      cancelBgColor: Vx.white,
      confirmBgColor: Vx.white,
      cancelTextColor: MyColor.blueTeal,
      confirmTextColor: MyColor.grayDark,
      cancel: getLocalize(kCancel),
      confirm: getLocalize(kConfirm),
      onCancelPress: onCancel,
      barrierDismissible: dismissible,
      onConfirmPress: onConfirm,
    );
  }
}

showPopupMaintain({VoidCallback? action}) {
  Get.dialog(
    WillPopScope(
      onWillPop: () async {
        if (Platform.isIOS) {
          exit(0);
        } else {
          SystemNavigator.pop();
        }
        return false;
      },
      child: VxBox(
            child: VStack([
              ImageCaches(
                url: MyImage.ic_system_maintain,
                borderRadius: BorderRadius.circular(16.0),
                height: 140,
                width: 240,
              ),
              // _itemNote(getLocalize(kSystemUpgrades)),
              // ButtonSubmit(
              //   title: getLocalize(kComeBackLate),
              //   action: () {
              //     goBack();
              //     if (action != null) {
              //       action.call();
              //     }
              //   },
              // )
            ], crossAlignment: CrossAxisAlignment.center),
          )
          .withRounded(value: 21)
          .height(350)
          .alignCenter
          .color(MyColor.white)
          .makeCentered()
          .marginSymmetric(horizontal: 20.0),
    ),
    barrierDismissible: false,
  );
}

_fetchRemoteConfig() async {
  if (!BBConfig.instance.isProd) return;
  try {
    await BBConfig.instance.refresh();
    var systemMaintain = BBConfig.instance.system_maintain;
    if (systemMaintain == true) {
      showPopupMaintain(
        action: () async {
          await _fetchRemoteConfig();
        },
      );
    }
  } catch (e) {
    print('Error: ${e.toString()}');
  }
}
