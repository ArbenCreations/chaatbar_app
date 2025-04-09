import 'package:TheChaatBar/languageSection/Languages.dart';
import 'package:TheChaatBar/model/response/locationListResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../model/apis/apiResponse.dart';
import '../../model/response/vendorListResponse.dart';
import '../../model/viewModel/mainViewModel.dart';
import '../../theme/CustomAppColor.dart';
import '../../utils/Helper.dart';
import '../../utils/Util.dart';
import '../component/connectivity_service.dart';
import '../component/toastMessage.dart';

class VendorsListScreen extends StatefulWidget {
  VendorsListScreen({Key? key}) : super(key: key);

  @override
  _VendorsListScreenState createState() => _VendorsListScreenState();
}

class _VendorsListScreenState extends State<VendorsListScreen> {
  int franchiseId = 1;
  late double screenWidth;
  late double screenHeight;
  bool isLoading = false;
  bool isDarkMode = false;
  var _connectivityService = ConnectivityService();
  static const maxDuration = Duration(seconds: 2);
  List<LocationData> locationList = [];
  List<VendorData> vendorList = [];
  String selectedLocality = "";
  String token = "";
  VendorData selectedLocalityData = VendorData();
  var placeholderImage =
      'https://upload.wikimedia.org/wikipedia/commons/c/cd/Portrait_Placeholder_Square.png';
  String? selectedItem;
  List<String> items = List<String>.generate(10, (index) => "Item $index");

  @override
  void initState() {
    super.initState();
    Helper.getUserToken().then((profile) {
      setState(() {
        token = "${profile ?? ""}";
        Helper.saveUserToken(token);
      });
    });
    getStoresList();
  }

  @override
  Widget build(BuildContext context) {
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    DateTime? lastBackPressed;
    return PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          print("DashBoard $didPop");
          if (didPop) return;

          final now = DateTime.now();
          const maxDuration = Duration(seconds: 2);
          final isWarning = lastBackPressed == null ||
              now.difference(lastBackPressed!) > maxDuration;

          if (isWarning) {
            lastBackPressed = DateTime.now();
            CustomToast.showToast(
                message: "Press back again to exit", context: context);
          } else {
            SystemNavigator.pop();
          }
        },
        child: Scaffold(
          body: Container(
            height: screenHeight,
            width: screenWidth,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/map_screen.png"),
                fit: BoxFit.cover,
                opacity: 0.6,
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Navigation Bar Replacement
                    _buildHeaderText(), // Header Text

                    isLoading
                        ? Column(
                            children: List.generate(
                                2,
                                (index) =>
                                    _buildShimmerCard()), // Show 5 shimmer placeholders
                          )
                        : Column(
                            children: vendorList.map((item) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedLocality = selectedLocality.isEmpty
                                        ? "${item.localityName}"
                                        : "";
                                    selectedLocalityData = item;
                                  });

                                  //Navigator.pushReplacementNamed(context, "/BottomNavigation");

                                  if (selectedLocality.isNotEmpty &&
                                          selectedLocalityData.status
                                                  ?.contains("online") ==
                                              true ||
                                      selectedLocalityData.status
                                              ?.contains("offline") ==
                                          true) {
                                    Helper.saveVendorData(selectedLocalityData);
                                    Helper.saveApiKey(selectedLocalityData
                                        .paymentSetting?.apiKey);
                                    Navigator.pushReplacementNamed(
                                        context, "/BottomNavigation");
                                  } else if (selectedLocalityData.status
                                          ?.contains("offline") ==
                                      true) {
                                    CustomToast.showToast(
                                        context: context,
                                        message:
                                            "This store is closed at the moment.");
                                  } else {
                                    CustomToast.showToast(
                                        context: context,
                                        message: "Select location.");
                                  }
                                },
                                child: _buildVendorCard(
                                    item), // Extracted vendor card widget
                              );
                            }).toList(),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  /// Shimmer Placeholder Card
  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        height: screenHeight * 0.17,
        width: screenWidth * 0.85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  /// Vendor Card
  Widget _buildVendorCard(item) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Container(
              height: screenHeight * 0.15,
              width: screenWidth * 0.85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: item.storeImage!.isNotEmpty
                    ? Image.network(
                        item.storeImage ?? placeholderImage,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(color: Colors.black54);
                        },
                      )
                    : Image.asset("assets/vendorLoc.png", fit: BoxFit.fitWidth),
              ),
            ),
            Container(
              height: screenHeight * 0.15,
              width: screenWidth * 0.85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  colors: (item.localityName == selectedLocality)
                      ? [AppColor.Primary, AppColor.Primary.withOpacity(0.4)]
                      : [Colors.black54, Colors.black54, Colors.black54],
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 220,
                          child: Text(
                            capitalizeFirstLetter("${item.businessName}"),
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              overflow: TextOverflow.fade,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              capitalizeFirstLetter("${item.localityName}"),
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          capitalizeFirstLetter("${item.description}"),
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  item.status?.contains("online") == true
                      ? _buildStatusBadge("Open", Colors.green)
                      : _buildStatusBadge("Close", Colors.red),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Status Badge Widget
  Widget _buildStatusBadge(String status, Color color) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: EdgeInsets.only(bottom: 10, right: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30), color: color),
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
        child: Row(
          children: [
            Icon(Icons.store_mall_directory, color: Colors.white, size: 16),
            SizedBox(width: 4),
            Text(status,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderText() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(6.0),
          margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.3),
                offset: Offset(0, 10),
                blurRadius: 10,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Image.asset(
            "assets/appLogo.png",
            height: 50,
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  void getStoresList() async {
    setState(() {
      isLoading = true;
    });

    bool isConnected = await _connectivityService.isConnected();
    if (!isConnected) {
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('${Languages.of(context)?.labelNoInternetConnection}'),
            duration: maxDuration,
          ),
        );
      });
    } else {
      await Future.delayed(Duration(milliseconds: 2));
      await Provider.of<MainViewModel>(context, listen: false)
          .fetchVendors("/api/v1/vendors/${franchiseId}/get_stores");
      ApiResponse apiResponse =
          Provider.of<MainViewModel>(context, listen: false).response;
      getStoreList(context, apiResponse);
    }
  }

  Widget getStoreList(BuildContext context, ApiResponse apiResponse) {
    VendorListResponse? vendorListResponse =
        apiResponse.data as VendorListResponse?;
    var message = apiResponse.message.toString();
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        setState(() {
          vendorList = vendorListResponse!.vendors!;
        });
        //CustomToast.showToast(context: context, message: "$token");
        return Container();
      case Status.ERROR:
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
}
