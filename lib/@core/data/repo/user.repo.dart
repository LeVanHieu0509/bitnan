import 'dart:io';

import 'package:bitnan/@core/data/api/upload.api.dart';
import 'package:bitnan/@core/data/api/user.api.dart';
import 'package:bitnan/@core/data/repo/model/referral.model.dart';
import 'package:bitnan/@core/data/repo/model/request_change_pass.dart';
import 'package:bitnan/@core/data/repo/model/token.model.dart';
import 'package:bitnan/@core/data/repo/model/user.model.dart';
import 'package:bitnan/@core/data/repo/request/auth_check.request.dart';
import 'package:bitnan/@core/data/repo/request/pass_code.request.dart';
import 'package:bitnan/@core/data/repo/request/profile.request.dart';
import 'package:bitnan/@core/data/repo/request/sign_up.request.dart';
import 'package:bitnan/@core/data/repo/response/base.response.dart';
import 'package:bitnan/@share/constants/value.constant.dart';

class UserRepo {
  final UserApi userApi;
  final UploadApi uploadApi;

  UserRepo(this.userApi, this.uploadApi);

  Future<BaseResponse> signInAuth(String token, String apiType) async {
    var res = await userApi.signInAuth(token, apiType);
    return res..data = res.status == kSuccessApi ? res.data : null;
  }

  Future<BaseResponse> authCheck(String phone, String email) async {
    return await userApi.authCheck(
      AuthCheckRequest(phone: phone, email: email),
    );
  }

  Future<BaseResponse> requestOtp({required AuthCheckRequest request}) async {
    var res = await userApi.requestOtp(request);
    return res
      ..data =
          res.status == kSuccessApi ? AuthCheckRequest.fromMap(res.data) : null;
  }

  Future<BaseResponse> verifyOtp({required AuthCheckRequest request}) async {
    var res = await userApi.verifyOtp(request);
    return res
      ..data =
          res.status == kSuccessApi ? AuthCheckRequest.fromMap(res.data) : null;
  }

  Future<BaseResponse> verifyEmail({required AuthCheckRequest request}) async {
    var res = await userApi.verifyEmail(request);
    return res
      ..data =
          res.status == kSuccessApi ? AuthCheckRequest.fromMap(res.data) : null;
  }

  Future<BaseResponse> signUp({required SignUpRequest request}) async {
    var res = await userApi.signUp(request);
    return res
      ..data = res.status == kSuccessApi ? TokenModel.fromMap(res.data) : null;
  }

  Future<BaseResponse> signIn({required SignUpRequest request}) async {
    var res = await userApi.signIn(request);
    return res
      ..data = res.status == kSuccessApi ? TokenModel.fromMap(res.data) : null;
  }

  Future<BaseResponse> getProfile() async {
    var res = await userApi.getProfile();
    return res
      ..data = res.status == kSuccessApi ? UserModel.fromMap(res.data) : null;
  }

  Future<BaseResponse> accountSetting(AccountSetting account) async {
    var res = await userApi.accountSetting(account);
    return res..data = res.status == kSuccessApi ? res.data : null;
  }

  Future<BaseResponse> editProfile(ProfileRequest request) async {
    var res = await userApi.editProfile(request);
    return res
      ..data = res.status == kSuccessApi ? UserModel.fromMap(res.data) : null;
  }

  Future<BaseResponse> editEmail(ProfileRequest request) async {
    var res = await userApi.editEmail(request);
    return res..data = res.status == kSuccessApi ? res.data : null;
  }

  Future<BaseResponse> resetPasscode(SignUpRequest request) async {
    var res = await userApi.resetPasscode(request);
    return res
      ..data =
          res.status == kSuccessApi ? SignUpRequest.fromMap(res.data) : null;
  }

  Future<BaseResponse> getNotification({
    int size = 10,
    required int page,
  }) async {
    var res = await userApi.getNotification(size, page);
    return res..data = res.status == kSuccessApi ? res.data : null;
  }

  Future<BaseResponse> changePassCode(RequestChangePass request) async {
    var res = await userApi.changePassCode(request);
    return res..data = res.status == kSuccessApi ? res.data : null;
  }

  Future<BaseResponse> getCheckKyc() async {
    var res = await userApi.getCheckKyc();
    return res..data = res.status == kSuccessApi ? res.data : null;
  }

  //Upload api

  Future<BaseResponse> postImages(String image, int type) async {
    var res = await uploadApi.postImages(File(image), type);
    return res;
  }

  Future<BaseResponse> postKycCheck(List<String> listImage) async {
    var res = await uploadApi.postKycCheck(listImage);
    return res;
  }

  Future<BaseResponse> verifyPassCode(PassCodeRequest request) async {
    var res = await userApi.verifyPassCode(request);
    return res
      ..data =
          res.status == kSuccessApi
              ? res.data is bool
                  ? res.data
                  : TokenModel.fromMap(res.data)
              : null;
  }

  Future<BaseResponse> signInPassCode(
    SignUpRequest request,
    String? path,
  ) async {
    var res = await userApi.postRequest(path ?? '', body: request.toMap());
    return res..data = res.status == kSuccessApi ? res.data : null;
  }

  // Future<BaseResponse> getCashBackIntroduce() async {
  //   var res = await userApi.getCashBackIntroduce();
  //   return res
  //     ..data =
  //         res.status == kSuccessApi ? ReferralModel.fromJson(res.data) : null;
  // }

  Future<BaseResponse> getCheckReferralCode(String ref) async {
    var res = await userApi.getCheckReferralCode(ref);
    return res..data = res.status == kSuccessApi ? res.data : null;
  }

  Future<BaseResponse> readAllNotification() async {
    return await userApi.readAllNotification();
  }

  Future<BaseResponse> readNotification(String id) async {
    return await userApi.readNotification(id);
  }

  // Future<BaseResponse> getFriends(num type) async {
  //   var res = await userApi.getFriends(type);
  //   return res
  //     ..data =
  //         res.status == kSuccessApi ? FriendModel.fromList(res.data) : null;
  // }

  Future<BaseResponse> getFriendKYC() async {
    var res = await userApi.getFriendKYC();
    return res..data = res.status == kSuccessApi ? res.data : null;
  }

  Future<BaseResponse> getDailyLuckyWheel() async {
    var res = await userApi.getDailyLuckyWheel();
    return res..data = res.status == kSuccessApi ? res.data : null;
  }

  // Future<BaseResponse> submitDailyLuckyWheel() async {
  //   var res = await userApi.submitDailyLuckyWheel();
  //   return res
  //     ..data =
  //         res.status == kSuccessApi ? DailyLuckyModel.fromJson(res.data) : null;
  // }

  // Future<BaseResponse> getListReward() async {
  //   var res = await userApi.getListReward();
  //   return res
  //     ..data =
  //         res.status == kSuccessApi ? RewardModel.fromList(res.data) : null;
  // }

  // Future<BaseResponse> getDashboard() async {
  //   var res = await userApi.getDashboard();
  //   return res
  //     ..data =
  //         res.status == kSuccessApi ? DashboardModel.fromJson(res.data) : null;
  // }

  Future<BaseResponse> getDashboardCommission(int page, int size) async {
    await userApi.getDashboard();
    var res = await userApi.getDashboardCommission(page, size);
    return res..data = res.status == kSuccessApi ? res.data : null;
  }

  Future<BaseResponse> checkPhone(String phone) async {
    var res = await userApi.checkPhone(phone);
    return res..data = res.status == kSuccessApi ? res.data : null;
  }

  Future<BaseResponse> preCheckOTP(String phone) async {
    var res = await userApi.preCheckPhone(phone);
    return res..data = res.status == kSuccessApi ? res.data : null;
  }

  Future<BaseResponse> preCheckPhoneOTP(String phone, String otp) async {
    var res = await userApi.preCheckPhoneOTP(phone, otp);
    return res..data = res.status == kSuccessApi ? res.data : null;
  }

  Future<BaseResponse> updatePhone(String phone) async {
    var res = await userApi.updatePhone(phone);
    return res..data = res.status == kSuccessApi ? res.data : null;
  }

  Future<BaseResponse> verifyPhone() async {
    var res = await userApi.verifyPhone();
    return res..data = res.status == kSuccessApi ? res.data : null;
  }

  Future<BaseResponse> updateKYC(int kycStatus, String userId) async {
    var res = await userApi.updateKYC(kycStatus, userId);
    return res..data = res.status == kSuccessApi ? res.data : null;
  }

  Future<BaseResponse> getCashBackIntroduce() async {
    var res = await userApi.getCashBackIntroduce();
    return res
      ..data =
          res.status == kSuccessApi ? ReferralModel.fromJson(res.data) : null;
  }
}
