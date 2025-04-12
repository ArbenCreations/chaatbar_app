

class GetApiAccessKeyResponse {
  bool? active;
  String? apiAccessKey;
  int? createdTime;
  int? modifiedTime;
  String? developerAppUuid;
  String? merchantUuid;
  String? message;

  GetApiAccessKeyResponse({
    required this.active,
    required this.apiAccessKey,
    required this.createdTime,
    required this.modifiedTime,
    required this.developerAppUuid,
    required this.merchantUuid,
    required this.message,
  });

  factory GetApiAccessKeyResponse.fromJson(Map<String, dynamic> json) {
    return GetApiAccessKeyResponse(
      message: json["message"] as String?,
      active: json["active"] as bool?,
      createdTime: json["createdTime"] as int?,
      modifiedTime: json["modifiedTime"] as int?,
      apiAccessKey: json["apiAccessKey"] as String?,
      developerAppUuid: json["developerAppUuid"] as String?,
      merchantUuid: json["merchantUuid"] as String?,

    );
  }
}
