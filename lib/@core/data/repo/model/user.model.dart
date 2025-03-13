import 'package:bitnan/@share/utils/json.utils.dart';

class UserModel {
  int status = 0, coinId = 0, kycStatus = 0;
  bool resendOtp = false,
      isIdentity = false,
      isVideo = false,
      isCheckSMS = false,
      isCheckMail = false,
      emailVerified = false,
      phoneVerified = false,
      isPartner = false;
  String id = '', email = '', phone = '';
  String fullName,
      avatar,
      createdAt,
      updateAt,
      passCode = '',
      walletAddress = '',
      giftAddress = '';
  String? referralCode, referralLink, referralBy;

  AccountSetting? setting;

  UserModel({
    this.id = '',
    this.status = 0,
    this.kycStatus = 0,
    this.referralCode,
    this.coinId = 0,
    this.isIdentity = false,
    this.isVideo = false,
    this.isCheckSMS = false,
    this.isCheckMail = false,
    this.emailVerified = false,
    this.resendOtp = false,
    this.isPartner = false,
    this.phoneVerified = false,
    this.phone = '',
    this.fullName = '',
    this.avatar = '',
    this.email = '',
    this.createdAt = '',
    this.updateAt = '',
    this.passCode = '',
    this.referralLink,
    this.referralBy,
    this.setting,
    this.giftAddress = '',
    this.walletAddress = '',
  });

  UserModel.fromMap(Map<String, dynamic> map)
    : id = jsonToString(map['id']),
      status = jsonToInt(map['status']),
      kycStatus = jsonToInt(map['kycStatus']),
      referralCode = jsonToString(map['referralCode']),
      coinId = jsonToInt(map['coinId']),
      isIdentity = jsonToBoolean(map['isIdentity']),
      isVideo = jsonToBoolean(map['isVideo']),
      phoneVerified = jsonToBoolean(map['phoneVerified']),
      isCheckSMS = jsonToBoolean(map['isCheckSMS']),
      isCheckMail = jsonToBoolean(map['isCheckMail']),
      emailVerified = jsonToBoolean(map['emailVerified']),
      isPartner = jsonToBoolean(map['isPartner']),
      phone = jsonToString(map['phone']).replaceAll('+84', '0'),
      fullName = jsonToString(map['fullName']),
      avatar = jsonToString(map['avatar']),
      email = jsonToString(map['email']),
      giftAddress = jsonToString(map['giftAddress']),
      walletAddress = jsonToString(map['walletAddress']),
      referralLink = jsonToString(map['referralLink']),
      createdAt = jsonToString(map['createdAt']),
      updateAt = jsonToString(map['updateAt']),
      referralBy = jsonToString(map['referralBy']),
      setting =
          map['accountSetting'] != null
              ? AccountSetting.fromJson(map['accountSetting'])
              : AccountSetting(language: 'VI', receiveNotify: true);

  Map<String, dynamic> toMap() => {
    'id': id,
    'status': status,
    'kycStatus': kycStatus,
    'referralCode': referralCode,
    'coinId': coinId,
    'isIdentity': isIdentity,
    'isVideo': isVideo,
    'isCheckSMS': isCheckSMS,
    'isCheckMail': isCheckMail,
    'phone': phone,
    'fullName': fullName,
    'avatar': avatar,
    'email': email,
    'createdAt': createdAt,
    'updateAt': updateAt,
    'giftAddress': giftAddress,
    'walletAddress': walletAddress,
  };

  bool getVerify() => isIdentity && isVideo;

  bool getVerifyOTP() => isCheckSMS && isCheckMail;
}

class AccountSetting {
  bool receiveNotify = true;
  String language = 'VI';

  AccountSetting({this.receiveNotify = true, this.language = 'VI'});

  factory AccountSetting.fromJson(Map<String, dynamic> map) {
    return AccountSetting(
      receiveNotify: map['receiveNotify'] ?? true,
      language: map['language'] ?? 'VI',
    );
  }

  Map<String, dynamic> toMap() => {
    'receiveNotify': receiveNotify,
    'language': language,
  };
}
