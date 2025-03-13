import 'dart:convert';

import 'package:bitnan/@core/data/api/url.api.dart';
import 'package:bitnan/@core/data/repo/model/request_change_pass.dart';
import 'package:bitnan/@core/data/repo/model/user.model.dart';
import 'package:bitnan/@core/data/repo/request/auth_check.request.dart';
import 'package:bitnan/@core/data/repo/request/kyc_status.dart';
import 'package:bitnan/@core/data/repo/request/pass_code.request.dart';
import 'package:bitnan/@core/data/repo/request/profile.request.dart';
import 'package:bitnan/@core/data/repo/request/sign_up.request.dart';
import 'package:bitnan/@core/data/repo/response/base.response.dart';
import 'package:bitnan/@share/common/encrypt_aesc.dart';
import 'package:bitnan/@share/constants/value.constant.dart';

import 'base_connect.api.dart';

class UserApi extends BaseConnect {
  Future<BaseResponse> authCheck(AuthCheckRequest request) async {
    return await getResponse(kApiAuthCheck, query: request.toMap());
  }

  Future<BaseResponse> getProfile() async {
    return await getResponse(kApiProfile);
  }

  Future<BaseResponse> accountSetting(AccountSetting account) async {
    return await patchRequest(kApiAccountSetting, body: account.toMap());
  }

  Future<BaseResponse> getNotification(int size, int page) async {
    Map<String, String> request = {'page': '$page', 'size': '$size'};
    return await getResponse(kApiNotification, query: request);
  }

  Future<BaseResponse> getCheckKyc() async {
    return await getResponse(kApiKycCheck);
  }

  //POST

  Future<BaseResponse> signInAuth(String token, String apiType) async {
    Map<String, String> request = {'accessToken': token};
    return await postRequest(apiType, body: request);
  }

  Future<BaseResponse> requestOtp(AuthCheckRequest request) async {
    return await postRequest(kApiRequestOtp, body: request.toMap());
  }

  Future<BaseResponse> verifyOtp(AuthCheckRequest request) async {
    return await postRequest(
      request.type == kTypeTransferScreen
          ? kApiCashBackExchangeOtp
          : kApiVerifyOtp,
      body: request.toMap(),
    );
  }

  Future<BaseResponse> verifyEmail(AuthCheckRequest request) async {
    return await patchRequest(kApiVerifyEmail, body: request.toMap());
  }

  Future<BaseResponse> signUp(SignUpRequest request) async {
    return await postRequest(kApiSignUp, body: request.toMap());
  }

  Future<BaseResponse> verifyPassCode(PassCodeRequest request) async {
    return await postRequest(
      request.token.isNotEmpty ? kApiVerifyPassCode : kAuthVerifyPassCode,
      body: request.toMap(),
    );
  }

  Future<BaseResponse> signIn(SignUpRequest request) async {
    return await postRequest(kApiSignIn, body: request.toMap());
  }

  //PATCH

  Future<BaseResponse> editProfile(ProfileRequest request) async {
    return await patchRequest(kApiProfile, body: request.toMap());
  }

  Future<BaseResponse> editEmail(ProfileRequest request) async {
    return await patchRequest(kApiChangeEmail, body: request.toMap());
  }

  Future<BaseResponse> resetPasscode(SignUpRequest request) async {
    return await patchRequest(kApiResetPassword, body: request.toMap());
  }

  Future<BaseResponse> changePassCode(RequestChangePass request) async {
    return patchRequest(kApiChangePasscode, body: request.toMap());
  }

  Future<BaseResponse> signInPassCode(SignUpRequest request) async {
    return await postRequest(kApiSignInPassCode, body: request.toMap());
  }

  Future<BaseResponse> getCashBackIntroduce() async {
    return await getResponse(kApiIntroduce);
  }

  Future<BaseResponse> getCheckReferralCode(String ref) async {
    Map<String, dynamic> body = {'referralCode': ref};
    return await getResponse(kApiCheckReferralCode, query: body);
  }

  Future<BaseResponse> readAllNotification() async {
    var utc = DateTime.now().toUtc();
    Map<String, dynamic> request = {'at': utc.toString()};
    return await patchRequest(kApiReadAllNotification, body: request);
  }

  Future<BaseResponse> readNotification(String id) async {
    return await patchRequest('$kApiReadNotification$id');
  }

  Future<BaseResponse> getFriends(num type) async {
    return await getResponse(kApiReferral);
  }

  Future<BaseResponse> getFriendKYC() async {
    return await getResponse(kApiTotalKyc);
  }

  Future<BaseResponse> getListReward() async {
    return await getResponse(kApiLuckyWheel);
  }

  Future<BaseResponse> getDailyLuckyWheel() async {
    return await getResponse(kApiDailyLuckyWheel);
  }

  Future<BaseResponse> submitDailyLuckyWheel() async {
    return await postRequest(kApiDailyLuckyWheel);
  }

  Future<BaseResponse> getDashboard() async {
    return await getResponse(kApiDashboard);
  }

  Future<BaseResponse> getDashboardCommission(int page, int size) async {
    Map<String, dynamic> query = {'page': '$page', 'size': '$size'};
    return await getResponse(kApiDashboardCommission, query: query);
  }

  Future<BaseResponse> checkPhone(String phone) async {
    Map<String, dynamic> body = {'phone': phone};
    return await postRequest(kApiCheckPhone, body: body);
  }

  Future<BaseResponse> updatePhone(String phone) async {
    Map<String, dynamic> body = {'phone': phone};
    return await patchRequest(kApiUpdatePhone, body: body);
  }

  Future<BaseResponse> verifyPhone() async {
    return await patchRequest(kApiVerifyPhone);
  }

  Future<BaseResponse> preCheckPhone(String phone) async {
    Map<String, dynamic> body = {'phone': phone};
    return await postRequest(kApiPreCheckPhone, body: body);
  }

  Future<BaseResponse> preCheckPhoneOTP(String phone, String otp) async {
    Map<String, dynamic> body = {'phone': phone, 'otp': otp};
    return await postRequest(kApiPreCheckPhoneOTP, body: body);
  }

  Future<BaseResponse> updateKYC(int kycStatus, String userId) async {
    KycStatus kyc = KycStatus(kycStatus);
    EncryptAESC encryptAESC = EncryptAESC();
    Map<String, dynamic> body = {
      'message': encryptAESC.encryptAESCryptoJS(
        jsonEncode(kyc.toJson()),
        userId.replaceAll('-', ''),
      ),
    };
    return await patchRequest(kApiDeviceInfo, body: body);
  }
}
