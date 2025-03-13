import 'package:get/get.dart';
import 'package:bitnan/screen/auth/signUp/signUp.controller.dart';

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignUpController());
  }
}
