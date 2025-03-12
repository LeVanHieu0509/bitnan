import 'package:bitnan/@core/binding/splash.binding.dart';
import 'package:bitnan/@core/router/pages.dart';
import 'package:bitnan/screen/splash/splash.screen.dart';
import 'package:get/get.dart';

GetPage _initPage(router, fuc, bindings) =>
    GetPage(name: router, page: fuc, binding: bindings);

class Routers {
  static final route = [
    _initPage(ROUTER_SPLASH, () => const SplashScreen(), SplashBinding()),
  ];
}
