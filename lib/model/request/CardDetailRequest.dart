class CardRequest {
  final CardDetailsRequest card;

  CardRequest({
    required this.card,
  });

  // Factory constructor to create an instance from JSON
  factory CardRequest.fromJson(Map<String, dynamic> json) {
    return CardRequest(
      card: CardDetailsRequest.fromJson(json['card']),
    );
  }

  // Method to convert an instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'card': card.toJson(),
    };
  }
}

class CardDetailsRequest {
  final String number;
  final String expMonth;
  final String expYear;
  final String cvv;
  //final String brand;

  CardDetailsRequest({
    required this.number,
    required this.expMonth,
    required this.expYear,
    required this.cvv,
   // required this.brand,
  });

  // Factory constructor to create an instance from JSON
  factory CardDetailsRequest.fromJson(Map<String, dynamic> json) {
    return CardDetailsRequest(
      number: json['number'],
      expMonth: json['exp_month'],
      expYear: json['exp_year'],
      cvv: json['cvv'],
     // brand: json['brand'],
    );
  }

  // Method to convert an instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'exp_month': expMonth,
      'exp_year': expYear,
      'cvv': cvv,
      //'brand': brand,
    };
  }
}
