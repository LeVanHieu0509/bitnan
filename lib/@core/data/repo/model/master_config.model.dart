import 'package:bitnan/@share/utils/json.utils.dart';

class MasterConfigCoin {
  String id, code, name, icon;
  bool withDrawable, exchangeAble, visible, isChecked = false;
  List<String> endPoint;

  MasterConfigCoin.fromJson(Map<String, dynamic> json)
    : code = jsonToString(json['code']),
      name = jsonToString(json['name']),
      withDrawable = jsonToBoolean(json['withdrawable']),
      exchangeAble = jsonToBoolean(json['exchangeable']),
      icon = jsonToString(json['icon']),
      visible = jsonToBoolean(json['visible']),
      id = jsonToString(json['id']),
      endPoint = jsonToList<String>(json['withdrawalEndpoint']);

  static List<MasterConfigCoin> fromList(List list) =>
      list.map((e) => MasterConfigCoin.fromJson(e)).toList();
}

class MasterConfigCoin2 {
  String id, code, name, icon;
  bool withDrawable, exchangeAble, visible, isChecked = false;
  List<String> endPoint;

  MasterConfigCoin2.fromJson(Map<String, dynamic> json)
    : code = jsonToString(json['code']),
      name = jsonToString(json['name']),
      withDrawable = jsonToBoolean(json['withdrawable']),
      exchangeAble = jsonToBoolean(json['exchangeable']),
      icon = jsonToString(json['icon']),
      visible = jsonToBoolean(json['visible']),
      id = jsonToString(json['id']),
      endPoint = jsonToList<String>(json['withdrawalEndpoint']);

  static List<MasterConfigCoin2> fromList(List list) =>
      list.map((e) => MasterConfigCoin2.fromJson(e)).toList();
}
