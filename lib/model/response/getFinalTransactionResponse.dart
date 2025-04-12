class GetFinalTransactionResponse {
  final String? message;
  final ErrorDetails error;

  GetFinalTransactionResponse({required this.message, required this.error});

  factory GetFinalTransactionResponse.fromJson(Map<String, dynamic> json) {
    return GetFinalTransactionResponse(
      message: json["message"] as String?,
      error: json["error"] as ErrorDetails,
    );
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
