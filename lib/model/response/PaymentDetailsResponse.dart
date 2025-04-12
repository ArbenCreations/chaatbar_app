class PaymentDetails {
  final String? message;
  final String id;
  final int amount;
  final String paymentMethodDetails;
  final int amountRefunded;
  final String currency;
  final int created;
  final bool captured;
  final String refNum;
  final String authCode;
  final Outcome outcome;
  final bool paid;
  final String status;
  final Source source;

  PaymentDetails({
    required this.message,
    required this.id,
    required this.amount,
    required this.paymentMethodDetails,
    required this.amountRefunded,
    required this.currency,
    required this.created,
    required this.captured,
    required this.refNum,
    required this.authCode,
    required this.outcome,
    required this.paid,
    required this.status,
    required this.source,
  });

  // Factory constructor to create an instance from JSON
  factory PaymentDetails.fromJson(Map<String, dynamic> json) {
    return PaymentDetails(
      message: json?['message'],
      id: json['id'],
      amount: json['amount'],
      paymentMethodDetails: json['payment_method_details'],
      amountRefunded: json['amount_refunded'],
      currency: json['currency'],
      created: json['created'],
      captured: json['captured'],
      refNum: json['ref_num'],
      authCode: json['auth_code'],
      outcome: Outcome.fromJson(json['outcome']),
      paid: json['paid'],
      status: json['status'],
      source: Source.fromJson(json['source']),
    );
  }

  // Method to convert an instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'payment_method_details': paymentMethodDetails,
      'amount_refunded': amountRefunded,
      'currency': currency,
      'created': created,
      'captured': captured,
      'ref_num': refNum,
      'auth_code': authCode,
      'outcome': outcome.toJson(),
      'paid': paid,
      'status': status,
      'source': source.toJson(),
    };
  }
}

class Outcome {
  final String networkStatus;
  final String type;

  Outcome({
    required this.networkStatus,
    required this.type,
  });

  // Factory constructor to create an instance from JSON
  factory Outcome.fromJson(Map<String, dynamic> json) {
    return Outcome(
      networkStatus: json['network_status'],
      type: json['type'],
    );
  }

  // Method to convert an instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'network_status': networkStatus,
      'type': type,
    };
  }
}

class Source {
  final String id;
  final String brand;
  final String expMonth;
  final String expYear;
  final String first6;
  final String last4;

  Source({
    required this.id,
    required this.brand,
    required this.expMonth,
    required this.expYear,
    required this.first6,
    required this.last4,
  });

  // Factory constructor to create an instance from JSON
  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json['id'],
      brand: json['brand'],
      expMonth: json['exp_month'],
      expYear: json['exp_year'],
      first6: json['first6'],
      last4: json['last4'],
    );
  }

  // Method to convert an instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand': brand,
      'exp_month': expMonth,
      'exp_year': expYear,
      'first6': first6,
      'last4': last4,
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
      code: json['code'],
      message: json['message'],
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
