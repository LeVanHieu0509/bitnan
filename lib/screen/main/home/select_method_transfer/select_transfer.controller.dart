import 'package:get/get.dart';
import 'package:bitnan/@core/data/repo/cash_back.repo.dart';
import 'package:bitnan/@core/data/repo/model/currency.model.dart';
import 'package:bitnan/@core/data/repo/model/master_config.model.dart';
import 'package:bitnan/@core/data/repo/response/base.response.dart';
import 'package:bitnan/@share/constants/value.constant.dart';
import 'package:bitnan/@share/utils/util.dart';

class SelectTransferController extends GetxController {
  // listCurrency là một danh sách các đối tượng CurrencyModel được quan sát (reactive) bằng obs.
  // Điều này có nghĩa là khi danh sách này thay đổi, giao diện sẽ tự động được cập nhật.
  var listCurrency = <CurrencyModel>[].obs;

  // listCoin là danh sách các đối tượng MasterConfigCoin được quan sát, dùng để lưu trữ các đồng xu (coin).
  var listCoin = <MasterConfigCoin>[].obs;

  // cashBackRepo là một đối tượng được lấy từ Get (Dependency Injection).
  // Nó có nhiệm vụ tương tác với API để lấy dữ liệu liên quan đến cashback (hoàn tiền).
  var cashBackRepo = Get.find<CashBackRepo>();

  // isCheck là một biến trạng thái (observable),
  // theo dõi xem người dùng đã chọn một đồng xu hay chưa. Giá trị mặc định là false.
  var isCheck = false.obs;

  // model là một đối tượng kiểu CurrencyModel, lưu trữ thông tin của một đồng tiền được chọn.
  CurrencyModel? model;

  // masterModel là một đối tượng kiểu MasterConfigCoin, lưu trữ thông tin của đồng xu hiện tại được chọn.
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

  // Phương thức này được gọi khi người dùng chọn một đồng xu trong danh sách.
  void updatePosition(int index) {
    // Đầu tiên, tất cả các phần tử trong listCoin sẽ được đặt lại trạng thái isChecked thành false.
    for (var element in listCoin) {
      element.isChecked = false;
    }

    // Sau đó, đồng xu tại chỉ số index trong listCoin sẽ được đánh dấu là đã chọn (isChecked = true).
    listCoin[index].isChecked = true;

    // masterModel sẽ lưu trữ thông tin của đồng xu được chọn.
    masterModel = listCoin[index];

    // isCheck.value sẽ được đặt thành true để chỉ ra rằng người dùng đã chọn một đồng xu.
    isCheck.value = true;

    // model sẽ tìm thông tin của đồng tiền tương ứng trong listCurrency.
    model = listCurrency.firstWhereOrNull(
      (element) => element.currency == listCoin[index].code,
    );
    model?.coins = listCoin.firstWhereOrNull(
      (p) => p.code == listCoin[index].code,
    );

    // Cuối cùng, update() sẽ được gọi để cập nhật lại giao diện nếu có sự thay đổi.
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
