import 'package:bitnan/@share/utils/json.utils.dart';

class CampaignRequest {
  String? categoryId, sort;

  CampaignRequest({this.categoryId, this.sort});

  Map<String, dynamic> toMap() => {
    'categoryId': categoryId ?? '',
    //'sort': this.sort != null ? this.sort : ''
  };

  CampaignRequest.fromMap(Map<String, dynamic> map)
    : categoryId = jsonToString(map['categoryId']),
      sort = jsonToString(map['sort']);
}
