import 'package:get/get.dart';
import 'package:bitnan/@core/data/repo/cash_back.repo.dart';
import 'package:bitnan/@core/data/repo/model/currency.model.dart';
import 'package:bitnan/@core/data/repo/model/master_config.model.dart';
import 'package:bitnan/@core/data/repo/response/base.response.dart';
import 'package:bitnan/@share/constants/value.constant.dart';
import 'package:bitnan/@share/utils/util.dart';

class SelectTransferController extends GetxController {
  var listCurrency = <CurrencyModel>[].obs;
  var listCoin = <MasterConfigCoin>[].obs;
  var cashBackRepo = Get.find<CashBackRepo>();

  var isCheck = false.obs;
  CurrencyModel? model;
  late MasterConfigCoin masterModel;

  @override
  void onInit() {
    super.onInit();
    getInfo();
  }

  getInfo() async {
    print("SelectTransferController");
    showLoading();
    await getCashBack();
    await getMasterConfigCoin();
    hideLoading();
  }

  void updatePosition(int index) {
    for (var element in listCoin) {
      element.isChecked = false;
    }
    listCoin[index].isChecked = true;
    masterModel = listCoin[index];
    isCheck.value = true;
    model = listCurrency.firstWhereOrNull(
      (element) => element.currency == listCoin[index].code,
    );
    model?.coins = listCoin.firstWhereOrNull(
      (p) => p.code == listCoin[index].code,
    );
    update();
  }

  Future getMasterConfigCoin() async {
    print("SelectTransferController --> getMasterConfigCoin");

    var res = await cashBackRepo.getMasterConfigCoin();
    if (res.status == kSuccessApi) {
      listCoin.value = MasterConfigCoin.fromList(res.data);
    } else {
      showAlert(content: res.getErrors());
    }
  }

  Future getCashBack() async {
    print("SelectTransferController --> getCashBack");

    BaseResponse? res = await cashBackRepo.getCashBack();
    if (res != null) {
      if (res.status == kSuccessApi) {
        listCurrency.value = res.data;
      } else {
        showAlert(content: res.getErrors());
      }
    }
  }
}
