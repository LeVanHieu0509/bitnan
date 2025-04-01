import 'package:bitnan/@share/utils/json.utils.dart';

class PartnerTransactionModel {
  int amount = 0;
  int? status, partnerType, methodType;
  String? orderId, title, description, updatedAt;
  Account? account;

  PartnerTransactionModel({
    this.orderId,
    this.amount = 0,
    this.status,
    this.title,
    this.partnerType,
    this.description,
    this.updatedAt,
    this.methodType,
    this.account,
  });

  PartnerTransactionModel.fromMap(Map<String, dynamic> json) {
    orderId = jsonToString(json['orderId']);
    amount = jsonToInt(json['amount']);
    status = jsonToInt(json['status']);
    title = jsonToString(json['title']);
    partnerType = jsonToInt(json['partnerType']);
    description = jsonToString(json['description']);
    updatedAt = jsonToString(json['updatedAt']);
    methodType = jsonToInt(json['methodType']);
    account =
        json['account'] != null ? Account.fromJson(json['account']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['orderId'] = orderId;
    data['amount'] = amount;
    data['status'] = status;
    data['title'] = title;
    data['partnerType'] = partnerType;
    data['description'] = description;
    data['updatedAt'] = updatedAt;
    if (account != null) data['account'] = account!.toJson();

    return data;
  }

  static fromList(List list) =>
      list.map((e) => PartnerTransactionModel.fromMap(e)).toList();
}

class Account {
  String? id;
  String? fullName;

  Account.fromJson(Map<String, dynamic> json)
    : id = jsonToString(json['id']),
      fullName = jsonToString(json['fullName']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['fullName'] = fullName;
    return data;
  }
}
