
import 'dart:convert';

import 'package:floor/floor.dart';

@entity
class CategoryDataDB {
  @primaryKey
  int? id;
  String? categoryName ;
  String? categoryImage ;
  String? menuImgUrl;
  bool? status;
  String? createdAt;
  String? updatedAt;
  int? franchiseId;
  int? vendorId;

  CategoryDataDB({
    this.id,
    this.status,
    this.categoryName,
    this.categoryImage,
    this.menuImgUrl,
    this.createdAt,
    this.updatedAt,
    this.vendorId,
    this.franchiseId,
  });

  factory CategoryDataDB.fromJson(Map<String, dynamic> json) {

    return CategoryDataDB(
        id: json["id"] as int?,
        categoryName: json["category_name"] as String?,
        categoryImage: json["category_image"] as String?,
        menuImgUrl: json["menu_img_url"] as String?,
        status: json["status"] as bool?,
        createdAt: json["created_at"] as String?,
        updatedAt: json["updated_at"] as String?,
      franchiseId: json["vendor_id"] as int?,
        vendorId: json["vendor"] as int?,
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
    data['vendor_id'] = this.franchiseId;
    data['vendor'] = this.vendorId;
    data['updated_at'] = this.updatedAt;
    return data;
  }

  String toJsonString() => json.encode(toJson());

  factory CategoryDataDB.fromJsonString(String source) {
    final Map<String, dynamic> jsonMap = json.decode(source);

    return CategoryDataDB(
      id: jsonMap["id"] as int?,
      categoryName: jsonMap["category_name"] as String?,
      categoryImage: jsonMap["category_image"] as String?,
      menuImgUrl: jsonMap["menu_img_url"] as String?,
      status: jsonMap["status"] as bool?,
      createdAt: jsonMap["created_at"] as String?,
      updatedAt: jsonMap["updated_at"] as String?,
      franchiseId: jsonMap["vendor_id"] as int?,
      vendorId: jsonMap["vendor"] as int?,
    );
  }
}