import 'master_config.model.dart';

class CurrencyModel {
  // final khai báo biến mà chỉ có thể được gán giá trị một lần trong suốt vòng đời của nó.
  late final double pending;
  double amount, sum = 0;
  String currencyId, currency, icon = '', name = '';
  bool isChecked = false;
  ConfigModel? config;
  ConfigModel? swapConfig;
  MasterConfigCoin? coins;

  // dynamic cho phép bạn khai báo một biến có thể nhận bất kỳ kiểu dữ liệu nào.
  // Nó cho phép bạn thay đổi kiểu dữ liệu của biến tại bất kỳ thời điểm nào.
  CurrencyModel.fromJson(dynamic js)
    : // Chuyển đổi từ String sang double
      amount = double.tryParse(js['amount']) ?? 0.0,
      // Chuyển đổi từ String sang double
      pending = double.tryParse(js['pending']) ?? 0.0,
      currency = js['currency'],
      currencyId = js['currencyId'],
      config = js['config'] != null ? ConfigModel.fromJson(js['config']) : null,
      swapConfig =
          js['swapConfig'] != null
              ? ConfigModel.fromJson(js['swapConfig'])
              : null;

  static fromList(List list) =>
      list.map((e) => CurrencyModel.fromJson(e)).toList();
}

class ConfigModel {
  final double fee, min, max, minHold, maxPerDay;

  ConfigModel.fromJson(dynamic js)
    : maxPerDay = js['maxPerDay']?.toDouble() ?? 0,
      fee = js['fee']?.toDouble() ?? 0,
      min = js['min']?.toDouble() ?? 0,
      max = js['max']?.toDouble() ?? 0,
      minHold = js['minHold']?.toDouble() ?? 0;
}
