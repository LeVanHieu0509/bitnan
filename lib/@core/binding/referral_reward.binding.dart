import 'package:get/get.dart';
import 'package:bitnan/screen/auth/signUp/referralewards/referral_reward.controller.dart';

class ReferralRewardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReferralRewardController());
  }
}
