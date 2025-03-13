class WalletDepositRequest {
  String? amount, url, transaction;
  int? method;

  WalletDepositRequest({this.amount, this.url, this.transaction, this.method});

  Map<String, dynamic> toMap() => {
        'amount': double.parse(amount?.replaceAll(',', '') ?? ''),
        'method': method
      };

  factory WalletDepositRequest.fromJson(dynamic js) =>
      WalletDepositRequest(url: js['url'], transaction: js['transaction']);
}
