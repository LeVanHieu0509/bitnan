import 'package:get/get.dart';
import 'package:bitnan/@core/data/repo/request/auth_check.request.dart';
import 'package:bitnan/@core/data/repo/request/sign_up.request.dart';
import 'package:bitnan/@core/data/repo/user.repo.dart';
import 'package:bitnan/@core/router/pages.dart';
import 'package:bitnan/@share/constants/key.error.dart';
import 'package:bitnan/@share/constants/language.constant.dart';
import 'package:bitnan/@share/constants/value.constant.dart';
import 'package:bitnan/@share/utils/util.dart';
import 'package:bitnan/resource/image.resource.dart';

// signUpRequest: Là một đối tượng của SignUpRequest,
// được khởi tạo trong phương thức onInit(). Nó sẽ lưu trữ thông tin đăng ký của người dùng, bao gồm email.
class InputEmailController extends GetxController {
  late final SignUpRequest signUpRequest;

  // Biến email là một Rx<String> (reactive),
  // có thể thay đổi và sẽ tự động làm mới giao diện khi thay đổi. Ban đầu, giá trị email là một chuỗi rỗng.
  var email = ''.obs;

  // Lấy đối tượng UserRepo từ GetX để truy cập các phương thức liên quan đến người dùng (như gửi yêu cầu OTP).
  var userRepo = Get.find<UserRepo>();
  @override
  void onInit() {
    super.onInit();

    // Lấy đối tượng SignUpRequest từ các tham số được truyền đến controller (thường được truyền từ màn hình trước đó).
    signUpRequest = getArgument();

    //  Lưu email trong signUpRequest và chuyển nó thành chữ thường trước khi gán cho biến email.
    email.value = signUpRequest.email.toLowerCase();
  }

  // Đây là phương thức chính để yêu cầu mã OTP khi người dùng nhập email.
  Future requestOtp() async {
    //  Gọi showLoading() để hiển thị trạng thái loading trong khi gửi yêu cầu.
    showLoading();

    // Phương thức gọi userRepo.requestOtp() với đối tượng AuthCheckRequest chứa email và type '1'.
    // Đây là bước gửi yêu cầu OTP tới server để kiểm tra tính hợp lệ của email.
    var res = await userRepo.requestOtp(
      request: AuthCheckRequest(email: email.value.toLowerCase(), type: '1'),
    );
    hideLoading();

    // Nếu server trả về kSuccessApi (mã thành công), lưu token trả về từ server vào signUpRequest.tokenEmail
    // và chuyển sang màn hình OTP với đối tượng signUpRequest như tham số.
    if (res.status == kSuccessApi) {
      signUpRequest.tokenEmail = res.data.token;
      signUpRequest.email = email.value.toLowerCase();
      goTo(screen: ROUTER_OTP, argument: signUpRequest);
    } else {
      // Nếu email đã tồn tại trong hệ thống,
      // phương thức sẽ hiển thị một modal cảnh báo với thông điệp "Email already exists" và một icon lỗi.
      if (res.getErrors() == EMAIL_EXIST) {
        // Được gọi khi có lỗi về email đã tồn tại, hiển thị modal với biểu tượng lỗi và thông điệp cảnh báo.
        showModalSheet(
          url: MyImage.ic_error_square,
          title: kEmailExists,
          message: kMgsEmailExists,
        );
      } else {
        // Được gọi nếu có lỗi khác từ server, hiển thị thông báo lỗi cho người dùng.
        showAlert(content: res.getErrors());
      }
    }
  }
}
