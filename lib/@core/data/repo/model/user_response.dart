import 'package:bitnan/@share/utils/json.utils.dart';

class UserResponseModel {
  String? id;
  String? email;
  String? phone;
  String? fullName;
  String? avatar;
  String signInToken = '';
  bool? isNewUser;

  UserResponseModel({
    this.id,
    this.email,
    this.phone,
    this.fullName,
    this.avatar,
    this.signInToken = '',
    this.isNewUser,
  });

  UserResponseModel.fromJson(Map<String, dynamic> json) {
    id = jsonToString(json['id']);
    email = jsonToString(json['email']);
    phone = jsonToString(json['phone']);
    fullName = jsonToString(json['fullName']);
    avatar = jsonToString(json['avatar']);
    signInToken = jsonToString(json['signInToken']);
    isNewUser = jsonToBoolean(json['isNewUser']);
  }
}
