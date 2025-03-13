class ChickenRequest {
  static const DEFAULT_SIZE = 15;
  static const DEFAULT_PAGE = 1;

  int? page, size, type, sex;

  ChickenRequest({this.page, this.size = DEFAULT_SIZE, this.type, this.sex});

  Map<String, dynamic> toMap() => {
        'page': page != null ? page.toString() : DEFAULT_PAGE.toString(),
        'size': size != null ? size.toString() : DEFAULT_SIZE.toString(),
        'type': type.toString(),
        'sex': sex.toString(),
      };

  factory ChickenRequest.fromMap(Map<String, dynamic> map) => ChickenRequest(
        page: map['page'],
        size: map['size'],
        type: map['type'],
      );
}
