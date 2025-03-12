import 'dart:ui';

import 'package:bitnan/@share/localize/en_US.localize.dart';
import 'package:bitnan/@share/localize/vi_VN.localize.dart';
import 'package:get/get.dart';

class Localizes extends Translations {
  static final locale = Get.deviceLocale;
  static const fallbackLocale = Locale('vi', 'VN');

  @override
  Map<String, Map<String, String>> get keys => {'vi_VN': vi_VN, 'en_US': en_US};
}
