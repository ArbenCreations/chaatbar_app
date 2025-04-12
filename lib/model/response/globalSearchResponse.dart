
import 'dart:convert';

import 'package:TheChaatBar/model/response/vendorListResponse.dart';


class GlobalSearchResponse {
  List<SearchItemDetails>? data;
  String? message;
  int? status;

  GlobalSearchResponse({
    this.message,
    this.data,
    this.status,
  });

  factory GlobalSearchResponse.fromJson(Map<String, dynamic> json) {

    var list = json['data'] as List;
    List<SearchItemDetails>? dataList = list?.map((i) => SearchItemDetails.fromJson(i)).toList();

    return GlobalSearchResponse(
      data: dataList,
      message: json["message"] as String?,
      status: json["status"] as int?,
    );

  }
}


class SearchItemDetails {
  VendorData? vendor;
  ProductSearchData? product;
  SearchItemDetails({
     this.vendor,
     this.product,
  });

  factory SearchItemDetails.fromJson(Map<String, dynamic> json) {

    return SearchItemDetails(
      vendor: VendorData.fromJson(json['vendor']),
      product:json['products'] != null
          ? new ProductSearchData.fromJson(json['products'])
          : null ,
    );

  }
}

class ProductSearchData {
  int? id;
  String? title;
  String? shortDescription;
  String? price;
  int? productCategoryId;
  String? image1;

  ProductSearchData({
     this.title,
     this.shortDescription,
     this.price,
     this.productCategoryId,
     this.image1,
     this.id,
  });

  factory ProductSearchData.fromJson(Map<String, dynamic> json) {

    return ProductSearchData(
      title: json["title"] as String?,
      shortDescription: json["short_description"] as String?,
      price: json["price"] as String?,
      productCategoryId: json["product_category_id"] as int?,
      image1: json["image1"] as String?,
      id: json["id"] as int?,
    );

  }
}
