class AppleTokenDetailsResponse {
  final String id;
  final String object;
  final Wallet? wallet;

  AppleTokenDetailsResponse({
    required this.id,
    required this.object,
    this.wallet,
  });

  factory AppleTokenDetailsResponse.fromJson(Map<String, dynamic> json) {
    return AppleTokenDetailsResponse(
      id: json['id'] ?? '',
      object: json['object'] ?? '',
      wallet: json['wallet'] != null
          ? Wallet.fromJson(json['wallet'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'object': object,
      'wallet': wallet?.toJson(),
    };
  }
}

class Wallet {
  final String expMonth;
  final String expYear;
  final String last4;
  final String first6;
  final String brand;
  final String addressLine1;
  final String addressZip;

  Wallet({
    required this.expMonth,
    required this.expYear,
    required this.last4,
    required this.first6,
    required this.brand,
    required this.addressLine1,
    required this.addressZip,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      expMonth: json['exp_month'] ?? '',
      expYear: json['exp_year'] ?? '',
      last4: json['last4'] ?? '',
      first6: json['first6'] ?? '',
      brand: json['brand'] ?? '',
      addressLine1: json['address_line1'] ?? '',
      addressZip: json['address_zip'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exp_month': expMonth,
      'exp_year': expYear,
      'last4': last4,
      'first6': first6,
      'brand': brand,
      'address_line1': addressLine1,
      'address_zip': addressZip,
    };
  }
}
