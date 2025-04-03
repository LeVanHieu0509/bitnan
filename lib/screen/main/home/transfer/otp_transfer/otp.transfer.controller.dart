import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bitnan/@core/data/repo/model/request_transfer.dart';
import 'package:bitnan/@core/data/repo/model/transactionConfirm.model.dart';
import 'package:bitnan/@core/data/repo/request/auth_check.request.dart';
import 'package:bitnan/@core/data/repo/transfer_reward.repo.dart';
import 'package:bitnan/@core/data/repo/user.repo.dart';
import 'package:bitnan/@core/router/pages.dart';
import 'package:bitnan/@share/constants/language.constant.dart';
import 'package:bitnan/@share/constants/value.constant.dart';
import 'package:bitnan/@share/utils/util.dart';

class OtpTransferController extends GetxController {
  // Điều khiển văn bản nhập vào của trường OTP.
  TextEditingController textEditingController = TextEditingController();

  // Quan sát trạng thái cho phép người dùng gửi lại OTP
  var isResend = false.obs;

  // Đối tượng Timer để quản lý thời gian đếm ngược
  Timer? timer;

  // Lưu trữ thông báo lỗi (nếu có)
  var error = ''.obs;

  // Lưu trữ thời gian còn lại cho OTP
  var timeText = '0:0'.obs;

  // Thời gian bắt đầu đếm ngược (số giây tối đa cho OTP).
  var start = kMaxTimeOutOtp;

  //  Lưu trữ thông tin về tiêu đề, nội dung thông báo, số điện thoại và mã OTP.
  var title = ''.obs;
  var content = ''.obs;
  var iD = ''.obs;
  var otp = ''.obs;

  // Các repository để lấy dữ liệu từ backend.
  var userRepo = Get.find<UserRepo>();
  var transferRepo = Get.find<TransferRewardRepo>();
  var authCheckRequest = AuthCheckRequest().obs;

  // Đối tượng yêu cầu chuyển tiền, chứa các thông tin về giao dịch như số tiền, tài khoản, token
  var requestTransfer = RequestTransfer();

  @override
  void onInit() {
    super.onInit();

    // Được gọi khi controller được khởi tạo,
    // trong đó requestTransfer được lấy từ tham số đầu vào và thông tin OTP được lấy thông qua getOTP().
    requestTransfer = getArgument();
    getInfoByType();
    getOTP();
  }

  // Được gọi khi controller bị hủy, dùng để hủy bỏ timer nếu đang chạy
  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }

  // Gọi phương thức startTimer để bắt đầu đếm ngược thời gian OTP
  Future getOTP() async {
    startTimer();
  }

  void startTimer() {
    // Sử dụng Timer.periodic để đếm ngược mỗi giây.
    // Khi thời gian hết, isResend được đặt là true cho phép người dùng gửi lại OTP.
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (start == 0) {
        timer.cancel();
        isResend.value = true;
      } else {
        _convertTimeToText();
      }
    });
  }

  // Khi giao dịch hoàn thành, phương thức này sẽ điều hướng người dùng đến một màn hình thành công (ROUTER_SUCCESS).
  void handleComplete() {
    TransactionConfirmModel transactionConfirmModel = TransactionConfirmModel(
      amount: requestTransfer.amount,
      successType: kTypeTransferScreen,
    );
    goTo(screen: ROUTER_SUCCESS, argument: transactionConfirmModel);
  }

  // Làm sạch trường nhập OTP và đặt lại lỗi về trạng thái rỗng.
  void _clearOtp() {
    textEditingController.text = '';
    setError(clear: true);
  }

  // Gửi lại OTP sau khi hết thời gian hoặc khi người dùng yêu cầu.
  // Sau khi gửi thành công, làm mới thời gian và bắt đầu lại bộ đếm.
  void reSendOtp() async {
    var res = await requestOtp();
    if (res) {
      _clearOtp();
      isResend.value = false;
      start = kMaxTimeOutOtp;
      startTimer();
    }
  }

  // Thiết lập các thông tin liên quan đến OTP như tiêu đề, nội dung và số điện thoại
  void getInfoByType() {
    title.value = kAuthenSMS;
    content.value = kInputOtp;
    iD.value = requestTransfer.phone;
    authCheckRequest.value.phone = requestTransfer.phone;
  }

  // Xác minh OTP bằng cách gọi API từ userRepo.
  // Nếu OTP hợp lệ, sẽ tiếp tục thực hiện giao dịch chuyển tiền bằng cách gọi transferExchange.
  Future verifyOtp() async {
    showLoading();
    authCheckRequest.value.otp = textEditingController.text;
    authCheckRequest.value.token = requestTransfer.token;
    var res = await userRepo.verifyOtp(request: authCheckRequest.value);
    if (res.status == kSuccessApi) {
      await transferExchange();
    } else {
      showDialogConfirm(content: res.getErrors());
    }
  }

  //  Gửi yêu cầu giao dịch chuyển tiền thông qua API của transferRepo.
  // Nếu giao dịch thành công, người dùng được chuyển đến màn hình thành công.
  // Nếu có lỗi, hiển thị thông báo lỗi và cho phép quay lại trang chủ.
  Future transferExchange() async {
    var res = await transferRepo.transferExchange(requestTransfer, '');
    if (res.status == kSuccessApi) {
      timer?.cancel();
      handleComplete();
      hideLoading();
    } else {
      showAlert(
        content: res.getErrors(),
        dismissible: false,
        onConfirm: () {
          goToAndRemoveAll(screen: ROUTER_MAIN_TAB);
        },
      );
    }
  }

  // Gửi yêu cầu OTP qua API và trả về một bool cho biết việc gửi OTP có thành công hay không.
  // Nếu thành công, hiển thị OTP trong chế độ debug
  Future<bool> requestOtp() async {
    showLoading();
    var res = await userRepo.requestOtp(
      request: AuthCheckRequest(
        phone: requestTransfer.phone,
        email: authCheckRequest.value.email,
        type: authCheckRequest.value.type,
      ),
    );
    if (res.status == kSuccessApi && kDebugMode) {
      hideLoading();
      otp.value = 'OTP Code ${res.data.otp}';
    } else {
      showAlert(content: res.getErrors());
    }
    return res.status == kSuccessApi;
  }

  void setError({String? data, bool clear = false}) {
    error.value = clear ? '' : data ?? '';
  }

  // Chuyển đổi thời gian đếm ngược từ giây sang phút và giây để hiển thị cho người dùng.
  void _convertTimeToText() {
    start--;
    var min = start ~/ 60;
    var second = start - (min * 60);
    timeText.value = "$min:${second < 10 ? "0$second" : second}";
  }
}
