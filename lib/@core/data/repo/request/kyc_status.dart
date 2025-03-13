class KycStatus {
  int status;

  KycStatus(this.status);

  Map toJson() => {
    'kycStatus': status,
  };
}