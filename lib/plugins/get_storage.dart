import 'package:bitnan/@core/data/local/storage/data.storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> configGetStorage() async {
  await GetStorage.init();
  Get.put(DataStorage(), permanent: true);
}
