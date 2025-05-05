import 'package:TheChaatBar/model/request/CardDetailRequest.dart';
import 'package:TheChaatBar/model/request/CreateOrderRequest.dart';
import 'package:TheChaatBar/model/request/EncryptedWalletRequest.dart';
import 'package:TheChaatBar/model/request/TransactionRequest.dart';
import 'package:TheChaatBar/model/request/createOtpChangePass.dart';
import 'package:TheChaatBar/model/request/deleteProfileRequest.dart';
import 'package:TheChaatBar/model/request/editProfileRequest.dart';
import 'package:TheChaatBar/model/request/featuredListRequest.dart';
import 'package:TheChaatBar/model/request/getCategoryRequest.dart';
import 'package:TheChaatBar/model/request/getCouponDetailsRequest.dart';
import 'package:TheChaatBar/model/request/getCouponListRequest.dart';
import 'package:TheChaatBar/model/request/getHistoryRequest.dart';
import 'package:TheChaatBar/model/request/getProductsRequest.dart';
import 'package:TheChaatBar/model/request/globalSearchRequest.dart';
import 'package:TheChaatBar/model/request/markFavoriteRequest.dart';
import 'package:TheChaatBar/model/request/otpVerifyRequest.dart';
import 'package:TheChaatBar/model/request/signInRequest.dart';
import 'package:TheChaatBar/model/request/signUpRequest.dart';
import 'package:TheChaatBar/model/request/signUpWithGoogleRequest.dart';
import 'package:TheChaatBar/model/request/successCallbackRequest.dart';
import 'package:TheChaatBar/model/request/vendorSearchRequest.dart';
import 'package:TheChaatBar/model/request/verifyOtpChangePass.dart';
import 'package:TheChaatBar/model/response/PaymentDetailsResponse.dart';
import 'package:TheChaatBar/model/response/StoreSettingResponse.dart';
import 'package:TheChaatBar/model/response/appleTokenDetailsResponse.dart';
import 'package:TheChaatBar/model/response/bannerListResponse.dart';
import 'package:TheChaatBar/model/response/categoryListResponse.dart';
import 'package:TheChaatBar/model/response/couponListResponse.dart';
import 'package:TheChaatBar/model/response/createOrderResponse.dart';
import 'package:TheChaatBar/model/response/createOtpChangePassResponse.dart';
import 'package:TheChaatBar/model/response/dashboardDataResponse.dart';
import 'package:TheChaatBar/model/response/favoriteListResponse.dart';
import 'package:TheChaatBar/model/response/featuredListResponse.dart';
import 'package:TheChaatBar/model/response/getApiAccessKeyResponse.dart';
import 'package:TheChaatBar/model/response/getCouponDetailsResponse.dart';
import 'package:TheChaatBar/model/response/getHistoryResponse.dart';
import 'package:TheChaatBar/model/response/globalSearchResponse.dart';
import 'package:TheChaatBar/model/response/locationListResponse.dart';
import 'package:TheChaatBar/model/response/loginResponse.dart';
import 'package:TheChaatBar/model/response/markFavoriteResponse.dart';
import 'package:TheChaatBar/model/response/productListResponse.dart';
import 'package:TheChaatBar/model/response/profileResponse.dart';
import 'package:TheChaatBar/model/response/signUpInitializeResponse.dart';
import 'package:TheChaatBar/model/response/signUpVerifyResponse.dart';
import 'package:TheChaatBar/model/response/storeStatusResponse.dart';
import 'package:TheChaatBar/model/response/successCallbackResponse.dart';
import 'package:TheChaatBar/model/response/tokenDetailsResponse.dart';
import 'package:TheChaatBar/model/response/vendorListResponse.dart';
import 'package:TheChaatBar/model/response/vendorSearchResponse.dart';
import 'package:TheChaatBar/model/services/apiService.dart';
import 'package:TheChaatBar/model/services/base_service.dart';

class MainRepository {
  BaseService service = ApiService();

  Future<LoginResponse> signInWithPass(
      String value, SignInRequest signInRequest) async {
    print(signInRequest);
    dynamic response = await service.postResponse(value, signInRequest);

    final jsonData = response;
    print(" ${jsonData}");
    LoginResponse mediaList = LoginResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<LoginResponse> signInWithGoogle(
      String value, SignUpWithGoogleRequest signUpWithGoogleRequest) async {
    print(signUpWithGoogleRequest);
    dynamic response =
        await service.postResponse(value, signUpWithGoogleRequest);

    final jsonData = response;
    print(" ${jsonData}");
    LoginResponse mediaList = LoginResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<GetApiAccessKeyResponse> getApiAccessKey(
      String value, String auth) async {
    dynamic response = await service.getCloverResponse(value, auth);

    final jsonData = response;
    print(" ${jsonData}");
    GetApiAccessKeyResponse mediaList =
        GetApiAccessKeyResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<TokenDetailsResponse> getApiToken(
      String value, String apiKey, CardRequest cardRequest) async {
    dynamic response =
        await service.postCloverResponse(value, apiKey, cardRequest);

    final jsonData = response;
    print(" ${jsonData}");
    TokenDetailsResponse mediaList = TokenDetailsResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<PaymentDetails> getFinalPaymentApi(
      String value, String auth, TransactionRequest transactionRequest) async {
    dynamic response = await service.postCloverFinalPaymentResponse(
        value, auth, transactionRequest);

    final jsonData = response;
    print(" ${jsonData}");
    PaymentDetails mediaList = PaymentDetails.fromJson(jsonData);
    return mediaList;
  }

  Future<SuccessCallbackResponse> successCallback(
      String value, SuccessCallbackRequest successCallbackRequest) async {
    print(successCallbackRequest);
    dynamic response =
        await service.postResponse(value, successCallbackRequest);

    final jsonData = response;
    print(" ${jsonData}");
    SuccessCallbackResponse mediaList =
        SuccessCallbackResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<SignUpInitializeResponse> signUpData(
      String value, SignUpRequest signUpRequest) async {
    print(signUpRequest);
    dynamic response = await service.postResponse(value, signUpRequest);

    final jsonData = response;
    print(" ${jsonData}");
    SignUpInitializeResponse mediaList =
        SignUpInitializeResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<SignUpVerifyResponse> signUpOtpVerifyData(
      String value, OtpVerifyRequest otpVerifyRequest) async {
    print(otpVerifyRequest);
    dynamic response = await service.postResponse(value, otpVerifyRequest);

    final jsonData = response;
    print(" ${jsonData}");
    SignUpVerifyResponse mediaList = SignUpVerifyResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<LocationListResponse> fetchLocationList(String value) async {
    dynamic response = await service.getResponse(value);

    final jsonData = response;
    print(jsonData);
    LocationListResponse mediaList = LocationListResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<VendorListResponse> fetchVendors(String value) async {
    dynamic response = await service.getResponse(value);

    final jsonData = response;
    print(jsonData);
    VendorListResponse mediaList = VendorListResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<BannerListResponse> fetchBanners(String value) async {
    dynamic response = await service.getResponse(value);

    final jsonData = response;
    print(jsonData);
    BannerListResponse mediaList = BannerListResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<DashboardDataResponse> fetchDashBoardData(
      String value, int? vendorId) async {
    GetCategoryRequest getCategoryRequest =
        GetCategoryRequest(vendorId: vendorId);

    dynamic response = await service.postResponse(value, getCategoryRequest);

    final jsonData = response;
    print(jsonData);
    DashboardDataResponse mediaList = DashboardDataResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<CategoryListResponse> fetchProductCategoriesList(
      String value, int? vendorId) async {
    GetCategoryRequest getCategoryRequest =
        GetCategoryRequest(vendorId: vendorId);

    dynamic response = await service.postResponse(value, getCategoryRequest);

    final jsonData = response;
    print(jsonData);
    CategoryListResponse mediaList = CategoryListResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<FeaturedListResponse> fetchFeaturedProductList(
      String value, FeaturedListRequest featuredListRequest) async {
    print(featuredListRequest);
    dynamic response = await service.postResponse(value, featuredListRequest);
    final jsonData = response;
    print(jsonData);
    FeaturedListResponse mediaList = FeaturedListResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<FavoriteListResponse> fetchFavoritesProductList(
      String value, MarkFavoriteRequest markFavRequest) async {
    dynamic response = await service.postResponse(value, markFavRequest);
    final jsonData = response;
    print(jsonData);
    FavoriteListResponse mediaList = FavoriteListResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<MarkFavoriteResponse> markFavoriteData(
      String value, MarkFavoriteRequest markFavoriteRequest) async {
    print(markFavoriteRequest);
    dynamic response = await service.putResponse(value, markFavoriteRequest);
    final jsonData = response;
    print(jsonData);
    MarkFavoriteResponse mediaList = MarkFavoriteResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<MarkFavoriteResponse> removeFavoriteData(
      String value, MarkFavoriteRequest request) async {
    dynamic response = await service.deleteResponse(value, request);
    final jsonData = response;
    print(jsonData);
    MarkFavoriteResponse mediaList = MarkFavoriteResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<StoreStatusResponse> fetchStoreStatus(String value) async {
    dynamic response = await service.getResponse(value);
    final jsonData = response;
    print(jsonData);
    StoreStatusResponse mediaList = StoreStatusResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<ProfileResponse> fetchProfile(String value) async {
    dynamic response = await service.getResponse(value);
    final jsonData = response;
    print(jsonData);
    ProfileResponse mediaList = ProfileResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<ProfileResponse> editProfile(
      String value, EditProfileRequest editProfileRequest) async {
    dynamic response = await service.putResponse(value, editProfileRequest);
    final jsonData = response;
    print(jsonData);
    ProfileResponse mediaList = ProfileResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<CouponListResponse> fetchCouponList(
      String value, GetCouponListRequest getCouponListRequest) async {
    print(getCouponListRequest);
    dynamic response = await service.postResponse(value, getCouponListRequest);
    final jsonData = response;
    print(jsonData);
    CouponListResponse mediaList = CouponListResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<ProductListResponse> fetchProductList(
      String value, GetProductsRequest getProductRequest) async {
    print(getProductRequest);
    dynamic response = await service.postResponse(value, getProductRequest);
    final jsonData = response;
    print(jsonData);
    ProductListResponse mediaList = ProductListResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<GlobalSearchResponse> fetchGlobalSearchResults(
      String value, GlobalSearchRequest globalSearchRequest) async {
    print(globalSearchRequest);
    dynamic response = await service.postResponse(value, globalSearchRequest);
    final jsonData = response;
    print(jsonData);

    GlobalSearchResponse mediaList = GlobalSearchResponse.fromJson(jsonData);

    return mediaList;
  }

  Future<VendorSearchResponse> fetchVendorSearchResults(
      String value, VendorSearchRequest searchRequest) async {
    print(searchRequest);
    dynamic response = await service.postResponse(value, searchRequest);
    final jsonData = response;
    print(jsonData);

    VendorSearchResponse mediaList = VendorSearchResponse.fromJson(jsonData);

    return mediaList;
  }

  Future<CouponDetailsResponse> fetchCouponDetails(
      String value, GetCouponDetailsRequest getCouponDetailsRequest) async {
    print(getCouponDetailsRequest);
    dynamic response =
        await service.postResponse(value, getCouponDetailsRequest);
    final jsonData = response;
    print(jsonData);
    CouponDetailsResponse mediaList = CouponDetailsResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<CreateOrderResponse> placeOrder(
      String value, CreateOrderRequest createOrderRequest) async {
    print(createOrderRequest);
    dynamic response = await service.postResponse(value, createOrderRequest);
    final jsonData = response;
    print(jsonData);
    CreateOrderResponse mediaList = CreateOrderResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<CreateOtpChangePassResponse> CreateOtpChangePass(String value,
      CreateOtpChangePassRequest createOtpChangePassRequest) async {
    print(createOtpChangePassRequest);
    dynamic response =
        await service.postResponse(value, createOtpChangePassRequest);

    final jsonData = response;
    print(jsonData);
    CreateOtpChangePassResponse mediaList =
        CreateOtpChangePassResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<SignUpInitializeResponse> VerifyOtpChangePass(
      String value, VerifyOtChangePassRequest verifyOtChangePassRequest) async {
    print(verifyOtChangePassRequest);
    dynamic response =
        await service.postResponse(value, verifyOtChangePassRequest);

    final jsonData = response;
    print(jsonData);
    SignUpInitializeResponse mediaList =
        SignUpInitializeResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<GetHistoryResponse> getHistoryData(
      String value, GetHistoryRequest getHistoryRequest) async {
    print(getHistoryRequest);
    dynamic response = await service.postResponse(value, getHistoryRequest);

    final jsonData = response;
    print(jsonData);
    GetHistoryResponse mediaList = GetHistoryResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<ProfileResponse> deleteProfile(
      String value, DeleteProfileRequest deleteProfileRequest) async {
    dynamic response =
        await service.deleteResponse(value, deleteProfileRequest);
    final jsonData = response;
    print(jsonData);
    ProfileResponse mediaList = ProfileResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<StoreSettingResponse> fetchStoreSettingData(String value) async {
    dynamic response = await service.getResponse(value);

    final jsonData = response;
    print(jsonData);
    StoreSettingResponse mediaList = StoreSettingResponse.fromJson(jsonData);
    return mediaList;
  }

  Future<AppleTokenDetailsResponse> getApiTokenForApplePay(
      String value, String apiKey, EncryptedWallet applePayTokenRequest) async {
    dynamic response =
        await service.postCloverResponse(value, apiKey, applePayTokenRequest);

    final jsonData = response;
    print(" ${jsonData}");
    AppleTokenDetailsResponse mediaList =
        AppleTokenDetailsResponse.fromJson(jsonData);
    return mediaList;
  }
}
