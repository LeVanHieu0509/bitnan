import 'package:biometric_storage/biometric_storage.dart';
import 'package:bitnan/@core/data/repo/model/biometric_type.model.dart';
import 'package:bitnan/@core/data/repo/model/config_bio.model.dart';
import 'package:bitnan/@core/data/repo/model/user_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:bitnan/@core/data/local/storage/data.storage.dart';
import 'package:bitnan/@core/data/repo/request/pass_code.request.dart';
import 'package:bitnan/@core/data/repo/user.repo.dart';
import 'package:bitnan/@core/router/pages.dart';
import 'package:bitnan/@share/constants/language.constant.dart';
import 'package:bitnan/@share/constants/value.constant.dart';
import 'package:bitnan/@share/utils/util.dart';
import 'package:bitnan/resource/image.resource.dart';

class SignInController extends GetxController {
  var passWord = ''.obs;
  var fullName = ''.obs;
  var phoneNumber = ''.obs;
  DataStorage store = Get.find();
  UserRepo userRepo = Get.find();
  String? token;
  var user = UserResponseModel().obs;
  final _storage = Get.find<DataStorage>();
  var configBio = ConfigBioModel().obs;
  late final LocalAuthentication _localAuthentication;
  var availableBiometrics = BiometricTypeModel().obs;
  var supportsAuthenticated = false.obs;
  final FlutterSecureStorage _localStorage = const FlutterSecureStorage();
  var hasPass = false.obs;
  var showIconAuth = true.obs;
  Rx<CanAuthenticateResponse> authenticateResponse =
      Rx<CanAuthenticateResponse>(
        CanAuthenticateResponse.errorNoBiometricEnrolled,
      );

  final passwordEditingController = TextEditingController();
  final passwordEditingNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    _localAuthentication = LocalAuthentication();
    if (getArgument() is ConfigBioModel) {
      showIconAuth.value = false;
      configBio.value = getArgument();
    } else {
      getAuthentication();
      getAvailableBiometrics();
    }
  }

  Future<void> signInLocal() async {
    // String passCode = '';
    // bool canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
    // await _localStorage.read(key: 'passcode').then((value) {
    //   if (value != null && !configBio.value.isConfigBio) {
    //     hasPass.value = true;
    //     passCode = value;
    //   }
    // });
    // if (canCheckBiometrics && !configBio.value.isConfigBio && hasPass.value) {
    //   try {
    //     await _localAuthentication
    //         .authenticate(
    //           options: const AuthenticationOptions(biometricOnly: true),
    //           localizedReason: 'Xác thực',
    //         )
    //         .then((value) async {
    //           if (value) {
    //             passWord.value = passCode;
    //             signInPassCode();
    //           }
    //         });
    //   } on PlatformException catch (e) {
    //     showAlert(content: e.message);
    //   }
    // }
  }

  getAvailableBiometrics() async {
    // try {
    // await _localAuthentication.getAvailableBiometrics().then((value) {
    //     if (value.isNotEmpty) {
    //       if (value.contains(BiometricType.fingerprint) &&
    //           value.contains(BiometricType.face)) {
    //         availableBiometrics.value = BiometricTypeModel(
    //           type: BiometricType.fingerprint.name,
    //           url: MyImage.ic_login_touch_id,
    //           icon: MyImage.ic_touch_id,
    //           title: kTouchIdUnActivated,
    //         );
    //       } else if (value.contains(BiometricType.face)) {
    //         availableBiometrics.value = BiometricTypeModel(
    //           type: BiometricType.face.name,
    //           url: MyImage.ic_login_face_id,
    //           icon: MyImage.ic_login_face_id,
    //           title: kFaceIdUnActivated,
    //         );
    //       } else if (value.contains(BiometricType.fingerprint)) {
    //         availableBiometrics.value = BiometricTypeModel(
    //           type: BiometricType.fingerprint.name,
    //           url: MyImage.ic_login_touch_id,
    //           icon: MyImage.ic_touch_id,
    //           title: kTouchIdUnActivated,
    //         );
    //       } else {
    //         showIconAuth.value = false;
    //       }
    //     } else {
    //       showIconAuth.value = false;
    //     }
    //   });
    // } on PlatformException catch (e) {
    //   Get.log(e.toString());
    //   showIconAuth.value = false;
    // }
  }

  @override
  void onReady() {
    super.onReady();
    getDataUser();
  }

  Future<void> getAuthentication() async {
    print("getAuthentication");

    try {
      bool canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
      supportsAuthenticated.value = canCheckBiometrics;
      final response = await BiometricStorage().canAuthenticate();
      if (response == CanAuthenticateResponse.errorNoBiometricEnrolled) {
        _localStorage.delete(key: 'passcode');
      }
      await _localStorage.read(key: 'passcode').then((value) {
        if (value != null && !configBio.value.isConfigBio) {
          hasPass.value = true;
        }
      });
      authenticateResponse.value = response;
    } on PlatformException catch (e) {
      showAlert(content: e.message);
    }
  }

  Future<void> signInPassCode() async {
    print({"signInPassCode": user.value.signInToken});
    showLoading();

    try {
      final token =
          user.value.signInToken.isNotEmpty
              ? user.value.signInToken
              : _storage.getRefreshToken();

      print({token});

      if (token.isEmpty) return handleNotMe();
      print({"passcode": passWord.value});

      var res = await userRepo.verifyPassCode(
        PassCodeRequest(passWord.value, token),
      );
      print(res);

      if (res.status == kSuccessApi) {
        await _storage.setToken(res.data);
        goToAndRemoveAll(screen: ROUTER_MAIN_TAB);
      } else {
        passWord.value = '';
        await showAlert(content: res.getErrors());
        passwordEditingController.clear();
        passwordEditingNode.requestFocus();
      }
    } finally {
      hideLoading();
    }
  }

  Future<void> verifyPassCode() async {
    // showLoading();
    // var res = await userRepo.verifyPassCode(
    //   PassCodeRequest(passWord.value, ''),
    // );
    // hideLoading();
    // if (res.status == kSuccessApi) {
    //   try {
    //     await _localAuthentication
    //         .authenticate(
    //           options: const AuthenticationOptions(biometricOnly: true),
    //           localizedReason: 'Xác thực',
    //         )
    //         .then((value) async {
    //           if (value) {
    //             await actionAuthenticate();
    //           }
    //         });
    //   } on PlatformException catch (e) {
    //     showAlert(content: e.message);
    //   }
    // } else {
    //   passWord.value = '';
    //   await showAlert(content: res.getErrors());
    //   passwordEditingController.clear();
    //   passwordEditingNode.requestFocus();
    // }
  }

  Future actionAuthenticate() async {
    // PersonController controller = Get.find();
    // if (configBio.value.enable) {
    //   _localStorage.deleteAll();
    //   controller.actionAllowFaceId(false);
    // } else {
    //   _localStorage.write(
    //     key: 'passcode',
    //     value: passWord.value,
    //     aOptions: const AndroidOptions(encryptedSharedPreferences: false),
    //   );
    //   controller.actionAllowFaceId(true);
    // }
    goBack();
  }

  Future getDataUser() async {
    if (getArgument() is UserResponseModel) {
      user.value = getArgument();
      fullName.value = user.value.fullName ?? '';
      await _storage.setFullName(fullName.value);
    } else {
      fullName.value = _storage.getFullName();
    }
  }

  Future handleNotMe() async {
    // await _storage.clearAllData();
    // await _localStorage.deleteAll();
    // goToAndRemoveAll(screen: ROUTER_SPLASH);
  }
}
