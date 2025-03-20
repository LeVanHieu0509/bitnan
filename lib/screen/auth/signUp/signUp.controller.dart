import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:bitnan/@core/data/api/url.api.dart';
import 'package:bitnan/@core/data/local/storage/data.storage.dart';
import 'package:bitnan/@core/data/repo/model/user.model.dart';
import 'package:bitnan/@core/data/repo/model/user_response.dart';
import 'package:bitnan/@core/data/repo/request/pass_code.request.dart';
import 'package:bitnan/@core/data/repo/request/sign_up.request.dart';
import 'package:bitnan/@core/data/repo/response/base.response.dart';
import 'package:bitnan/@core/data/repo/user.repo.dart';
import 'package:bitnan/@core/router/pages.dart';
import 'package:bitnan/@share/constants/key.error.dart';
import 'package:bitnan/@share/constants/language.constant.dart';
import 'package:bitnan/@share/constants/value.constant.dart';
import 'package:bitnan/@share/utils/json.utils.dart';
import 'package:bitnan/@share/utils/util.dart';
import 'package:bitnan/config.dart';
import 'package:velocity_x/velocity_x.dart';

class SignUpController extends GetxController {
  var phoneNumber = ''.obs;
  var error = ''.obs;
  var isNextPhone = false.obs;
  var isEnable = false.obs;
  var refCode = '';
  var userRepo = Get.find<UserRepo>();
  final _storage = Get.find<DataStorage>();
  final isReview = true.obs;

  late Timer timer;
  int countPress = 0;

  @override
  void onInit() {
    super.onInit();
    if (getArgument() is String) refCode = getArgument();
    checkAppleReview();
  }

  specialEvent() {
    if (countPress < 5) return countPress = 0;
    countPress = 0;
    // goTo(screen: ROUTER_CHANGE_VERSION);
  }

  void checkAppleReview() async {
    // final isInReview = await BBConfig.instance.isInReviewApple();
    // isReview.value = isInReview;
  }

  Future signInAppleId() async {
    print("signInAppleId");

    try {
      // final credential = await SignInWithApple.getAppleIDCredential(
      //   scopes: [
      //     AppleIDAuthorizationScopes.email,
      //     AppleIDAuthorizationScopes.fullName,
      //   ],
      // );

      // var displayName = '';
      // if ((!credential.givenName.isEmptyOrNull) &&
      //     (!credential.familyName.isEmptyOrNull)) {
      //   displayName = '${credential.givenName} ${credential.familyName}';
      // }
      signInAuth(
        token: "123123123",
        type: kApiSignInApple,
        fullName: "Le Van Hieu",
      );
    } catch (e) {
      showAlert(title: 'Lỗi', content: e.toString());
    }
  }

  Future signInFacebook() async {
    print("signInFacebook");

    try {
      // await FacebookAuth.instance.logOut();
      // final accessToken = await FacebookAuth.instance.accessToken;
      // if (accessToken != null) {
      //   final userData = await FacebookAuth.instance.getUserData();
      //   getUserFb(accessToken.token, userData);
      // } else {
      //   List<String> permissions = const ['email', 'public_profile'];
      //   LoginResult auth = await FacebookAuth.instance.login(
      //     permissions: permissions,
      //   );
      //   switch (auth.status) {
      //     case LoginStatus.success:
      //       final userData = await FacebookAuth.instance.getUserData();
      //       getUserFb(auth.accessToken!.token, userData);
      //       break;
      //     case LoginStatus.cancelled:
      //       break;
      //     case LoginStatus.failed:
      //       print('Login FB ${auth.message}');
      //       break;
      //     default:
      //   }
      // }
      final userData = {"name": "lebanhieu"};

      getUserFb("asdasdasd", userData);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> signInGoogle() async {
    try {
      // final googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);
      // await googleSignIn.signOut();
      // final account =
      //     await googleSignIn.signInSilently() ?? await googleSignIn.signIn();

      // if (account == null) return;
      // Get.log('[Google Id] : ${account.id}');
      // final value = await account.authentication;
      print("signInGoogle");

      await signInAuth(
        token: "hgashdghhduasgdjhadhajs123gd1211212312123232312",
        type: kApiSignInGoogle,
        fullName: "LeVanH111",
        url: "https://levanhieupro.com",
        email: "levanhieu14@pro.com",
      );
    } catch (e) {
      showAlert(title: 'Lỗi', content: e.toString());
    }
  }

  Future signInAuth({
    required String token,
    required String type,
    String? fullName,
    String? url,
    String email = '',
  }) async {
    print({"res": token, "type": type});

    showLoading();
    final res = await userRepo.signInAuth(token, type);
    hideLoading();

    if (res.status == kSuccessApi) {
      // final isInReview = await BBConfig.instance.isInReviewApple();
      final isInReview = true;

      if (res.data['isNewUser'] == false) {
        await bypassAppleReview(type, isInReview, res);
      } else {
        var signUpToken = res.data['signUpToken'];
        // Bypass Apple Review for new user
        if (type == kApiSignInApple && isInReview) {
          _bypassAppleReview(signUpToken, fullName, url);
        } else {
          goTo(
            screen: ROUTER_USER_INFO,
            argument: SignUpRequest(
              token: signUpToken,
              fullName: fullName ?? '',
              url: url,
              referralBy: refCode,
              screenType: type,
              email: email,
            ),
          );
        }
      }
    } else {
      if (res.getErrors() == TOKEN_INVALID) {
        await showModalSheet(title: kTitleExpired, message: kMgsExpired);
      } else {
        await showAlert(content: res.getErrors());
      }
    }
  }

  /// Bypass Apple Review for existing user
  Future<void> bypassAppleReview(
    String type,
    bool isInReview,
    BaseResponse res,
  ) async {
    if (type == kApiSignInApple && isInReview) {
      showLoading();

      final signInToken = res.data['signInToken'];
      print({"signInToken": signInToken});
      var res2 = await userRepo.verifyPassCode(
        PassCodeRequest('123123', signInToken),
      );

      hideLoading();

      if (res2.status == kSuccessApi) {
        await _storage.setToken(res2.data);
        await goToAndRemoveAll(screen: ROUTER_MAIN_TAB);
      } else {
        await showAlert(content: res2.getErrors());
      }
    } else {
      print("goToAndRemoveAll ROUTER_SIGN_IN");
      final model = UserResponseModel.fromJson(res.data);
      await goToAndRemoveAll(screen: ROUTER_SIGN_IN, argument: model);
    }
  }

  String parseJson(Map json) {
    JsonEncoder encoder = const JsonEncoder.withIndent('  ');
    String pretty = encoder.convert(json);
    return pretty;
  }

  Future getUserFb(String token, Map<String, dynamic> userData) async {
    Map<String, dynamic> map = jsonDecode(parseJson(userData));
    await signInAuth(
      token: token,
      type: kApiSignInFacebook,
      fullName: jsonToString(map['name']),
      url: jsonToString(map['picture']?['data']?['url']),
      email: jsonToString(map['email']),
    );
  }

  Future _bypassAppleReview(
    String signUpToken,
    String? fullName,
    String? url,
  ) async {
    const pass = '123123';
    var signUpRes = SignUpRequest(
      token: signUpToken,
      passcode: pass,
      fullName: !fullName.isEmptyOrNull ? fullName! : 'Hidden Name',
      url: url,
    );

    showLoading();
    var res = await userRepo.signUp(request: signUpRes);
    print(res);
    hideLoading();
    if (res.status == kSuccessApi) {
      await _storage.setPasscodeInReview(pass);

      var resProfile = await userRepo.getProfile();
      if (resProfile.status == kSuccessApi) {
        UserModel model = resProfile.data;
        await _storage.setFullName(model.fullName);
        await _storage.setUser(model);
        goToAndRemove(screen: ROUTER_SUCCESS, argument: kTypeSignUpSuccess);
      } else {
        showDialogConfirm(content: resProfile.getErrors());
      }
    } else {
      showDialogConfirm(content: res.getErrors());
    }
  }
}
