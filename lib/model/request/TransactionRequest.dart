class TransactionRequest {
  final double amount;
  final String currency;
  final String source;
  final String description;

  TransactionRequest(
      {required this.amount,
        required this.currency,
        required this.source,
        required this.description});

  // Factory constructor to create an instance from JSON
  factory TransactionRequest.fromJson(Map<String, dynamic> json) {
    return TransactionRequest(
      amount: json['amount'],
      currency: json['currency'],
      source: json['source'],
      description: json['description'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'currency': currency,
      'source': source,
      'description': description
    };
  }
}
