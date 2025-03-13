import 'package:bitnan/@share/utils/json.utils.dart';

class TokenModel {
  String accessToken, refreshToken;
  int expiresIn;

  TokenModel.fromMap(Map<String, dynamic> map)
    : accessToken = jsonToString(map['accessToken']),
      refreshToken = jsonToString(map['refreshToken']),
      expiresIn = jsonToInt(map['expiresIn']);

  Map<String, dynamic> toMap() => {
    'accessToken': accessToken,
    'refreshToken': refreshToken,
    'expiresIn': expiresIn,
  };
}
