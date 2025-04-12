
import 'package:TheChaatBar/model/response/productListResponse.dart';
import 'package:floor/floor.dart';

class MarkFavoriteResponse {
  int? id;
  int? productId;
  int? customerId;
  String? message;
  int? status;

  MarkFavoriteResponse({
     this.id,
     this.productId,
     this.customerId,
     this.message,
     this.status,
  });

  factory MarkFavoriteResponse.fromJson(Map<String, dynamic> json) {


    return MarkFavoriteResponse(
      message: json["message"] as String,
      status: json["status"] as int,
      id: json['data']?["id"] as int?,
      productId: json['data']?["status"] as int?,
      customerId: json['data']?["customer_id"] as int?,
    );

  }
}
