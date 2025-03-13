import 'package:bitnan/@share/common/encrypt_pass.dart';
import 'package:bitnan/@share/utils/json.utils.dart';

class ProfileRequest {
  String? avatar,
      email,
      fullName,
      passCode,
      referralLink,
      giftAddress,
      walletAddress;
  int? coinId, id;

  ProfileRequest({
    this.id,
    this.avatar,
    this.email,
    this.fullName,
    this.coinId,
    this.referralLink,
    this.passCode,
    this.giftAddress,
    this.walletAddress,
  });

  Map<String, dynamic> toMap() => {
    if (avatar != null) 'avatar': avatar,
    if (email != null) 'email': email,
    if (fullName != null) 'fullName': fullName,
    if (passCode != null) 'passcode': EncryptPass.generateMd5(passCode!),
    if (coinId != null) 'coinId': coinId,
    if (referralLink != null) 'referralLink': referralLink,
    if (giftAddress != null) 'giftAddress': giftAddress,
    if (walletAddress != null) 'walletAddress': walletAddress,
  };

  ProfileRequest.fromMap(Map<String, dynamic> map)
    : id = jsonToInt(map['id']),
      avatar = jsonToString(map['avatar']),
      email = jsonToString(map['email']),
      fullName = jsonToString(map['fullName']),
      coinId = jsonToInt(map['coinId']),
      giftAddress = jsonToString(map['giftAddress']),
      walletAddress = jsonToString(map['walletAddress']);
}
