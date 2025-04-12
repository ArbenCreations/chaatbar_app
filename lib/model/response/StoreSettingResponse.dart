class StoreSettingResponse {
  final int? id;
  final int? vendorId;
  final int? gst;
  final int? pst;
  final int? hst;
  final bool? upcomingOrReserveDay;
  final dynamic deliveryCharges;
  final bool? storeStatus;
  final bool? codStatus;
  final bool? paypalStatus;
  final String? paypalMode;
  final String? paypalClientId;
  final String? paypalSecretKey;
  final String? aboutPageTopDescription;
  final String? aboutPageBottomDescription;
  final String? timezone;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? domainUrl;
  final String? appId;
  final String? apiKey;
  final String? timer;
  final String? url;
  final String? vendorStatus;
  final String? pauseTime;
  final String? message;
  final int? status;

  StoreSettingResponse(
      {this.id,
      this.vendorId,
      this.gst,
      this.pst,
      this.hst,
      this.upcomingOrReserveDay,
      this.deliveryCharges,
      this.storeStatus,
      this.codStatus,
      this.paypalStatus,
      this.paypalMode,
      this.paypalClientId,
      this.paypalSecretKey,
      this.aboutPageTopDescription,
      this.aboutPageBottomDescription,
      this.timezone,
      this.createdAt,
      this.updatedAt,
      this.domainUrl,
      this.appId,
      this.apiKey,
      this.timer,
      this.url,
      this.vendorStatus,
      this.pauseTime,
      this.status,
      this.message});

  factory StoreSettingResponse.fromJson(Map<String, dynamic> json) {
    return StoreSettingResponse(
      message: json['message'] as String?,
      status: json['status'] as int?,
      id: json['data']?['id'] as int?,
      vendorId: json['data']?['vendor_id'] as int?,
      gst: json['data']?['gst'] as int?,
      pst: json['data']?['pst'] as int?,
      hst: json['data']?['hst'] as int?,
      upcomingOrReserveDay: json['data']?['upcoming_or_reserve_day'] as bool?,
      deliveryCharges: json['data']?['delivery_charges'],
      storeStatus: json['data']?['store_status'] as bool?,
      codStatus: json['data']?['cod_status'] as bool?,
      paypalStatus: json['data']?['paypal_status'] as bool?,
      paypalMode: json['data']?['paypal_mode'] as String?,
      paypalClientId: json['data']?['paypal_client_id'] as String?,
      paypalSecretKey: json['data']?['paypal_secret_key'] as String?,
      aboutPageTopDescription:
          json['data']?['about_page_top_description'] as String?,
      aboutPageBottomDescription:
          json['data']?['about_page_bottom_description'] as String?,
      timezone: json['data']?['timezone']?.toString(),
      createdAt: json['data']?['created_at'] != null
          ? DateTime.tryParse(json['data']?['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['data']?['updated_at'])
          : null,
      domainUrl: json['data']?['domain_url'] as String?,
      appId: json['data']?['app_id'] as String?,
      apiKey: json['data']?['api_key'] as String?,
      timer: json['data']?['timer']?.toString(),
      url: json['data']?['url'] as String?,
      vendorStatus: json['data']?['vendor_status'] as String?,
      pauseTime: json['data']?['pause_time'] as String?,
    );
  }

  factory StoreSettingResponse.fromPref(Map<String, dynamic> json) {
    return StoreSettingResponse(
      id: json['id'] as int?,
      vendorId: json['vendor_id'] as int?,
      gst: json['gst'] as int?,
      pst: json['pst'] as int?,
      hst: json['hst'] as int?,
      upcomingOrReserveDay: json['upcoming_or_reserve_day'] as bool?,
      deliveryCharges: json['delivery_charges'],
      storeStatus: json['store_status'] as bool?,
      codStatus: json['cod_status'] as bool?,
      paypalStatus: json['paypal_status'] as bool?,
      paypalMode: json['paypal_mode'] as String?,
      paypalClientId: json['paypal_client_id'] as String?,
      paypalSecretKey: json['paypal_secret_key'] as String?,
      aboutPageTopDescription: json['about_page_top_description'] as String?,
      aboutPageBottomDescription:
          json['about_page_bottom_description'] as String?,
      timezone: json['timezone']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      domainUrl: json['domain_url'] as String?,
      appId: json['app_id'] as String?,
      apiKey: json['api_key'] as String?,
      timer: json['timer']?.toString(),
      url: json['url'] as String?,
      vendorStatus: json['vendor_status'] as String?,
      pauseTime: json['pause_time'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['vendor_id'] = vendorId;
    data['gst'] = gst;
    data['pst'] = pst;
    data['hst'] = hst;
    data['upcoming_or_reserve_day'] = upcomingOrReserveDay;
    data['delivery_charges'] = deliveryCharges;
    data['store_status'] = storeStatus;
    data['cod_status'] = codStatus;
    data['paypal_status'] = paypalStatus;
    data['paypal_mode'] = paypalMode;
    data['paypal_client_id'] = paypalClientId;
    data['paypal_secret_key'] = paypalSecretKey;
    data['about_page_top_description'] = aboutPageTopDescription;
    data['about_page_bottom_description'] = aboutPageBottomDescription;
    data['timezone'] = timezone;
    data['created_at'] = createdAt?.toIso8601String();
    data['updated_at'] = updatedAt?.toIso8601String();
    data['domain_url'] = domainUrl;
    data['app_id'] = appId;
    data['api_key'] = apiKey;
    data['timer'] = timer;
    data['url'] = url;
    data['vendor_status'] = vendorStatus;
    data['pause_time'] = pauseTime;
    return data;
  }
}
