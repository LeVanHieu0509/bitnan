import 'package:bitnan/@share/utils/json.utils.dart';

class ExchangeWallet {
  final String code, account;
  final bool editable;

  ExchangeWallet.fromJson(Map<String, dynamic> js)
    : code = jsonToString(js['code']),
      account = jsonToString(js['walletAddress']),
      editable = jsonToBoolean(js['editable']);

  static List<ExchangeWallet> fromList(List list) =>
      list.map((e) => ExchangeWallet.fromJson(e)).toList();
}
