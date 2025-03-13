import 'package:bitnan/@share/common/encrypt_pass.dart';

class RequestChangePass {
  late final String? newPass, oldPass, type;

  RequestChangePass({this.newPass, this.oldPass, this.type});

  Map<String, dynamic> toMap() => {
    'passcode': newPass != null ? EncryptPass.generateMd5(newPass!) : null,
    'currentPasscode':
        oldPass != null ? EncryptPass.generateMd5(oldPass!) : null,
  };
}
