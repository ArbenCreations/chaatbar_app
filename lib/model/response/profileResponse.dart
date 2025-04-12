import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ProfileResponse {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final int? activeOrders;
  final int? completedOrders;
  final int? favorites;
  final String? createdAt;
  final String? updatedAt;
  final String? message;
  final int? status;

  ProfileResponse({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.status,
    this.activeOrders,
    this.completedOrders,
    this.favorites,
    this.createdAt,
    this.updatedAt,
    this.phoneNumber,
    this.message,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      message: json['message'] as String?,
      status: json['status'] as int?,
      id: json['data']?['id'] as int?,
      activeOrders: json['data']?['active_orders'] as int?,
      completedOrders: json['data']?['completed_orders'] as int?,
      favorites: json['data']?['favourites'] as int?,
      firstName: json['data']?['first_name'] as String?,
      lastName: json['data']?['last_name'] as String?,
      phoneNumber: json['data']?['phone_number'] as String?,
      createdAt: json['data']?['created_at'] as String?,
      updatedAt: json['data']?['updated_at'] as String?,
      email: json['data']?['email'] as String?,
    );
  }

  factory ProfileResponse.fromSignIn(Map<String, dynamic> json) {
    return ProfileResponse(
      message: json['message'] as String?,
      status: json['status'] as int?,
      id: json['data']?['id'] as int?,
      firstName: json['data']?['first_name'] as String?,
      lastName: json['data']?['last_name'] as String?,
      phoneNumber: json['data']?['phone_number'] as String?,
      email: json['data']?['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['phone_number'] = this.phoneNumber;
    data['active_orders'] = this.activeOrders;
    data['completed_orders'] = this.completedOrders;
    data['favourites'] = this.favorites;
    data['email'] = this.email;
    data['message'] = this.message;
    return data;
  }

  factory ProfileResponse.fromPref(Map<String, dynamic> json) {
    return ProfileResponse(
      id: json['id'] as int?,
      activeOrders: json['active_orders'] as int?,
      completedOrders: json['completed_orders'] as int?,
      favorites: json['favourites'] as int?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      phoneNumber: json['phone_number'] as String?,
      email: json['email'] as String?,
    );
  }
}

