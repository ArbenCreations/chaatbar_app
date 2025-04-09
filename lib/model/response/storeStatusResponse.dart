
import 'package:TheChaatBar/model/response/productListResponse.dart';
import 'package:floor/floor.dart';

class StoreStatusResponse {
  String? storeStatus;
  bool? IsUpcomingAllowed;
  String? message;
  int? status;

  StoreStatusResponse({
     this.storeStatus,
     this.IsUpcomingAllowed,
     this.message,
     this.status,
  });

  factory StoreStatusResponse.fromJson(Map<String, dynamic> json) {
    return StoreStatusResponse(
      message: json["message"] as String,
      status: json["status"] as int,
      storeStatus: json['data']?["status"] as String?,
      IsUpcomingAllowed: json['data']?["upcoming_or_reserve_day"] as bool?,
    );

  }
}
