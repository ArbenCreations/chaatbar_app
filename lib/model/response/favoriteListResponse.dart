
import 'package:TheChaatBar/model/response/productListResponse.dart';
import 'package:floor/floor.dart';

class FavoriteListResponse {
  List<ProductData>? products;
  String message;
  int status;

  FavoriteListResponse({
    required this.products,
    required this.message,
    required this.status,
  });

  factory FavoriteListResponse.fromJson(Map<String, dynamic> json) {

    var list = json['data'] as List;

    List<ProductData>? productList = list.map((i) => ProductData.fromJson(i)).toList();

    return FavoriteListResponse(
      products: productList,
      message: json["message"] as String,
      status: json["status"] as int,
    );

  }
}
