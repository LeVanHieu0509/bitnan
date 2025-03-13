import 'package:bitnan/@share/utils/json.utils.dart';

class AuthCheckRequest {
  String? phone, email, type, token, otp, name, refCode;
  bool? resendOtp;
  AuthCheckRequest({
    this.phone,
    this.email,
    this.type,
    this.token,
    this.resendOtp,
    this.otp,
    this.name,
    this.refCode,
  });

  Map<String, dynamic> toMap() => {
    if (phone != null) 'phone': phone,
    if (email != null) 'email': email,
    if (type != null) 'type': type,
    if (token != null) 'token': token,
    if (otp != null) 'otp': otp,
  };

  AuthCheckRequest.fromMap(Map<String, dynamic> map)
    : phone = jsonToString(map['phone']),
      email = jsonToString(map['email']),
      type = jsonToString(map['type']),
      token = jsonToString(map['token']),
      otp = jsonToString(map['otp']);
}
