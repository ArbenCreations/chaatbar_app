
import 'dart:convert';

class VendorListResponse {
  List<VendorData>? vendors;
  String message;
  int status;

  VendorListResponse({
    required this.vendors,
    required this.message,
    required this.status,
  });

  factory VendorListResponse.fromJson(Map<String, dynamic> json) {

    var list = json['data'] as List;
    List<VendorData>? vendorList = list?.map((i) => VendorData.fromJson(i)).toList();

    return VendorListResponse(
      vendors: vendorList,
      message: json["message"] as String,
      status: json["status"] as int,
    );

  }
}

class VendorData {
  int? id;
  int? gst;
  int? hst;
  int? pst;
  String? businessName ;
  String? description ;
  String? gstNumber;
  String? slug;
  String? status;
  String? createdAt;
  String? uniqueId;
  String? pauseTime;
  String? domainUrl;
  String? updatedAt;
  String? theme;
  String? localityId;
  String? vendorImage;
  String? storeImage;
  String? pickupNumber;
  bool? isPickup;
  bool? isDeliver;
  bool? isStoreOrderStatusOnline;
  String? detailType;
  int? selectedCategoryId;
  String? localityName;
  PaymentSetting? paymentSetting;
  String? appId;
  String? apiKey;

  VendorData({
     this.id,
     this.businessName,
     this.description,
     this.gstNumber,
     this.slug,
     this.status,
     this.uniqueId,
     this.gst,
     this.hst,
     this.pst,
     this.pauseTime,
     this.domainUrl,
     this.createdAt,
     this.updatedAt,
     this.theme,
     this.localityId,
     this.vendorImage,
     this.storeImage,
     this.pickupNumber,
     this.isPickup,
     this.isDeliver,
     this.isStoreOrderStatusOnline,
     this.detailType,
     this.selectedCategoryId,
     this.localityName,
     this.paymentSetting,
     this.appId,
     this.apiKey,
  });

  factory VendorData.fromJson(Map<String, dynamic> json) {
    return VendorData(
      id: json["id"] as int?,
      gst: json["gst"] as int?,
      hst: json["hst"] as int?,
      pst: json["pst"] as int?,
      businessName: json["business_name"] as String?,
      description: json["description"] as String?,
      gstNumber: json["gst_number"] as String?,
      slug: json["slug"] as String?,
      status: json["status"] as String?,
      uniqueId: json["unique_id"] as String?,
      pauseTime: json["pause_time"] as String?,
      createdAt: json["created_at"] as String?,
      domainUrl: json["domain_url"] as String?,
      updatedAt: json["updated_at"] as String?,
      theme: json["theme"] as String?,
      localityId: json["locality_id"] as String?,
      vendorImage: json["vendor_image"] as String?,
      storeImage: json["store_image"] as String?,
      pickupNumber: json["pickup_number"] as String?,
      isPickup: json["is_pickup"] as bool?,
      isDeliver: json["is_deliver"] as bool?,
      isStoreOrderStatusOnline: json["is_store_order_status_online"] as bool?,
      localityName: json["locality_name"] as String?,
      paymentSetting: json["payment_setting"] != null
          ? PaymentSetting.fromJson(json["payment_setting"])
          : null,
    );
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['id'] = this.id;
    data['business_name'] = this.businessName;
    data['gst_number'] = this.gstNumber;
    data['description'] = this.description;
    data['slug'] = this.slug;
    data['status'] = this.status;
    data['unique_id'] = this.uniqueId;
    data['pause_time'] = this.pauseTime;
    data['created_at'] = this.createdAt;
    data['domain_url'] = this.domainUrl;
    data['locality_id'] = this.localityId;
    data['theme'] = this.theme;
    data['updated_at'] = this.updatedAt;
    data['gst'] = this.gst;
    data['hst'] = this.hst;
    data['pst'] = this.pst;
    data['vendor_image'] = this.vendorImage;
    data['store_image'] = this.storeImage;
    data['pickup_number'] = this.pickupNumber;
    data['is_pickup'] = this.isPickup;
    data['is_deliver'] = this.isDeliver;
    data['locality_name'] = this.localityName;
    data['app_id'] = this.appId;
    data['api_key'] = this.apiKey;
    data['is_store_order_status_online'] = this.isStoreOrderStatusOnline;
    if (this.paymentSetting != null) {
      data['payment_setting'] = this.paymentSetting?.toJson();
    }
    return data;
  }

  String toJsonString() => json.encode(toJson());

  factory VendorData.fromJsonString(String source) {
    final Map<String, dynamic> jsonMap = json.decode(source);
    return VendorData(
      id: jsonMap["id"] as int?,
      hst: jsonMap["hst"] as int?,
      gst: jsonMap["gst"] as int?,
      pst: jsonMap["pst"] as int?,
      appId: jsonMap["payment_setting"]["app_id"] as String?,
      apiKey: jsonMap["payment_setting"]["api_key"] as String?,
      businessName: jsonMap["business_name"] as String?,
      gstNumber: jsonMap["gst_number"] as String?,
      slug: jsonMap["slug"] as String?,
      status: jsonMap["status"] as String?,
      uniqueId: jsonMap["unique_id"] as String?,
      description: jsonMap["description"] as String?,
      pauseTime: jsonMap["pause_time"] as String?,
      domainUrl: jsonMap["domain_url"] as String?,
      localityId: jsonMap["locality_id"] as String?,
      theme: jsonMap["theme"] as String?,
      createdAt: jsonMap["created_at"] as String?,
      updatedAt: jsonMap["updated_at"] as String?,
      vendorImage: jsonMap["vendor_image"] as String?,
      storeImage: jsonMap["store_image"] as String?,
      pickupNumber: jsonMap["pickup_number"] as String?,
      isPickup: jsonMap["is_pickup"] as bool?,
      isDeliver: jsonMap["is_deliver"] as bool?,
      localityName: jsonMap["locality_name"] as String?,
      isStoreOrderStatusOnline: jsonMap["is_store_order_status_online"] as bool?,
    );
  }


  factory VendorData.fromPref(Map<String, dynamic> json) {
    return VendorData(
      id: json["id"] as int?,
      pst: json["pst"] as int?,
      gst: json["gst"] as int?,
      hst: json["hst"] as int?,
      //appId: json["payment_setting"]["app_id"] as String?,
      apiKey: json["api_key"] as String?,
      businessName: json["business_name"] as String?,
      gstNumber: json["gst_number"] as String?,
      slug: json["slug"] as String?,
      status: json["status"] as String?,
      uniqueId: json["unique_id"] as String?,
      description: json["description"] as String?,
      pauseTime: json["pause_time"] as String?,
      domainUrl: json["domain_url"] as String?,
      localityId: json["locality_id"] as String?,
      theme: json["theme"] as String?,
      createdAt: json["created_at"] as String?,
      updatedAt: json["updated_at"] as String?,
      vendorImage: json["vendor_image"] as String?,
      storeImage: json["store_image"] as String?,
      pickupNumber: json["pickup_number"] as String?,
      isPickup: json["is_pickup"] as bool?,
      isDeliver: json["is_deliver"] as bool?,
      isStoreOrderStatusOnline: json["is_store_order_status_online"] as bool?,
      detailType: json["detail_type"] as String?,
      localityName: json["locality_name"] as String?,
      selectedCategoryId: json["selectedCategoryId"] as int?,
    );
  }
}

class PaymentSetting {
  String? appId;
  String? apiKey;
  String? paymentPlatform;

  PaymentSetting({this.appId, this.apiKey, this.paymentPlatform});

  PaymentSetting.fromJson(Map<String, dynamic> json) {
    appId = json['app_id'];
    apiKey = json['api_key'];
    paymentPlatform = json['payment_platform'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_id'] = this.appId;
    data['api_key'] = this.apiKey;
    data['payment_platform'] = this.paymentPlatform;
    return data;
  }
}