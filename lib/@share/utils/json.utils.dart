int jsonToInt(dynamic val, [int defaulVal = 0]) {
  if (val is num) return val.toInt();
  if (val is String) return int.tryParse(val) ?? defaulVal;
  return defaulVal;
}

double jsonToDouble(dynamic val, [double defaulVal = 0]) {
  if (val is num) return val.toDouble();
  if (val is String) return double.tryParse(val) ?? defaulVal;
  return defaulVal;
}

bool jsonToBoolean(dynamic val, [bool defaulVal = false]) {
  if (val is bool) return val;
  if (val is num) return val != 0;
  if (val is String) return val.isNotEmpty;
  return defaulVal;
}

String jsonToString(dynamic val, [String defaulVal = '']) {
  if (val is String) return val;
  if (val is num) return val.toString();
  return defaulVal;
}

List<T> jsonToList<T>(dynamic val, [List<T> defaulVal = const []]) {
  if (val is List<T>) return val;
  if (val is List) {
    if (T == int) return val.map(jsonToInt).toList() as List<T>;
    if (T == double) return val.map(jsonToDouble).toList() as List<T>;
    if (T == bool) return val.map(jsonToBoolean).toList() as List<T>;
    if (T == String) return val.map(jsonToString).toList() as List<T>;
  }
  return defaulVal;
}
