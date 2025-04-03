import 'package:bitnan/@core/data/api/transfer_reward.api.dart';
import 'package:bitnan/@core/data/api/url.api.dart';
import 'package:bitnan/@core/data/repo/model/currency.model.dart';
import 'package:bitnan/@core/data/repo/model/exchange_rate.model.dart';
import 'package:bitnan/@core/data/repo/model/exchange_wallet.model.dart';
import 'package:bitnan/@core/data/repo/model/transfer_reward.model.dart';
import 'package:bitnan/@core/data/repo/request/auth_check.request.dart';
import 'package:bitnan/@core/data/repo/request/sign_up.request.dart';
import 'package:bitnan/@core/data/repo/response/base.response.dart';
import 'package:bitnan/@share/constants/value.constant.dart';

import 'model/request_transfer.dart';

class TransferRewardRepo {
  final TransferRewardApi api;

  TransferRewardRepo(this.api);

  Future<BaseResponse> getCashBack() async {
    var res = await api.getCashBack();
    return res
      ..data =
          res.status == kSuccessApi ? CurrencyModel.fromList(res.data) : null;
  }

  Future<BaseResponse> verifyOtp(AuthCheckRequest request) async {
    var res = await api.postRequest(kApiVerifyOtp, body: request.toMap());
    return res..data = res.status == kSuccessApi ? res.data : null;
  }

  Future<BaseResponse> signInPassCode(SignUpRequest request) async {
    var res = await api.postRequest(kApiSignInPassCode, body: request.toMap());
    return res..data = res.status == kSuccessApi ? res.data : null;
  }

  Future<BaseResponse> exchangeInquiry(
    RequestTransfer request,
    String path,
  ) async {
    var res = await api.exchangeInquiry(request, path);
    return res
      ..data =
          res.status == kSuccessApi
              ? TransferRewardModel.fromJson(res.data)
              : null;
  }

  Future<BaseResponse> transferConfirm(RequestTransfer request) async {
    var res = await api.transferConfirm(request);
    return res..data = res.status == kSuccessApi ? res.data : null;
  }

  Future<BaseResponse> transferExchange(
    RequestTransfer request,
    String path,
  ) async {
    var res = await api.transferExchange(request, path);
    return res..data = res.status == kSuccessApi ? res.data : null;
  }

  Future<BaseResponse> getExchangeRate() async {
    var res = await api.getExchangeRate();

    var data = Map.from(res.data).map(
      (key, value) => MapEntry<String, ExchangeRateModel>(
        key,
        ExchangeRateModel.fromMap(value),
      ),
    );

    return res..data = res.status == kSuccessApi ? data : null;
  }

  Future<BaseResponse> getExchangeWallet() async {
    var res = await api.getExchangeWallet();
    return res
      ..data =
          res.status == kSuccessApi ? ExchangeWallet.fromList(res.data) : null;
  }
}
