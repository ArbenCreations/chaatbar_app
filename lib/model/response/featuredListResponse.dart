
import 'package:TheChaatBar/model/response/productListResponse.dart';

class FeaturedListResponse {
  List<ProductData>? products;
  String message;
  int status;

  FeaturedListResponse({
    required this.products,
    required this.message,
    required this.status,
  });

  factory FeaturedListResponse.fromJson(Map<String, dynamic> json) {

    var list = json['data'] as List;

    List<ProductData>? productList = list.map((i) => ProductData.fromJson(i)).toList();

    return FeaturedListResponse(
      products: productList,
      message: json["message"] as String,
      status: json["status"] as int,
    );

  }
}
