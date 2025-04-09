class CouponListResponse {
  List<PrivateCouponDetailsResponse>? couponsResponse;
  String? message;
  int? status;

  CouponListResponse({
    this.couponsResponse,
    this.message,
    this.status,
  });

  factory CouponListResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;

    List<PrivateCouponDetailsResponse> couponResponseList =
    list.map((i) => PrivateCouponDetailsResponse.fromJson(i)).toList();

    return CouponListResponse(
      couponsResponse: couponResponseList,
      message: json["message"] as String?,
      status: json["status"] as int?,
    );
  }
}

class PrivateCouponDetailsResponse {
  int? discount;
  int? id;
  String? maxDiscountAmt;
  int? maxCouponUse;
  String? minCartAmt;
  bool? maxDisStatus;
  bool? minCartAmountStatus;
  DateTime? createdAt;  // Change String to DateTime
  DateTime? updatedAt;  // Change String to DateTime
  String? description;
  String? couponCode;
  DateTime? expireAt;  // Change String to DateTime
  String? couponType;
  int? vendorId;
  int? customerId;

  PrivateCouponDetailsResponse({
    this.discount,
    this.id,
    this.maxDiscountAmt,
    this.couponCode,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.maxCouponUse,
    this.maxDisStatus,
    this.minCartAmountStatus,
    this.minCartAmt,
    this.expireAt,
    this.couponType,
    this.customerId,
    this.vendorId,
  });

  factory PrivateCouponDetailsResponse.fromJson(Map<String, dynamic> json) {
    return PrivateCouponDetailsResponse(
      discount: json["discount"] as int?,
      id: json["id"] as int?,
      minCartAmt: json["min_cart_amount"] as String?,
      maxCouponUse: json["max_coupon_use"] as int?,
      maxDiscountAmt: json["max_discount_amount"] as String?,
      minCartAmountStatus: json["min_cart_amount_status"] as bool?,
      maxDisStatus: json["max_dis_status"] as bool?,
      updatedAt: _parseDate(json["updated_at"]),
      createdAt: _parseDate(json["created_at"]),
      expireAt: _parseDate(json["expire_at"]), // Add this for the expire_at field
      description: json["description"] as String?,
      couponType: json["coupon_type"] as String?,
      couponCode: json["coupon_code"] as String?,
      customerId: json["customer_id"] == null ? null : json["customer_id"] as int?,
      vendorId: json["vendor_id"] as int?,
    );
  }

  // Helper function to parse DateTime from ISO 8601 string
  static DateTime? _parseDate(String? dateString) {
    if (dateString == null) return null;
    try {
      return DateTime.parse(dateString); // Parse ISO 8601 format date
    } catch (e) {
      print("Error parsing date: $e");
      return null;
    }
  }
}

