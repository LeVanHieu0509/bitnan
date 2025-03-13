class RankRequest {
  int? page, size, status, type;
  int from, to;

  RankRequest(
      {this.from = 0,
      this.to = 0,
      this.page,
      this.size,
      this.status,
      this.type});

  Map<String, dynamic> toMap() => {
        'page': '$page',
        'size': '$size',
        if (from != 0) 'from': '$from',
        if (to != 0) 'to': '$to'
      };
}
