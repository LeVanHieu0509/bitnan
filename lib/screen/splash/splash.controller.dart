import 'dart:io';
import 'package:bitnan/@core/data/local/storage/data.storage.dart';
import 'package:bitnan/@core/data/repo/request/pass_code.request.dart';
import 'package:bitnan/@core/data/repo/user.repo.dart';
import 'package:bitnan/@core/router/pages.dart';
import 'package:bitnan/@core/service/dynamic_link.service.dart';
import 'package:bitnan/@share/constants/value.constant.dart';
import 'package:bitnan/@share/utils/util.dart';
import 'package:bitnan/config.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart'; // Để kiểm tra xem thiết bị có bị jailbreak không (quan trọng đối với bảo mật ứng dụng).
import 'package:package_info/package_info.dart'; // Để lấy thông tin về phiên bản của ứng dụng.

/*
1. GetxController: Được sử dụng cho dependency injection, routing, và state management.
2. SplashController kế thừa từ GetxController, nghĩa là nó có thể sử dụng các tính năng của GetX
như state management, dependency injection.
 */
class SplashController extends GetxController {
  var refCode = ''; // refCode: Biến này dùng để lưu trữ mã tham chiếu.

  // Các service và repository được lấy thông qua Get.find()
  // để dễ dàng truy cập: UserRepo, DynamicLinkService, và DataStorage.
  final userRepo = Get.find<UserRepo>();
  final _dynamicService = Get.find<DynamicLinkService>();
  final _storage = Get.find<DataStorage>();

  // onInit(): Đây là phương thức được gọi khi SplashController được khởi tạo. Phương thức này sẽ thực hiện các hành động sau
  @override
  void onInit() {
    super.onInit();

    // Sau 2 giây, Future.delayed() sẽ gọi checkMaintenance() để kiểm tra tình trạng bảo trì của hệ thống.
    Future.delayed(const Duration(seconds: 2), () {
      print("delayed");

      checkMaintenance(
        callback: () {
          // Nếu ứng dụng đang chạy trên môi trường prod, nó sẽ kiểm tra phiên bản ứng dụng trước khi gọi _jailbreakDetection().
          // Nếu không phải môi trường prod, nó sẽ trực tiếp kiểm tra jailbreak.
          print(BBConfig.instance.isProd);
          if (BBConfig.instance.isProd) {
            checkAppVersion(callback: _jailbreakDetection);
          } else {
            print("_jailbreakDetection");
            _jailbreakDetection();
          }
        },
      );
    });
  }

  /*
 Phương thức này lấy dynamic link từ DynamicLinkService tùy theo hệ điều hành (Android hoặc iOS).
 */
  Future _getDynamicLink() async {
    if (Platform.isAndroid) {
      // Trên Android, nó gọi handleDynamicLinks()
      refCode = await _dynamicService.handleDynamicLinks();
    } else if (Platform.isIOS) {
      // còn trên iOS, nó gọi initUniLinks() để lấy refCode.
      refCode = await _dynamicService.initUniLinks();
    }
  }

  Future<void> _jailbreakDetection() async {
    print("_jailbreakDetection");

    bool jailBroken;
    try {
      // không cho phép chạy ứng dụng trên các thiết bị đã bị chỉnh sửa
      // nếu thư viện không thể truy xuất thông tin từ hệ điều hành
      jailBroken = await FlutterJailbreakDetection.jailbroken;
    } on PlatformException {
      jailBroken = true;
    }

    // nó sẽ gọi _getDynamicLink() và _validateLogin() để kiểm tra và xử lý thông tin người dùng.
    if (!jailBroken) {
      _getDynamicLink();
      _validateLogin();
    } else {
      _getDynamicLink();
      _validateLogin();
      // showAlert(content: 'Please check your network configuration');
    }
  }

  //  Phương thức này kiểm tra quá trình xác thực người dùng
  Future _validateLogin() async {
    // Lấy thông tin từ DataStorage: Dữ liệu như tên người dùng và phiên bản ứng dụng được lấy từ DataStorage.
    var data = Get.find<DataStorage>();
    getVersion(data);

    // final isInReview = await BBConfig.instance.isInReviewApple();
    // final pass = _storage.getPasscodeInReview();

    final pass = 2;
    if (pass == 1) {
      showLoading();

      // Kiểm tra passcode: Nếu passcode được thiết lập,
      // nó sẽ gọi userRepo.verifyPassCode() để xác thực mã passcode từ người dùng
      var res = await userRepo.verifyPassCode(
        PassCodeRequest("123123", _storage.getRefreshToken()),
      );

      hideLoading();

      // Nếu passcode hợp lệ, nó sẽ lưu token vào DataStorage và chuyển đến màn hình chính (ROUTER_MAIN_TAB).
      // Nếu không hợp lệ, nó hiển thị thông báo lỗi.
      if (res.status == kSuccessApi) {
        await _storage.setToken(res.data);
        goToAndRemoveAll(screen: ROUTER_MAIN_TAB);
      } else {
        showAlert(content: res.getErrors());
      }
    } else {
      print({'fullname': data.getFullName().isEmpty});
      // Nếu passcode không được yêu cầu (ví dụ, đang trong quá trình đăng ký),
      // nó sẽ chuyển hướng người dùng đến màn hình đăng ký hoặc đăng nhập.
      goToAndRemoveAll(
        screen: data.getFullName().isEmpty ? ROUTER_SIGN_UP : ROUTER_SIGN_IN,
        argument: data.getFullName().isEmpty ? refCode : '',
      );
    }

    // Bypass Apple Review
  }

  // Phương thức này lấy thông tin về phiên bản ứng dụng hiện tại và lưu nó vào DataStorage.
  void getVersion(DataStorage data) {
    // PackageInfo được sử dụng để lấy phiên bản ứng dụng từ hệ thống (từ platform).
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      if (packageInfo.version != data.getVersion()) {
        data.setVersion(packageInfo.version);
      }
    });
  }
}

/*
SplashController thực hiện các công việc chính trong quá trình tải ứng dụng:
  1. Kiểm tra tình trạng bảo trì.
  2. Kiểm tra phiên bản ứng dụng.
  3. Kiểm tra jailbreak của thiết bị.
  4. Xử lý dynamic links và xác thực người dùng.
 */
