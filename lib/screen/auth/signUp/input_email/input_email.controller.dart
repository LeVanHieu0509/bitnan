import 'package:get/get.dart';
import 'package:bitnan/@core/data/repo/request/auth_check.request.dart';
import 'package:bitnan/@core/data/repo/request/sign_up.request.dart';
import 'package:bitnan/@core/data/repo/user.repo.dart';
import 'package:bitnan/@core/router/pages.dart';
import 'package:bitnan/@share/constants/key.error.dart';
import 'package:bitnan/@share/constants/language.constant.dart';
import 'package:bitnan/@share/constants/value.constant.dart';
import 'package:bitnan/@share/utils/util.dart';
import 'package:bitnan/resource/image.resource.dart';

class InputEmailController extends GetxController {
  late final SignUpRequest signUpRequest;
  var email = ''.obs;
  var userRepo = Get.find<UserRepo>();
  @override
  void onInit() {
    super.onInit();
    signUpRequest = getArgument();
    email.value = signUpRequest.email.toLowerCase();
  }

  Future requestOtp() async {
    showLoading();
    var res = await userRepo.requestOtp(
      request: AuthCheckRequest(email: email.value.toLowerCase(), type: '1'),
    );
    hideLoading();
    if (res.status == kSuccessApi) {
      signUpRequest.tokenEmail = res.data.token;
      signUpRequest.email = email.value.toLowerCase();
      goTo(screen: ROUTER_OTP, argument: signUpRequest);
    } else {
      if (res.getErrors() == EMAIL_EXIST) {
        showModalSheet(
          url: MyImage.ic_error_square,
          title: kEmailExists,
          message: kMgsEmailExists,
        );
      } else {
        showAlert(content: res.getErrors());
      }
    }
  }
}
