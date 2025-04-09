class GetCouponListRequest {
  int? vendorId;
  int? customerId;

  GetCouponListRequest({
    required this.vendorId,
    required this.customerId,
  });

  Map<String, dynamic> toJson() {
    return {
      'vendor_id': vendorId,
      'customer_id': customerId,
    };
  }
}
