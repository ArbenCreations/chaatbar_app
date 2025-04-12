
import 'dart:convert';

class LocationListResponse {
  List<LocationData>? locations;
  String message;
  int status;

  LocationListResponse({
    required this.locations,
    required this.message,
    required this.status,
  });

  factory LocationListResponse.fromJson(Map<String, dynamic> json) {

    var list = json['data'] as List;
    List<LocationData>? locationList = list?.map((i) => LocationData.fromJson(i)).toList();

    return LocationListResponse(
      locations: locationList,
      message: json["message"] as String,
      status: json["status"] as int,
    );

  }
}

class LocationData {
  String? id;
  String? localityName;
  String? region;
  String? pincode;
  String? latitude;
  String? createdAt;
  String? longitude;
  String? country;
  bool? availability;
  String? updatedAt;

  LocationData({
     this.id,
     this.localityName,
     this.region,
     this.pincode,
     this.latitude,
     this.longitude,
     this.country,
     this.availability,
     this.createdAt,
     this.updatedAt,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      id: json["id"] as String?,
      localityName: json["locality_name"] as String?,
      region: json["region"] as String?,
      pincode: json["pincode"] as String?,
      latitude: json["latitude"] as String?,
      longitude: json["longitude"] as String?,
      country: json["country"] as String?,
      createdAt: json["created_at"] as String?,
      availability: json["availability"] as bool?,
      updatedAt: json["updated_at"] as String?,
    );
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['id'] = this.id;
    data['locality_name'] = this.localityName;
    data['region'] = this.region;
    data['pincode'] = this.pincode;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['country'] = this.country;
    data['created_at'] = this.createdAt;
    data['availability'] = this.availability;
    data['updated_at'] = this.updatedAt;
    return data;
  }

  String toJsonString() => json.encode(toJson());

  factory LocationData.fromJsonString(String source) {
    final Map<String, dynamic> jsonMap = json.decode(source);
    return LocationData(
      id: jsonMap["id"] as String?,
      localityName: jsonMap["locality_name"] as String?,
      region: jsonMap["region"] as String?,
      pincode: jsonMap["pincode"] as String?,
      latitude: jsonMap["latitude"] as String?,
      longitude: jsonMap["longitude"] as String?,
      country: jsonMap["country"] as String?,
      availability: jsonMap["availability"] as bool?,
      createdAt: jsonMap["created_at"] as String?,
      updatedAt: jsonMap["updated_at"] as String?,
    );
  }
}