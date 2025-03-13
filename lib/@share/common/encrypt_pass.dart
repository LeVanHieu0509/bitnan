import 'dart:convert';

import 'package:crypto/crypto.dart';

class EncryptPass {
  static String generateMd5(String pass) {
    return md5.convert(utf8.encode(pass)).toString();
  }
}
