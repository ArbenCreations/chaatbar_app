import 'package:TheChaatBar/model/request/verifyOtpChangePass.dart';
import 'package:TheChaatBar/model/response/signUpInitializeResponse.dart';
import 'package:TheChaatBar/theme/CustomAppColor.dart';
import 'package:TheChaatBar/view/component/toastMessage.dart';
import 'package:TheChaatBar/view/screens/authentication/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../languageSection/Languages.dart';
import '../../../../../model/apis/apiResponse.dart';
import '../../../../../utils/Helper.dart';
import '../../../../model/viewModel/mainViewModel.dart';
import '../../../../utils/Util.dart';
import '../../../component/CustomAlert.dart';
import '../../../component/connectivity_service.dart';
import '../../../component/session_expired_dialog.dart';

class ChangePasswordScreen extends StatefulWidget {
  final VerifyOtChangePassRequest? data;

  ChangePasswordScreen({Key? key, this.data}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late double mediaWidth;
  late double screenHeight;
  bool isLoading = false;
  bool newPasswordVisible = false;
  bool confirmPasswordVisible = false;
  bool isValid = false;
  bool isKeypadVisible = true;
  String responseMessage = '';
  bool phoneNumberValid = false;
  bool isDarkMode = false;

  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  var _connectivityService = ConnectivityService();
  static const maxDuration = Duration(seconds: 2);
  List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());

  @override
  void initState() {
    super.initState();
    print("${widget.data?.email}");
    isValid = false;
    phoneNumberValid = false;
    newPasswordVisible = true;
    confirmPasswordVisible = true;
    //_fetchData();
    for (var i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus && _controllers[i].text.isEmpty) {
          // Automatically select all text when the field gains focus
          _controllers[i].selection = TextSelection(
              baseOffset: 0, extentOffset: _controllers[i].text.length);
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<Widget> verifyOtpResponse(
      BuildContext context, ApiResponse apiResponse) async {
    SignUpInitializeResponse? mediaList =
        apiResponse.data as SignUpInitializeResponse?;
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("rwrwr ");
        //Navigator.pushNamed(context, '/ProfileScreen');
        CustomAlert.showToast(context: context, message: apiResponse.message);
        Helper.clearAllSharedPreferences();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false,
        );

        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        if (nonCapitalizeString("${apiResponse.message}") ==
            nonCapitalizeString(
                "${Languages.of(context)?.labelInvalidAccessToken}")) {
          SessionExpiredDialog.showDialogBox(context: context);
        } else {
          CustomAlert.showToast(context: context, message: apiResponse.message);
        }
        return Center(
            //child: Text('Please try again later!!!'),
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
    double screenHeight = MediaQuery.of(context).size.height;
    isDarkMode = Theme.of(context).brightness == Brightness.dark;

    mediaWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          toolbarHeight: 65,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            Languages.of(context)!.labelChangePass,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
          ),
        ),
        //backgroundColor: Theme.of(context).backgroundColor,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    Center(
                      child: Image(
                        alignment: Alignment.topLeft,
                        //width: mediaWidth*0.8,
                        height: screenHeight * 0.27,
                        image: AssetImage("assets/changePass.png"),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    SizedBox(height: 30),
                    _buildPasswordTextFields(isDarkMode),
                    SizedBox(height: 15),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      isLoading
          ? Stack(
              children: [
                // Block interaction
                ModalBarrier(
                    dismissible: false, color: Colors.black.withOpacity(0.3)),
                // Loader indicator
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            )
          : SizedBox(),
    ]);
  }

  Widget _buildPasswordTextFields(bool isDarkMode) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "New Password",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        _buildPasswordInput(
            context,
            Languages.of(context)!.labelNewPass,
            _newPasswordController,
            Icon(
              Icons.password,
              size: 16,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            newPasswordVisible,
            isDarkMode),
        SizedBox(height: 15),
        Text(
          "Confirm Password",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        _buildPasswordInput(
            context,
            Languages.of(context)!.labelConfirmPass,
            _confirmPasswordController,
            Icon(
              Icons.password,
              size: 16,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            confirmPasswordVisible,
            isDarkMode)
      ],
    );
  }

  Widget _buildPasswordInput(
    BuildContext context,
    String text,
    TextEditingController nameController,
    Icon icon,
    bool passwordVisibles,
    bool isDarkMode,
  ) {
    return Container(
      width: mediaWidth * 0.85,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      margin: EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        color: isDarkMode ? AppColor.CardDarkColor : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.07),

            offset: Offset(0, 1),
            // Adjust X and Yoffset to match Figma
            blurRadius: 5,
            spreadRadius: 0.6,
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(width: 6),
          Expanded(
            child: TextField(
              style: TextStyle(fontSize: 14.0),
              obscureText: passwordVisibles,
              obscuringCharacter: "*",
              controller: nameController,
              textAlignVertical: TextAlignVertical.center,
              onChanged: (value) {
                setState(() {
                  nameController.text = value;
                });
                isInputValid();
              },
              onSubmitted: (value) {},
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: text,
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 12
                ),
                icon: icon,
                suffixIcon: IconButton(
                  icon: Icon(
                    passwordVisibles
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: isDarkMode ? Colors.white : Colors.black,
                    size: 16,
                  ),
                  onPressed: () {
                    setState(
                      () {
                        if (nonCapitalizeString(text) ==
                            nonCapitalizeString(
                                "${Languages.of(context)!.labelNewPass}")) {
                          newPasswordVisible = !newPasswordVisible;
                        } else {
                          confirmPasswordVisible = !confirmPasswordVisible;
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void isInputValid() {
    if (_newPasswordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _newPasswordController.text == _confirmPasswordController.text &&
        _newPasswordController.text.length >= 8) {
      isValid = true;
    } else {
      isValid = false;
    }
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SizedBox(
        width: mediaWidth * 0.7,
        child: ElevatedButton(
          onPressed: () async {
            hideKeyBoard();
            String otp = "${widget.data}";
            isInputValid();
            if (otp.isNotEmpty &&
                _newPasswordController.text.isNotEmpty &&
                _confirmPasswordController.text.isNotEmpty &&
                _newPasswordController.text ==
                    _confirmPasswordController.text &&
                _newPasswordController.text.length >= 8) {
              setState(() {
                isLoading = true;
              });

              bool isConnected = await _connectivityService.isConnected();
              if (!isConnected) {
                setState(() {
                  isLoading = false;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          '${Languages.of(context)?.labelNoInternetConnection}'),
                      duration: maxDuration,
                    ),
                  );
                });
              } else {
                print(_phoneNumberController.text);
                setState(() {
                  isLoading = true;
                });
                print("${widget.data?.email}");
                VerifyOtChangePassRequest request = VerifyOtChangePassRequest(
                    email: "${widget.data?.email}",
                    password: _newPasswordController.text,
                    mobileOtp: "${widget.data?.mobileOtp}");

                await Provider.of<MainViewModel>(context, listen: false)
                    .VerifyOtpChangePass(
                        "/api/v1/app/customers/verify_otp_change_pass",
                        request);
                ApiResponse apiResponse =
                    Provider.of<MainViewModel>(context, listen: false).response;
                verifyOtpResponse(context, apiResponse);
              }
            } else if (_newPasswordController.text.length < 8) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${Languages.of(context)?.labelPasswordAlert}'),
                  duration: maxDuration,
                ),
              );
            } else if (_newPasswordController.text !=
                _confirmPasswordController.text) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      "${Languages.of(context)?.labelPasswordDoesntMatch}"),
                  duration: maxDuration,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      "${Languages.of(context)?.labelPleaseEnterAllDetails}"),
                  duration: maxDuration,
                ),
              );
            }
          },
          child: Text(
            Languages.of(context)!.labelValidate,
            style: TextStyle(
                color: isValid ? Colors.white : AppColor.ButtonBackColor),
          ),
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              backgroundColor:
                  isValid ? AppColor.ButtonBackColor : Colors.white,
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8))),
        ),
      ),
    );
  }
}
