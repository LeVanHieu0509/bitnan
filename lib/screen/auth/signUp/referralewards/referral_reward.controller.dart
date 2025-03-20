import 'package:get/get.dart';
import 'package:bitnan/@core/data/repo/model/referral.model.dart';
import 'package:bitnan/@core/data/repo/request/sign_up.request.dart';
import 'package:bitnan/@core/data/repo/user.repo.dart';
import 'package:bitnan/@core/router/pages.dart';
import 'package:bitnan/@share/constants/language.constant.dart';
import 'package:bitnan/@share/constants/value.constant.dart';
import 'package:bitnan/@share/utils/util.dart';
import 'package:bitnan/resource/image.resource.dart';

class ReferralRewardController extends GetxController {
  late final SignUpRequest signUpRequest;
  var refCode = ''.obs;
  UserRepo userRepo = Get.find();
  var enableRefCode = false.obs;
  int referralReceiver = 700;

  @override
  void onInit() {
    super.onInit();
    signUpRequest = getArgument();
    refCode.value = signUpRequest.referralBy ?? '';
    getIntroduce();
  }

  Future getIntroduce() async {
    showLoading();
    var res = await userRepo.getCashBackIntroduce();
    hideLoading();
    if (res.status == kSuccessApi) {
      if (res.data != null) {
        ReferralModel model = res.data;
        if (refCode.value.isNotEmpty) {
          enableRefCode.value = false;
        } else {
          enableRefCode.value = true;
        }
        referralReceiver = model.referralFrom;
        getReferralReward();
      }
    } else {
      showAlert(content: res.getErrors());
    }
  }

  void getReferralReward() {
    showModalSheet(
      message: kGetReferralReward,
      useRichText: true,
      reward: referralReceiver,
      height: 96,
      width: 96,
      url: MyImage.ic_reward_pink,
      title: kReceiverReferralReward,
    );
  }

  onSubmit() async {
    String ref;
    if (validEmail(refCode.value)) {
      ref = refCode.toLowerCase();
    } else {
      ref = refCode.value;
    }
    showLoading();
    var res = await userRepo.getCheckReferralCode(ref);
    hideLoading();
    if (res.status == kSuccessApi) {
      if (res.data['status']) {
        signUpRequest.referralBy = ref;
        goTo(screen: ROUTER_CREATE_PASS_WORD, argument: signUpRequest);
      } else {
        showModalSheet(
          title: kInputReferralReward,
          message: kInputReferralAgain,
        );
      }
    } else {
      showAlert(content: res.message);
    }
  }
}
