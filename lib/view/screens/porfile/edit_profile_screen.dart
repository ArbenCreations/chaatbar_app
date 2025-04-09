import 'package:TheChaatBar/model/database/ChaatBarDatabase.dart';
import 'package:TheChaatBar/model/request/editProfileRequest.dart';
import 'package:TheChaatBar/model/response/couponListResponse.dart';
import 'package:TheChaatBar/view/component/toastMessage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../languageSection/Languages.dart';
import '../../../../model/apis/apiResponse.dart';
import '../../../../model/response/profileResponse.dart';
import '../../../../model/viewModel/mainViewModel.dart';
import '../../../../theme/CustomAppColor.dart';
import '../../../../utils/Helper.dart';
import '../../../../utils/Util.dart';
import '../../../model/request/deleteProfileRequest.dart';
import '../../component/connectivity_service.dart';
import '../../component/custom_button_component.dart';
import '../../component/custom_circular_progress.dart';
import '../../component/session_expired_dialog.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen();

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool isLoading = false;
  bool isInternetConnected = true;
  bool isDarkMode = false;
  bool editProfile = false;
  late double mediaWidth;
  late double screenHeight;
  String? userId = "";
  String? firstName = "";
  String? lastName = "";
  String? phoneNo = "";
  String? email = "";
  String? imageUrl = "";
  String active = "0";
  String completed = "0";
  String favorites = "0";
  static const maxDuration = Duration(seconds: 2);
  bool isDataLoading = false;
  late ChaatBarDatabase database;
  var _connectivityService = ConnectivityService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? theme = "";
  String? vendorId = "";
  Color primaryColor = AppColor.Secondary;
  Color? secondaryColor = Colors.red[100];
  Color? lightColor = Colors.red[50];

  final GlobalKey _buttonKey = GlobalKey();
  bool mExpanded = false;
  String mSelectedText = "";
  final List<String> themeType = ["Light", "Dark", "Default"];
  String selectedValue = "";

  @override
  void initState() {
    super.initState();
    Helper.getVendorDetails().then((onValue) {
      print("theme : $onValue");
      setState(() {
        theme = onValue?.theme;
        vendorId = "${onValue?.id}";
        //setThemeColor();
      });
    });

    Helper.getAppThemeMode().then((appTheme) {
      setState(() {
        //print("App theme $appTheme");
        selectedValue = "$appTheme" != "null" ? "$appTheme" : themeType.first;
      });
    });
    $FloorChaatBarDatabase
        .databaseBuilder('basic_structure_database.db')
        .build()
        .then((value) async {
      this.database = value;
    });
    isDataLoading = true;
    _fetchDataFromPref();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    mediaWidth = MediaQuery.of(context).size.width;
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.BackgroundColor,
          title: Text(
            "Edit Profile",
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        body: Container(
          height: screenHeight,
          decoration: BoxDecoration(),
          child: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20), // Add padding
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      Image.asset(
                        "assets/appLogo.png",
                        height: screenHeight / 5,
                        width: mediaWidth / 2.5,
                      ),
                      SizedBox(height: 20),
                      _buildTextInputField(
                        label: "First Name",
                        controller: _nameController,
                        icon: Icons.person,
                        isClickable: true
                      ),
                      SizedBox(height: 12),
                      _buildTextInputField(
                        label: "Last Name",
                        controller: _lastNameController,
                        icon: Icons.person_outline,
                          isClickable: true
                      ),
                      SizedBox(height: 12),
                      _buildTextInputField(
                        label: "Email",
                        controller: _emailController,
                        icon: Icons.mail_outline,
                        keyboardType: TextInputType.emailAddress,
                          isClickable: false
                      ),
                      SizedBox(height: 35),
                      Container(
                        width: mediaWidth * 0.45,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(vertical: 13)),
                            backgroundColor:
                                MaterialStateProperty.all(AppColor.Primary),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            )),
                          ),
                          child: Text(
                            "Save Changes",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          onPressed: () {
                            setState(() {
                              editProfile = true;
                            });
                            _saveChanges();
                          },
                        ),
                      ),
                      email !=
                          "guest@isekaitech.com" ?
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: mediaWidth * 0.45,
                          margin: EdgeInsets.only(top: 5),
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor:
                              WidgetStateProperty.all(Colors.red),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(vertical: 13)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  )),
                            ),
                            onPressed: () async {
                              _deleteAccount();
                            },
                            child: Text(
                              Languages.of(context)!.labelDeleteAccount,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ): SizedBox(),
                    ],
                  ),
                ),
                isLoading
                    ? Stack(
                  children: [
                    // Block interaction
                    ModalBarrier(
                        dismissible: false, color: Colors.transparent),
                    // Loader indicator
                    Center(
                      child: CustomCircularProgress(),
                    ),
                  ],
                )
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextInputField(
      {required String label,
      required TextEditingController controller,
      required IconData icon,
      TextInputType keyboardType = TextInputType.text,
      required bool isClickable}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, 4))
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(fontSize: 14),
        enabled: isClickable,
        decoration: InputDecoration(
          icon: Icon(icon, color: AppColor.Secondary, size: 18,),
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey, fontSize: 13),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Future<void> _fetchData() async {
    bool isConnected = await _connectivityService.isConnected();
    print(("isConnected - ${isConnected}"));
    if (!isConnected) {
      setState(() {
        isLoading = false;
        isInternetConnected = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(Languages.of(context)!.labelNoInternetConnection),
            duration: maxDuration,
          ),
        );
      });
    } else {
      hideKeyBoard();
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        await Future.delayed(Duration(milliseconds: 2));
        await Provider.of<MainViewModel>(context, listen: false)
            .fetchProfile("/api/v1/app/customers/$vendorId/get_profile");
        ApiResponse apiResponse =
            Provider.of<MainViewModel>(context, listen: false).response;
        getProfileResponse(context, apiResponse);
      }
    }
  }

  Future<void> _saveChanges() async {
    bool isConnected = await _connectivityService.isConnected();
    hideKeyBoard();
    print(("isConnected - ${isConnected}"));
    if (mounted) {
      setState(() {
        isLoading = true;
      });
      if (!isConnected) {
        setState(() {
          isLoading = false;
          isInternetConnected = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(Languages.of(context)!.labelNoInternetConnection),
              duration: maxDuration,
            ),
          );
        });
      } else {
        EditProfileRequest request = EditProfileRequest(
            email: _emailController.text,
            firstName: _nameController.text,
            lastName: _lastNameController.text);
        await Future.delayed(Duration(milliseconds: 2));
        await Provider.of<MainViewModel>(context, listen: false).editProfile(
            "/api/v1/app/customers/$userId/update_profile", request);
        ApiResponse apiResponse =
            Provider.of<MainViewModel>(context, listen: false).response;
        getProfileResponse(context, apiResponse);
      }
    }
  }

  Future<Widget> getProfileResponse(
      BuildContext context, ApiResponse apiResponse) async {
    ProfileResponse? mediaList = apiResponse.data as ProfileResponse?;
    print("apiResponse${apiResponse.status}");
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        await Helper.saveProfileDetails(mediaList);
        print("${mediaList?.completedOrders}");
        if (editProfile) {
          Navigator.of(context).pushReplacementNamed("/BottomNavigation");
          CustomToast.showToast(
              context: context, message: "${apiResponse.message}");
        }

        _fetchDataFromPref();

        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        // _fetchDataFromPref();
        print("Message : ${apiResponse.message}");
        if (nonCapitalizeString("${apiResponse.message}") ==
            nonCapitalizeString(
                "${Languages.of(context)?.labelInvalidAccessToken}")) {
          SessionExpiredDialog.showDialogBox(context: context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Something went wrong.'),
              duration: maxDuration,
            ),
          );
        }
        print(apiResponse.message);
        return Center(
          child: Text('Please try again later!!!'),
        );
      case Status.INITIAL:
      default:
        return Center(
          child: Text(''),
        );
    }
  }

  void _fetchDataFromPref() async {
    await Future.delayed(Duration(milliseconds: 2));
    Helper.getProfileDetails().then((profile) {
      setState(() {
        isLoading = false;
        print("$firstName");
        firstName = "${profile?.firstName}";

        userId = "${profile?.id}";
        lastName = "${profile?.lastName}";
        phoneNo = "${profile?.phoneNumber}";
        email = "${profile?.email}";
        _nameController.text = firstName.toString();
        _lastNameController.text = lastName.toString();
        _emailController.text = email.toString();
        active = "${profile?.activeOrders ?? 0}";
        completed = "${profile?.completedOrders ?? 0}";
        favorites = "${profile?.favorites ?? 0}";
        print("profileResponse?.favorites :: ${profile?.favorites}");
        //isUsernameRetrieved = true;
      });
    });
  }

  void setThemeColor() {
    if (theme == "blue") {
      setState(() {
        primaryColor = Colors.blue.shade900;
        secondaryColor = Colors.blue[100];
        lightColor = Colors.blue[50];
      });
    }
  }

  Future<void> _deleteAccount() async {
    hideKeyBoard();
    //_showLogOutDialog();
    _showModal(context);
  }

  void _showModal(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
        TextEditingController phoneController = TextEditingController();
        bool passwordVisible = false;
        bool isLoading = false;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 10),
              title: Text(
                "Please enter your password for confirmation to delete account",
                style: TextStyle(fontSize: 12),
              ),
              content: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Email : ${_emailController.text}",
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: isDarkMode
                            ? AppColor.CardDarkColor
                            : Colors.white,
                        border: Border.all(color: Colors.grey, width: 0.5),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              style: TextStyle(fontSize: 11.0),
                              obscureText: !passwordVisible,
                              obscuringCharacter: "*",
                              controller: phoneController,
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 16.0),
                                hintText: Languages.of(context)!.labelPassword,
                                hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                                icon: Icon(
                                  Icons.password,
                                  size: 16,
                                  color: isDarkMode ? Colors.white : Colors.black,
                                ),
                                suffixIcon: GestureDetector(
                                  child: Icon(
                                    passwordVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    size: 20,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      passwordVisible = !passwordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isLoading)
                      Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  ],
                ),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: <Widget>[
                CustomButtonComponent(
                  text: "Delete",
                  mediaWidth: MediaQuery.of(context).size.width * 0.6,
                  textColor: Colors.white,
                  buttonColor: Colors.red,
                  isDarkMode: isDarkMode,
                  verticalPadding: 10,
                  onTap: () async {
                    hideKeyBoard();
                    bool isConnected = await _connectivityService.isConnected();

                    if (phoneController.text.isEmpty) {
                      CustomToast.showToast(
                          context: context, message: "Please enter password");
                    } else {
                      setState(() => isLoading = true);

                      if (!isConnected) {
                        setState(() {
                          isLoading = false;
                          isInternetConnected = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(Languages.of(context)!.labelNoInternetConnection),
                            duration: maxDuration,
                          ),
                        );
                      } else {
                        DeleteProfileRequest request = DeleteProfileRequest(
                          email: _emailController.text,
                          password: phoneController.text,
                        );

                        await Future.delayed(Duration(milliseconds: 2));
                        await Provider.of<MainViewModel>(context, listen: false)
                            .deleteProfile("/api/v1/app/customers/verify_and_destroy", request);

                        ApiResponse apiResponse =
                            Provider.of<MainViewModel>(context, listen: false).response;
                        deleteProfileResponse(context, apiResponse);

                        setState(() => isLoading = false);
                      }
                    }
                  },
                )
              ],
            );
          },
        );
      },
    );
  }

  Future<Widget> deleteProfileResponse(
      BuildContext context, ApiResponse apiResponse) async {
    ProfileResponse? mediaList = apiResponse.data as ProfileResponse?;
    print("apiResponse${mediaList?.message}");
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        CustomToast.showToast(
            context: context, message: "${mediaList?.message}");

        hideKeyBoard();
        Helper.clearAllSharedPreferencesForLogout();
        database.favoritesDao.clearAllFavoritesProduct();
        database.cartDao.clearAllCartProduct();
        database.categoryDao.clearAllCategories();
        database.productDao.clearAllProducts();
        database.cartDao.clearAllCartProduct();
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/LoginScreen',
              (Route<dynamic> route) => false,
        );
        return Container(); //Return an empty container as you'll navigate away
      case Status.ERROR:
        Navigator.pop(context);
        _fetchDataFromPref();
        print("Message : ${apiResponse.message}");
        if (nonCapitalizeString("${apiResponse.message}") ==
            nonCapitalizeString(
                "${Languages.of(context)?.labelInvalidAccessToken}")) {
          SessionExpiredDialog.showDialogBox(context: context);
        } else {
          CustomToast.showToast(context: context, message: apiResponse.message);
        }
        print(apiResponse.message);
        return Center(
          child: Text('Please try again later!!!'),
        );
      case Status.INITIAL:
      default:
        return Center(
          child: Text(''),
        );
    }
  }

  Widget _buildNameInput(BuildContext context, String text,
      TextEditingController nameController, Icon icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.0),
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextField(
        style: TextStyle(
          fontSize: 12.0,
        ),
        obscureText: false,
        obscuringCharacter: "*",
        controller: nameController,
        onChanged: (value) {
          //_isValidInput();
        },
        onSubmitted: (value) {},
        keyboardType: TextInputType.visiblePassword,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 0.5, color: Colors.grey)),
          border: OutlineInputBorder(
              borderSide: BorderSide(width: 0.5, color: AppColor.Primary)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: AppColor.Primary)),
          hintText: text,
          labelText: "$text",
          labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
          hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
          //icon: icon,
        ),
      ),
    );
  }

  void openBottomSheet(BuildContext context,
      List<PrivateCouponDetailsResponse>? couponsResponse) {
    showModalBottomSheet(
      context: context,
      shape: Border(),
      scrollControlDisabledMaxHeightRatio: 0.85,
      isScrollControlled: false,
      // Allows draggable sheet
      builder: (context) {
        return Container(
          child: ListView.builder(
            itemCount: couponsResponse?.length,
            padding: EdgeInsets.only(bottom: 10),
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => {Navigator.of(context).pop()},
                    child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: ShapeDecoration(
                                color: AppColor.Primary,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)))),
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            child: Text(
                              "Close",
                              style: TextStyle(color: Colors.white),
                            ))),
                  ),
                  Text("Coupons",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 10,
                  ),
                  appliedCouponWidget(couponsResponse![index]),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    width: mediaWidth * 0.5,
                    color: isDarkMode ? Colors.white : Colors.transparent,
                    height: 0.4,
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget appliedCouponWidget(PrivateCouponDetailsResponse couponsResponse) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppColor.CardDarkColor : Colors.blue[50],
      ),
      padding: EdgeInsets.only(left: 10, right: 0, top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: AppColor.Secondary),
              padding: EdgeInsets.all(5),
              child: Icon(
                Icons.discount,
                color: Colors.white,
                size: 18,
              )),
          SizedBox(
            width: 15,
          ),
          Container(
            width: mediaWidth * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Expire At => ${convertDateTimeFormat("${couponsResponse?.expireAt?.toString().toUpperCase()}")}",
                  style: TextStyle(fontSize: 11),
                ),
                SizedBox(
                  height: 2,
                ),
                Text("Code : ${couponsResponse?.couponCode?.toUpperCase()}",
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 2,
                ),
                Text("${couponsResponse?.description?.toUpperCase()}",
                    style:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.normal)),
                SizedBox(
                  height: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        "Min Amt. : \$${couponsResponse.minCartAmt?.toUpperCase()}",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.normal)),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                        "Max Amt. : \$${couponsResponse.maxDiscountAmt?.toUpperCase()}",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.normal))
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text("You can use coupon code to apply.",
                      style: TextStyle(
                          fontSize: 10, fontWeight: FontWeight.normal)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
