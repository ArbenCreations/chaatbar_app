import 'dart:convert';

import 'package:TheChaatBar/model/response/productListResponse.dart';
import 'package:floor/floor.dart';

import '../database/list_converter.dart';

@TypeConverters([ListConverter, ProductSizeListConverter])
@Entity(tableName: 'ProductDataDB', primaryKeys: ['productId'])
class ProductDataDB {
  int? productId;
  String? title ;
  String? shortDescription ;
  String? description ;
  int? vendorId;
  int? franchiseId;
  double? price;
  int? productCategoryId;
  String? deposit;
  bool? status;
  bool? favorite;
  bool? isBuy1Get1;
  String? addOnIdsList;
  String? salePrice;
  int? qtyLimit;
  String?  addOnType;
  String? imageUrl;
  String? vendorName;
  String? theme;
  String? addOn;
  String? categoryName;
  String? addedToCartAt;
  int? quantity ;
  String? productSizesList;

  ProductDataDB({
    this.productId,
    this.title,
    this.shortDescription,
    this.description,
    this.price,
    this.productCategoryId,
    this.vendorId,
    this.franchiseId,
    this.deposit,
     this.addOnIdsList,
    this.status,
    this.isBuy1Get1,
    this.salePrice,
    this.favorite,
    this.qtyLimit,
    this.addOnType,
    this.vendorName,
    this.addOn,
    this.theme,
    this.imageUrl,
    this.categoryName,
    this.addedToCartAt,
     this.productSizesList,
    this.quantity,
  });

  List<int> getIntList() {
    if (jsonDecode("${addOnIdsList}") != null) {
      return (jsonDecode("${addOnIdsList}") as List<dynamic>).cast<int>();
    } else {
      return [];
    }
  }

  List<ProductSize> getProductSizeList() {
    print("${productSizesList?.length}");
    if (productSizesList?.length != 0) {
      if (jsonDecode("${productSizesList}") != null) {
        final decoded = jsonDecode("${productSizesList}") as List<dynamic>;
        return decoded
            .map((item) => ProductSize.fromJson(item as Map<String, dynamic>))
            .toList();
      } else
        return [];
    } else
      return [];
  }

  List<AddOnCategory> getAddOnList() {
    if(addOn?.length !=0) {
      if (jsonDecode("${addOn}") != null) {
        final decoded = jsonDecode("${addOn}") as List<dynamic>;
        return decoded.map((item) =>
            AddOnCategory.fromJson(item as Map<String, dynamic>)).toList();
      }else return [];
    }
    else return [];
  }

 /* factory ProductDataDB.fromJson(Map<String, dynamic> json) {
    return ProductDataDB(
      productId: json["id"] as int?,
      shortDescription: json["short_description"] as String?,
      description: json["description"] as String?,
      title: json["title"] as String?,
      productCategoryId: json["product_category_id"] as int?,
      price: json["price"] as double?,
      vendorId: json["vendor_id"] as int?,
      deposit: json["deposit"] as String?,
      addOnIds: json["add_on_ids"] as List<int>?,
      status: json["status"] as bool?,
      salePrice: json["sale_price"] as String?,
      qtyLimit: json["qty_limit"] as int?,
      addOnType: json["add_on_type"] as List<dynamic>?,
      vendorName: json["vendor_name"] as String?,
      theme: json["theme"] as String?,
      imageUrl: json["image_url"] as String?,
      categoryName: json["category_name"] as String?,
      addedToCartAt: json["addedToCartAt"] as String?,
      quantity: json["quantity"] as int?,
    );
  }
*/
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'title': title,
      'shortDescription': shortDescription,
      'description': description,
      'vendorId': vendorId,
      'franchiseId': franchiseId,
      'price': price,
      'productCategoryId': productCategoryId,
      'deposit': deposit,
      'status': status,
      'addOnIds': addOnIdsList,
      'salePrice': salePrice,
      'qtyLimit': qtyLimit,
      'addOnType': addOnType,
      'is_buy_1_get_1': isBuy1Get1  ,
      'favourites': favorite,
      'imageUrl': imageUrl,
      'add_on': addOn,
      'theme': theme,
      'vendor_name': vendorName,
      'categoryName': categoryName,
      'product_sizes': productSizesList,
      'addedToCartAt': addedToCartAt,
      'quantity': quantity,
    };
  }

  // Convert Map to Product
  factory ProductDataDB.fromMap(Map<String, dynamic> map) {
    return ProductDataDB(
      productId: map['productId'],
      title: map['title'],
      shortDescription: map['shortDescription'],
      description: map['description'],
      vendorId: map['vendorId'],
      franchiseId: map['franchiseId'],
      price: map['price'],
      productCategoryId: map['productCategoryId'],
      deposit: map['deposit'],
      status: map['status'],
      addOnIdsList: map['addOnIds'] ,
      favorite: map['favourites'] ,
      isBuy1Get1: map['is_buy_1_get_1'] ,
      salePrice: map['salePrice'],
      qtyLimit: map['qtyLimit'],
      addOnType: map['addOnType'],
      addOn: map['add_on'],
      imageUrl: map['imageUrl'],
      categoryName: map['categoryName'],
      addedToCartAt: map['addedToCartAt'],
      quantity: map['quantity'],
      productSizesList: map['product_sizes'],
    );
  }


  /*Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['id'] = this.id;
    data['short_description'] = this.shortDescription;
    data['description'] = this.description;
    data['title'] = this.title;
    data['product_category_id'] = this.productCategoryId;
    data['price'] = this.price;
    data['gst'] = this.gst;
    data['created_at'] = this.createdAt;
    data['vendor_id'] = this.vendorId;
    data['updated_at'] = this.updatedAt;
    return data;
  }

  String toJsonString() => json.encode(toJson());

  factory ProductData.fromJsonString(String source) {
    final Map<String, dynamic> jsonMap = json.decode(source);
    return ProductData(
      id: jsonMap["id"] as int?,
      shortDescription: jsonMap["short_description"] as String?,
      description: jsonMap["description"] as String?,
      title: jsonMap["title"] as String?,
      productCategoryId: jsonMap["product_category_id"] as String?,
      price: jsonMap["price"] as String?,
      gst: jsonMap["gst"] as int?,
      createdAt: jsonMap["created_at"] as String?,
      updatedAt: jsonMap["updated_at"] as String?,
      vendorId: jsonMap["vendor_id"] as String?,
    );
  }*/
}