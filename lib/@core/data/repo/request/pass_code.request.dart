import 'package:bitnan/@share/common/encrypt_pass.dart';

class PassCodeRequest {
  String passCode;
  String token;

  PassCodeRequest(this.passCode, this.token);

  Map<String, dynamic> toMap() => {
    'passcode': EncryptPass.generateMd5(passCode),
    // 'passcode': passCode,
    if (token.isNotEmpty) 'token': token,
  };
}
