import 'package:bitnan/@share/common/encrypt_pass.dart';
import 'package:bitnan/@share/utils/json.utils.dart';

class SignUpRequest {
  String? url, phone, passcode, token, tokenEmail, referralBy, screenType;
  String email, fullName;

  SignUpRequest({
    this.url,
    this.phone,
    this.passcode,
    this.fullName = '',
    this.token,
    this.referralBy,
    this.email = '',
    this.tokenEmail,
    this.screenType,
  });

  Map<String, dynamic> toMap() => {
    if (email.isNotEmpty) 'email': email,
    if (phone is String) 'phone': phone,
    if (passcode is String && passcode != null)
      'passcode': EncryptPass.generateMd5(passcode!),
    if (fullName.isNotEmpty) 'fullName': fullName,
    if (token != null) 'token': token,
    if (referralBy is String && referralBy!.length >= 8)
      'referralBy': referralBy,
  };

  SignUpRequest.fromMap(Map<String, dynamic> map)
    : phone = jsonToString(map['phone']),
      passcode = jsonToString(map['passcode']),
      fullName = jsonToString(map['fullName']),
      token = jsonToString(map['token']),
      referralBy = jsonToString(map['referralBy']),
      email = jsonToString(map['email']);
}
