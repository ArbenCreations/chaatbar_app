import 'package:TheChaatBar/model/response/bannerListResponse.dart';
import 'package:TheChaatBar/model/response/vendorListResponse.dart';
import 'package:TheChaatBar/view/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../languageSection/Languages.dart';
import '../../model/apis/apiResponse.dart';
import '../../theme/CustomAppColor.dart';
import '../../utils/Helper.dart';
import '../../utils/Util.dart';
import '../../model/viewModel/mainViewModel.dart';
import '../component/connectivity_service.dart';
import '../component/promotion_offers_widget.dart';

class VendorScreen extends StatefulWidget {
  /* final LocationData? data; // Define the 'data' parameter here

  VendorScreen({Key? key, this.data}) : super(key: key);*/

  @override
  _VendorScreenState createState() => _VendorScreenState();
}

class _VendorScreenState extends State<VendorScreen>
    with SingleTickerProviderStateMixin {
  String token = "";
  int franchiseId = 1;
  late double mediaWidth;
  bool isInternetConnected = true;
  late bool isDarkMode;
  late double screenHeight;
  bool isLoading = false;
  var _connectivityService = ConnectivityService();
  static const maxDuration = Duration(seconds: 2);
  final ScrollController _scrollController = ScrollController();
  List<VendorData> vendorList = [];
  List<BannerData> bannerList = [];
  final TextEditingController queryController = TextEditingController();

  AnimationController? _animationController;
  Animation<Offset>? _animation;

  @override
  void initState() {
    super.initState();

    Helper.saveVendorData(VendorData());
    _fetchBannerData();
    _fetchData();
    /*setState(() {
      franchiseId = "eabe7a43-1cb4-4a2a-a091-2f862957bd1f";
    });*/
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = Tween<Offset>(begin: Offset(0, -1), end: Offset(0, 0)).animate(
        CurvedAnimation(
            parent: _animationController!, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  Widget getVendorList(BuildContext context, ApiResponse apiResponse) {
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
        print("rwrwr ${vendorListResponse?.vendors?[0].businessName}");

        // countryList = countryListResponse!.countries!;
        //Helper.saveCountryList(vendorList);
        //selectedItem = "${countryListResponse?.countries?[0].flagImageUrl}";
        setState(() {
          vendorList = vendorListResponse!.vendors!;
        });

        //_showPicker(context: context);

        return Container(); // Return an empty container as you'll navigate away
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

  Widget getBannerList(BuildContext context, ApiResponse apiResponse) {
    BannerListResponse? vendorListResponse =
        apiResponse.data as BannerListResponse?;
    var message = apiResponse.message.toString();
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("rwrwr ${vendorListResponse?.data?[0].title}");

        setState(() {
          bannerList = vendorListResponse!.data!;
        });

        return Container(); // Return an empty container as you'll navigate away
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

  @override
  Widget build(BuildContext context) {
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    mediaWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(children: [
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/appLogo.png",
                              height: 50,
                            ),
                          ],
                        ),
                        // Row(
                        //   children: [
                        //     GestureDetector(
                        //       onTap: () {
                        //         queryController.text = "";
                        //         _showTopSheet();
                        //       },
                        //       child: Padding(
                        //         padding: const EdgeInsets.symmetric(
                        //             horizontal: 8.0),
                        //         child: Icon(Icons.search),
                        //       ),
                        //     ),
                        //   ],
                        // )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: BannerListWidget(
                      data: bannerList,
                      isInternetConnected: isInternetConnected,
                      isLoading: isLoading,
                      isDarkMode: isDarkMode),
                ),
                Container(
                  height: screenHeight * 0.65,
                  //constraints: BoxConstraints(maxHeight: 1, minHeight: 1),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _scrollController,
                    itemCount: vendorList.length,
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(bottom: 0),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                          onTap: () {
                            Helper.saveVendorData(vendorList[index]);
                            vendorList[index].theme ?? Helper.saveVendorTheme(vendorList[index].theme);
                            Navigator.pushNamed(context, "/BottomNavigation");
                          },
                          child: _buildVendorCard(vendorList[index]));
                    },
                  ),
                ),
                /*  SizedBox(
                  height: 52,
                )*/
              ],
            ),
          ),
          /* isLoading
              ? Stack(
                  children: [
                    // Block interaction
                    ModalBarrier(
                        dismissible: false, color: Colors.transparent),
                    // Loader indicator
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                )
              : SizedBox()*/
        ]),
      ),
    );
  }

  Widget _buildVendorCard(VendorData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 24),
      child: Card(
        child: Container(
          width: mediaWidth * 0.19,
          child: Stack(
            children: [
              Container(
                child: Stack(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.5),
                      ),
                      child: data.vendorImage == "" || data.vendorImage == null
                          ? Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.5),
                                  color: AppColor.Primary),
                              child: Image.asset(
                                "assets/appLogo.png",
                                height: screenHeight * 0.19,
                                width: double.infinity,
                                fit: BoxFit.fitWidth,
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.5),
                                border: Border.all(
                                    color: Theme.of(context).cardColor,
                                    width: 0.3),
                                color: Colors.white,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.5),
                                child: Image.network(
                                  "${data.vendorImage}",
                                  height: screenHeight * 0.19,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    return Container(
                                      child: Image.asset(
                                        "assets/appLogo.png",
                                        height: screenHeight * 0.19,
                                        width: double.infinity,
                                        fit: BoxFit.fitWidth,
                                      ),
                                    );
                                  },
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return Shimmer.fromColors(
                                        baseColor: Colors.white38,
                                        highlightColor: Colors.grey,
                                        child: Container(
                                          height: screenHeight * 0.19,
                                          width: double.infinity,
                                          color: Colors.white,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                    ),
                    Container(
                      height: screenHeight * 0.19,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.5),
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.0),
                            // Semi-transparent blue
                            Colors.black.withOpacity(0.6),
                            // Semi-transparent purple
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, bottom: 2, right: 8, left: 8),
                            child: Text(
                              "${capitalizeFirstLetter("${data.businessName}")}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                          ),
                          data.description != null
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 6, right: 8, left: 8),
                                  child: Row(
                                    children: [
                                      Text(
                                        "${data.description} ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 11,
                                            color: Colors.white),
                                      ),
                                      /* Icon(Icons.star, color: Colors.yellow,size: 10,),
                                Text("4.5", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 11, color: Colors.white),),*/
                                    ],
                                  ),
                                )
                              : SizedBox(
                                  height: 15,
                                ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _fetchData() async {
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
      getVendorList(context, apiResponse);
    }
  }

  void _fetchBannerData() async {
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
          .fetchBanners("/api/v1/banner_settings");
      ApiResponse apiResponse =
          Provider.of<MainViewModel>(context, listen: false).response;
      getBannerList(context, apiResponse);
    }
  }

  void _showTopSheet() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      // Sheet can be dismissed by tapping outside
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.5),
      // Optional: Background color behind the sheet
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, animation1, animation2, widget) {
        return SlideTransition(
          position: _animation!,
          child: Align(
            alignment: Alignment.topCenter,
            child: Material(
              elevation: 10,
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(20)),
              child: Container(
                height: 200, // Top sheet height
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                              queryController.text = "";
                            },
                            child: Icon(Icons.arrow_back_rounded)),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'Search for dishes & restaurants',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: TextField(
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                        obscureText: false,
                        obscuringCharacter: "*",
                        controller: queryController,
                        onChanged: (value) async {
                          if (queryController.text.length >= 4) {
                            print("queryController${queryController.text}");
                            showSearch(
                              context: context,
                              delegate: GlobalSearchDelegate(
                                  initialQuery: queryController.text),
                            );
                          }
                          //_isValidInput();
                        },
                        onSubmitted: (value) {},
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: AppColor.Primary, width: 0.8)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: AppColor.Primary, width: 0.7)),
                          hintText: "Search..",
                          suffixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    /*ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();  // Close the top sheet
                      },
                      child: Text('Close'),
                    ),*/
                  ],
                ),
              ),
            ),
          ),
        );
      },
      pageBuilder: (context, animation1, animation2) => Container(),
    );
    _animationController!.forward();
  }
}
