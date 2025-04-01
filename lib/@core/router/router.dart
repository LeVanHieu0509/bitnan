import 'package:bitnan/@core/binding/create_pass_word.binding.dart';
import 'package:bitnan/@core/binding/input_email.binding.dart';
import 'package:bitnan/@core/binding/main.binding.dart';
import 'package:bitnan/@core/binding/otp.binding.dart';
import 'package:bitnan/@core/binding/referral_reward.binding.dart';
import 'package:bitnan/@core/binding/signIn.binding.dart';
import 'package:bitnan/@core/binding/signUp.binding.dart';
import 'package:bitnan/@core/binding/splash.binding.dart';
import 'package:bitnan/@core/binding/summary.binding.dart';
import 'package:bitnan/@core/binding/user_info.binding.dart';
import 'package:bitnan/@core/router/pages.dart';
import 'package:bitnan/screen/auth/signIn/signIn.screen.dart';
import 'package:bitnan/screen/auth/signUp/input_email/input_email.screen.dart';
import 'package:bitnan/screen/auth/signUp/otp/otp.screen.dart';
import 'package:bitnan/screen/auth/signUp/password/create_password.screen.dart';
import 'package:bitnan/screen/auth/signUp/referralewards/referral_rewards.screen.dart';
import 'package:bitnan/screen/auth/signUp/signUp.screen.dart';
import 'package:bitnan/screen/auth/signUp/userInfo/user_info.screen.dart';
import 'package:bitnan/screen/main/home/summary/summary.screen.dart';
import 'package:bitnan/screen/main/main.screen.dart';
import 'package:bitnan/screen/splash/splash.screen.dart';
import 'package:get/get.dart';

GetPage _initPage(router, fuc, bindings) =>
    GetPage(name: router, page: fuc, binding: bindings);

class Routers {
  static final route = [
    _initPage(ROUTER_SPLASH, () => const SplashScreen(), SplashBinding()),
    _initPage(ROUTER_SIGN_IN, () => const SignInScreen(), SignInBinding()),
    _initPage(ROUTER_SIGN_UP, () => const SignUpScreen(), SignUpBinding()),
    _initPage(ROUTER_MAIN_TAB, () => const MainScreen(), MainBinding()),
    _initPage(
      ROUTER_USER_INFO,
      () => const UserInfoScreen(),
      UserInfoBinding(),
    ),
    _initPage(
      ROUTER_INPUT_EMAIL,
      () => const InputEmailScreen(),
      InputEmailBinding(),
    ),
    _initPage(ROUTER_OTP, () => const OtpScreen(), OtpBinding()),
    _initPage(
      ROUTER_REFERRAL_REWARD,
      () => const ReferralRewardScreen(),
      ReferralRewardBinding(),
    ),
    _initPage(
      ROUTER_CREATE_PASS_WORD,
      () => CreatePasswordScreen(),
      CreatePassWordBinding(),
    ),
    _initPage(ROUTER_SUMMARY, () => const SummaryScreen(), SummaryBinding()),
  ];
}
