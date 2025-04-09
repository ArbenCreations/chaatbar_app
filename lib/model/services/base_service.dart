import 'dart:io';


abstract class BaseService {
  final String BaseUrl = "http://66.179.210.141:3000/";

  String getFullUrl(String endpoint) {
    return "$BaseUrl$endpoint";
  }

  Future<dynamic> postResponse(String url, dynamic phoneRequest);

  Future<dynamic> postCloverResponse(String url, String apiKey, dynamic phoneRequest);

  Future<dynamic> postCloverFinalPaymentResponse(String url, String apiKey, dynamic phoneRequest);

  Future<dynamic> putResponse(String url, dynamic phoneRequest);

  Future<dynamic> putCloverResponse(String url, String apiKey ,dynamic phoneRequest);

  Future<dynamic> getResponse(String url);

  Future<dynamic> getCloverResponse(String url, String auth);

  Future<dynamic> deleteResponse(String url, dynamic phoneRequest);

  Future<dynamic> putMultiFormResponse(String url, File file, String firstName,
      String lastName, String dob);
}