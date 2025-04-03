import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bitnan/@core/data/api/url.api.dart';
import 'package:bitnan/@core/data/local/storage/data.storage.dart';
import 'package:bitnan/@core/data/repo/model/currency.model.dart';
import 'package:bitnan/@core/data/repo/model/exchange_wallet.model.dart';
import 'package:bitnan/@core/data/repo/model/request_transfer.dart';
import 'package:bitnan/@core/data/repo/model/transfer_reward.model.dart';
import 'package:bitnan/@core/data/repo/response/base.response.dart';
import 'package:bitnan/@core/data/repo/transfer_reward.repo.dart';
import 'package:bitnan/@core/router/pages.dart';
import 'package:bitnan/@share/constants/key.error.dart';
import 'package:bitnan/@share/constants/language.constant.dart';
import 'package:bitnan/@share/constants/value.constant.dart';
import 'package:bitnan/@share/utils/util.dart';
import 'package:bitnan/resource/image.resource.dart';
import 'package:bitnan/screen/main/main.controller.dart';
import '../../../../../resource/color.resource.dart';
import '../../exchange/widgets/popup_confirm.dart';

// quản lý trạng thái và tương tác với các API,
// thực hiện các chức năng như: lấy thông tin ví, thực hiện giao dịch chuyển tiền và xử lý các thông báo lỗi.
class TransfersRewardController extends GetxController {
  // Đây là đối tượng repository được sử dụng để gọi API cho các hoạt động liên quan đến chuyển tiền thưởng.
  var transferRepo = Get.find<TransferRewardRepo>();

  // Đối tượng DataStorage dùng để truy xuất và lưu trữ dữ liệu cục bộ, chẳng hạn như ngôn ngữ ứng dụng.
  final _store = Get.find<DataStorage>();

  // Chúng sẽ tự động cập nhật giao diện khi giá trị của chúng thay đổi.
  var account = ''.obs;
  var amount = 0.0.obs;
  var error = ''.obs;
  var errorOnus = false.obs;
  var mgsOnus = kOnusNotFound.obs;
  var max = ''.obs;
  var bannerOnus = MyImage.ic_banner_onus;
  var paddingShowKeyBoard = 0.0.obs;
  var availableCoin = 0.0.obs;
  var editableEmail = true.obs;
  var amountFee = 0.obs;
  var maxLength = 0.obs;

  // final có nghĩa là giá trị của biến sẽ không thể thay đổi sau khi được gán lần đầu tiên.
  late final String currency;

  // listAddress là một danh sách (List) chứa các đối tượng kiểu ExchangeWallet.
  List<ExchangeWallet> listAddress = [];

  // là một đối tượng của lớp TextEditingController,
  // dùng để điều khiển và xử lý các thao tác nhập liệu từ người dùng trong trường TextField.
  TextEditingController onusController = TextEditingController(text: '');
  TextEditingController amountController = TextEditingController(text: '');

  // late có nghĩa là model sẽ được khởi tạo tại một thời điểm sau, không phải ngay khi khai báo.
  late final CurrencyModel model;

  // final cho biết giá trị của model không thể thay đổi sau khi được gán lần đầu.
  late final ScrollController scrollController;

  // focusOnus là một đối tượng FocusNode dùng để theo dõi trạng thái của trường nhập liệu có tên "onus".
  FocusNode focusOnus = FocusNode();

  @override
  void onInit() {
    super.onInit();

    // scrollController là một đối tượng của lớp ScrollController, dùng để kiểm soát việc cuộn của màn hình.
    // đối tượng này sẽ được khởi tạo sau khi controller được tạo ra.
    scrollController = ScrollController();
    model = getArgument();
    maxLength.value = moneyFormatSAT(model.config?.max).length;
    availableCoin.value = model.amount;
    currency = model.currency;
    initApi();
    bannerOnus =
        _store.getLang() == 'vi'
            ? MyImage.ic_banner_onus
            : MyImage.ic_banner_onus_en;
  }

  @override
  void onReady() {
    super.onReady();
    // Lắng nghe sự thay đổi của trạng thái focus trong trường nhập liệu
    // Nếu người dùng bắt đầu nhập liệu (focus vào trường nhập), phương thức _onFocusChange sẽ được gọi.
    focusOnus.addListener(_onFocusChange);
  }

  @override
  void onClose() {
    // Dừng việc lắng nghe sự thay đổi của focus khi không còn cần thiết nữa.
    focusOnus.removeListener(_onFocusChange);
    super.onClose();
  }

  void _onFocusChange() {
    /*
      Khi người dùng tập trung vào trường nhập liệu (focus vào onusController), 
      paddingShowKeyBoard sẽ được đặt thành một giá trị cố định (kToolbarHeight), 
      có thể dùng để tạo khoảng trống cho bàn phím.
     */
    paddingShowKeyBoard.value = focusOnus.hasFocus ? kToolbarHeight : 0.0;

    // Sau một khoảng thời gian ngắn (200ms),
    // scrollController.animateTo() sẽ được gọi để cuộn màn hình xuống cuối cùng của danh sách hoặc vùng chứa nội dung.
    Future.delayed(const Duration(milliseconds: 200), () {
      // giúp cuộn màn hình đến vị trí cuối cùng của danh sách,
      //giúp người dùng nhìn thấy trường nhập liệu nếu bàn phím xuất hiện.
      //Điều này thường được sử dụng trong các trường hợp người dùng nhập liệu
      //ở các phần tử gần dưới cùng của màn hình và bàn phím xuất hiện.
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: Duration(
          milliseconds: focusOnus.hasFocus ? 200 : 0,
        ), // đảm bảo rằng hiệu ứng cuộn chỉ xảy ra khi bàn phím được kích hoạt (khi có focus).
      );
    });
  }

  Future<dynamic> initApi() async {
    showLoading();
    await getExchangeWallet();
    hideLoading();
  }

  Future getExchangeWallet() async {
    BaseResponse res = await transferRepo.getExchangeWallet();
    if (res.status == kSuccessApi) {
      listAddress = res.data;
      if (listAddress.isNotEmpty) {
        ExchangeWallet? model = listAddress.firstWhereOrNull(
          (element) => element.code == currency,
        );
        if (model == null) return;
        account.value = model.account;
        onusController.text = model.account;
        editableEmail.value = model.editable;
      }
    }
  }

  // thực hiện một cuộc gọi API kiểm tra yêu cầu chuyển tiền.
  // Phương thức này bao gồm các bước xử lý như tạo yêu cầu chuyển tiền,
  // hiển thị loading, xử lý kết quả API, và hiển thị các thông báo lỗi hoặc yêu cầu tiếp theo cho người dùng.
  Future exchangeInquiry() async {
    print(
      "exchangeInquiry -->${account.value.trim()}: ${amount.value.toString()}",
    );

    RequestTransfer request = RequestTransfer(
      account: account.value.trim(),
      amount: amount.value.toString(),
      currency: currency,
      method: 'ONUS',
    );

    showLoading();
    var res = await transferRepo.exchangeInquiry(request, kApiExchangeInquiry);

    hideLoading();

    if (res.status == kSuccessApi) {
      TransferRewardModel model = res.data;
      hideKeyboard();
      // Điều hướng người dùng đến màn hình xác minh
      // (ví dụ: yêu cầu người dùng xác nhận thông tin). Truyền model.token như một tham số.
      await goTo(screen: ROUTER_VERIFY_USER, argument: model.token)?.then((
        token,
      ) {
        // Khi quay lại sau khi xác minh, nếu có token, gọi transferExchange(token) để thực hiện giao dịch chuyển tiền thực tế.
        if (token != null) {
          transferExchange(token);
        }
      });
    } else {
      // Kiểm tra xem có giao dịch nào đang chờ xử lý không.
      // Nếu có, hiển thị thông báo với modal bottom sheet và yêu cầu người dùng đợi.
      if (res.getErrors() == HAS_TRANSACTION_PENDING) {
        showModalBottomSheet(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(4),
              topLeft: Radius.circular(4),
            ),
          ),
          backgroundColor: MyColor.white,
          context: Get.overlayContext!,
          builder:
              (_) => PopupConfirm(
                textSubmit: 'OK',
                urlImage: MyImage.ic_pending_transfer,
                content:
                    '${getLocalize(kHasTransactionPending)}\n${getLocalize(kPleaseWait)}',
                isShowCancel: false,
                action: () {
                  backHome();
                },
              ),
        );
      }
      // Kiểm tra nếu lỗi là tài khoản không hợp lệ.
      // Nếu có, gọi showErrorAccount() để thông báo cho người dùng và yêu cầu họ kiểm tra tài khoản.
      else if (res.getErrors() == ACCOUNT_INVALID) {
        showErrorAccount();
        mgsOnus.value = kOnusNotFoundOrKYC;
      }
      // Nếu có lỗi khác, xử lý từng lỗi cụ thể (ví dụ như lỗi số tiền, trạng thái tài khoản không hợp lệ, v.v.).
      // Hiển thị thông báo lỗi cho người dùng qua error.value.
      else {
        if (res.getErrors() == AMOUNT_INVALID) {
          showErrorAmount();
        }
        error.value = getLocalize(getError(res.getErrors()));
      }
    }
  }

  String getError(String err) {
    switch (err) {
      case INVALID_BALANCE:
        return kInvalidBalance;
      case AMOUNT_INVALID_MIN:
        return kAmountInvalidMin;
      case AMOUNT_INVALID_MAX_MONTH:
        return kAmountInvalidMonth;
      case AMOUNT_INVALID:
        return kAmountInvalid;
      case AMOUNT_INVALID_MAX_DAY:
        return kAmountInvalidDay;
      case COIN_INVALID:
      case STATUS_INVALID:
      case METHOD_INVALID:
      case X_API_KEY_INVALID:
      case X_API_VALIDATE_INVALID:
      case X_API_MESSAGE_INVALID:
        return kHandleInvalid;
      default:
        return kHandleInvalid;
    }
  }

  Future transferExchange(String token) async {
    try {
      showLoading();
      // Đây là một hàm gọi API để thực hiện yêu cầu chuyển đổi hoặc rút tiền.
      // check inquired => token => token verified => success
      var res = await transferRepo.transferExchange(
        RequestTransfer(
          amount:
              '${amount.value}', //  Số tiền cần rút (được chuyển đổi thành chuỗi).
          account: account.value, // Tài khoản người nhận
          token: token, // Token xác thực
          currency: currency, // Loại tiền tệ
          method: 'ONUS', // Phương thức thực hiện giao dịch
        ),
        kApiTransferExchange,
      );
      hideLoading();
      if (res.status == kSuccessApi) {
        showModalBottomSheet(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(4),
              topLeft: Radius.circular(4),
            ),
          ),
          backgroundColor: MyColor.white,
          context: Get.overlayContext!,
          builder:
              (_) => PopupConfirm(
                urlImage:
                    // Hình ảnh tương ứng với loại tiền tệ (VNDC hoặc BBC).
                    currency == kVNDC ? MyImage.ic_new_vndc : MyImage.ic_bbc,
                textSubmit: 'OK', // Nội dung thông báo về giao dịch
                content:
                    '${getLocalize(kWithDrawTitle)}\n${getLocalize(kWithDrawMgs)}',
                // Hiển thị số tiền đã rút
                contentGradient: '${moneyFormatSAT(amount.value)} $currency',
                isShowCancel: false,
                action: () {
                  // Khi người dùng nhấn nút "OK", hàm backHome() sẽ được gọi để quay lại trang chủ.
                  backHome();
                },
              ),
        );
      } else {
        // hiển thị một modal với thông báo lỗi về token hết hạn
        if (res.getErrors() == TOKEN_INVALID) {
          showModalBottomSheet(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(4),
                topLeft: Radius.circular(4),
              ),
            ),
            backgroundColor: MyColor.white,
            context: Get.overlayContext!,
            builder:
                (_) => PopupConfirm(
                  textSubmit: 'OK',
                  content:
                      '${getLocalize(kTitleExpired)}\n${getLocalize(kMgsExpired)}',
                  isShowCancel: false,
                  action: () {
                    backHome();
                  },
                ),
          );
        } else {
          // hiển thị thông báo lỗi mặc định
          _showModalSheetError();
        }
      }
    } catch (e) {
      // hiển thị thông báo lỗi mặc định
      _showModalSheetError();
    }
  }

  void backHome() {
    MainController controller = Get.find();
    controller.changePage(0);
    goToAndRemoveAll(screen: ROUTER_MAIN_TAB);
  }

  _showModalSheetError() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(4),
          topLeft: Radius.circular(4),
        ),
      ),
      backgroundColor: MyColor.white,
      context: Get.overlayContext!,
      builder:
          (_) => PopupConfirm(
            textSubmit: 'OK',
            urlImage:
                currency == kVNDC
                    ? MyImage.ic_disable_vndc
                    : MyImage.ic_bbc_disable,
            content:
                '${getLocalize(kWithDrawFail)}\n${getLocalize(kTryAgainWithDraw)}',
            isShowCancel: false,
            action: () {
              backHome();
            },
          ),
    );
  }

  void showErrorAccount() {
    errorOnus.value = true;
    scrollController.animateTo(
      36,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeIn,
    );
    mgsOnus.value = kInputOnus;
  }

  void showErrorAmount() {
    scrollController.animateTo(
      -36,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeIn,
    );
  }
}

/*
Tóm tắt:
1. Hàm transferExchange thực hiện các bước sau:
2. Hiển thị màn hình loading khi giao dịch bắt đầu.
3. Gửi yêu cầu đến API để thực hiện giao dịch chuyển tiền hoặc rút tiền.
4. Xử lý kết quả API:
5. Nếu thành công, hiển thị thông báo thành công với thông tin giao dịch.
6. Nếu token không hợp lệ, hiển thị thông báo lỗi về token hết hạn.
7. Nếu có lỗi khác, hiển thị thông báo lỗi chung.
8. Nếu có lỗi trong quá trình gọi API, hiển thị thông báo lỗi.
 */
