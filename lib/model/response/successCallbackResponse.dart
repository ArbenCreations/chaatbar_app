
import 'dart:convert';

class SuccessCallbackResponse {
  OrderData? order;
  String message;
  int status;

  SuccessCallbackResponse({
    required this.order,
    required this.message,
    required this.status,
  });

  factory SuccessCallbackResponse.fromJson(Map<String, dynamic> json) {
    return SuccessCallbackResponse(
      order: json.containsKey('data') && json['data'] != null
          ? OrderData.fromJson(json['data'])
          : null,  // Handle missing data gracefully
      message: json["message"] ?? "Order User not found",
      status: json["status"] ?? 400,
    );
  }

}

class OrderData {
  String? status;
  bool? isPaymentSuccessTrue;
  String? transactionId;
  String? paymentAppRejTime;
  int? vendorId;
  int? customerId;
  String? orderNumber;
  int? id;
  int? quantity;
  String? customerName;
  String? customerEmail;
  String? totalPrice;
  String? createdAt;
  String? updatedAt;
  String? deliveryStatus;
  int? couponId;
  String? couponCode;
  String? totalAmount;
  String? discountAmount;
  String? payableAmount;
  String? deliveryCharges;
  String? orderNotes;
  int? userId;
  String? phoneNumber;
  String? pickupDate;
  String? pickupTime;
  double? tip;
  int? preparationTime;
  String? rejectNote;
  double? gst;
  double? pst;
  double? hst;
  String? transactionStatus;

  OrderData({
    this.status,
    this.isPaymentSuccessTrue,
    this.transactionId,
    this.paymentAppRejTime,
    this.vendorId,
    this.customerId,
    this.orderNumber,
    this.id,
    this.quantity,
    this.customerName,
    this.customerEmail,
    this.totalPrice,
    this.createdAt,
    this.updatedAt,
    this.deliveryStatus,
    this.couponId,
    this.couponCode,
    this.totalAmount,
    this.discountAmount,
    this.payableAmount,
    this.deliveryCharges,
    this.orderNotes,
    this.userId,
    this.phoneNumber,
    this.pickupDate,
    this.pickupTime,
    this.tip,
    this.preparationTime,
    this.rejectNote,
    this.gst,
    this.pst,
    this.hst,
    this.transactionStatus,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      status: json["status"] as String?,
      isPaymentSuccessTrue: json["is_payment_success_true"] as bool?,
      transactionId: json["transaction_id"] as String?,
      paymentAppRejTime: json["payment_app_rej_time"] as String?,
      vendorId: json["vendor_id"] as int?,
      customerId: json["customer_id"] as int?,
      orderNumber: json["order_number"] as String?,
      id: json["id"] as int?,
      quantity: json["quantity"] as int?,
      customerName: json["customer_name"] as String?,
      customerEmail: json["customer_email"] as String?,
      totalPrice: json["total_price"] as String?,
      createdAt: json["created_at"] as String?,
      updatedAt: json["updated_at"] as String?,
      deliveryStatus: json["delivery_status"] as String?,
      couponId: json["coupon_id"] as int?,
      couponCode: json["coupon_code"] as String?,
      totalAmount: json["total_amount"] as String?,
      discountAmount: json["discount_amount"] as String?,
      payableAmount: json["payable_amount"] as String?,
      deliveryCharges: json["delivery_charges"] as String?,
      orderNotes: json["order_notes"] as String?,
      userId: json["user_id"] as int?,
      phoneNumber: json["phone_number"] as String?,
      pickupDate: json["pickup_date"] as String?,
      pickupTime: json["pickup_time"] as String?,
      tip: (json["tip"] as num?)?.toDouble(),
      preparationTime: json["preparation_time"] as int?,
      rejectNote: json["reject_note"] as String?,
      gst: (json["gst"] as num?)?.toDouble(),
      pst: (json["pst"] as num?)?.toDouble(),
      hst: (json["hst"] as num?)?.toDouble(),
      transactionStatus: json["transaction_status"] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = this.status;
    data['is_payment_success_true'] = this.isPaymentSuccessTrue;
    data['transaction_id'] = this.transactionId;
    data['payment_app_rej_time'] = this.paymentAppRejTime;
    data['vendor_id'] = this.vendorId;
    data['customer_id'] = this.customerId;
    data['order_number'] = this.orderNumber;
    data['id'] = this.id;
    data['quantity'] = this.quantity;
    data['customer_name'] = this.customerName;
    data['customer_email'] = this.customerEmail;
    data['total_price'] = this.totalPrice;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['delivery_status'] = this.deliveryStatus;
    data['coupon_id'] = this.couponId;
    data['coupon_code'] = this.couponCode;
    data['total_amount'] = this.totalAmount;
    data['discount_amount'] = this.discountAmount;
    data['payable_amount'] = this.payableAmount;
    data['delivery_charges'] = this.deliveryCharges;
    data['order_notes'] = this.orderNotes;
    data['user_id'] = this.userId;
    data['phone_number'] = this.phoneNumber;
    data['pickup_date'] = this.pickupDate;
    data['pickup_time'] = this.pickupTime;
    data['tip'] = this.tip;
    data['preparation_time'] = this.preparationTime;
    data['reject_note'] = this.rejectNote;
    data['gst'] = this.gst;
    data['pst'] = this.pst;
    data['hst'] = this.hst;
    data['transaction_status'] = this.transactionStatus;
    return data;
  }

  String toJsonString() => json.encode(toJson());

  factory OrderData.fromJsonString(String source) {
    final Map<String, dynamic> jsonMap = json.decode(source);
    return OrderData.fromJson(jsonMap);
  }
}