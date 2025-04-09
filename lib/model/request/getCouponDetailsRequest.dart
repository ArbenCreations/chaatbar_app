class GetCouponDetailsRequest {
  String couponCode;
  int? vendorId;
  int? customerId;

  GetCouponDetailsRequest({
    required this.couponCode,
    required this.vendorId,
    required this.customerId
  });

  Map<String, dynamic> toJson() {
    return {
      'coupon_code': couponCode,
      'vendor_id': vendorId,
      'customer_id': customerId,
    };
  }
}

