import '/model/response/productListResponse.dart';

class CreateOrderResponse {
  String? message;
  int? responseStatus;
  TrxDetails? trxDetails;
  OrderDetails? order;

  CreateOrderResponse(
      {this.message, this.responseStatus, this.trxDetails, this.order});

  factory CreateOrderResponse.fromJson(Map<String, dynamic> json) {
    return CreateOrderResponse(
      message: json['message'] as String?,
      responseStatus: json['status'] as int?,
      trxDetails: TrxDetails.fromJson(json['data']?['trx_details']),
      order: OrderDetails.fromJson(json['data']?['order']),
    );
  }

/* Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'product': product?.toJson(),
    };
  }*/
}

class OrderDetails {
  int? id;
  int? quantity;
  String? customerName;
  String? customerEmail;
  String? totalPrice;
  String? createdAt;
  String? updatedAt;
  String? deliveryStatus;
  String? status;
  int? vendorId;
  int? couponId;
  String? couponCode;
  String? totalAmount;
  String? discountAmount;
  String? payableAmount;
  String? deliveryCharges;
  String? orderNotes;
  double? tip;
  int? userId;
  String? phoneNumber;
  String? pickupDate;
  String? pickupTime;
  String? orderNo;
  String? preparationTime;
  String? rejectNote;
  String? locality;
  int? gst;
  int? hst;
  int? pst;
  String? transactionStatus;
  String? transactionId;
  List<OrderItem>? orderItems;

  OrderDetails({
    this.id,
    this.quantity,
    this.customerName,
    this.customerEmail,
    this.totalPrice,
    this.createdAt,
    this.updatedAt,
    this.deliveryStatus,
    this.status,
    this.vendorId,
    this.couponId,
    this.couponCode,
    this.locality,
    this.totalAmount,
    this.discountAmount,
    this.payableAmount,
    this.deliveryCharges,
    this.orderNotes,
    this.tip,
    this.userId,
    this.phoneNumber,
    this.orderNo,
    this.preparationTime,
    this.rejectNote,
    this.gst,
    this.hst,
    this.pst,
    this.transactionId,
    this.transactionStatus,
    this.pickupDate,
    this.pickupTime,
    this.orderItems,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    var list = json['order_items'] as List?;
    List<OrderItem>? orderList =
        list?.map((i) => OrderItem.fromJson(i)).toList();
    return OrderDetails(
      id: json['id'],
      quantity: json['quantity'],
      customerName: json['customer_name'],
      customerEmail: json['customer_email'],
      totalPrice: json['total_price'],
      createdAt: json['created_at'],
      locality: json['locality'],
      updatedAt: json['updated_at'],
      deliveryStatus: json['delivery_status'],
      status: json['status'],
      vendorId: json['vendor_id'],
      gst: json['gst'],
      pst: json['pst'],
      hst: json['hst'],
      couponId: json['coupon_id'],
      couponCode: json['coupon_code'],
      totalAmount: json['total_amount'],
      discountAmount: json['discount_amount'],
      payableAmount: json['payable_amount'],
      deliveryCharges: json['delivery_charges'],
      orderNotes: json['order_notes'],
      orderNo: json['order_number'],
      tip: json['tip'],
      userId: json['user_id'],
      phoneNumber: json['phone_number'],
      pickupDate: json['pickup_date'],
      pickupTime: json['pickup_time'],
      orderItems: json['order_items'] != null ? orderList : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'customer_name': customerName,
      'customer_email': customerEmail,
      'total_price': totalPrice,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'delivery_status': deliveryStatus,
      'status': status,
      'vendor_id': vendorId,
      'coupon_id': couponId,
      'locality': locality,
      'coupon_code': couponCode,
      'total_amount': totalAmount,
      'discount_amount': discountAmount,
      'payable_amount': payableAmount,
      'delivery_charges': deliveryCharges,
      'order_notes': orderNotes,
      'tip': tip,
      'user_id': userId,
      'phone_number': phoneNumber,
      'pickup_date': pickupDate,
      'pickup_time': pickupTime,
      'order_items': orderItems?.map((item) => item.toJson()).toList(),
    };
  }
} 

class OrderItem {
  int? id;
  int? orderId;
  int? productId;
  int? quantity;
  String? createdAt;
  String? updatedAt;
  List<dynamic>? addOnIds;
  ProductData? product;

  OrderItem({this.id,
    this.productId,
    this.orderId,
    this.quantity,
    this.createdAt,
    this.updatedAt,
    this.product,
    this.addOnIds});

  factory OrderItem.fromJson(Map<String, dynamic> json) {

    return OrderItem(
      quantity: json['quantity'],
      orderId: json['order_id'],
      productId: json['product_id'],
      id: json['id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      product: ProductData.fromJson(json['product']),
      addOnIds: json['addon_ids'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'product_id': productId,
      'order_id': orderId,
      'id': id,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'product': product,
      'addon_ids': addOnIds,
    };
  }
}

class TrxDetails {
  int? amount;
  String? generatedHash;
  String? timeStamp;

  TrxDetails({this.amount, this.generatedHash, this.timeStamp});

  factory TrxDetails.fromJson(Map<String, dynamic> json) {
    return TrxDetails(
      amount: json['amount'],
      generatedHash: json['generated_hash'],
      timeStamp: json['timestamp'],
    );
  }

/* Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'product': product?.toJson(),
    };
  }*/
}
/*
class NewOrderProduct {
  int? id;
  String? title;
  String? shortDescription;
  String? description;
  int? gst;
  String? price;
  int? productCategoryId;
  int? pst;
  int? vpt;
  String? deposit;
  String? environmentalFee;
  List<int>? addOnIds;
  bool? featured;
  bool? status;
  String? salePrice;
  String? qtyLimit;

  NewOrderProduct({
    this.id,
    this.title,
    this.shortDescription,
    this.description,
    this.gst,
    this.price,
    this.productCategoryId,
    this.pst,
    this.vpt,
    this.deposit,
    this.environmentalFee,
    this.addOnIds,
    this.featured,
    this.status,
    this.salePrice,
    this.qtyLimit,
  });

  factory NewOrderProduct.fromJson(Map<String, dynamic> json) {
    return NewOrderProduct(
      id: json['id'],
      title: json['title'],
      shortDescription: json['short_description'],
      description: json['description'],
      gst: json['gst'],
      price: json['price'],
      productCategoryId: json['product_category_id'],
      pst: json['pst'],
      vpt: json['vpt'],
      deposit: json['deposit'],
      environmentalFee: json['environmental_fee'],
      addOnIds: json['add_on_ids'],
      featured: json['featured'],
      status: json['status'],
      salePrice: json['sale_price'],
      qtyLimit: json['qty_limit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'short_description': shortDescription,
      'description': description,
      'gst': gst,
      'price': price,
      'product_category_id': productCategoryId,
      'pst': pst,
      'vpt': vpt,
      'deposit': deposit,
      'environmental_fee': environmentalFee,
      'add_on_ids': addOnIds,
      'featured': featured,
      'status': status,
      'sale_price': salePrice,
      'qty_limit': qtyLimit,
    };
  }
}*/
