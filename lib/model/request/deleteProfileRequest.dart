class DeleteProfileRequest {
  String? email;
  String? password;

  DeleteProfileRequest({
    this.email,
    this.password,
  });

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}
