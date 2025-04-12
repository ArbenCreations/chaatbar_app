class SignUpInitializeResponse {
  final String? phoneNumber;
  final String? message;
  final int? status;

  SignUpInitializeResponse({
    this.phoneNumber,
    this.message,
    this.status,
  });

  factory SignUpInitializeResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return SignUpInitializeResponse(
      message: data is String ? data : json['message'] as String?,
      status: json['status'] as int?,
      phoneNumber: data is Map<String, dynamic> ? data['phone_number'] as String? : null,
    );
  }
}
