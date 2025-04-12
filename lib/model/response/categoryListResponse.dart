
import 'dart:convert';

import 'package:TheChaatBar/model/response/productListResponse.dart';
import 'package:floor/floor.dart';

class CategoryListResponse {
  List<CategoryData>? data;
  String message;
  int status;

  CategoryListResponse({
    required this.data,
    required this.message,
    required this.status,
  });

  factory CategoryListResponse.fromJson(Map<String, dynamic> json) {

    try {
      var list = json['data'] as List?;
      List<CategoryData>? detailList = list != null
          ? list.map((i) => CategoryData.fromJson(i)).toList()
          : [];

      return CategoryListResponse(
        data: detailList,
        message: json["message"] as String,
        status: json["status"] as int,
      );
    } catch (e) {
      print("Error parsing CategoryListResponse: $e");
      rethrow;
    }
  }
}

@entity
class CategoryData {
  @primaryKey
  int? id;
  String? categoryName ;
  String? categoryImage ;
  String? menuImgUrl;
  bool? status;
  String? createdAt;
  String? updatedAt;
  int? vendorId;
  List<ProductData>? products;

  CategoryData({
     this.id,
     this.status,
     this.categoryName,
     this.categoryImage,
     this.menuImgUrl,
     this.createdAt,
     this.updatedAt,
     this.vendorId,
     this.products,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {

    var list = json['products'] as List?;
    List<ProductData>? productList = list != null
        ? list.map((i) => ProductData.fromJson(i)).toList()
        : [];

    return CategoryData(
      id: json["id"] as int?,
      categoryName: json["category_name"] as String?,
      categoryImage: json["category_image"] as String?,
      menuImgUrl: json["menu_img_url"] as String?,
      status: json["status"] as bool?,
      createdAt: json["created_at"] as String?,
      updatedAt: json["updated_at"] as String?,
      vendorId: json["vendor_id"] as int?,
      products: productList
    );
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    data['category_image'] = this.categoryImage;
    data['menu_img_url'] = this.menuImgUrl;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['vendor_id'] = this.vendorId;
    data['updated_at'] = this.updatedAt;
    return data;
  }

  String toJsonString() => json.encode(toJson());

  factory CategoryData.fromJsonString(String source) {
    final Map<String, dynamic> jsonMap = json.decode(source);

    var list = jsonMap['products'] as List;
    List<ProductData>? productList = list.map((i) => ProductData.fromJson(i)).toList();
    return CategoryData(
      id: jsonMap["id"] as int?,
      categoryName: jsonMap["category_name"] as String?,
      categoryImage: jsonMap["category_image"] as String?,
      menuImgUrl: jsonMap["menu_img_url"] as String?,
      status: jsonMap["status"] as bool?,
      createdAt: jsonMap["created_at"] as String?,
      updatedAt: jsonMap["updated_at"] as String?,
      vendorId: jsonMap["vendor_id"] as int?,
        products: productList,
    );
  }
}
