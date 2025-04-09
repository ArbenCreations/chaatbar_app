import 'dart:convert';
import 'dart:io';

import 'package:TheChaatBar/model/apis/appException.dart';
import 'package:TheChaatBar/model/services/base_service.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:path/path.dart';

import '../../utils/Helper.dart';

class ApiService extends BaseService {
  String? retrievedToken;
  String? apiKey;
  var selectedLanguage;


  Future<void> setStateData() async {
    retrievedToken = await Helper.getUserToken(); // Ensure we wait for this
    selectedLanguage = await Helper.getLocale();
    print("Updated retrievedToken: $retrievedToken");
  }

  Future<Map<String, String>> getHeaders() async {
    retrievedToken = await Helper.getUserToken(); // Always fetch latest
    print("Using token for API request: $retrievedToken");

    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${retrievedToken ?? ''}',
      'Accept-Language': selectedLanguage?.languageCode ?? 'en',
      'App-Type': 'mobile',
    };
  }

  Future<Map<String, String>> getCloverHeaders(String auth) async {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $auth',
    };
  }

  Future<Map<String, String>> getCloverTokenHeader(String apiKey) async {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'apikey': '$apiKey',
    };
  }

  Future<Map<String, String>> getMultiDataHeaders() async {
    if (retrievedToken == null || selectedLanguage == null) {
      await setStateData();
    }
    return {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $retrievedToken',
      'Accept-Language': "in",
      'App-Type': "mobile",
    };
  }

  void printRequestDetails(
      String url, Map<String, String> headers, dynamic body) {
    print('Request URL: $url');
    print('Request Headers: $headers');
    if (body != null) {
      print('Request Body: ${jsonEncode(body)}');
    }
  }

  void printResponseDetail(http.StreamedResponse response) {
    // Implement this function to print response details
    print('Response Status: ${response.statusCode}');
    // Print other response details as needed
  }

  void printResponseDetails(http.Response response) {
    print('Response Status Code: ${response.statusCode}');
    print('Response Headers: ${response.headers}');
    print('Response Body: ${response.body}');
    try {
      var responseBody = jsonDecode(response.body);
      print('Success: ${responseBody['success']}');
      print('Message: ${responseBody['message']}');
      print('Status: ${responseBody['status']}');
      print('Data: ${responseBody['data']}');
    } catch (e) {
      print('Error parsing response body: $e');
    }
  }

  @override
  Future<dynamic> postResponse(String url, dynamic requestBody) async {
    dynamic responseJson;
    try {
      await Future.delayed(Duration(milliseconds: 2));
      var headers = await getHeaders();

      printRequestDetails(getFullUrl(url), headers, requestBody);
      final response = await http.post(
        Uri.parse(getFullUrl(url)),
        headers: headers,
        body: jsonEncode(requestBody),
      );
      responseJson = returnResponse(response);
      printResponseDetails(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future<dynamic> postCloverResponse(
      String url, String apiKey, dynamic requestBody) async {
    dynamic responseJson;
    try {
      await Future.delayed(Duration(milliseconds: 2));
      var headers = await getCloverTokenHeader(apiKey);

      printRequestDetails(url, headers, requestBody);
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(requestBody),
      );
      responseJson = returnResponse(response);
      printResponseDetails(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future<dynamic> postCloverFinalPaymentResponse(
      String url, String auth, dynamic requestBody) async {
    dynamic responseJson;
    try {
      await Future.delayed(Duration(milliseconds: 2));
      var headers = await getCloverHeaders(auth);

      printRequestDetails(url, headers, requestBody);
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(requestBody),
      );
      responseJson = returnResponse(response);
      printResponseDetails(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future<dynamic> putResponse(String url, dynamic requestBody) async {
    dynamic responseJson;
    try {
      await Future.delayed(Duration(milliseconds: 2));
      var headers = await getHeaders();

      printRequestDetails(getFullUrl(url), headers, requestBody);

      final response = await http.put(
        Uri.parse(getFullUrl(url)),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      responseJson = returnResponse(response);
      printResponseDetails(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future<dynamic> putCloverResponse(
      String url, String apiKey, dynamic requestBody) async {
    dynamic responseJson;
    try {
      await Future.delayed(Duration(milliseconds: 2));
      var headers = await getCloverTokenHeader(apiKey);

      printRequestDetails(url, headers, requestBody);

      final response = await http.put(
        Uri.parse(getFullUrl(url)),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      responseJson = returnResponse(response);
      printResponseDetails(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future getResponse(String url) async {
    dynamic responseJson;
    try {
      await Future.delayed(Duration(milliseconds: 2));
      var headers = await getHeaders();

      printRequestDetails(getFullUrl(url), headers, {});

      final response =
          await http.get(Uri.parse(getFullUrl(url)), headers: headers);
      responseJson = returnResponse(response);
      printResponseDetails(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future getCloverResponse(String url, String auth) async {
    dynamic responseJson;
    try {
      await Future.delayed(Duration(milliseconds: 2));
      var headers = await getCloverHeaders(auth);

      printRequestDetails(url, headers, {});

      final response = await http.get(Uri.parse(url), headers: headers);
      responseJson = returnResponse(response);
      printResponseDetails(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future<dynamic> deleteResponse(String url, dynamic requestBody) async {
    dynamic responseJson;
    try {
      await Future.delayed(Duration(milliseconds: 2));
      var headers = await getHeaders();

      printRequestDetails(getFullUrl(url), headers, requestBody);

      final response = await http.delete(
        Uri.parse(getFullUrl(url)),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      responseJson = returnResponse(response);
      printResponseDetails(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  Future<dynamic> putMultiFormResponse(
    String url,
    File file,
    String firstName,
    String lastName,
    String dob,
  ) async {
    print("::::: File: $file");
    dynamic responseJson;

    try {
      // Create a multipart request
      var requestBody =
          http.MultipartRequest('PUT', Uri.parse(getFullUrl(url)));

      if (file.path.isNotEmpty) {
        // Add file
        var stream = http.ByteStream(file.openRead());
        var length = await file.length();

        // multipart that takes file
        var multipartFile = http.MultipartFile('customer_image', stream, length,
            filename: basename(file.path));
        print("Multipart File: ${multipartFile.filename}");
        requestBody.files.add(multipartFile);
      }
      requestBody.fields['first_name'] = firstName;
      requestBody.fields['last_name'] = lastName;
      requestBody.fields['dob'] = dob;

      // Add headers
      var headers = await getHeaders();
      requestBody.headers.addAll(headers);

      // Debugging the request
      print("Request URL: ${getFullUrl(url)}");
      print("Request Headers: $headers");
      print(
          "Request Files: ${requestBody.files.map((file) => file.filename).join(', ')}");

      // Send the request and get the response
      var response = await requestBody.send();
      final responses = await http.Response.fromStream(response);
      print("Response Status Code: ${responses.statusCode}");
      print("Response Body: ${responses.body}");

      responseJson = returnResponse(responses);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } catch (e) {
      print('Error: $e');
      throw FetchDataException('Error occurred while sending the request');
    }
    return responseJson;
  }

  dynamic returnResponses(String responseString, int statusCode) {
    // Implement this function to parse and return the response
    return {
      'statusCode': statusCode,
      'body': responseString,
    };
  }

  @visibleForTesting
  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 201:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 422:
        var responseBody = jsonDecode(response.body);
        print("Message >>::${responseBody['statusCode']}");
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 401:
        //final responseBody = response;
        var responseBody = jsonDecode(response.body);
        print("Message >>::${responseBody['message']}");
        dynamic responseJson = jsonDecode(responseBody['message']);
        return responseJson;
      //throw UnauthorisedException(response.body.toString());
      case 403:
        {
          //var responseBody = jsonDecode(response);
          final responseBody = response;
          print("Message ${responseBody}");
          dynamic responseJson = jsonDecode(response.body);
          return responseJson;
          // throw UnauthorisedException("${responseBody['message']}");
        }
      case 404:
        //final responseBody = response;
        var responseBody = jsonDecode(response.body);
        print("Message >>::${responseBody['message']}");
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      //throw UnauthorisedException(response.body.toString());
      case 500:
        throw BadRequestException(response.body.toString());
      default:
        throw FetchDataException('Error occured while communication with server' +
            ' with status code : ${response.statusCode} ${response.body.toString()}');
    }
  }
}
