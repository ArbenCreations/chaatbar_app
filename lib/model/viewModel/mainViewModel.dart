import 'dart:convert';

import 'package:TheChaatBar/model/apis/apiResponse.dart';
import 'package:TheChaatBar/model/repository.dart';
import 'package:TheChaatBar/model/request/TransactionRequest.dart';
import 'package:TheChaatBar/model/request/featuredListRequest.dart';
import 'package:TheChaatBar/model/request/getCouponListRequest.dart';
import 'package:TheChaatBar/model/request/getHistoryRequest.dart';
import 'package:TheChaatBar/model/request/getProductsRequest.dart';
import 'package:TheChaatBar/model/request/globalSearchRequest.dart';
import 'package:TheChaatBar/model/request/markFavoriteRequest.dart';
import 'package:TheChaatBar/model/request/signUpRequest.dart';
import 'package:TheChaatBar/model/request/vendorSearchRequest.dart';
import 'package:TheChaatBar/model/response/bannerListResponse.dart';
import 'package:TheChaatBar/model/response/categoryListResponse.dart';
import 'package:TheChaatBar/model/response/couponListResponse.dart';
import 'package:TheChaatBar/model/response/favoriteListResponse.dart';
import 'package:TheChaatBar/model/response/featuredListResponse.dart';
import 'package:TheChaatBar/model/response/getApiAccessKeyResponse.dart';
import 'package:TheChaatBar/model/response/getHistoryResponse.dart';
import 'package:TheChaatBar/model/response/globalSearchResponse.dart';
import 'package:TheChaatBar/model/response/locationListResponse.dart';
import 'package:TheChaatBar/model/response/productListResponse.dart';
import 'package:TheChaatBar/model/response/profileResponse.dart';
import 'package:TheChaatBar/model/response/loginResponse.dart';
import 'package:TheChaatBar/model/response/signUpInitializeResponse.dart';
import 'package:TheChaatBar/model/response/signUpVerifyResponse.dart';
import 'package:TheChaatBar/model/response/vendorSearchResponse.dart';
import 'package:flutter/cupertino.dart';

import '../request/CardDetailRequest.dart';
import '../request/CreateOrderRequest.dart';
import '../request/createOtpChangePass.dart';
import '../request/deleteProfileRequest.dart';
import '../request/editProfileRequest.dart';
import '../request/getCouponDetailsRequest.dart';
import '../request/otpVerifyRequest.dart';
import '../request/signInRequest.dart';
import '../request/signUpWithGoogleRequest.dart';
import '../request/successCallbackRequest.dart';
import '../request/verifyOtpChangePass.dart';
import '../response/ErrorResponse.dart';
import '../response/PaymentDetailsResponse.dart';
import '../response/StoreSettingResponse.dart';
import '../response/createOrderResponse.dart';
import '../response/createOtpChangePassResponse.dart';
import '../response/dashboardDataResponse.dart';
import '../response/getCouponDetailsResponse.dart';
import '../response/markFavoriteResponse.dart';
import '../response/storeStatusResponse.dart';
import '../response/successCallbackResponse.dart';
import '../response/tokenDetailsResponse.dart';
import '../response/vendorListResponse.dart';

class MainViewModel with ChangeNotifier {
  ApiResponse _apiResponse = ApiResponse.initial('Empty data');
  var repository = MainRepository();

  ApiResponse get response {
    return _apiResponse;
  }

  Future<void> signInWithPass(String value, SignInRequest signInRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      LoginResponse response =
          await repository.signInWithPass(value, signInRequest);
      if (response.status == 200 || response.status == 201) {
        _apiResponse = ApiResponse.completed(response);
      } else {
        _apiResponse = ApiResponse.error(response.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  Future<void> signInWithGoogle(
      String value, SignUpWithGoogleRequest signUpWithGoogleRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      LoginResponse response =
          await repository.signInWithGoogle(value, signUpWithGoogleRequest);
      if (response.status == 200 || response.status == 201) {
        _apiResponse = ApiResponse.completed(response);
      } else {
        _apiResponse = ApiResponse.error(response.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  Future<void> getApiAccessKey(String value, String auth) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      GetApiAccessKeyResponse response =
          await repository.getApiAccessKey(value, auth);
      if (response.apiAccessKey?.isNotEmpty == true ||
          response.active == true) {
        _apiResponse = ApiResponse.completed(response);
      } else {
        _apiResponse = ApiResponse.error("${response.message}");
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  Future<void> getApiToken(
      String value, String apiKey, CardRequest cardRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      TokenDetailsResponse response =
          await repository.getApiToken(value, apiKey, cardRequest);
      if (response.id?.isNotEmpty == true) {
        _apiResponse = ApiResponse.completed(response);
      } else {
        _apiResponse = ApiResponse.error("Something went wrong.");
      }
    } catch (e) {
      // Deserialize JSON string to Dart object
      int jsonStartIndex = e.toString().indexOf('{');
      String jsonString = e.toString().substring(jsonStartIndex);
      final Map<String, dynamic> decodedJson = jsonDecode(jsonString);
      ErrorResponse errorResponse = ErrorResponse.fromJson(decodedJson);
      _apiResponse = ApiResponse.error("${errorResponse.error?.message ?? "Something went wrong."}");
      print("LoginResponse ${errorResponse.error?.message}");
    }
    notifyListeners();
  }

  Future<void> getFinalPaymentApi(
      String value, String auth, TransactionRequest transactionRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      PaymentDetails response =
          await repository.getFinalPaymentApi(value, auth, transactionRequest);
      if (response.id.isNotEmpty == true) {
        _apiResponse = ApiResponse.completed(response);
      } else {
        _apiResponse = ApiResponse.error("${response.message}");
      }
    } catch (e) {
      int jsonStartIndex = e.toString().indexOf('{');
      String jsonString = e.toString().substring(jsonStartIndex);
      final Map<String, dynamic> decodedJson = jsonDecode(jsonString);
      ErrorResponse errorResponse = ErrorResponse.fromJson(decodedJson);
      _apiResponse = ApiResponse.error("${errorResponse.error?.message}");
    }
    notifyListeners();
  }

  Future<void> successCallback(
      String value, SuccessCallbackRequest successCallbackRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      SuccessCallbackResponse response =
          await repository.successCallback(value, successCallbackRequest);
      if (response.status == 200 || response.status == 201) {
        _apiResponse = ApiResponse.completed(response);
      } else {
        _apiResponse = ApiResponse.error(response.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  Future<void> signUpData(String value, SignUpRequest signUpRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      SignUpInitializeResponse response =
          await repository.signUpData(value, signUpRequest);
      if (response.status == 200 || response.status == 201) {
        _apiResponse = ApiResponse.completed(response);
      } else {
        _apiResponse = ApiResponse.error(response.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  Future<void> signUpOtpVerifyData(
      String value, OtpVerifyRequest otpVerifyRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      SignUpVerifyResponse response =
          await repository.signUpOtpVerifyData(value, otpVerifyRequest);
      if (response.status == 200 || response.status == 201) {
        _apiResponse = ApiResponse.completed(response);
      } else {
        _apiResponse = ApiResponse.error(response.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print("LoginResponse $e");
    }
    notifyListeners();
  }

  Future<void> fetchLocationList(String value) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      LocationListResponse response = await repository.fetchLocationList(value);
      if (response.status == 200 || response.status == 201) {
        _apiResponse = ApiResponse.completed(response);
      } else {
        _apiResponse = ApiResponse.error(response.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(" catch ${e}");
    }
    notifyListeners();
  }

  Future<void> fetchVendors(String value) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      VendorListResponse response = await repository.fetchVendors(value);
      if (response.status == 200 || response.status == 201) {
        _apiResponse = ApiResponse.completed(response);
      } else {
        _apiResponse = ApiResponse.error(response.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(" catch ${e}");
    }
    notifyListeners();
  }

  Future<void> fetchBanners(String value) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      BannerListResponse response = await repository.fetchBanners(value);
      if (response.status == 200 || response.status == 201) {
        _apiResponse = ApiResponse.completed(response);
      } else {
        _apiResponse = ApiResponse.error(response.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(" catch ${e}");
    }
    notifyListeners();
  }

  Future<void> fetchDashboardData(String value, int? vendorId) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      DashboardDataResponse response =
          await repository.fetchDashBoardData(value, vendorId);
      if (response.status == 200 || response.status == 201) {
        _apiResponse = ApiResponse.completed(response);
      } else {
        _apiResponse = ApiResponse.error(response.message);
      }
    } catch (e) {
      print(" catch ${e}");
      _apiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  Future<void> fetchCategoriesList(String value, int? vendorId) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      CategoryListResponse response =
          await repository.fetchProductCategoriesList(value, vendorId);
      if (response.status == 200 || response.status == 201) {
        _apiResponse = ApiResponse.completed(response);
      } else {
        _apiResponse = ApiResponse.error(response.message);
      }
    } catch (e) {
      print(" catch ${e}");
      _apiResponse = ApiResponse.error(e.toString());
    }
    notifyListeners();
  }

  Future<void> fetchFeaturedProductList(
      String value, FeaturedListRequest featuredListRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      FeaturedListResponse response =
          await repository.fetchFeaturedProductList(value, featuredListRequest);
      if (response.status == 200 || response.status == 201) {
        _apiResponse = ApiResponse.completed(response);
      } else {
        _apiResponse = ApiResponse.error(response.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> fetchFavoritesProductList(
      String value, MarkFavoriteRequest markFavRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      FavoriteListResponse response =
          await repository.fetchFavoritesProductList(value, markFavRequest);
      if (response.status == 200 || response.status == 201) {
        _apiResponse = ApiResponse.completed(response);
      } else {
        print("viewmodel ${response.message}");
        _apiResponse = ApiResponse.error(response.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> markFavoriteData(
      String value, MarkFavoriteRequest markFavoriteRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      MarkFavoriteResponse response =
          await repository.markFavoriteData(value, markFavoriteRequest);
      if (response.status == 200 || response.status == 201) {
        _apiResponse = ApiResponse.completed(response);
      } else {
        _apiResponse = ApiResponse.error(response.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> removeFavoriteData(
      String value, MarkFavoriteRequest markFavRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      MarkFavoriteResponse response =
          await repository.removeFavoriteData(value, markFavRequest);
      if (response.status == 200 || response.status == 201) {
        _apiResponse = ApiResponse.completed(response);
      } else {
        _apiResponse = ApiResponse.error(response.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> fetchStoreStatus(String value) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      StoreStatusResponse response = await repository.fetchStoreStatus(value);
      if (response.status == 200 || response.status == 201) {
        _apiResponse = ApiResponse.completed(response);
      } else {
        _apiResponse = ApiResponse.error(response.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> fetchProfile(String value) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      ProfileResponse response = await repository.fetchProfile(value);
      if (response.status == 200 || response.status == 201) {
        _apiResponse = ApiResponse.completed(response);
      } else {
        _apiResponse = ApiResponse.error(response.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> editProfile(
      String value, EditProfileRequest editProfileRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      ProfileResponse response =
          await repository.editProfile(value, editProfileRequest);
      if (response.status == 200 || response.status == 201) {
        _apiResponse = ApiResponse.completed(response);
      } else {
        _apiResponse = ApiResponse.error(response.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> fetchCouponList(
      String value, GetCouponListRequest getCouponListRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      CouponListResponse response =
          await repository.fetchCouponList(value, getCouponListRequest);
      if (response.status == 200 || response.status == 201) {
        _apiResponse = ApiResponse.completed(response);
      } else {
        _apiResponse = ApiResponse.error(response.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> fetchProductList(
      String value, GetProductsRequest getProductRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      ProductListResponse response =
          await repository.fetchProductList(value, getProductRequest);
      if (response.status == 200 || response.status == 201) {
        _apiResponse = ApiResponse.completed(response);
      } else {
        _apiResponse = ApiResponse.error(response.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> fetchGlobalSearchResults(
      String value, GlobalSearchRequest globalSearchRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      print(globalSearchRequest.query);

      GlobalSearchResponse response =
          await repository.fetchGlobalSearchResults(value, globalSearchRequest);
      if (response.status == 200 || response.status == 201) {
        _apiResponse = ApiResponse.completed(response);
      } else {
        _apiResponse = ApiResponse.error(response.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> fetchVendorSearchResults(
      String value, VendorSearchRequest vendorSearchRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      print(vendorSearchRequest.query);

      VendorSearchResponse response =
          await repository.fetchVendorSearchResults(value, vendorSearchRequest);
      if (response.status == 200 || response.status == 201) {
        _apiResponse = ApiResponse.completed(response);
      } else {
        _apiResponse = ApiResponse.error(response.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> fetchCouponDetails(
      String value, GetCouponDetailsRequest getCouponDetailsRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      CouponDetailsResponse response =
          await repository.fetchCouponDetails(value, getCouponDetailsRequest);
      print("Yess" + "${response.discount}");
      if (response.status == 200 || response.status == 201) {
        _apiResponse = ApiResponse.completed(response);
      } else {
        print("viewmodel ${response.message}");
        _apiResponse = ApiResponse.error(response.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> placeOrder(
      String value, CreateOrderRequest createOrderRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      print(createOrderRequest.order.phoneNumber);

      CreateOrderResponse response =
          await repository.placeOrder(value, createOrderRequest);
      print("Yess" + "${response.order?.id}");
      if (response.responseStatus == 200 || response.responseStatus == 201) {
        _apiResponse = ApiResponse.completed(response);
      } else {
        print("viewmodel ${response.message}");
        _apiResponse = ApiResponse.error(response.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> CreateOtpChangePass(String value,
      CreateOtpChangePassRequest createOtpChangePassRequest) async {
    _apiResponse = ApiResponse.loading('Loading');

    notifyListeners();
    try {
      print(createOtpChangePassRequest.email);

      CreateOtpChangePassResponse response =
          await repository.CreateOtpChangePass(
              value, createOtpChangePassRequest);
      print("Yess" + "${response.email}");

      if (response.status == 200 || response.status == 201) {
        _apiResponse = ApiResponse.completed(response);
      } else {
        _apiResponse = ApiResponse.error(response.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> VerifyOtpChangePass(
      String value, VerifyOtChangePassRequest verifyOtChangePassRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      SignUpInitializeResponse response = await repository.VerifyOtpChangePass(
          value, verifyOtChangePassRequest);
      if (response.status == 200 || response.status == 201) {
        _apiResponse = ApiResponse.completed(response);
      } else {
        _apiResponse = ApiResponse.error(response.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> getHistoryData(
      String value, GetHistoryRequest getHistoryRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      GetHistoryResponse response =
          await repository.getHistoryData(value, getHistoryRequest);
      if (response.status == 200 || response.status == 201) {
        _apiResponse = ApiResponse.completed(response);
      } else {
        _apiResponse = ApiResponse.error(response.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> deleteProfile(
      String value, DeleteProfileRequest deleteProfileRequest) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      ProfileResponse profileResponse =
      await MainRepository().deleteProfile(value, deleteProfileRequest);
      print("Yess" + profileResponse.firstName.toString());
      if (profileResponse.status == 200 || profileResponse.status == 201) {
        _apiResponse = ApiResponse.completed(profileResponse);
      } else {
        print("viewmodel ${profileResponse.message}");
        _apiResponse = ApiResponse.error(profileResponse.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString().contains("<!DOCTYPE html>") ? "Something went wrong!" : e.toString());
      print(e);
    }
    notifyListeners();
  }

  Future<void> fetchStoreSettingData(String value) async {
    _apiResponse = ApiResponse.loading('Loading');
    notifyListeners();
    try {
      StoreSettingResponse storeSettingResponse =
      await MainRepository().fetchStoreSettingData(value);
      print("Yess" + storeSettingResponse.message.toString());

      //_apiResponse = ApiResponse.completed(countryListResponse);
      if (storeSettingResponse.status == 200 ||
          storeSettingResponse.status == 201) {
        _apiResponse = ApiResponse.completed(storeSettingResponse);
      } else {
        _apiResponse = ApiResponse.error(storeSettingResponse.message);
      }
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString().contains("<!DOCTYPE html>") ? "Something went wrong!" : e.toString());
      print(" catch ${e}");
    }
    notifyListeners();
  }

  /// Call the media service and gets the data of requested media data of
  /// an artist.
}
