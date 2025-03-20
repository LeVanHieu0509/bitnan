import 'package:get/get.dart';
import 'package:bitnan/screen/auth/signUp/password/create_password.controller.dart';

class CreatePassWordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreatePasswordController());
  }
}
