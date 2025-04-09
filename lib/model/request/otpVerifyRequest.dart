class OtpVerifyRequest {
  CustomerOtpVerify customer;

  OtpVerifyRequest({required this.customer});

  Map<String, dynamic> toJson() {
    return {
      'temp_customer': customer.toJson(), // Convert the customer object to JSON
    };
  }
}

class CustomerOtpVerify {
  String phoneNumber;
  String mobileOtp;

  CustomerOtpVerify({required this.phoneNumber, required this.mobileOtp});

  Map<String, dynamic> toJson() {
    return {'phone_number': phoneNumber, 'mobile_otp': mobileOtp};
  }
}
