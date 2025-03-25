import 'dart:async';
import 'package:bitnan/@core/data/repo/user.repo.dart';
import 'package:bitnan/@share/constants/value.constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bitnan/@core/data/repo/request/auth_check.request.dart';
import 'package:bitnan/@core/data/repo/request/sign_up.request.dart';
import 'package:bitnan/@core/router/pages.dart';
import 'package:bitnan/@share/constants/key.error.dart';
import 'package:bitnan/@share/constants/language.constant.dart';
import 'package:bitnan/@share/utils/util.dart';
import 'package:bitnan/resource/image.resource.dart';
import 'package:velocity_x/velocity_x.dart';

class OtpController extends GetxController {
  TextEditingController textEditingController = TextEditingController(text: '');

  // Biến này kiểm soát việc hiển thị nút "Gửi lại OTP"
  var isResend = false.obs;
  Timer? timer; //  Được sử dụng để tạo đồng hồ đếm ngược cho việc gửi lại OTP.
  var error = ''.obs; // Biến lưu thông báo lỗi (nếu có).
  var timeText =
      '0:0'.obs; // Lưu trữ thời gian đếm ngược (hiển thị trên giao diện).
  var start = kMaxTimeOutOtpEmail; // Thời gian đếm ngược ban đầu cho OTP.
  var title = ''.obs;
  var content = ''.obs;
  var iD = ''.obs; // Biến lưu trữ phần email đã bị ẩn đi một phần cho bảo mật.
  var otp = ''.obs; // Biến lưu mã OTP nhận được từ server.
  var token = ''; // Token nhận được từ server sau khi yêu cầu OTP.
  var userRepo = Get.find<UserRepo>();
  // var transferRepo = Get.find<TransferRewardRepo>();
  // UserModel model;

  // Lưu yêu cầu xác thực OTP.
  var authCheckRequest = AuthCheckRequest().obs;

  // Đối tượng lưu thông tin đăng ký người dùng (email, token, v.v.)
  late final SignUpRequest signUpRequest;
  late final FocusNode inputNode; //FocusNode cho trường nhập OTP.

  @override
  void onInit() {
    super.onInit();
    inputNode = FocusNode();

    // được lấy từ đối tượng trước đó được truyền vào (thông qua getArgument()).
    signUpRequest = getArgument();

    //  là mã token email từ signUpRequest (dùng trong yêu cầu OTP).
    token = signUpRequest.tokenEmail ?? '';

    // Phần email trước dấu "@" được ẩn để bảo mật (ví dụ: ***@gmail.com).
    int length = signUpRequest.email.indexOf('@');
    if (length == 1) {
      iD.value = signUpRequest.email.replaceRange(
        1,
        signUpRequest.email.indexOf('@') - 0,
        '***',
      );
    } else if (length == 2 || length == 3 || length == 4) {
      iD.value = signUpRequest.email.replaceRange(
        1,
        signUpRequest.email.indexOf('@') - 1,
        '***',
      );
    } else {
      iD.value = signUpRequest.email.replaceRange(
        2,
        signUpRequest.email.indexOf('@') - 2,
        '***',
      );
    }
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }

  // Tại đây, phương thức getOTP() sẽ được gọi để bắt đầu quá trình yêu cầu OTP,
  // và inputNode sẽ được focus để người dùng có thể nhập OTP ngay lập tức.
  @override
  void onReady() {
    getOTP();
    FocusScope.of(Get.overlayContext!).requestFocus(inputNode);
    super.onReady();
  }

  Future getOTP() async {
    // getOTP() gọi startTimer() để bắt đầu đếm ngược thời gian cho phép gửi lại mã OTP.
    startTimer();
  }

  void startTimer() {
    // Phương thức này khởi tạo một Timer để đếm ngược từng giây
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (start == 0) {
        timer.cancel();
        isResend.value = true;
      } else {
        // được gọi mỗi giây để chuyển đổi thời gian còn lại thành chuỗi hiển thị (ví dụ: "2:05").
        _convertTimeToText();
      }
    });
  }

  // Dọn sạch trường OTP và xóa lỗi nếu có.
  void _clearOtp() {
    textEditingController.text = '';
    setError(clear: true);
  }

  void reSendOtp() async {
    FocusScope.of(Get.overlayContext!).unfocus();
    var res = await requestOtp();
    if (res) {
      _clearOtp();
      isResend.value = false;
      start = kMaxTimeOutOtpEmail;
      startTimer();
    }
  }

  Future verifyOtp() async {
    authCheckRequest.value.otp = textEditingController.text;
    authCheckRequest.value.token = token;
    authCheckRequest.value.type = '1';
    authCheckRequest.value.email = signUpRequest.email;

    if (authCheckRequest.value.otp.isEmptyOrNull) return;

    showLoading();
    var res = await userRepo.verifyOtp(request: authCheckRequest.value);
    hideLoading();
    if (res.status == kSuccessApi) {
      timer?.cancel();
      token = res.data.token;
      await goTo(
        screen: ROUTER_REFERRAL_REWARD,
        argument: signUpRequest,
      )?.then((value) => startTimer());
    } else {
      if (res.getErrors() == OTP_INVALID) {
        _clearOtp();
        showModalSheet(
          url: MyImage.ic_error_square,
          title: getLocalize(kInvalidOtp),
        );
      } else if (res.getErrors() == TOKEN_INVALID) {
        showModalSheet(
          url: MyImage.ic_error_square,
          title: kExpiresOtp,
          message: kTryAgainOtp,
          action: () {
            textEditingController.text = '';
            startTimer();
          },
        );
      } else {
        showAlert(content: res.message);
      }
    }
  }

  Future<bool> requestOtp() async {
    showLoading();
    var res = await userRepo.requestOtp(
      request: AuthCheckRequest(email: signUpRequest.email, type: '1'),
    );
    hideLoading();
    if (res.status == kSuccessApi) {
      FocusScope.of(Get.overlayContext!).requestFocus(inputNode);
      token = res.data.token;
      otp.value = res.data.otp;
    } else {
      showAlert(content: res.getErrors());
    }
    return res.status == kSuccessApi;
  }

  void setError({String? data, bool clear = false}) {
    error.value = clear ? '' : data ?? '';
  }

  void _convertTimeToText() {
    start--;
    var min = start ~/ 60;
    var second = start - (min * 60);
    timeText.value = "$min:${second < 10 ? "0$second" : second}";
  }
}
