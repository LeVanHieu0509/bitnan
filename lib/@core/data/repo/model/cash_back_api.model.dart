import 'package:bitnan/@core/data/repo/model/currency.model.dart';
import 'package:bitnan/@share/utils/json.utils.dart';

class CashBackApiModel {
  double? amount;
  CurrencyModel? coinMaster;

  Map<String, dynamic> toMap() => {'amount': amount, 'coinMaster': coinMaster};

  CashBackApiModel.fromMap(dynamic map)
    : amount = jsonToDouble(map['amount']),
      coinMaster = CurrencyModel.fromJson(map['coinMaster']);

  static List<CashBackApiModel> fromList(List list) =>
      list.map((e) => CashBackApiModel.fromMap(e)).toList();
}
