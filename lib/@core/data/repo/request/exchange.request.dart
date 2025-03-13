class ExchangeRequest {
  final double amount;
  final String fromCoin, toCoin;

  ExchangeRequest(
      {required this.amount, required this.fromCoin, required this.toCoin});

  Map<String, dynamic> toMap() =>
      {'amount': amount, 'fromCoin': fromCoin, 'toCoin': toCoin};
}
