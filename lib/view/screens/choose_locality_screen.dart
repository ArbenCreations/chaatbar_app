import 'package:TheChaatBar/languageSection/Languages.dart';
import 'package:TheChaatBar/model/response/locationListResponse.dart';
import 'package:TheChaatBar/utils/Helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../model/apis/apiResponse.dart';
import '../../theme/CustomAppColor.dart';
import '../../model/viewModel/mainViewModel.dart';
import '../component/connectivity_service.dart';
import '../component/toastMessage.dart';

class ChooseLocalityScreen extends StatefulWidget {

  final String? data; // Define the 'data' parameter here

  ChooseLocalityScreen({Key? key, this.data}) : super(key: key);
  @override
  _ChooseLocalityScreenState createState() => _ChooseLocalityScreenState();
}

class _ChooseLocalityScreenState extends State<ChooseLocalityScreen> {
  String token = "";
  late double mediaWidth;
  late double screenHeight;
  PageController _pageController = PageController();
  bool isLoading = false;
  var _connectivityService = ConnectivityService();
  static const maxDuration = Duration(seconds: 2);
  List<LocationData> locationList = [];
  String selectedLocality = "";
  LocationData selectedLocalityData = LocationData();

  String? selectedItem;
  List<String> items = List<String>.generate(10, (index) => "Item $index");

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Widget getLocationList(BuildContext context, ApiResponse apiResponse) {
    LocationListResponse? locationListResponse =
        apiResponse.data as LocationListResponse?;
    var message = apiResponse?.message.toString();
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        //print("rwrwr ${locationListResponse?.locations?[1].localityName}");

        locationList = locationListResponse!.locations!;
        //Helper.saveCountryList(locationList);
        //selectedItem = "${countryListResponse?.countries?[0].flagImageUrl}";

        print("countriess ${locationList}");

        //_showPicker(context: context);

        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        print("countriess ${locationList}");
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
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    mediaWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) {
        Future.value(false);
        if (kDebugMode) {
          print("$didPop");
          //if(widget.data?.isEmpty == true) {
            SystemNavigator.pop();
         /* }else{
            Navigator.pop(context);
          }*/
          // return Future.value(true);
        }

       /* if(widget.data?.isEmpty == true) {
          SystemNavigator.pop();
        }else{
          Navigator.pop(context);
        }*/
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(children: [
            //Image(image: AssetImage("assets/home_background.png"), width: mediaWidth, height: screenHeight,fit: BoxFit.fitHeight,),

            Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: screenHeight * 0.33,
                    child:
                    _buildScanButton(context: context, text: ""),
                    alignment: AlignmentDirectional.center,
                  ),
                ),
                Flexible(
                  child: Container(
                    width: mediaWidth,
                    padding: EdgeInsets.zero,
                    child: Card(
                      elevation: 20,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 20),
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            Text("Choose your", style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),),
                            Text("Location", style: TextStyle(fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: AppColor.Primary),),
                            Container(
                              height: screenHeight*0.38,
                              child: ListView.builder(
                                  itemCount: locationList.length,
                                  itemBuilder: (context, index) {
                                    final item = locationList[index];

                                    return GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          selectedLocality = "${item.localityName}";
                                          selectedLocalityData = item;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: (item.localityName == selectedLocality) ? BorderRadius.circular(10): BorderRadius.zero,
                                          border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 0.7)),
                                          color: (item.localityName == selectedLocality) ? Colors.red[100]: Colors.white
                                        ),
                                          margin: EdgeInsets.only(left: 16.0, bottom:0 , top: 2, right: 16),
                                          padding: EdgeInsets.symmetric(horizontal: 6.0, vertical:12 ),
                                          child:
                                             Row(
                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text("${item.localityName}",style: TextStyle(color: (item.localityName == selectedLocality) ? AppColor.Primary : Colors.black,
                                                    fontWeight: (item.localityName == selectedLocality) ? FontWeight.bold : FontWeight.normal),),
                                                Icon(Icons.call_made),
                                              ],
                                            ),
                                      ),
                                    );
                                  }
                              ),
                            ),

                            SizedBox(height: 18),
                            _buildFooter(context: context, text: "Proceed")


                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            isLoading
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
                : SizedBox()
          ]),
        ),
      ),
    );
  }


  Widget _buildScanButton(
      {required BuildContext context,
      required String text,}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      child: Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(100)
        ),
       // margin: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        child:
        IconButton(onPressed: (){
          Navigator.pushNamed(context, "/ScanQRScreen");
        }, icon: Icon(Icons.qr_code_scanner_rounded, size: 110,))
      ),
    );
  }


  Widget _buildFooter(
      {required BuildContext context,
      required String text,}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: Column(
        children: [
          SizedBox(
            width: mediaWidth*0.55,
            child: ElevatedButton(
              onPressed: (){
                if(selectedLocality.isNotEmpty){
                  Navigator.pushReplacementNamed(context, "/VendorScreen");
                }else{
                  CustomToast.showToast(context: context, message: "Select location or scan QR.");
                }
              },
              child: Text(
                text,
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  backgroundColor: AppColor.Primary,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18))),
            ),
          ),
        ],
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
          .fetchLocationList("/api/v1/localities");
      ApiResponse apiResponse =
          Provider.of<MainViewModel>(context, listen: false).response;
      getLocationList(context, apiResponse);
    }
  }
}
