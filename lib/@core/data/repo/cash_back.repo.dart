import 'package:bitnan/@core/data/api/cash_back.api.dart';
import 'package:bitnan/@core/data/repo/model/ads_banner.model.dart';
import 'package:bitnan/@core/data/repo/model/exchange_rate.model.dart';
import 'package:bitnan/@core/data/repo/model/partner_transaction.model.dart';
import 'package:bitnan/@core/data/repo/response/base.response.dart';
import 'package:bitnan/@share/constants/value.constant.dart';

import 'model/currency.model.dart';

class CashBackRepo {
  final CashBackApi cashBackApi;

  CashBackRepo(this.cashBackApi);

  Future<BaseResponse?> getCashBack() async {
    var res = await cashBackApi.getCashBack();

    try {
      return res
        ..data =
            res.status == kSuccessApi ? CurrencyModel.fromList(res.data) : null;
    } catch (err) {
      return null;
    }
  }

  Future<BaseResponse?> getExchangeRate() async {
    var res = await cashBackApi.getExchangeRate();
    try {
      if (res.data != null) {
        var data = Map.from(res.data).map(
          (key, value) => MapEntry<String, ExchangeRateModel>(
            key,
            ExchangeRateModel.fromMap(value),
          ),
        );

        return res..data = res.status == kSuccessApi ? data : null;
      }
      return null;
    } catch (err) {
      print(err.toString());
    }
    return null;
  }

  Future<BaseResponse?> patchDeviceToken(String? token) async {
    if (token == null) return null;
    var res = await cashBackApi.patchDeviceToken(token);
    return res..data = res.status == kSuccessApi ? res.data : null;
  }

  Future<BaseResponse> getNotification() async {
    var res = await cashBackApi.getNotification();
    return res..data = res.status == kSuccessApi ? res.data : null;
  }

  Future<BaseResponse> getBanner() async {
    var res = await cashBackApi.getBanner();
    return res..data = res.status == kSuccessApi ? res.data : null;
  }

  Future<BaseResponse> getWalletBalance() async {
    var res = await cashBackApi.getWalletBalance();
    return res..data = res.status == kSuccessApi ? res.data : null;
  }

  Future<BaseResponse> submitAmount({
    required String amount,
    String? method,
    String? currency,
    required String path,
  }) async {
    var res = await cashBackApi.submitAmount(
      amount: amount,
      method: method,
      currency: currency,
      path: path,
    );
    return res..data = res.status == kSuccessApi ? res.data : null;
  }

  Future<BaseResponse> submitVNDC({
    required String amount,
    required String account,
  }) async {
    var res = await cashBackApi.submitVNDC(amount: amount, account: account);
    return res..data = res.status == kSuccessApi ? res.data : null;
  }

  Future<BaseResponse> getAdsBanner() async {
    var res = await cashBackApi.getAdsBanner();
    return res
      ..data = res.status == kSuccessApi ? AdsBanner.fromList(res.data) : null;
  }

  Future<BaseResponse> getPartnerTransaction() async {
    var res = await cashBackApi.getPartnerTransaction();
    return res
      ..data =
          res.status == kSuccessApi
              ? PartnerTransactionModel.fromList(res.data)
              : null;
  }

  Future<BaseResponse> updateTransactionStatus(String id) async {
    var res = await cashBackApi.updateTransactionStatus(id);
    return res..data = res.status == kSuccessApi ? res.data : null;
  }

  Future<BaseResponse> cancelTransaction(String id) async {
    var res = await cashBackApi.cancelTransaction(id);
    return res..data = res.status == kSuccessApi ? res.data : null;
  }

  Future<BaseResponse> getMasterConfigCoin() async {
    var res = await cashBackApi.getMasterConfigCoin();
    return res..data = res.status == kSuccessApi ? res.data : null;
  }
}
