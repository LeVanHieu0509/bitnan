class HistoryFarmRequest {
  int? page, size, status;
  int type = 0, eggType = 0, from = 0, to = 0;

  HistoryFarmRequest({
    this.from = 0,
    this.to = 0,
    this.page,
    this.size,
    this.status,
    this.type = 0,
    this.eggType = 0,
  });

  Map<String, dynamic> toMap() => {
        'page': '$page',
        'size': '$size',
        'status': '$status',
        if (type != 0) 'type': '$type',
        if (from != 0) 'from': '$from',
        if (to != 0) 'to': '$to',
        if (eggType != 0) 'eggType': '$eggType'
      };
}
