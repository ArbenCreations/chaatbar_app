
import 'dart:convert';

import 'package:TheChaatBar/model/response/bannerListResponse.dart';
import 'package:TheChaatBar/model/response/categoryListResponse.dart';
import 'package:TheChaatBar/model/response/createOrderResponse.dart';
import 'package:TheChaatBar/model/response/productListResponse.dart';
import 'package:floor/floor.dart';

@entity
class DashboardDataResponse {
  String? featuredProducts;
  String? favoriteProducts ;
  String? categories ;
  String? banners ;
  String? recentOrders ;
  String? message;
  @primaryKey
  int? status;

  DashboardDataResponse({
     this.featuredProducts,
     this.favoriteProducts,
     this.categories,
     this.banners,
     this.recentOrders,
     this.message,
     this.status,
  });

  factory DashboardDataResponse.fromJson(Map<String, dynamic> json) {

    return DashboardDataResponse(
      featuredProducts: _convertToString(json['data']?['featured']),
      favoriteProducts: _convertToString(json['data']?['favourites']),
      categories: _convertToString(json['data']?['categories']),
      banners: _convertToString(json['data']?['banners']),
      recentOrders: _convertToString(json['data']?['recent_orders']),
      message: json["message"] as String,
      status: json["status"] as int,
    );

  }

  static String? _convertToString(dynamic value) {
    if (value == null) {
      return '[]'; // Return an empty JSON array as string
    } else if (value is String) {
      return value; // Return as is
    } else if (value is List) {
      return jsonEncode(value); // Convert List to JSON String
    } else {
      throw Exception("Invalid type for intList or productSizeList: ${value.runtimeType}. Expected String or List.");
    }
  }


  List<ProductData> getFeaturedList() {
    print("${featuredProducts?.length}");
    if (featuredProducts?.length != 0) {
      if (jsonDecode("${featuredProducts}") != null) {
        final decoded = jsonDecode("${featuredProducts}") as List<dynamic>;
        return decoded
            .map((item) => ProductData.fromJson(item as Map<String, dynamic>))
            .toList();
      } else
        return [];
    } else
      return [];
  }

  List<ProductData> getFavoritesList() {
    print("${favoriteProducts?.length}");
    if (favoriteProducts?.length != 0) {
      if (jsonDecode("${favoriteProducts}") != null) {
        final decoded = jsonDecode("${favoriteProducts}") as List<dynamic>;
        return decoded
            .map((item) => ProductData.fromJson(item as Map<String, dynamic>))
            .toList();
      } else
        return [];
    } else
      return [];
  }

  List<BannerData> getBannerList() {
    print("${banners?.length}");
    if (banners?.length != 0) {
      if (jsonDecode("${banners}") != null) {
        final decoded = jsonDecode("${banners}") as List<dynamic>;
        return decoded
            .map((item) => BannerData.fromJson(item as Map<String, dynamic>))
            .toList();
      } else
        return [];
    } else
      return [];
  }

  List<CategoryData> getCategoryList() {
    print("${categories?.length}");
    if (categories?.length != 0) {
      if (jsonDecode("${categories}") != null) {
        final decoded = jsonDecode("${categories}") as List<dynamic>;
        return decoded
            .map((item) => CategoryData.fromJson(item as Map<String, dynamic>))
            .toList();
      } else
        return [];
    } else
      return [];
  }

  List<OrderItem> getRecentDataList() {
    print("${recentOrders?.length}");
    if (recentOrders?.length != 0) {
      if (jsonDecode("${recentOrders}") != null) {
        final decoded = jsonDecode("${recentOrders}") as List<dynamic>;
        return decoded
            .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
            .toList();
      } else
        return [];
    } else
      return [];
  }
}
