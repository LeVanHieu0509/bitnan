import 'package:biometric_storage/biometric_storage.dart';
import 'package:bitnan/@core/data/repo/model/biometric_type.model.dart';
import 'package:bitnan/@core/data/repo/model/config_bio.model.dart';
import 'package:bitnan/@core/data/repo/model/user_response.dart';
import 'package:bitnan/screen/main/person/person.controller.dart';
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

  // supportsAuthenticated là một biến phản ánh liệu thiết bị có hỗ trợ xác thực sinh trắc học hay không.
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

    // _localAuthentication là một đối tượng từ LocalAuthentication,
    // một thư viện dùng để thực hiện xác thực sinh trắc học (vân tay, nhận diện khuôn mặt).
    _localAuthentication = LocalAuthentication();

    if (getArgument() is ConfigBioModel) {
      showIconAuth.value = false;
      configBio.value = getArgument();
    } else {
      getAuthentication();

      // availableBiometrics lưu trữ thông tin về loại sinh trắc học
      // có sẵn trên thiết bị (ví dụ: vân tay hoặc nhận diện khuôn mặt).
      getAvailableBiometrics();
    }
  }

  //  Phương thức signInLocal() (Đăng nhập sinh trắc học):
  Future<void> signInLocal() async {
    String passCode = '';

    // Kiểm tra xem thiết bị có hỗ trợ biometric authentication không qua canCheckBiometrics.
    bool canCheckBiometrics = await _localAuthentication.canCheckBiometrics;

    // Kiểm tra xem người dùng có cấu hình passcode hay không (được lưu trong FlutterSecureStorage).
    await _localStorage.read(key: 'passcode').then((value) {
      if (value != null && !configBio.value.isConfigBio) {
        hasPass.value = true;
        passCode = value;
      }
    });

    // Nếu có passcode và thiết bị hỗ trợ biometric authentication,
    // phương thức sẽ yêu cầu người dùng xác thực bằng sinh trắc học (ví dụ: vân tay hoặc nhận diện khuôn mặt).
    if (canCheckBiometrics && !configBio.value.isConfigBio && hasPass.value) {
      try {
        await _localAuthentication
            .authenticate(
              options: const AuthenticationOptions(biometricOnly: true),
              localizedReason: 'Xác thực',
            )
            .then((value) async {
              if (value) {
                passWord.value = passCode;

                // Nếu xác thực thành công, signInPassCode() sẽ được gọi để thực hiện đăng nhập với mã PIN.
                signInPassCode();
              }
            });
      } on PlatformException catch (e) {
        showAlert(content: e.message);
      }
    }
  }

  // Phương thức này kiểm tra các loại sinh trắc học có sẵn trên thiết bị:
  getAvailableBiometrics() async {
    try {
      // Sử dụng _localAuthentication.getAvailableBiometrics() để lấy danh sách
      // các loại xác thực sinh trắc học (ví dụ: vân tay, nhận diện khuôn mặt).
      await _localAuthentication.getAvailableBiometrics().then((value) {
        if (value.isNotEmpty) {
          // Nếu có vân tay và nhận diện khuôn mặt, nó sẽ gán giá trị
          // cho availableBiometrics và chọn biểu tượng và tiêu đề tương ứng.
          if (value.contains(BiometricType.fingerprint) &&
              value.contains(BiometricType.face)) {
            availableBiometrics.value = BiometricTypeModel(
              type: BiometricType.fingerprint.name,
              url: MyImage.ic_login_touch_id,
              icon: MyImage.ic_touch_id,
              title: kTouchIdUnActivated,
            );
          } else if (value.contains(BiometricType.face)) {
            availableBiometrics.value = BiometricTypeModel(
              type: BiometricType.face.name,
              url: MyImage.ic_login_face_id,
              icon: MyImage.ic_login_face_id,
              title: kFaceIdUnActivated,
            );
          } else if (value.contains(BiometricType.fingerprint)) {
            availableBiometrics.value = BiometricTypeModel(
              type: BiometricType.fingerprint.name,
              url: MyImage.ic_login_touch_id,
              icon: MyImage.ic_touch_id,
              title: kTouchIdUnActivated,
            );
          } else {
            showIconAuth.value = false;
          }
        } else {
          // Nếu không có biometry hỗ trợ, showIconAuth sẽ được đặt là false,
          // nghĩa là ẩn biểu tượng sinh trắc học.
          showIconAuth.value = false;
        }
      });
    } on PlatformException catch (e) {
      Get.log(e.toString());
      showIconAuth.value = false;
    }
  }

  @override
  void onReady() {
    super.onReady();
    getDataUser();
  }

  Future<void> getAuthentication() async {
    print("getAuthentication");

    try {
      // Kiểm tra xem thiết bị có hỗ trợ xác thực sinh trắc học không.
      bool canCheckBiometrics = await _localAuthentication.canCheckBiometrics;

      // Kiểm tra xem người dùng có cấu hình sinh trắc học chưa.
      supportsAuthenticated.value = canCheckBiometrics;
      final response = await BiometricStorage().canAuthenticate();

      // Kiểm tra passcode đã được lưu trong bộ nhớ an toàn (secure storage).
      if (response == CanAuthenticateResponse.errorNoBiometricEnrolled) {
        _localStorage.delete(key: 'passcode');
      }
      await _localStorage.read(key: 'passcode').then((value) {
        if (value != null && !configBio.value.isConfigBio) {
          hasPass.value = true;
        }
      });

      // Xử lý kết quả trả về từ việc kiểm tra khả năng xác thực sinh trắc học.
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
      // Kiểm tra xem user.value.signInToken có phải là một chuỗi không rỗng hay không.
      if (token.isEmpty) return handleNotMe();
      print({"passcode": passWord.value});

      var res = await userRepo.verifyPassCode(
        PassCodeRequest(passWord.value, token),
      );
      print("verifyPassCode");

      if (res.status == kSuccessApi) {
        //  Lưu token đăng nhập vào _storage để sử dụng cho các yêu cầu tiếp theo.
        await _storage.setToken(res.data);

        // Điều hướng người dùng đến màn hình chính (hoặc màn hình tab chính),
        // đồng thời loại bỏ tất cả các màn hình hiện tại trong stack navigation
        // (đảm bảo người dùng không quay lại màn hình đăng nhập).
        goToAndRemoveAll(screen: ROUTER_MAIN_TAB);
      } else {
        passWord.value = '';
        await showAlert(content: res.getErrors());
        passwordEditingController.clear();
        passwordEditingNode.requestFocus();
      }
    } on PlatformException catch (e) {
      passWord.value = '';
      showAlert(content: e.message);
    } finally {
      hideLoading();
    }
  }

  Future<void> verifyPassCode() async {
    print("verifyPassCode");

    showLoading();
    try {
      //  Phương thức này thực hiện kiểm tra mã PIN nhập vào
      var res = await userRepo.verifyPassCode(
        PassCodeRequest(passWord.value, ''),
      );
      hideLoading();
      if (res.status == kSuccessApi) {
        try {
          // Nếu mã PIN hợp lệ, phương thức sẽ yêu cầu xác thực sinh trắc học qua _localAuthentication.authenticate().
          await _localAuthentication
              .authenticate(
                options: const AuthenticationOptions(biometricOnly: true),
                localizedReason: 'Xác thực',
              )
              .then((value) async {
                if (value) {
                  // Nếu người dùng xác thực sinh trắc học thành công,
                  // actionAuthenticate() sẽ được gọi để thực hiện các hành động cần thiết (ví dụ: chuyển đến màn hình chính).
                  await actionAuthenticate();
                }
              });
        } on PlatformException catch (e) {
          showAlert(content: e.message);
        }
      } else {
        print("error verifyPassCode");
        passWord.value = '';
        await showAlert(content: res.getErrors());
        passwordEditingController.clear();
        passwordEditingNode.requestFocus();
      }
    } finally {
      print("try catch");

      hideLoading();
    }
  }

  // actionAuthenticate(): Sau khi xác thực thành công,
  // phương thức này sẽ quay lại màn hình trước (hoặc thực hiện các hành động xác thực khác).
  Future actionAuthenticate() async {
    PersonController controller = Get.find();
    if (configBio.value.enable) {
      _localStorage.deleteAll();
      controller.actionAllowFaceId(false);
    } else {
      _localStorage.write(
        key: 'passcode',
        value: passWord.value,
        aOptions: AndroidOptions(),
      );
      controller.actionAllowFaceId(true);
    }
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
    await _storage.clearAllData();
    await _localStorage.deleteAll();
    goToAndRemoveAll(screen: ROUTER_SPLASH);
  }
}

/*
  Tóm lại:
1, Xử lý sinh trắc học (biometric authentication) trong mã này được thực hiện qua thư viện local_auth và BiometricStorage.
2, Controller kiểm tra khả năng xác thực sinh trắc học của thiết bị và sử dụng nó để đăng nhập hoặc xác thực người dùng.
3, signInLocal() yêu cầu người dùng xác thực sinh trắc học (vân tay hoặc nhận diện khuôn mặt) và sau đó gọi phương thức đăng nhập.
4, getAvailableBiometrics() kiểm tra loại sinh trắc học có sẵn trên thiết bị và hiển thị biểu tượng xác thực nếu có hỗ trợ.
 */
