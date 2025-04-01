class ExchangeRateModel {
  String? bid, ask, market;
  int? time;

  ExchangeRateModel({this.bid, this.time = 0, this.market, this.ask});

  factory ExchangeRateModel.fromMap(Map<String, dynamic> map) =>
      ExchangeRateModel(
        bid: map['bid'],
        time: map['time']?.toInt(),
        market: map['market'],
        ask: map['ask'],
      );

  Map<String, dynamic> toMap() => {
    'bid': bid,
    'time': time,
    'market': market,
    'ask': ask,
  };
}
