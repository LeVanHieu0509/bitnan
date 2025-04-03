import 'package:bitnan/@core/data/api/base_connect.api.dart';
import 'package:bitnan/@core/data/api/url.api.dart';
import 'package:bitnan/@core/data/repo/model/request_transfer.dart';
import 'package:bitnan/@core/data/repo/request/auth_check.request.dart';
import 'package:bitnan/@core/data/repo/response/base.response.dart';

class TransferRewardApi extends BaseConnect {
  Future<BaseResponse> getCashBack() async {
    return await getResponse(kApiMultipleCoin);
  }

  Future<BaseResponse> verifyOtp(AuthCheckRequest request) async {
    return await postRequest(kApiVerifyOtp, body: request.toMap());
  }

  Future<BaseResponse> exchangeInquiry(
    RequestTransfer request,
    String path,
  ) async {
    return await postRequest(path, body: request.toMap());
  }

  Future<BaseResponse> transferConfirm(RequestTransfer request) async {
    return await postRequest(kApiTransferConfirm, body: request.toMap());
  }

  Future<BaseResponse> transferExchange(
    RequestTransfer request,
    String path,
  ) async {
    return await postRequest(path, body: request.toMap());
  }

  Future<BaseResponse> getExchangeRate() async {
    return await getResponse(kApiExchangeRate);
  }

  Future<BaseResponse> getExchangeWallet() async {
    return await getResponse(kApiExchangeWallets);
  }
}
