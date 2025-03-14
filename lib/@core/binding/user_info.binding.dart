import 'package:get/get.dart';
import 'package:bitnan/screen/auth/signUp/userInfo/user_info.controller.dart';

class UserInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserInfoController());
  }
}
