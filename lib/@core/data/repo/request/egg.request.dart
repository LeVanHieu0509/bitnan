import 'package:bitnan/@share/utils/json.utils.dart';

class EggRequest {
  static const DEFAULT_SIZE = 15;
  static const DEFAULT_PAGE = 1;

  int? page, size, type, sex;

  EggRequest({this.sex, this.type, this.page, this.size = DEFAULT_SIZE});

  Map<String, dynamic> toMap() => {
    'page': page != null ? page.toString() : DEFAULT_PAGE.toString(),
    'size': size != null ? size.toString() : DEFAULT_SIZE.toString(),
    if (sex != null) 'sex': sex.toString(),
    if (type != null) 'type': type.toString(),
  };

  factory EggRequest.fromMap(Map<String, dynamic> map) =>
      EggRequest(page: jsonToInt(map['page']), size: jsonToInt(map['size']));
}
