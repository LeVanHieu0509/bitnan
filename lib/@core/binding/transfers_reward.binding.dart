import 'package:get/get.dart';
import 'package:bitnan/screen/main/home/transfer/transfers/transfers_reward.controller.dart';

class TransfersRewardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TransfersRewardController());
    // Get.lazyPut(() => VerifyUserController());
  }
}
