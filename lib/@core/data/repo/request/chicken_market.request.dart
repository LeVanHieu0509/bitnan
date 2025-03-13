import 'package:bitnan/@share/utils/json.utils.dart';

class ChickenMarketRequest {
  static const DEFAULT_SIZE = 20;
  static const DEFAULT_PAGE = 1;

  int? page, size, type, chickenType, sex;

  ChickenMarketRequest({
    this.page,
    this.size,
    this.type,
    this.chickenType,
    this.sex,
  });

  Map<String, dynamic> requestChicken() => {
    'page': page != null ? page.toString() : DEFAULT_PAGE,
    'size': size != null ? size.toString() : DEFAULT_SIZE,
    'type': type.toString(),
    'chickenType': chickenType.toString(),
    'sex': sex.toString(),
  };

  Map<String, dynamic> requestEgg() => {
    'page': page != null ? page.toString() : DEFAULT_PAGE,
    'size': size != null ? size.toString() : DEFAULT_SIZE,
    'type': type.toString(),
    if (chickenType != null) 'chickenType': chickenType.toString(),
  };

  factory ChickenMarketRequest.fromMap(Map<String, dynamic> map) =>
      ChickenMarketRequest(
        page: jsonToInt(map['number']),
        size: jsonToInt(map['size']),
        type: jsonToInt(map['chickenType']),
      );
}

class BuyChickenRequest {
  BuyChickenRequest({this.token = 'BBC'});

  String token;

  factory BuyChickenRequest.fromJson(Map<String, dynamic> json) =>
      BuyChickenRequest(token: json['token']);

  Map<String, dynamic> toJson() => {'token': token};
}
