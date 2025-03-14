import 'package:get/get.dart';
import 'package:bitnan/screen/auth/signUp/input_email/input_email.controller.dart';

class InputEmailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InputEmailController());
  }
}
