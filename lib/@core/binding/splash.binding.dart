import 'package:bitnan/@core/data/local/storage/data.storage.dart';
import 'package:bitnan/@core/service/dynamic_link.service.dart';
import 'package:bitnan/screen/splash/splash.controller.dart';
import 'package:get/get.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DataStorage(), permanent: true);
    Get.put(DynamicLinkService(), permanent: true);
    Get.lazyPut(() => SplashController());
  }
}
