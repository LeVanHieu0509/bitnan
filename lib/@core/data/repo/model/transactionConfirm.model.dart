import 'package:bitnan/@share/utils/json.utils.dart';

class TransactionConfirmModel {
  String? successType;
  String? transactionType;
  String amount = '';

  TransactionConfirmModel({
    this.successType,
    this.transactionType,
    this.amount = '',
  });

  TransactionConfirmModel.fromMap(Map<String, dynamic> map)
    : successType = jsonToString(map['successType']),
      transactionType = jsonToString(map['transactionType']);

  Map<String, dynamic> toMap() => {
    'successType': successType,
    'transactionType': transactionType,
  };
}
