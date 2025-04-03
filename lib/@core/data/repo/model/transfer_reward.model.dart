import 'package:bitnan/@share/utils/json.utils.dart';

class TransferRewardModel {
  String? token;

  TransferRewardModel.fromJson(Map<String, dynamic> json)
    : token = jsonToString(json['token']);
}
