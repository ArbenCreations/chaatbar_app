class TokenDetailsResponse {
  final String? id;
  final String? object;
  final String? message;
  final CardDetails card;

  TokenDetailsResponse({
    required this.id,
    required this.object,
    required this.card,
    required this.message,
  });

  // Factory constructor to create an instance from JSON
  factory TokenDetailsResponse.fromJson(Map<String, dynamic> json) {
    // Handle cases where 'card' might be missing
    return TokenDetailsResponse(
      message: json['message'] ?? '', // Provide a default empty string if 'message' is missing
      id: json['id'],
      object: json['object'],
      card: json['card'] != null ? CardDetails.fromJson(json['card']) : CardDetails.defaultCard(), // Handle missing card
    );
  }

  // Method to convert an instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'object': object,
      'card': card.toJson(),
    };
  }
}

class CardDetails {
  final String? expMonth;
  final String? expYear;
  final String? first6;
  final String? last4;
  final String? brand;

  CardDetails({
    required this.expMonth,
    required this.expYear,
    required this.first6,
    required this.last4,
    required this.brand,
  });

  // Factory constructor to create an instance from JSON
  factory CardDetails.fromJson(Map<String, dynamic> json) {
    return CardDetails(
      expMonth: json['exp_month'] ?? '', // Provide default empty string if key is missing
      expYear: json['exp_year'] ?? '',
      first6: json['first6'] ?? '',
      last4: json['last4'] ?? '',
      brand: json['brand'] ?? '',
    );
  }

  // Default constructor to handle missing data
  factory CardDetails.defaultCard() {
    return CardDetails(
      expMonth: '',
      expYear: '',
      first6: '',
      last4: '',
      brand: '',
    );
  }

  // Method to convert an instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'exp_month': expMonth,
      'exp_year': expYear,
      'first6': first6,
      'last4': last4,
      'brand': brand,
    };
  }
}

class ErrorDetails {
  final String code;
  final String message;

  ErrorDetails({
    required this.code,
    required this.message,
  });

  // Factory constructor to create an instance from JSON
  factory ErrorDetails.fromJson(Map<String, dynamic> json) {
    return ErrorDetails(
      code: json['code'] ?? '', // Provide default empty string if key is missing
      message: json['message'] ?? '',
    );
  }

  // Method to convert an instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
    };
  }
}
