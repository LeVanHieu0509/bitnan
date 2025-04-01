import 'package:bitnan/@core/data/api/url.api.dart';
import 'package:bitnan/@core/data/repo/response/base.response.dart';

import 'base_connect.api.dart';

class CashBackApi extends BaseConnect {
  //GET

  Future<BaseResponse> getCashBack() async {
    return await getResponse(kApiMultipleCoin);
  }

  Future<BaseResponse> getExchangeRate() async {
    return await getResponse(kApiExchangeRate);
  }

  Future<BaseResponse> patchDeviceToken(String token) async {
    Map<String, String> request = {'deviceToken': token};
    return await patchRequest2(kApiDeviceToken, body: request);
  }

  Future<BaseResponse> getNotification() async {
    return await getResponse(kApiGetNotification);
  }

  Future<BaseResponse> getBanner() async {
    return await getResponse(kApiBanner);
  }

  Future<BaseResponse> getWalletBalance() async {
    return await getResponse(kApiWalletBalance);
  }

  Future<BaseResponse> getAdsBanner() async {
    return await getResponse(kApiAdsBanner);
  }

  Future<BaseResponse> submitAmount({
    required String amount,
    String? method,
    String? currency,
    required String path,
  }) async {
    Map request = {
      'amount': amount,
      if (method != null) 'methodType': method,
      if (currency != null) 'currency': currency,
    };
    return await postRequest(path, body: request);
  }

  Future<BaseResponse> submitVNDC({
    required String amount,
    required String account,
  }) async {
    Map request = {'amount': amount, 'vndcReceiver': account};
    return await postRequest(kApiPartnerLink, body: request);
  }

  Future<BaseResponse> getPartnerTransaction() async {
    return await getResponse('$kApiPartnerTransaction?version=latest');
  }

  Future<BaseResponse> updateTransactionStatus(String id) async {
    return await patchRequest('$kApiPartnerTransaction/$id');
  }

  Future<BaseResponse> cancelTransaction(String id) async {
    return await deleteRequest('$kApCancelTransaction$id');
  }

  Future<BaseResponse> getMasterConfigCoin() async {
    return await getResponse(kApiMasterConfigCoin);
  }
}
