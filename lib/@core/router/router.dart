import 'package:bitnan/@core/binding/signIn.binding.dart';
import 'package:bitnan/@core/binding/signUp.binding.dart';
import 'package:bitnan/@core/binding/splash.binding.dart';
import 'package:bitnan/@core/router/pages.dart';
import 'package:bitnan/screen/auth/signIn/signIn.screen.dart';
import 'package:bitnan/screen/auth/signUp/signUp.screen.dart';
import 'package:bitnan/screen/splash/splash.screen.dart';
import 'package:get/get.dart';

GetPage _initPage(router, fuc, bindings) =>
    GetPage(name: router, page: fuc, binding: bindings);

class Routers {
  static final route = [
    _initPage(ROUTER_SPLASH, () => const SplashScreen(), SplashBinding()),
    _initPage(ROUTER_SIGN_IN, () => const SignInScreen(), SignInBinding()),
    _initPage(ROUTER_SIGN_UP, () => const SignUpScreen(), SignUpBinding()),
  ];
}
