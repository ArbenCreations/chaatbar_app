
import 'dart:convert';

class CouponDetailsResponse {
  int? discount;
  int? id;
  String? maxDiscountAmt;
  int? maxCouponUse;
  String? minCartAmt;
  bool? maxDisStatus;
  bool? minCartAmountStatus;
  String? createdAt;
  String? updatedAt;
  String? description;
  String? couponCode;
  String? message;
  String? expire_at;
  String? coupon_type;
  int? status;

  CouponDetailsResponse({
     this.discount,
     this.id,
     this.message,
     this.maxDiscountAmt,
     this.couponCode,
     this.description,
     this.createdAt,
     this.updatedAt,
     this.maxCouponUse,
     this.maxDisStatus,
     this.minCartAmountStatus,
     this.minCartAmt,
     this.expire_at,
     this.coupon_type,
     this.status,
  });

  factory CouponDetailsResponse.fromJson(Map<String, dynamic> json) {
    return CouponDetailsResponse(
      message: json["message"] as String?,
      status: json["status"] as int?,
      discount:json["data"]?["discount"] as int?,
      id: json["data"]?["id"] as int?,
      minCartAmt: json["data"]?["min_cart_amount"] as String?,
      maxCouponUse: json["data"]?["max_coupon_use"] as int?,
      maxDiscountAmt: json["data"]?["max_discount_amount"] as String?,
      minCartAmountStatus: json["data"]?["min_cart_amount_status"] as bool?,
      maxDisStatus: json["data"]?["max_dis_status"] as bool?,
      updatedAt: json["data"]?["updated_at"] as String?,
      createdAt: json["data"]?["created_at"] as String?,
      expire_at: json["data"]?["expire_at"] as String?,
      description: json["data"]?["description"] as String?,
      coupon_type: json["data"]?["coupon_type"] as String?,
      couponCode: json["data"]?["coupon_code"] as String?,
    );

  }
}
