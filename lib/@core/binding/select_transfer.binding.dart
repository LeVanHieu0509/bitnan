import 'package:bitnan/screen/main/home/select_method_transfer/select_transfer.controller.dart';
import 'package:get/get.dart';

class SelectTransferBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SelectTransferController());
  }
}
