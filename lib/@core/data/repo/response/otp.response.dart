import 'package:bitnan/@share/utils/json.utils.dart';

class OtpResponse {
  int? otp;
  String? token;

  OtpResponse({this.otp, this.token});

  factory OtpResponse.fromMap(dynamic map) {
    return map is Map
        ? OtpResponse(
          otp: jsonToInt(map['otp']),
          token: jsonToString(map['token']),
        )
        : OtpResponse();
  }

  Map<String, dynamic> toMap() => {'otp': otp, 'token': token};
}
