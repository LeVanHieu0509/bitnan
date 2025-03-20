import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:bitnan/@core/data/local/storage/data.storage.dart';
import 'package:bitnan/@core/data/repo/request/sign_up.request.dart';
import 'package:bitnan/@core/data/repo/user.repo.dart';
import 'package:bitnan/@core/router/pages.dart';
import 'package:bitnan/@share/constants/key.error.dart';
import 'package:bitnan/@share/constants/language.constant.dart';
import 'package:bitnan/@share/constants/value.constant.dart';
import 'package:bitnan/@share/utils/util.dart';
import 'package:bitnan/resource/image.resource.dart';
import 'package:bitnan/resource/style.resource.dart';

class CreatePasswordController extends GetxController {
  late final SignUpRequest signUpRequest;
  var passWord = ''.obs;
  var confirmPass = ''.obs;
  get ready => passWord.value.length == 6 && confirmPass.value.length == 6;
  get matched => passWord.value == confirmPass.value;

  var userRepo = Get.find<UserRepo>();
  var store = Get.find<DataStorage>();

  final passwordNode = FocusNode();
  final passwordEditingController = TextEditingController();
  final passwordConfirmNode = FocusNode();
  final passwordConfirmEditingController = TextEditingController();

  @override
  onInit() {
    super.onInit();
    signUpRequest = getArgument();
  }

  _clearAllPass() {
    passWord.value = '';
    confirmPass.value = '';
  }

  Future _submitPass() async {
    showLoading();
    signUpRequest.passcode = passWord.value;
    var res = await userRepo.signUp(request: signUpRequest);
    hideLoading();
    if (res.status == kSuccessApi) {
      await store.setFullName(signUpRequest.fullName);
      await store.setToken(res.data);
      await userRepo.getProfile().then((value) => store.setUser(value.data));
      showModalSheet(
        dismissible: false,
        url: MyImage.ic_account_success,
        title: kCreateAccountSuccess,
        button: kSignIn,
        width: 96,
        height: 96,
        styleTitle: MyStyle.typeBold.copyWith(fontSize: 16.sp),
        action: () {
          goToAndRemoveAll(screen: ROUTER_SIGN_IN);
        },
        message: kWellComeMember,
      );
    } else {
      if (res.getErrors() == TOKEN_INVALID) {
        showModalSheet(
          title: kTitleExpired,
          message: kMgsExpired,
          action: () {
            goToAndRemoveAll(screen: ROUTER_SIGN_UP);
          },
        );
      } else {
        showAlert(content: res.getErrors());
      }
    }
  }

  Future<void> handleSubmit() async {
    if (!ready) {
      return await showModalSheet(
        url: MyImage.ic_lock,
        title: kInvalidNumberPass,
        message: kInputAgain,
        action: _clearAllPass,
      );
    }
    if (!matched) {
      return await showModalSheet(
        url: MyImage.ic_lock,
        title: kInvalidPass,
        message: kInputAgain,
        action: _clearAllPass,
      );
    }

    return await _submitPass();
  }
}
