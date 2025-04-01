import 'package:bitnan/@share/utils/json.utils.dart';

class AdsBanner {
  final String title, url, startAt, stopAt, externalLink, buttonTitle;

  AdsBanner.fromMap(Map<String, dynamic> js)
    : title = jsonToString(js['title']),
      url = jsonToString(js['url']),
      startAt = jsonToString(js['startAt']),
      externalLink = jsonToString(js['externalLink']),
      buttonTitle = jsonToString(js['buttonTitle']),
      stopAt = jsonToString(js['stopAt']);

  static List<AdsBanner> fromList(List list) =>
      list.map((e) => AdsBanner.fromMap(e)).toList();

  bool isEmptyButtonOrLink() {
    if (buttonTitle.isEmpty) return true;
    if (externalLink.isEmpty) return true;
    return false;
  }
}
