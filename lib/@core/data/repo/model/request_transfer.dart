class RequestTransfer {
  String currency, amount, account, type, otp, phone, method;
  String? token;

  RequestTransfer({
    this.currency = '',
    this.amount = '',
    this.account = '',
    this.token,
    this.otp = '',
    this.phone = '',
    this.type = '',
    this.method = '',
  });

  Map<String, dynamic> toMap() => {
    'currency': currency,
    'amount': amount,
    'receiverInfo': account,
    if (token != null) 'token': token,
    'method': method,
  };
}
