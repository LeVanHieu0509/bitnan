import 'package:bitnan/screen/main/home/summary/summary.controller.dart';
import 'package:get/get.dart';

import 'package:bitnan/screen/main/main.controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainController());
    // Get.lazyPut(() => HomeController());
    // Get.lazyPut(() => ConnectController());
    // Get.lazyPut(() => HistoryController());
    // Get.lazyPut(() => PersonController());
    // Get.lazyPut(() => BitPlayController());
    // Get.lazyPut(() => GiftBagController());
    // Get.lazyPut(() => LoginPhoneController());
    Get.lazyPut(() => SummaryController());
  }
}
