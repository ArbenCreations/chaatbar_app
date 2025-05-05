class EncryptedWallet {
  final ApplePayPaymentData applePayPaymentData;
  final String addressLine1;
  final String addressZip;

  EncryptedWallet({
    required this.applePayPaymentData,
    required this.addressLine1,
    required this.addressZip,
  });

  factory EncryptedWallet.fromJson(Map<String, dynamic> json) {
    final data = json['encryptedWallet'];
    return EncryptedWallet(
      applePayPaymentData: ApplePayPaymentData.fromJson(data['applePayPaymentData']),
      addressLine1: data['address_line1'] ?? '',
      addressZip: data['address_zip'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'encryptedWallet': {
        'applePayPaymentData': applePayPaymentData.toJson(),
        'address_line1': addressLine1,
        'address_zip': addressZip,
      }
    };
  }
}

class ApplePayPaymentData {
  final String version;
  final String data;
  final String signature;
  final PaymentHeader header;

  ApplePayPaymentData({
    required this.version,
    required this.data,
    required this.signature,
    required this.header,
  });

  factory ApplePayPaymentData.fromJson(Map<String, dynamic> json) {
    return ApplePayPaymentData(
      version: json['version'] ?? '',
      data: json['data'] ?? '',
      signature: json['signature'] ?? '',
      header: PaymentHeader.fromJson(json['header'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'data': data,
      'signature': signature,
      'header': header.toJson(),
    };
  }
}

class PaymentHeader {
  final String ephemeralPublicKey;
  final String publicKeyHash;
  final String transactionId;

  PaymentHeader({
    required this.ephemeralPublicKey,
    required this.publicKeyHash,
    required this.transactionId,
  });

  factory PaymentHeader.fromJson(Map<String, dynamic> json) {
    return PaymentHeader(
      ephemeralPublicKey: json['ephemeralPublicKey'] ?? '',
      publicKeyHash: json['publicKeyHash'] ?? '',
      transactionId: json['transactionId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ephemeralPublicKey': ephemeralPublicKey,
      'publicKeyHash': publicKeyHash,
      'transactionId': transactionId,
    };
  }
}
