import 'package:bitnan/@share/utils/json.utils.dart';

class BaseResponse {
  int status, totalRecords;
  String message;
  int page;
  dynamic data;
  List<ItemError> errors;

  BaseResponse({
    this.status = 0,
    this.message = '',
    this.errors = const [],
    this.data,
    this.page = 0,
    this.totalRecords = 0,
  });

  factory BaseResponse.fromMap(dynamic map) {
    return map is Map
        ? BaseResponse(
          status: jsonToInt(map['status']),
          message: jsonToString(map['message']),
          page: jsonToInt(map['page']),
          totalRecords: jsonToInt(map['totalRecords']),
          data: map['data'],
          errors: map['data'] is List ? ItemError.fromList(map['data']) : [],
        )
        : BaseResponse(status: 0, message: '');
  }

  String getErrors() =>
      errors.isNotEmpty
          ? errors.map((e) => e.message).toList().join('\n')
          : message;

  List<String> getFieldError() => errors.map((e) => e.field).toList();

  Map<String, dynamic> toMap() => {
    'status': status,
    'message': message,
    'data': data,
    'totalRecords': totalRecords,
  };
}

class ItemError {
  String field, message, expiresIn, otp;
  int remainingSeconds;

  ItemError.fromMap(Map<String, dynamic> map)
    : field = jsonToString(map['field']),
      otp = jsonToString(map['otp']),
      message = jsonToString(map['message']),
      expiresIn = jsonToString(map['expiresIn']),
      remainingSeconds = jsonToInt(map['remainingSeconds']);

  static List<ItemError> fromList(List list) =>
      list.map((e) => ItemError.fromMap(e)).toList();

  Map<String, dynamic> toMap() => {'field': field, 'message': message};
}
