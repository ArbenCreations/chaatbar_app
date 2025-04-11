import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../languageSection/Languages.dart';
import '../../../../model/apis/apiResponse.dart';
import '../../../../model/response/profileResponse.dart';
import '../../../../theme/CustomAppColor.dart';
import '../../../../utils/Helper.dart';
import '../../../../utils/Util.dart';
import '../../../../model/viewModel/mainViewModel.dart';
import '../../component/CustomAlert.dart';
import '../../component/connectivity_service.dart';
import '../../component/custom_circular_progress.dart';
import '../../component/session_expired_dialog.dart';
import '../../component/toastMessage.dart';

class EditInformationScreen extends StatefulWidget {
  @override
  _EditInformationScreenState createState() => _EditInformationScreenState();
}

class _EditInformationScreenState extends State<EditInformationScreen> {
  bool isLoading = false;
  bool isInternetConnected = true;
  bool isDarkMode = false;
  late double mediaWidth;
  late double screenHeight;
  String documentNumber = "";
  String? firstName = "";
  String? lastName = "";
  String? email = "";
  String? dob = "";
  String? imageUrl = "";
  String? recentDocumentName = "";
  String? recentDocumentNumber = "";
  String? address = "";
  File? galleryFile = File("");
  bool mExpanded = false;
  String mSelectedText = "";
  final List<String> docType = ["National Id", "Passport"];
  static const maxDuration = Duration(seconds: 2);
  bool isDataLoading = false;
  final TextEditingController documentNumberController =
  TextEditingController();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  var _connectivityService = ConnectivityService();

  @override
  void initState() {
    super.initState();
    firstName = "";
    lastName = "";
    dob = "";
    email = "";
    isDataLoading = true;

    Helper.getProfileDetails().then((profileDetails) {
      setState(() {
        firstName = profileDetails?.firstName;
        lastName = profileDetails?.lastName;
        _nameController.text = "${firstName}";
        _lastNameController.text = "${lastName}";
        _dobController.text = convertDateFormat("${dob}");
        email = profileDetails?.email;
        isDataLoading = false;

      });
    });
  }

  Future<Widget> getProfileResponse(
      BuildContext context, ApiResponse apiResponse) async
  {
    ProfileResponse? mediaList = apiResponse.data as ProfileResponse?;
    print("apiResponse${mediaList?.message}");
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
/*        await Helper.saveProfileDetails(mediaList);
        await Helper.saveUserBalance(mediaList?.balance);
        await Helper.saveCountry(mediaList?.countryName);
        await Helper.saveKycStatus(mediaList?.kycStatus);
        print(mediaList?.countryName);*/

        CustomAlert.showToast(
            context: context, message: "${mediaList?.message}");
        hideKeyBoard();
        Navigator.pushReplacementNamed(context, "/BottomNavigation",arguments: 3);

        _fetchDataFromPref();
        //Navigator.pushReplacementNamed(context, "/PersonalInfoScreen");
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        _fetchDataFromPref();
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
    ProfileResponse? profileResponse = await Helper.getProfileDetails();

    setState(() {
      isLoading = false;
      //customerName = "${profileResponse?.firstName} ${profileResponse?.lastName}";
      //firstName = "${profileResponse?.firstName}";
      //lastName = "${profileResponse?.lastName}";
      //dob = "${profileResponse?.dob}";
      //email = "${profileResponse?.email}";

      //isUsernameRetrieved = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    mediaWidth = MediaQuery.of(context).size.width;
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, "/PersonalInfoScreen");
          },
        ),
        title: Text(
          Languages.of(context)!.labelEditPersonalInfo,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 30),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: () => {},
                            child: galleryFile != null && galleryFile!.path.isNotEmpty
                                ? Container(
                              height: 110,
                              width: 110,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(color: Theme.of(context).cardColor, width: 0.3),
                                color: Colors.white,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100.0),
                                child: Image.file(
                                  galleryFile!,
                                  height: 110,
                                  width: 110,
                                  fit: BoxFit.cover,
                                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                    return Container(
                                      height: 110,
                                      width: 110,
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.white,
                                        backgroundImage: AssetImage("assets/userIcon.png"),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                                : imageUrl == ""
                                ? Container(
                              height: 110,
                              width: 110,
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage("assets/userIcon.png"),
                              ),
                            )
                                : Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(color: Theme.of(context).cardColor, width: 0.3),
                                color: Colors.white,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100.0),
                                child: Image.network(
                                  "${imageUrl}",
                                  height: 110,
                                  width: 110,
                                  fit: BoxFit.cover,
                                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                    return Container(
                                      height: 110,
                                      width: 110,
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.white,
                                        backgroundImage: AssetImage("assets/userIcon.png"),
                                      ),
                                    );
                                  },
                                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return Shimmer.fromColors(
                                        baseColor: Colors.white38,
                                        highlightColor: Colors.grey,
                                        child: Container(
                                          height: 80,
                                          width: 80,
                                          color: Colors.white,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),

                          Positioned(
                            bottom: -5,
                            right: -4,
                            child: Padding(
                              padding: const EdgeInsets.all(1.5),
                              child: Container(
                                height: 45,
                                width: 45,
                                child: Card(
                                  shape: CircleBorder(),
                                  color: Colors.white,
                                  child: IconButton(
                                    iconSize: 20,
                                    onPressed: () {
                                    },
                                    icon: Icon(Icons.edit_outlined),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: mediaWidth * 0.45,
                            minWidth: mediaWidth * 0.45,
                          ),
                          child: editableDetailBox(
                            Languages.of(context)!.labelFirstname,
                            "${firstName}",
                            14,
                            13,
                            Icons.person,
                            _nameController,
                          ),
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: mediaWidth * 0.45,
                            minWidth: mediaWidth * 0.45,
                          ),
                          child: editableDetailBox(
                              Languages.of(context)!.labelLastname,
                              "${lastName}",
                              14,
                              13,
                              Icons.person,
                              _lastNameController),
                        ),
                      ],
                    ),
                    _buildDOBInput(
                        context,
                        Languages.of(context)!.labelDOB,
                        _dobController,
                        Icon(
                          Icons.calendar_month,
                          size: 18,
                          color: isDarkMode ? Colors.white : Colors.black,
                        )
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: mediaWidth * 0.45,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all( Theme.of(context).cardColor),
                          ),
                          onPressed: () async {
                          },
                          child: Text(
                            Languages.of(context)!.labelSubmit,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
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
    );
  }

  Widget buildBirthdateSection() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Languages.of(context)!.labelBirthdate,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 5),
                Text(
                  "${dob}",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDocumentNumberSection(String heading, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text("${value}",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
        ],
      ),
    );
  }

  Future<File?> _resizeAndCompressImage(File file, int targetWidth) async {
    try {
      final directory = await getTemporaryDirectory();
      final targetPath = path.join(directory.path,
          '${DateTime.now().millisecondsSinceEpoch}_compressed.jpg');

      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        minWidth: targetWidth,
        quality: 85, // Adjust quality to balance size and quality
        format: CompressFormat.jpeg,
        keepExif: false, // Remove metadata
      );

      if (result == null) {
        print('Resizing and compression failed.');
        return null;
      }

      print('Original size: ${file.lengthSync()} bytes');
      print('Resized and compressed size: ${result.lengthSync()} bytes');

      return result;
    } catch (e) {
      print('Error resizing and compressing image: $e');
      return null;
    }
  }


  Widget editableDetailBox(
      String heading,
      String subHeading,
      double subHeadingTextSize,
      double headingTextSize,
      IconData icon,
      TextEditingController controller,
      ) {
    //controller.text = subHeading;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  heading,
                  style: TextStyle(
                    fontSize: headingTextSize,
                    fontWeight: FontWeight.w600,
                    //color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 2,
            ),
            Container(
              // width: mediaWidth *0.8,
              child: TextField(
                scrollPadding: EdgeInsets.all(0),
                controller: controller,
                textAlignVertical: TextAlignVertical.center,
                onChanged: (value) {
                  //isInputValid();
                },
                onSubmitted: (value) {},
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                decoration:  InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.2 ,color :isDarkMode ? Colors.white : Colors.black), ),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.25, color: Theme.of(context).cardColor)),
                  hintText: heading,
                  prefixIcon: Icon(icon),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget  _buildDOBInput(BuildContext context, String text,
      TextEditingController dateController, Icon icon)
  {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          Expanded(
              child: TextField(
                  controller: dateController,
                  //editing controller of this TextField
                  textInputAction: TextInputAction.done,

                  decoration:  InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 12),
                      border: InputBorder.none,
                      hintText: Languages.of(context)!.labelBirthdate,
                      icon: icon
                    //icon of text field
                  ),
                  readOnly: true,
                  // when true user cannot edit text
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate:DateTime.now().subtract(Duration(days: 365*18)),
                        firstDate: DateTime(1950),
                        //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime.now().subtract(Duration(days: 365*18)),
                        helpText: "${Languages.of(context)?.labelSelectDob}",
                        confirmText: "${Languages.of(context)?.labelConfirm}",
                        errorFormatText: '${Languages.of(context)?.labelEnterValidDate}',
                        errorInvalidText: '${Languages.of(context)?.labelEnterDateInValidRange}',
                        builder: (context, child) {
                          return Theme(
                            data: isDarkMode
                                ? ThemeData.dark()
                                : ThemeData
                                .light(), // This will change to light theme.
                            child: child!,
                          );
                        });

                    if (pickedDate != null) {
                      print(
                          pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                      String formattedDate =
                      DateFormat('dd-MM-yyyy').format(pickedDate);
                      print(
                          formattedDate); //formatted date output using intl package =>  2021-03-16
                      setState(() {
                        _dobController.text =
                            formattedDate; //set output date to TextField value.
                      });
                    } else {}
                  })),
        ],
      ),
    );
  }

  void isInputValid() {}
}
