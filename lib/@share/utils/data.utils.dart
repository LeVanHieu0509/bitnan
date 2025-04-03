import 'package:bitnan/resource/image.resource.dart';
import 'package:bitnan/@share/constants/language.constant.dart';
import 'package:bitnan/resource/image.resource.dart';

class PayModel {
  final String image;
  final String content;
  final String code;

  PayModel({required this.image, required this.content, required this.code});
}

class User {
  final String uuid;
  User(this.uuid);
}

List<User> listUser = [
  User('769cb050-05c1-11ec-b9e9-a10c78fc0250'), // Tam nguyen
  User('bb4350e1-9585-4e0a-9d64-9f1b41b0a0b1'),
  User('bc0f25ff-6d57-4838-9b25-1932bc144f36'),
  User('a75d6897-6b2a-4589-a978-a4236c4788cc'),
  User('0bbed1b2-3c2f-4518-951e-b767d4596194'), //Truong ,
  User('f68e2e31-a7ac-42b2-a65f-50565dda6155'), //Quoc Cuong
  User('b4372738-7819-49cf-ac29-1ce4c2084a21'), //Long
  User('aa429da0-254f-4eb5-9516-a54dcf3802c5'), // Lan Anh
  User('4d0c4b13-3f09-4eee-ad5e-e807a52828e2'), // Minh Chau
  User('82ec957b-d9ec-424c-99d9-e585ef56e558'), // Nguyen Thi
  User('8168bade-ebbe-492c-9080-77138af58d68'), // Minh Phan
  User('634267e4-2d10-486a-ad70-a6d47a1e999c'), // Thanh Huynh
  User('62ab023d-3db5-4395-a2a4-ee139099bc8f'), // Phuong Anh
  User('80d98f4d-8795-4ade-8b92-c918c54d2ef0'), // Pham Anh dev
  User('2777ad51-e439-439c-a4da-d17c81a2091a'), // Pham Anh uat
];

List<PayModel> listServices = [
  PayModel(
    image: MyImage.ic_service_card,
    content: 'Nạp ĐT',
    code: 'MOBILE_TOPUP',
  ),
  PayModel(
    image: MyImage.ic_service_card_3g,
    content: 'Mã ĐT',
    code: 'MOBILE_CARD',
  ),
  PayModel(image: MyImage.ic_service_water, content: 'Nước', code: 'WATE'),
  PayModel(image: MyImage.ic_service_electron, content: 'Điện', code: 'POWE'),
  PayModel(image: MyImage.ic_service_tv, content: 'Truyền Hình', code: 'TIVI'),
  PayModel(image: MyImage.ic_service_fly, content: 'Vé Máy Bay', code: 'ATIC'),
  PayModel(
    image: MyImage.ic_service_internet,
    content: 'Internet',
    code: 'ADSL',
  ),
  PayModel(image: MyImage.ic_service_study, content: 'Học Phí', code: 'HOCPHI'),
];

class Promo {
  final String? icon;
  final String? promoDetail;
  final String? expiredDate;
  final bool? isUse;

  Promo({this.icon, this.promoDetail, this.expiredDate, this.isUse});
}

List<Promo> promoList = [
  Promo(
    icon: MyImage.img_logo_pizza,
    promoDetail: 'Ưu đãi 200,000 ₫ khi mua sản phẩm mới',
    expiredDate: 'HSD: 31/04/2021',
    isUse: true,
  ),
  Promo(
    icon: MyImage.img_logo_pepsi,
    promoDetail: 'Ưu đãi 200,000 ₫ khi mua sản phẩm mới',
    expiredDate: 'HSD: 31/04/2021',
    isUse: false,
  ),
];

class BankRecent {
  final String name = 'NGUYEN VAN A';
  final String bankName = 'Techcombank';
  final String bankNumber = '12346543';
}

List<BankRecent> bankRecent = [BankRecent(), BankRecent()];

List<String> alphaList = [
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'L',
  'M',
  'N',
  'O',
  'Q',
  'R',
  'S',
  'T',
  'U',
  'V',
  'W',
  'X',
  'Y',
  'Z',
  '#',
];

List<String> listVNDC = [
  '100,000',
  '200,000',
  '500,000',
  //pending remove
  // "1,500,000",
];

List<String> listBBC = ['500', '550', '700', '1,000'];
