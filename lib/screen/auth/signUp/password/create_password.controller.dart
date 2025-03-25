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

/*
Đoạn mã trên là controller cho màn hình tạo mật khẩu trong ứng dụng Flutter. 
Controller này sử dụng GetX để quản lý trạng thái và xử lý các sự kiện 
liên quan đến việc tạo mật khẩu (passcode) mới của người dùng khi đăng ký tài khoản.
 */
class CreatePasswordController extends GetxController {
  // Đây là đối tượng chứa thông tin đăng ký của người dùng, được lấy từ getArgument().
  // Đối tượng này sẽ bao gồm các trường như email, tên đầy đủ, và mật khẩu (passcode).
  late final SignUpRequest signUpRequest;
  var passWord =
      ''.obs; // Các biến này là reactive variables (Rx<String>), lưu trữ mật khẩu và xác nhận mật khẩu của người dùng.
  var confirmPass = ''.obs;
  get ready =>
      passWord.value.length == 6 &&
      confirmPass.value.length ==
          6; // Trả về true nếu cả mật khẩu và xác nhận mật khẩu đều có độ dài bằng 6 ký tự (điều kiện để mật khẩu hợp lệ).
  get matched =>
      passWord.value ==
      confirmPass
          .value; // Trả về true nếu mật khẩu và xác nhận mật khẩu trùng nhau

  // Các đối tượng để truy cập vào UserRepo và DataStorage.
  // UserRepo giúp giao tiếp với API, còn DataStorage lưu trữ thông tin người dùng như token và tên.
  var userRepo = Get.find<UserRepo>();
  var store = Get.find<DataStorage>();

  // Các đối tượng FocusNode và TextEditingController dùng để quản lý trường nhập mật khẩu
  // và xác nhận mật khẩu, giúp điều khiển giao diện và xử lý sự kiện người dùng nhập liệu.
  final passwordNode = FocusNode();
  final passwordEditingController = TextEditingController();
  final passwordConfirmNode = FocusNode();
  final passwordConfirmEditingController = TextEditingController();

  @override
  onInit() {
    super.onInit();
    // Phương thức này được gọi khi CreatePasswordController được khởi tạo.
    // Tại đây, đối tượng signUpRequest được lấy từ đối tượng đã được truyền vào controller thông qua getArgument().
    signUpRequest = getArgument();
  }

  // Phương thức này xóa mật khẩu và xác nhận mật khẩu.
  // Đây là một phần của các hành động khi người dùng nhập mật khẩu không hợp lệ và cần nhập lại.
  _clearAllPass() {
    passWord.value = '';
    confirmPass.value = '';
  }

  // Phương thức này được gọi khi người dùng nhấn nút xác nhận để tạo mật khẩu
  Future<void> handleSubmit() async {
    // Nếu mật khẩu hoặc xác nhận mật khẩu không hợp lệ (nghĩa là không đủ dài hoặc không trùng khớp),
    // sẽ hiển thị modal thông báo yêu cầu người dùng nhập lại.
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

    //  // Nếu mật khẩu hợp lệ, phương thức sẽ gọi _submitPass() để gửi yêu cầu đăng ký tới server.
    return await _submitPass();
  }

  // Phương thức này thực hiện việc gửi yêu cầu đăng ký tới server
  Future _submitPass() async {
    showLoading();

    // Đặt mật khẩu vào signUpRequest
    signUpRequest.passcode = passWord.value;

    // Gọi userRepo.signUp() để thực hiện yêu cầu đăng ký với thông tin người dùng.
    var res = await userRepo.signUp(request: signUpRequest);
    hideLoading();

    // Nếu đăng ký thành công (mã trả về là kSuccessApi),
    // thông tin người dùng sẽ được lưu vào DataStorage
    // và người dùng sẽ được chuyển đến màn hình đăng nhập với thông báo thành công.
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
      // Nếu có lỗi, ví dụ như token hết hạn, sẽ hiển thị modal cảnh báo và yêu cầu người dùng thử lại.
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
}


/*
Tóm tắt về các phương thức và chức năng trong CreatePasswordController:
1. onInit(): Khởi tạo controller và lấy thông tin đăng ký từ màn hình trước.
2. _clearAllPass(): Xóa mật khẩu và xác nhận mật khẩu.
3. _submitPass(): Gửi yêu cầu đăng ký tới API và xử lý kết quả đăng ký.
4. handleSubmit(): Kiểm tra tính hợp lệ của mật khẩu và gọi phương thức _submitPass() nếu hợp lệ.
5. ready: Trả về true nếu cả mật khẩu và xác nhận mật khẩu đều đủ dài.
6. matched: Trả về true nếu mật khẩu và xác nhận mật khẩu khớp nhau.
7. Tính năng chính của CreatePasswordController:
8. Kiểm tra mật khẩu người dùng nhập vào và đảm bảo rằng chúng hợp lệ (đủ dài và khớp nhau).
9. Gửi yêu cầu đăng ký tới server khi mật khẩu hợp lệ.
10. Hiển thị thông báo khi có lỗi hoặc yêu cầu người dùng nhập lại mật khẩu.
 */