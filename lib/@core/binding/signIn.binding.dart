import 'package:get/get.dart';
import 'package:bitnan/screen/auth/signIn/signIn.controller.dart';

class SignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignInController());
  }
}
