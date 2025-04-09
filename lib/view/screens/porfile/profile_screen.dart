import 'package:TheChaatBar/model/database/ChaatBarDatabase.dart';
import 'package:TheChaatBar/model/request/editProfileRequest.dart';
import 'package:TheChaatBar/model/response/couponListResponse.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/apiResponse.dart';
import '../../../model/response/profileResponse.dart';
import '../../../model/viewModel/mainViewModel.dart';
import '../../../theme/CustomAppColor.dart';
import '../../../utils/Helper.dart';
import '../../../utils/Util.dart';
import '../../component/connectivity_service.dart';
import '../../component/custom_circular_progress.dart';
import '../../component/session_expired_dialog.dart';
import '../../component/toastMessage.dart';

class ProfileScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;

  ProfileScreen({required this.onThemeChanged});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
  int? customerId = 0;
  Color primaryColor = AppColor.Secondary;
  Color? secondaryColor = Colors.red[100];
  Color? lightColor = Colors.red[50];

  final GlobalKey _buttonKey = GlobalKey();
  bool mExpanded = false;
  String mSelectedText = "";
  final List<String> themeType = ["Light", "Dark", "Default"];
  String selectedValue = "";
  Uri _url = Uri.parse('');

  @override
  void initState() {
    super.initState();
    _fetchData();
    Helper.getProfileDetails().then((onValue) {
      setState(() {
        customerId = int.parse("${onValue?.id ?? 0}"); //?? VendorData();
      });
    });

    Helper.getVendorDetails().then((onValue) {
      print("theme : $onValue");
      setState(() {
        theme = onValue?.theme;
        vendorId = "${onValue?.id}";
        _url = Uri.parse("https://www.thechaatbar.ca/");
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
    firstName = "";
    lastName = "";
    email = "";
    isDataLoading = true;
    _fetchDataFromPref();
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
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
        Navigator.pushReplacementNamed(context, "/BottomNavigation");
      },
      child: Scaffold(
        backgroundColor: AppColor.BackgroundColor,
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: mediaWidth,
                          //height: screenHeight * 0.25,
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10, top: 10, bottom: 20),
                          margin: const EdgeInsets.only(
                              left: 10.0, right: 10, top: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                child: GestureDetector(
                                  onTap: () {
                                    _launchUrl();
                                  },
                                  child: IntrinsicWidth(
                                    child: Container(
                                      child: Text(
                                        "Explore",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 3),
                                      margin: EdgeInsets.only(bottom: 15),
                                      alignment: Alignment.topRight,
                                      decoration: BoxDecoration(
                                          color: Colors.red.shade50,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                    ),
                                  ),
                                ),
                                alignment: Alignment.topRight,
                              ),
                              Text(
                                "${firstName ?? ""} ${lastName ?? ""}"
                                    .toUpperCase(),
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.email,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    "${email ?? ""}",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Icon(
                                    Icons.phone_iphone,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    "${phoneNo ?? ""}",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 0.5,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10)),
                            margin: EdgeInsets.symmetric(horizontal: 20),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: mediaWidth * 0.9,
                            margin: EdgeInsets.only(top: 20),
                            child: Card(
                              elevation: 0,
                              color: AppColor.Primary.withOpacity(0.15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              shadowColor: Colors.black,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, "/ActiveOrdersScreen");
                                        },
                                        child:
                                            _buildCount("$active", "Active")),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    _buildCount("$completed", "Completed"),
                                    SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              _buildItem(
                                  Icons.edit_document,
                                  "Personal Information",
                                  "Edit your profile",
                                  "EditInformationScreen"),
                              SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                height: 0.2,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[600],
                                      borderRadius: BorderRadius.circular(10)),
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              _buildItem(
                                  Icons.card_giftcard_rounded,
                                  "Available Coupons",
                                  "Click here to get exciting offers!",
                                  ""),

                              //_buildItem(Icons.language,"Language","English",""),
                              // _buildTheme(),
                              SizedBox(
                                height: 0.2,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[600],
                                      borderRadius: BorderRadius.circular(10)),
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                ),
                              ),
                              /*_buildItem(Icons.contact_support_rounded,
                                  "Help & Support", "Help & Support", "")*/
                              /* _buildItem(Icons.perm_contact_cal_sharp,
                                  "Contact Us", "Contact Us", ""),*/
                              _buildItem(
                                  Icons.logout, "Logout", "", "LoginScreen"),
                              SizedBox(
                                height: 2,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        /* Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          shadowColor: Colors.black,
                          child: Column(
                            children: [
                              SizedBox(height: 2,),
                              SizedBox(height: 2,),
                            ],
                          ),
                        ),
                        SizedBox(height: 5,),
                        Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          shadowColor: Colors.black,
                          child: Column(
                            children: [
                              SizedBox(height: 2,),
                              SizedBox(height: 2,),
                            ],
                          ),
                        )*/
                      ],
                    ),
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
    );
  }

  Widget _buildLoadingIndicator() {
    return Stack(
      children: [
        ModalBarrier(dismissible: false, color: Colors.black.withOpacity(0.3)),
        Center(
            child: CircularProgressIndicator(
                color: isDarkMode ? Colors.white : Colors.deepOrange)),
      ],
    );
  }

  Widget _buildItem(
      IconData icon, String value, String detail, String navigation) {
    return GestureDetector(
      onTap: () {
        if (value == "Logout") {
          if (!isLoading) _showLogOutDialog();
        } else if (value == "Personal Information") {
          Navigator.pushNamed(context, "/EditProfileScreen");
        } else if (value == "Available Coupons") {
          Navigator.pushNamed(context, "/CouponsScreen");
        }
      },
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100)),
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  value != "Logout"
                      ? Text(
                          detail,
                          style:
                              TextStyle(fontSize: 10, color: Colors.grey[500]),
                        )
                      : SizedBox(),
                ],
              ),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 13,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCount(String count, String text) {
    return Column(
      children: [
        Text(
          "$count",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),
        ),
        Text(
          "$text",
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: Colors.grey[600]),
        )
      ],
    );
  }

  Future<void> _fetchData() async {
    bool isConnected = await _connectivityService.isConnected();
    print(("isConnected - ${isConnected}"));
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
      hideKeyBoard();
      setState(() {
        isLoading = true;
      });

      await Provider.of<MainViewModel>(context, listen: false)
          .fetchProfile("/api/v1/app/customers/$vendorId/get_profile");

      if (mounted) {
        ApiResponse apiResponse =
            Provider.of<MainViewModel>(context, listen: false).response;
        getProfileResponse(context, apiResponse);
      }
    }
  }

  Future<void> _saveChanges() async {
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
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        setState(() {
          isLoading = false;
        });
        await Helper.saveProfileDetails(mediaList);

        print("ApiResponse => ${mediaList?.completedOrders}");
        if (editProfile) {
          Navigator.pop(context);
          CustomToast.showToast(
              context: context, message: "${apiResponse.message}");
        }

        _fetchDataFromPref();

        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        // _fetchDataFromPref();
        setState(() {
          isLoading = false;
        });
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
    Helper.getProfileDetails().then((profile) {
      setState(() {
        print("$firstName");
        firstName = "${profile?.firstName ?? ""}";
        userId = "${profile?.id}";
        lastName = "${profile?.lastName ?? ""}";
        phoneNo = "${profile?.phoneNumber ?? ""}";
        email = "${profile?.email ?? ""}";

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

  Future<void> _showLogOutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20), // Adjust the radius as needed
          ),
          insetPadding: EdgeInsets.zero,
          elevation: 5,
          titleTextStyle: TextStyle(
              fontSize: 20,
              color: isDarkMode ? Colors.white : AppColor.Primary,
              fontWeight: FontWeight.bold),
          title: Center(
              child: Text(
            "Logout",
            style: TextStyle(fontSize: 20),
          )),
          content: IntrinsicHeight(
            child: Container(
              //height: screenHeight * 0.25,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                          child: Text(
                        "Are you sure you want to logout?",
                        textAlign: TextAlign.center,
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: mediaWidth * 0.33,
                        child: TextButton(
                          child: Text("Yes"),
                          onPressed: () {
                            Helper.clearAllSharedPreferences();
                            database.favoritesDao.clearAllFavoritesProduct();
                            database.cartDao.clearAllCartProduct();
                            database.categoryDao.clearAllCategories();
                            database.productDao.clearAllProducts();
                            database.cartDao.clearAllCartProduct();
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              '/LoginScreen',
                              (Route<dynamic> route) => false,
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: mediaWidth * 0.33,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.redAccent),
                          ),
                          child: Text("No"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[],
        );
      },
    );
  }

  Future<void> _showEditProfileDialog() async {
    _nameController.text = "$firstName";
    _lastNameController.text = "$lastName";
    _emailController.text = "$email";
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(10), // Adjust the radius as needed
          ),
          insetPadding: EdgeInsets.symmetric(horizontal: 28, vertical: 5),
          elevation: 5,
          icon: Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.close,
                    size: 20,
                  ))),
          iconPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          titleTextStyle: TextStyle(
              fontSize: 20,
              color: isDarkMode ? Colors.white : AppColor.Primary,
              fontWeight: FontWeight.bold),
          title: Center(
              child: Text(
            "Edit Profile",
          )),
          content: IntrinsicHeight(
            child: Container(
              //height: screenHeight * 0.25,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      _buildNameInput(
                          context,
                          Languages.of(context)!.labelName,
                          _nameController,
                          Icon(
                            Icons.person,
                            size: 18,
                            color: AppColor.Secondary,
                          )),
                      SizedBox(
                        height: 8,
                      ),
                      _buildNameInput(
                          context,
                          Languages.of(context)!.labelLastname,
                          _lastNameController,
                          Icon(
                            Icons.person,
                            size: 18,
                            color: AppColor.Secondary,
                          )),
                      SizedBox(
                        height: 8,
                      ),
                      _buildNameInput(
                          context,
                          Languages.of(context)!.labelEmail,
                          _emailController,
                          Icon(
                            Icons.mail,
                            size: 16,
                            color: AppColor.Secondary,
                          )),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        width: mediaWidth * 0.33,
                        child: TextButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(AppColor.Secondary)),
                          child: Text("Save"),
                          onPressed: () {
                            setState(() {
                              editProfile = true;
                            });
                            _saveChanges();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[],
        );
      },
    );
  }

  Widget _buildNameInput(BuildContext context, String text,
      TextEditingController nameController, Icon icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      margin: EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          SizedBox(width: 8),
          Container(
            width: mediaWidth * 0.65,
            padding: EdgeInsets.only(right: 4),
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
                    borderSide:
                        BorderSide(width: 0.5, color: AppColor.Primary)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: AppColor.Primary)),
                hintText: text,
                labelText: "$text",
                hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                //icon: icon,
              ),
            ),
          ),
        ],
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
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          // Optional padding for better spacing
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // Ensures the column takes only the required space
            children: [
              // Static "Close" button
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: ShapeDecoration(
                      color: AppColor.Primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    child: Text(
                      "Close",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),

              // Static text outside the list
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  "Coupons",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),

              // Divider line
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                color: isDarkMode ? Colors.white : Colors.transparent,
                height: 0.4,
              ),

              // List of coupons inside a SingleChildScrollView to prevent overflow
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        itemCount: couponsResponse?.length ?? 0,
                        // Make sure it's safe to access
                        shrinkWrap: true,
                        // Ensures ListView takes only as much space as needed
                        physics: NeverScrollableScrollPhysics(),
                        // Prevents scrolling conflicts with SingleChildScrollView
                        padding: EdgeInsets.only(bottom: 10),
                        itemBuilder: (context, index) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              appliedCouponWidget(couponsResponse![index]),
                              // Your existing widget
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                width: mediaWidth * 0.5,
                                color: isDarkMode
                                    ? Colors.white
                                    : Colors.transparent,
                                height: 0.4,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
            width: mediaWidth * 0.75,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*  Text(
                  "Expire At => ${convertDateTimeFormat("${couponsResponse?.expireAt?.toString().toUpperCase()}")}",
                  style: TextStyle(fontSize: 11),
                ),*/
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
