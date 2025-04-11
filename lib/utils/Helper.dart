import 'dart:convert';
import 'dart:io';

import 'package:TheChaatBar/model/response/vendorListResponse.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/response/profileResponse.dart';

class Helper {
  static String valueSharedPreferences = '';
  static String vendorDetailPref = 'VendorDetail';
  static String vendor_theme = 'vendorTheme';
  static String api_key = 'apikey';
  static String app_id = 'appId';
  static String pref_token = 'token';
  static String pref_device_token = 'device_token';
  static String biometricPref = 'biometricPref';
  static String isAuthenticatedPref = 'isAuthenticatedPref';
  static String userBalancePref = 'UserBalance';
  static String userId = 'UserId';
  static String currencySymbolPref = 'CurrencySymbol';
  static String userDetailsPref = 'UserDetails';
  static String countryPref = 'Country';
  static String addressPref = 'Address';
  static String kycStatusPref = 'KycStatus';
  static String passwordPref = 'Password';
  static String recentP2PPref = 'RecentP2P';
  static String countryList = 'CountryList';
  static String profileDetailPref = 'ProfileDetail';
  static const String prefSelectedLanguageCode = "SelectedLanguageCode";
  static const String prefRecentDocument = "RecentDocument";
  static String appThemePref = 'appThemePref';

// Write DATA
  static Future<bool> saveUserToken(token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(pref_token, token);
  }

  // Read Data
  static Future<String?> getUserToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(pref_token);
  }

// Write DATA
  static Future<bool> saveFirebaseToken(token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(pref_device_token, token);
  }

  // Read Data
  static Future<String?> getFirebaseToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(pref_device_token);
  }

  static Future<bool> saveVendorData(_VendorDetail) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String VendorDetailJson = jsonEncode(_VendorDetail.toJson());
    return await sharedPreferences.setString(
        vendorDetailPref, VendorDetailJson);
  }

  static Future<VendorData?> getVendorDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? VendorDetailJson =
    sharedPreferences.getString(vendorDetailPref);

    if (VendorDetailJson == null) {
      return null;
    }
    final Map<String, dynamic> VendorDetailMap = jsonDecode(VendorDetailJson);
    return VendorData.fromPref(VendorDetailMap);
  }

  static Future<bool> saveVendorTheme(token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(vendor_theme, token);
  }

  // Read Data
  static Future<String?> getVendorTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(vendor_theme);
  }


  static Future<bool> saveApiKey(token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(api_key, token);
  }

  // Read Data
  static Future<String?> getApiKey() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(api_key);
  }


  static Future<bool> saveAppId(token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(app_id, token);
  }

  // Read Data
  static Future<String?> getAppId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(app_id);
  }


  // Write DATA
  static Future<bool> saveBiometric(isEnable) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setBool(biometricPref, isEnable);
  }

  // Read Data
  static Future<bool?> getBiometric() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(biometricPref);
  }

  // Write DATA
  static Future<bool> saveUserAuthenticated(isAuthenticated) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setBool(isAuthenticatedPref, isAuthenticated);
  }

  // Read Data
  static Future<bool?> getUserAuthenticated() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(isAuthenticatedPref);
  }

  static Future<bool> savePassword(token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(passwordPref, token);
  }

  // Read Data
  static Future<String?> getPassword() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(passwordPref);
  }


  static Future<bool> saveUserId(token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(userId, token);
  }

  // Read Data
  static Future<String?> getUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(userId);
  }


// Read Data
  static Future<ProfileResponse?> getProfileDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? ProfileDetailJson =
    sharedPreferences.getString(profileDetailPref);

    if (ProfileDetailJson == null) {
      return null;
    }
    final Map<String, dynamic> ProfileDetailMap = jsonDecode(ProfileDetailJson);
    return ProfileResponse.fromPref(ProfileDetailMap);
  }

  static Future<bool> saveProfileDetails(_ProfileDetail) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String ProfileDetailJson = jsonEncode(_ProfileDetail.toJson());
    return await sharedPreferences.setString(
        profileDetailPref, ProfileDetailJson);
  }

// Read Data

  static Future<Locale> setLocale(_languageCode) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(prefSelectedLanguageCode, _languageCode);
    return _locale(_languageCode);
  }

  static Future<Locale> getLocale() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String languageCode = _prefs.getString(prefSelectedLanguageCode) ?? "en";
    return _locale(languageCode);
  }

  static Future<bool> saveCountry(token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(countryPref, token);
  }

  // Read Data
  static Future<String?> getCountry() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(countryPref);
  }

  static Future<bool> saveAddress(token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(addressPref, token);
  }

  // Read Data
  static Future<String?> getAddress() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(addressPref);
  }

  static Future<bool> saveKycStatus(token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(kycStatusPref, token);
  }

  // Recent Document Read Data
 /* static Future<DocumentDetail?> getRecentDocument() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? recentDocumentJson = sharedPreferences.getString(prefRecentDocument);

    if (recentDocumentJson == null) {
      return null;
    }
    final Map<String, dynamic> recentDocumentMap = jsonDecode(recentDocumentJson);
    return DocumentDetail.fromJson(recentDocumentMap);
  }*/

  static Locale _locale(String languageCode) {
    return languageCode != null && languageCode.isNotEmpty
        ? Locale(languageCode, '')
        : Locale('en', '');
  }

  static void changeLanguage(
      BuildContext context, String selectedLanguageCode) async {
    var _locale = await setLocale(selectedLanguageCode);
    //_MyAPp.setLocale(context, _locale);
  }

  static Future<bool> saveAppThemeMode(appTheme) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(appThemePref, appTheme);
  }

  // Read Data
  static Future<String?> getAppThemeMode() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(appThemePref);
  }

  static Future<void> clearAllSharedPreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //await prefs.clear();
    await sharedPreferences.remove(pref_token);
    await saveVendorData(VendorData());
    await saveProfileDetails(ProfileResponse());
    await saveBiometric(false);
    //await saveUserDetails(null);
    await saveCountry("");
    await saveKycStatus("");
    await setLocale("");
    print('All shared preferences cleared');
  }

  static Future<void> clearAllSharedPreferencesForLogout() async {
    final prefs = await SharedPreferences.getInstance();
    //await prefs.clear();
    await saveVendorData(VendorData());
    await saveBiometric(false);
    await setLocale("");
    print('All shared preferences cleared');
  }


}
