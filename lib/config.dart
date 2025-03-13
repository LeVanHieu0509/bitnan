import 'dart:io';
import 'dart:io' show Platform;

import 'package:package_info/package_info.dart';

import '@share/constants/value.constant.dart';

class BBConfig {
  /// Singleton
  BBConfig._();
  static final BBConfig _instance = BBConfig._();
  static BBConfig get instance => _instance;
  var base_url = prodServer;

  setBaseUrl(url) {
    base_url = url;
  }

  getBaseUrl() {
    return base_url;
  }

  bool get isProd => base_url == prodServer;

  // FirebaseRemoteConfig get _frc => FirebaseRemoteConfig.instance;
  Future<void> refresh() => Future.value();
  bool get system_maintain => false;

  // bool get system_maintain => isProd ? _frc.getBool(SYSTEM_MAINTAIN) : false;
  // String get support_fanpage => isProd ? _frc.getString(SUPPORT_FANPAGE) : '';
  // String get support_zalo => isProd ? _frc.getString(SUPPORT_ZALO) : '';
  // String get support_telegram => isProd ? _frc.getString(SUPPORT_TELE) : '';
  // String get support_twitter => isProd ? _frc.getString(SUPPORT_TW) : '';
  // String get support_youtube => isProd ? _frc.getString(SUPPORT_YT) : '';
  // String get support_tiktok => isProd ? _frc.getString(SUPPORT_TT) : '';
  // String get support_browser => isProd ? _frc.getString(SUPPORT_BR) : '';

  // String get minimum_version => isProd
  //     ? Platform.isIOS
  //         ? _frc.getString('minimum_version_ios')
  //         : _frc.getString('minimum_version_android')
  //     : '';
  // String get apple_review_version =>
  //     isProd ? _frc.getString('apple_review_version') : '';

  // bool get referral_leaderboard =>
  //     isProd ? _frc.getBool(SUPPORT_LEADER_BOARD) : false;

  // String get base_url_game => isProd
  //     ? _frc.getString(BASE_URL_GAME)
  //     : kIsEnvProd
  //         ? 'https://bitplay-membership-api.bitback.community/api/'
  //         : 'https://bitplay-uat-membership-api.bitback.vn/api/';

  String get android_ad_unit_id =>
      kIsEnvProd
          ? 'ca-app-pub-5832491763812561/3575839155'
          : 'ca-app-pub-3940256099942544/5224354917';

  String get ios_ad_unit_id =>
      kIsEnvProd
          ? 'ca-app-pub-5832491763812561/5379149063'
          : 'ca-app-pub-3940256099942544/1712485313';

  String get ad_unit_id =>
      Platform.isAndroid ? android_ad_unit_id : ios_ad_unit_id;

  // Future<bool> isInReviewApple() async {
  //   final packageInfo = await PackageInfo.fromPlatform();
  //   return apple_review_version == packageInfo.version;
  // }
}
