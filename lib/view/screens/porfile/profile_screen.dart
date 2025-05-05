import 'package:TheChaatBar/model/database/ChaatBarDatabase.dart';
import 'package:TheChaatBar/model/request/editProfileRequest.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../languageSection/Languages.dart';
import '../../../model/apis/apiResponse.dart';
import '../../../model/database/DatabaseHelper.dart';
import '../../../model/response/profileResponse.dart';
import '../../../model/viewModel/mainViewModel.dart';
import '../../../theme/CustomAppColor.dart';
import '../../../utils/Helper.dart';
import '../../../utils/Util.dart';
import '../../component/CustomAlert.dart';
import '../../component/connectivity_service.dart';
import '../../component/custom_circular_progress.dart';
import '../../component/session_expired_dialog.dart';

class ProfileScreen extends StatefulWidget {
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
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
    initializeDatabase();
    Helper.getProfileDetails().then((onValue) {
      setState(() {
        customerId = int.parse("${onValue?.id ?? 0}");
      });
    });

    Helper.getVendorDetails().then((onValue) {
      setState(() {
        vendorId = "${onValue?.id}";
        _url = Uri.parse("https://www.thechaatbar.ca/");
      });
    });

    Helper.getAppThemeMode().then((appTheme) {
      setState(() {
        selectedValue = "$appTheme" != "null" ? "$appTheme" : themeType.first;
      });
    });

    firstName = "";
    lastName = "";
    email = "";
    isDataLoading = true;
    _fetchDataFromPref();
  }

  Future<void> _loadAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = '${info.version} (${info.buildNumber})';
    });
  }

  Future<void> initializeDatabase() async {
    database = await DatabaseHelper().database;
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  final maskFormatter = MaskTextInputFormatter(
    mask: '(###) ###-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

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
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Card
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      shadowColor: Colors.black12,
                      semanticContainer: true,
                      borderOnForeground: true,
                      elevation: 1,
                      child: Padding(
                        padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.red.shade100,
                              child: Text(
                                (firstName?.substring(0, 1) ?? '')
                                    .toUpperCase(),
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${firstName ?? ""} ${lastName ?? ""}"
                                        .trim()
                                        .toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(Icons.email,
                                          size: 16, color: Colors.grey),
                                      SizedBox(width: 6),
                                      Expanded(
                                        child: Text(email ?? "",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey[800]),
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ],
                                  ),
                                  if (phoneNo != null && phoneNo != "null") ...[
                                    SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Icon(Icons.phone,
                                            size: 16, color: Colors.grey),
                                        SizedBox(width: 6),
                                        Text(
                                            "+1 ${maskFormatter.maskText(phoneNo!)}",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey[800])),
                                      ],
                                    ),
                                  ],
                                  SizedBox(height: 10),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: GestureDetector(
                                      onTap: _launchUrl,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade50,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.open_in_new,
                                                color: Colors.black, size: 14),
                                            SizedBox(width: 4),
                                            Text("Explore",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 5),

                    // Divider
                    Divider(thickness: 1, color: Colors.grey.shade300),
                    SizedBox(height: 15),
                    // Active / Completed
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                      color: Colors.green.shade50,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                  context, "/ActiveOrdersScreen"),
                              child: _buildCount(active.toString(), "Active",
                                  isPrimary: true),
                            ),
                            VerticalDivider(
                                color: Colors.grey.shade300, thickness: 1),
                            _buildCount(completed.toString(), "Completed"),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    // Settings Items
                    _buildItem(
                        Icons.person_outline_rounded,
                        "Personal Information",
                        "Edit your profile",
                        "/EditProfileScreen"),
                    Divider(thickness: 1, color: Colors.black12),
                    _buildItem(Icons.card_giftcard_rounded, "Available Coupons",
                        "Click here to get exciting offers!", "/CouponsScreen"),
                    Divider(thickness: 1, color: Colors.black12),
                    _buildItem(Icons.logout, "Logout", "", "Logout"),

                    SizedBox(height: 24),
                  ],
                ),
              ),

              // App version
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Version $_appVersion',
                    style: TextStyle(color: Colors.grey[400], fontSize: 10),
                  ),
                ),
              ),

              // Loading overlay
              if (isLoading)
                Stack(
                  children: [
                    ModalBarrier(dismissible: false, color: Colors.transparent),
                    Center(child: CustomCircularProgress()),
                  ],
                ),
            ],
          ),
        ),
      ),

    );
  }

  Widget _buildItem(
      IconData icon, String title, String subtitle, String routeName) {
    return GestureDetector(
      onTap: () {
        if (routeName == "Logout") {
          if (!isLoading) _showLogOutDialog();
        } else {
          Navigator.pushNamed(context, routeName);
        }
      },
      child: Card(
        elevation: 0,
        color: AppColor.BackgroundColor,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 5),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Colors.green.shade700,
                  size: 20,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    if (subtitle.isNotEmpty) SizedBox(height: 4),
                    if (subtitle.isNotEmpty)
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: Colors.grey.shade500,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCount(String count, String label, {bool isPrimary = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isPrimary ? AppColor.Primary : Colors.black,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
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
          CustomAlert.showToast(
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 10,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              CircleAvatar(
                backgroundColor: Colors.red.shade50,
                radius: 30,
                child: Icon(Icons.logout, color: Colors.red, size: 30),
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                "Logout?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : AppColor.Primary,
                ),
              ),
              const SizedBox(height: 12),

              // Subtitle
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: "Are you sure you want to "),
                    TextSpan(
                      text: "log out",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    TextSpan(text: " from your account?"),
                  ],
                ),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 24),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => Center(child: CircularProgressIndicator()),
                        );
                        await Helper.clearAllSharedPreferences();
                        await database.favoritesDao.clearAllFavoritesProduct();
                        await database.cartDao.clearAllCartProduct();
                        await database.categoryDao.clearAllCategories();
                        await database.productDao.clearAllProducts();

                        Navigator.of(context)
                            .pushNamedAndRemoveUntil('/LoginScreen', (_) => false);
                      },
                      icon: Icon(Icons.exit_to_app, size: 18, color: Colors.white,),
                      label: Text("Yes, Logout"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancel"),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }


}
