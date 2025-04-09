class SignUpVerifyResponse {
  final SignUpCustomer? customer;
  final String? token;
  final String? message;
  final int? status;

  SignUpVerifyResponse(
      {this.customer,
      this.token,
      this.status,
      this.message,});

  factory SignUpVerifyResponse.fromJson(Map<String, dynamic> json) {
    if (json['status'] == 422) {
      return SignUpVerifyResponse(
        message: json['data']?.toString() ?? "Unknown error",
        status: json['status'] as int?,
      );
    }

    final data = json['data'];
    return SignUpVerifyResponse(
      message: json['message']?.toString(),
      status: json['status'] as int?,
      customer: data is Map<String, dynamic> ? SignUpCustomer.fromJson(data['customer']) : null,
      token: data is Map<String, dynamic> ? data['token'] as String? : null,
    );
  }

}

class SignUpCustomer {
  final String? firstName;
  final String? lastName;
  final int? id;
  final String? phoneNumber;
  final String? createdAt;
  final String? updatedAt;
  final String? email;

  SignUpCustomer(
      {this.firstName,
      this.lastName,
      this.id,
      this.phoneNumber,
      this.createdAt,
      this.updatedAt,
      this.email,});

  factory SignUpCustomer.fromJson(Map<String, dynamic> json) {
    return SignUpCustomer(
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      id: json['id'] as int?,
      phoneNumber: json['phone_number'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['id'] = this.id;
    data['phone_number'] = this.phoneNumber;
    data['email'] = this.email;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }

  factory SignUpCustomer.fromPref(Map<String, dynamic> json) {
    return SignUpCustomer(
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      id: json['id'] as int?,
      phoneNumber: json['phone_number'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      email: json['email'] as String?,
    );
  }
}
