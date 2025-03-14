import 'package:get/get.dart';
import 'package:bitnan/@core/data/repo/request/sign_up.request.dart';
import 'package:bitnan/@share/utils/util.dart';

class UserInfoController extends GetxController {
  late final SignUpRequest signUpRequest;
  var fullName = ''.obs;
  @override
  void onInit() {
    super.onInit();
    signUpRequest = getArgument();
    fullName.value = signUpRequest.fullName;
  }
}
