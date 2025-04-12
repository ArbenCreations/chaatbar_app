
import '/model/response/createOrderResponse.dart';

class GetHistoryResponse {
  List<OrderDetails>? orders;
  String? message;
  int? status;
  int? totalRows;

  GetHistoryResponse({
    required this.orders,
    required this.message,
    required this.status,
    required this.totalRows,
  });

  factory GetHistoryResponse.fromJson(Map<String, dynamic> json) {

    var list = json['data'] as List?;  // Make it nullable

    List<OrderDetails>? productList = list?.map((i) => OrderDetails.fromJson(i)).toList() ?? [];
    return GetHistoryResponse(
      orders: productList,
      message: json["message"] as String?,
      status: json["status"] as int?,
      totalRows: json["total_rows"] as int?,
    );

  }
}