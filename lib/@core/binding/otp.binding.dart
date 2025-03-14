import 'package:get/get.dart';
import 'package:bitnan/screen/auth/signUp/otp/otp.controller.dart';

class OtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OtpController());
  }
}
