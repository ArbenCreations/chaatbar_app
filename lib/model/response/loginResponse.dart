import '/model/response/signUpVerifyResponse.dart';

class LoginResponse {
  final SignUpCustomer? customer;
  final String? token;
  final bool? newUser;
  final String? message;
  final int? status;

  LoginResponse(
      {this.customer,
        this.token,
        this.newUser,
        this.status,
        this.message,});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] == null) {
      return LoginResponse(
        message: json['message'] as String?,
        status: json['status'] as int?,);
    }
    return LoginResponse(
      message: json['message'] as String?,
      status: json['status'] as int?,
      customer: SignUpCustomer.fromJson(json['data']?['customer']),
      token: json['data']?['token'] as String?,
      newUser: json['data']?['new_user'] as bool?,
    );
  }
}
