import 'package:get/get.dart';
import 'package:bitnan/@core/data/repo/model/referral.model.dart';
import 'package:bitnan/@core/data/repo/request/sign_up.request.dart';
import 'package:bitnan/@core/data/repo/user.repo.dart';
import 'package:bitnan/@core/router/pages.dart';
import 'package:bitnan/@share/constants/language.constant.dart';
import 'package:bitnan/@share/constants/value.constant.dart';
import 'package:bitnan/@share/utils/util.dart';
import 'package:bitnan/resource/image.resource.dart';

class ReferralRewardController extends GetxController {
  // Lưu trữ thông tin đăng ký của người dùng, bao gồm email, tên đầy đủ, mã giới thiệu, v.v.
  // Được khởi tạo từ getArgument() (thông tin được truyền từ màn hình trước).
  late final SignUpRequest signUpRequest;

  // Biến reactive lưu trữ mã giới thiệu người dùng nhập vào (mã này sẽ được kiểm tra khi người dùng nhập).
  var refCode = ''.obs;

  //  Lấy đối tượng UserRepo thông qua
  // Get.find() để truy cập các phương thức liên quan đến người dùng, như yêu cầu mã giới thiệu và kiểm tra mã giới thiệu.
  UserRepo userRepo = Get.find();

  // Biến này xác định xem có cho phép nhập mã giới thiệu hay không.
  // Nếu người dùng đã có mã giới thiệu, không cho phép nhập lại.
  var enableRefCode = false.obs;

  // Lưu số tiền thưởng khi người dùng nhận được thưởng giới thiệu (700 là giá trị mặc định).
  int referralReceiver = 700;

  @override
  void onInit() {
    super.onInit();
    // signUpRequest được lấy từ getArgument() (thông qua dữ liệu được truyền vào từ màn hình trước).
    signUpRequest = getArgument();
    // được gán giá trị từ signUpRequest.referralBy (nếu có mã giới thiệu).
    refCode.value = signUpRequest.referralBy ?? '';

    // getIntroduce() được gọi để lấy thông tin giới thiệu từ server
    getIntroduce();
  }

  // Gửi yêu cầu đến API để lấy thông tin Referral Reward (giới thiệu) từ server
  Future getIntroduce() async {
    showLoading();
    var res = await userRepo.getCashBackIntroduce();
    hideLoading();
    if (res.status == kSuccessApi) {
      if (res.data != null) {
        ReferralModel model = res.data;

        if (refCode.value.isNotEmpty) {
          // Nếu có mã giới thiệu (refCode.value), không cho phép thay đổi mã.
          enableRefCode.value = false;
        } else {
          enableRefCode.value = true;
        }

        // Lưu giá trị của số tiền thưởng (referralReceiver) từ dữ liệu trả về.
        referralReceiver = model.referralFrom;

        // Phương thức này hiển thị một modal sheet với thông tin thưởng giới thiệu (số tiền thưởng mà người dùng nhận được).
        getReferralReward();
      }
    } else {
      showAlert(content: res.getErrors());
    }
  }

  void getReferralReward() {
    // Hiển thị modal với thông tin thưởng giới thiệu, biểu tượng, và thông điệp
    showModalSheet(
      message: kGetReferralReward,
      useRichText: true,
      reward: referralReceiver,
      height: 96,
      width: 96,
      url: MyImage.ic_reward_pink,
      title: kReceiverReferralReward,
    );
  }

  // Phương thức này xử lý khi người dùng nhấn nút "Tiếp tục" để kiểm tra mã giới thiệu:
  onSubmit() async {
    String ref;
    if (validEmail(refCode.value)) {
      // Nếu là email hợp lệ, chuyển đổi thành chữ thường.
      ref = refCode.toLowerCase();
    } else {
      // Nếu không, giữ nguyên mã giới thiệu.
      ref = refCode.value;
    }
    showLoading();

    // Gửi yêu cầu kiểm tra mã giới thiệu qua userRepo.getCheckReferralCode()
    var res = await userRepo.getCheckReferralCode(ref);
    hideLoading();

    // Nếu mã giới thiệu hợp lệ, lưu giá trị vào signUpRequest.referralBy và chuyển sang màn hình tạo mật khẩu.
    if (res.status == kSuccessApi) {
      if (res.data['status']) {
        signUpRequest.referralBy = ref;
        goTo(screen: ROUTER_CREATE_PASS_WORD, argument: signUpRequest);
      } else {
        // Nếu mã không hợp lệ, hiển thị modal yêu cầu nhập lại mã giới thiệu
        showModalSheet(
          title: kInputReferralReward,
          message: kInputReferralAgain,
        );
      }
    } else {
      showAlert(content: res.message);
    }
  }
}

/*
Tóm tắt về ReferralRewardController:
1. Quản lý mã giới thiệu: Mã này giúp người dùng nhập mã giới thiệu (referral code) và nhận thưởng khi mã hợp lệ.
2. Kiểm tra mã giới thiệu: Sau khi người dùng nhập mã, hệ thống sẽ gửi yêu cầu tới server 
để kiểm tra tính hợp lệ của mã và xử lý theo kết quả.
3. Hiển thị thông tin thưởng: Khi mã hợp lệ, người dùng sẽ nhận được thưởng giới thiệu 
và hệ thống sẽ chuyển hướng họ đến màn hình tiếp theo.
4. Xử lý các lỗi: Nếu mã giới thiệu không hợp lệ, hệ thống sẽ yêu cầu người dùng nhập lại mã.
 */
