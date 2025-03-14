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
  var isResend = false.obs;
  Timer? timer;
  var error = ''.obs;
  var timeText = '0:0'.obs;
  var start = kMaxTimeOutOtpEmail;
  var title = ''.obs;
  var content = ''.obs;
  var iD = ''.obs;
  var otp = ''.obs;
  var token = '';
  var userRepo = Get.find<UserRepo>();
  // var transferRepo = Get.find<TransferRewardRepo>();
  // UserModel model;
  var authCheckRequest = AuthCheckRequest().obs;
  late final SignUpRequest signUpRequest;
  late final FocusNode inputNode;

  @override
  void onInit() {
    super.onInit();
    inputNode = FocusNode();
    signUpRequest = getArgument();
    token = signUpRequest.tokenEmail ?? '';
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

  @override
  void onReady() {
    getOTP();
    FocusScope.of(Get.overlayContext!).requestFocus(inputNode);
    super.onReady();
  }

  Future getOTP() async {
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (start == 0) {
        timer.cancel();
        isResend.value = true;
      } else {
        _convertTimeToText();
      }
    });
  }

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
