import 'package:bitnan/@core/data/repo/model/token.model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DataStorage {
  late GetStorage _storage;

  final _fullName = 'fullName';
  final _token = 'token';
  final _refreshToken = 'refreshToken';
  final _userInfo = 'userInfo';
  final _eventId = 'eventId';
  final _version = 'version';
  final _walletVNDC = 'walletVNDC';
  final _lastHarvestTimeStamp = '_lastHarvestTimeStamp';
  final _countRate = '_countRate';
  final _dateRate = '_dateRate';
  final _lang = '_lang';
  final _notification = '_notification';
  final _enableAuthentication = '_enableAuthentication';
  final _passcodeInReview = '';
  final _baseUrl = '_baseUrl';
  final _baseUrlGame = '_baseUrlGame';

  DataStorage() {
    _storage = GetStorage();
  }

  Future setWalletVNDC(bool value) async =>
      await _storage.write(_walletVNDC, value);

  Future setAuthentication(bool value) async =>
      await _storage.write(_enableAuthentication, value);

  Future setFullName(String value) async =>
      await _storage.write(_fullName, value);

  Future setLang(String value) async => await _storage.write(_lang, value);

  Future setVersion(String value) async =>
      await _storage.write(_version, value);

  Future setNotification(bool value) async =>
      await _storage.write(_notification, value);

  Future setEventId(String value) async =>
      await _storage.write(_eventId, value);

  Future setPasscodeInReview(String value) async =>
      await _storage.write(_passcodeInReview, value);

  Future getWalletVNDC() async => await _storage.read(_walletVNDC) ?? false;

  Future getAuthentication() async =>
      await _storage.read(_enableAuthentication) ?? false;

  bool getNotification() => _storage.read(_notification) ?? true;

  Future setToken(TokenModel model) async {
    await _storage.write(_token, model.accessToken);
    await _storage.write(_refreshToken, model.refreshToken);
  }

  Future clearToken() async {
    await _storage.write(_token, '');
    await _storage.write(_refreshToken, '');
    await _storage.write(_passcodeInReview, '');
  }

  String getAccessToken() => _storage.read<String>(_token) ?? '';

  String getLang() => _storage.read<String>(_lang) ?? 'vi';

  String getVersion() => _storage.read<String>(_version) ?? '';

  String getRefreshToken() => _storage.read<String>(_refreshToken) ?? '';

  String getFullName() => _storage.read<String>(_fullName) ?? '';

  String getEventId() => _storage.read<String>(_eventId) ?? '';

  int getLastHarvestTimeStamp() =>
      _storage.read<int>(_lastHarvestTimeStamp) ?? 0;

  Future setLastHarvestTimeStamp(int timeStamp) async {
    await _storage.write(_lastHarvestTimeStamp, timeStamp);
  }

  Future setCountRate(int value) async =>
      await _storage.write(_countRate, value);

  int getCountRate() => _storage.read<int>(_countRate) ?? 0;

  Future setDateRate(int value) async => await _storage.write(_dateRate, value);

  int getDateRate() =>
      _storage.read<int>(_dateRate) ?? DateTime.now().millisecondsSinceEpoch;

  // Future setUser(UserModel model) async {
  //   var json = jsonEncode(model.toMap());
  //   await _storage.write(_userInfo, json);
  // }

  // UserModel getUser() {
  //   String data = _storage.read<String>(_userInfo) ?? '';
  //   if (data.isNotEmpty) {
  //     return UserModel.fromMap(jsonDecode(data));
  //   } else {
  //     return UserModel();
  //   }
  // }

  Future setBaseUrl({required String baseUrl}) async {
    await _storage.write(_baseUrl, baseUrl);
    Get.log('UPDATE BASE URL $baseUrl');
  }

  Future setBaseUrlGame({required String baseUrl}) async {
    await _storage.write(_baseUrlGame, baseUrl);
    Get.log('UPDATE BASE URL $baseUrl');
  }

  String getPasscodeInReview() => _storage.read(_passcodeInReview) ?? '';

  Future clearUser() async {
    await _storage.remove(_userInfo);
  }

  // Future clearAllData() async {
  //   await _storage.erase();
  //   await GoogleSignIn().signOut();
  //   await FacebookAuth.instance.logOut();
  // }
}
