class NoDataResponse {
  final String? message;
  final int? status;

  NoDataResponse({
    this.message,
    this.status,
  });

  factory NoDataResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] == null) {
      return NoDataResponse(message: json['message'] as String?,
        status: json['status'] as int?,);
    }
    return NoDataResponse(
      message: json['message'] as String?,
      status: json['status'] as int?,
    );
  }
}
