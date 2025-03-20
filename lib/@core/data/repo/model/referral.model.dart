import 'package:bitnan/@share/utils/json.utils.dart';

class ReferralModel {
  int referralFrom, referralBy, nonReferral;

  ReferralModel({
    this.referralFrom = 0,
    this.referralBy = 0,
    this.nonReferral = 0,
  });

  ReferralModel.fromJson(Map<String, dynamic> js)
    : referralFrom = jsonToInt(js['referralFrom']),
      referralBy = jsonToInt(js['referralBy']),
      nonReferral = jsonToInt(js['nonReferral']);
}
