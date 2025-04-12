class CreateOtpChangePassResponse {
  int? status;
  String? email;
  String? message;

  CreateOtpChangePassResponse({
    this.status,
    this.email,
    this.message,
  });

  factory CreateOtpChangePassResponse.fromJson(Map<String, dynamic> json) {
    return CreateOtpChangePassResponse(
      status: json["status"] as int?,
      message: json["message"] as String?,
      email: json.containsKey('data') && json['data'] is Map
          ? (json['data'] as Map<String, dynamic>)["email"] as String?
          : null,
    );
  }
}
