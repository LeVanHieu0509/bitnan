import 'package:get/get.dart';
import 'package:bitnan/@core/data/repo/cash_back.repo.dart';
import 'package:bitnan/@core/data/repo/model/currency.model.dart';
import 'package:bitnan/@core/data/repo/model/exchange_rate.model.dart';
import 'package:bitnan/@core/data/repo/model/master_config.model.dart';
import 'package:bitnan/@core/data/repo/model/partner_transaction.model.dart';
import 'package:bitnan/@core/data/repo/model/user.model.dart';
import 'package:bitnan/@core/data/repo/response/base.response.dart';
import 'package:bitnan/@core/data/repo/user.repo.dart';
import 'package:bitnan/@core/router/pages.dart';
import 'package:bitnan/@share/constants/value.constant.dart';
import 'package:bitnan/@share/utils/util.dart';
import 'package:bitnan/config.dart';

import '../../../../@share/constants/language.constant.dart';

// var là kiểu khai báo biến không xác định kiểu dữ liệu.
// Dart sẽ tự động suy ra kiểu dữ liệu của biến dựa trên giá trị được gán cho nó.
class SummaryController extends GetxController {
  // Là các repository giúp bạn giao tiếp với API để lấy thông tin người dùng
  // và tiền thưởng (cashback).
  var userRepo = Get.find<UserRepo>();
  var cashBackRepo = Get.find<CashBackRepo>();

  //  Biến Rx lưu tổng giá trị của tiền tệ, có thể được tính toán từ các CurrencyModel
  var valueTotal = 0.0.obs;

  // Biến này xác định xem có hiển thị số tiền hay không
  var isShowHideMoney = false.obs;

  // Danh sách các đối tượng tiền tệ
  var listCurrency = <CurrencyModel>[].obs;

  // Danh sách các đối tượng có trạng thái chờ (pending).
  var listPending = <CurrencyModel>[].obs;

  //  Kiểm tra xem ứng dụng có đang trong quá trình Apple Review không.
  var isInReview = false.obs;

  // Lưu dữ liệu liên quan đến tỷ giá và các thông tin cashback.
  Map<String, ExchangeRateModel>? dataCashBack;

  //  Danh sách các đối tác giao dịch
  var listPartner = <PartnerTransactionModel>[].obs;

  //  Cấu hình tiền tệ.
  List<MasterConfigCoin> listConfig = [];

  // Thông tin người dùng
  UserModel user = UserModel();

  final loading = false.obs;
  @override
  void onInit() {
    // Nó sẽ gọi checkInAppleReview() để kiểm tra xem ứng dụng
    // có đang trong quá trình Apple Review không,
    // và gọi getInfo() để lấy thông tin cần thiết từ các API.
    print("1. initial summary");
    super.onInit();
    checkInAppleReview();
    getInfo();
  }

  Future getInfo() async {
    print("3. initial getInfo");

    loading.value = true;

    await getMasterConfigCoin(); // Lấy cấu hình đồng tiền.
    await getProfile(); // Lấy thông tin người dùng.
    await getExchangeRate(); // Lấy tỷ giá hối đoái.
    await getCashBack(); //  Lấy thông tin tiền thưởng (cashback)

    loading.value = false;
  }

  Future checkInAppleReview() async {
    print("2. initial checkInAppleReview");
    isInReview.value = await BBConfig.instance.isInReviewApple();
  }

  Future getProfile() async {
    print("5. initial getProfile");

    // Lấy thông tin người dùng từ API.
    BaseResponse res = await userRepo.getProfile();

    if (res.status == kSuccessApi) {
      // Nếu thành công, lưu thông tin người dùng vào user.
      user = res.data;
    } else {
      showAlert(content: res.getErrors());
    }
  }

  // Kiểm tra và xử lý xác minh KYC (Know Your Customer).
  getKYC({required String type}) async {
    // ùy thuộc vào type, phương thức sẽ thực hiện các hành động khác nhau,
    // như kRecharge, kTranfersAmount, kExchangeAmount.
    bool withDrawable =
        listConfig.where((element) => element.withDrawable == false).isNotEmpty;
    bool exchangeAble =
        listConfig.where((element) => element.exchangeAble == false).length > 1;

    checkUserKyc(
      status: kKycStatus,
      // status: user.kycStatus,
      action: (bool isVerifyPhone) async {
        // Nếu người dùng chưa xác minh số điện thoại, gọi onVerifyPhone().

        print("isVerifyPhone: ${isVerifyPhone}");

        if (isVerifyPhone) {
          onVerifyPhone();
        } else {
          if (type == kRecharge) {
            showAlert(content: 'Tính năng đang bảo trì, vui lòng quay lại sau');
          } else if (type == kTranfersAmount && withDrawable) {
            _goto(ROUTER_SELECT_TRANSFER);
          } else if (type == kExchangeAmount && exchangeAble) {
            // await goTo(screen: ROUTER_EXCHANGE, argument: listCurrency)?.then((
            //   value,
            // ) async {
            //   if (value != null) {
            //     await getCashBack();
            //   }
            // });
            showAlert(content: '_exchangeAble');
          } else {
            showAlert(content: '_gotoRecharge');

            // _gotoRecharge();
          }
        }
      },
    );
  }

  void _gotoRecharge() {
    goTo(screen: ROUTER_RECHARGE_PAYME);
  }

  _goto(String router) async {
    await goTo(
      screen: router,
      argument: listCurrency,
    )?.then((value) => getInfo());
  }

  Future onVerifyPhone() async {
    showModalSheetVerifyPhone(
      action: (String phone) {
        getProfile();
      },
    );
  }

  //  Phương thức này lấy thông tin tiền thưởng từ API và tính toán tổng giá trị tiền tệ (cashback).
  Future getCashBack() async {
    print("7. initial getExchangeRate");

    valueTotal.value = 0;
    listCurrency.value = [];

    if (dataCashBack == null) {
      return;
    }
    // Lọc các phần tử trong listCurrency và listPending.
    BaseResponse? res = await cashBackRepo.getCashBack();

    if (res != null) {
      if (res.status == kSuccessApi) {
        if (res.data == null) {
          return;
        }

        listCurrency.value = res.data;

        // Cập nhật các trường icon và name cho các phần tử trong danh sách
        for (var e in listCurrency) {
          // Tìm phần tử trong listConfig mà có code bằng với e.currency.
          // Nếu tìm thấy, lấy icon và name, nếu không có thì gán giá trị mặc định ('').
          e.icon =
              listConfig
                  .firstWhereOrNull((element) => element.code == e.currency)
                  ?.icon ??
              '';
          e.name =
              listConfig
                  .firstWhereOrNull((element) => element.code == e.currency)
                  ?.name ??
              '';

          // Kiểm tra điều kiện e.amount > 0 || e.pending > 0:
          // Chỉ tính toán giá trị nếu phần tử có amount > 0 hoặc pending > 0
          if (e.amount > 0 || e.pending > 0) {
            // Tính giá trị bằng (e.amount + e.pending) * getBIDByCode(e.currency).
            // Đây có thể là giá trị quy đổi sang đơn vị khác (như quy đổi theo tỷ giá BID của mã tiền tệ).
            valueTotal.value +=
                e.currency != 'VNDC'
                    ? (e.amount + e.pending) * getBIDByCode(e.currency)
                    : (e.amount + e.pending);
          }
        }
        listPending.assignAll(
          listCurrency.where((element) => element.pending > 0).toList(),
        );

        // Lọc các phần tử trong listCurrency mà có pending > 0.
        for (var e in listPending) {
          e.icon =
              listConfig
                  .firstWhereOrNull((element) => element.code == e.currency)
                  ?.icon ??
              '';
          e.name =
              listConfig
                  .firstWhereOrNull((element) => element.code == e.currency)
                  ?.name ??
              '';
        }
      } else {
        showAlert(content: res.getErrors());
      }
    }
  }

  Future getExchangeRate() async {
    print("6. initial getExchangeRate");

    var res = await cashBackRepo.getExchangeRate();
    if (res != null) {
      if (res.status == kSuccessApi) {
        print({"getExchangeRate", res.data});

        // Lấy tỷ giá hối đoái từ API và lưu vào dataCashBack.
        dataCashBack = res.data;
      } else {
        showAlert(content: res.getErrors());
      }
    }
  }

  // Tính tỷ giá trung bình giữa bid và ask cho một loại tiền tệ.
  double getBIDByCode(String code) {
    print({">>>>>>>getBIDByCode --> currency": code});
    print({
      ">>>>>>>getBIDByCode --> price":
          ((double.parse(dataCashBack?['${code}VNDC']?.bid ?? '') +
                  double.parse(dataCashBack?['${code}VNDC']?.ask ?? '')) /
              2),
    });
    return ((double.parse(dataCashBack?['${code}VNDC']?.bid ?? '') +
            double.parse(dataCashBack?['${code}VNDC']?.ask ?? '')) /
        2);
  }

  // Lấy cấu hình tiền tệ từ API và chuyển đổi thành danh sách MasterConfigCoin.
  Future getMasterConfigCoin() async {
    print("4. initial getMasterConfigCoin");
    var res = await cashBackRepo.getMasterConfigCoin();
    if (res.status == kSuccessApi) {
      listConfig = MasterConfigCoin.fromList(res.data);
    } else {
      showAlert(content: res.getErrors());
    }
  }
}

/*
Tóm tắt:
1. SummaryController thực hiện các tác vụ quan trọng như lấy thông tin người dùng, tiền thưởng (cashback), tỷ giá hối đoái, và cấu hình tiền tệ.
2. GetX được sử dụng để quản lý trạng thái và dữ liệu, giúp giao diện tự động cập nhật khi có thay đổi.
3. Controller này cũng xử lý các logic về xác minh KYC, chuyển tiền, và thực hiện các yêu cầu liên quan đến tiền tệ và tiền thưởng.
 */
