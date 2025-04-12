
import 'dart:convert';

class BannerListResponse {
  List<BannerData>? data;
  String message;/*
  int totalRecords;
  int totalPages;*/
  int status;

  BannerListResponse({
    required this.data,
    required this.message,/*
    required this.totalRecords,
    required this.totalPages,*/
    required this.status,
  });

  factory BannerListResponse.fromJson(Map<String, dynamic> json) {

    var list = json['data'] as List;
    List<BannerData>? detailList = list.map((i) => BannerData.fromJson(i)).toList();


    return BannerListResponse(
      data: detailList,/*
      totalRecords: json["data"]?["total_records"] as int,
      totalPages: json["data"]?["total_pages"] as int,*/
      message: json["message"] as String,
      status: json["status"] as int,
    );

  }
}


class BannerData {
  int? id;
  String? title ;
  String? description ;
  int? discount;
  bool? status;
  String? createdAt;
  String? url;
  String? updatedAt;
  String? bannerImages;
  List<String>? bannerImagesUrls;
  int? vendorId;

  BannerData({
     this.id,
     this.status,
     this.title,
     this.description,
     this.url,
     this.bannerImagesUrls,
     this.vendorId,
     this.createdAt,
     this.updatedAt,
     this.bannerImages,
     this.discount,
  });

  factory BannerData.fromJson(Map<String, dynamic> json) {
    return BannerData(
      id: json["id"] as int?,
      title: json["title"] as String?,
      description: json["description"] as String?,
      url: json["url"] as String?,
      status: json["status"] as bool?,
      createdAt: json["created_at"] as String?,
      updatedAt: json["updated_at"] as String?,
      bannerImages: json["banner_images"] as String?,
      vendorId: json["vendor_id"] as int?,
      discount: json["discount"] as int?,
      bannerImagesUrls: json["banner_images_urls"] as List<String>?,
    );
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['url'] = this.url;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['banner_images_urls'] = this.bannerImagesUrls;
    data['discount'] = this.discount;
    data['vendor_id'] = this.vendorId;
    data['updated_at'] = this.updatedAt;
    return data;
  }

  String toJsonString() => json.encode(toJson());

  factory BannerData.fromJsonString(String source) {
    final Map<String, dynamic> jsonMap = json.decode(source);
    return BannerData(
      id: jsonMap["id"] as int?,
      title: jsonMap["title"] as String?,
      description: jsonMap["description"] as String?,
      url: jsonMap["url"] as String?,
      status: jsonMap["status"] as bool?,
      createdAt: jsonMap["created_at"] as String?,
      updatedAt: jsonMap["updated_at"] as String?,
      vendorId: jsonMap["vendor_id"] as int?,
      bannerImagesUrls: jsonMap["banner_images_urls"] as List<String>?,
      discount: jsonMap["discount"] as int?,
    );
  }
}
