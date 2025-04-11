import 'package:TheChaatBar/model/request/verifyOtpChangePass.dart';
import 'package:flutter/material.dart';
import 'package:otp_pin_field/otp_pin_field.dart';

import '../../../../theme/CustomAppColor.dart';
import '../../../../utils/Util.dart';
import '../../../component/custom_button_component.dart';

class OtpForgotPassScreen extends StatefulWidget {
  final String? data;

  OtpForgotPassScreen({Key? key, this.data}) : super(key: key);

  @override
  _OtpForgotPassScreenState createState() => _OtpForgotPassScreenState();
}

class _OtpForgotPassScreenState extends State<OtpForgotPassScreen> {
  late double mediaWidth;
  late double screenHeight;
  bool isLoading = false;
  bool newPasswordVisible = false;
  bool confirmPasswordVisible = false;
  bool isValid = false;
  bool isKeypadVisible = true;
  String responseMessage = '';
  String otp = '';
  bool phoneNumberValid = false;
  bool isDarkMode = false;
  List<String> _inputValues = ['', '', '', '', '', ''];

  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());

  void _handleKeyTap(String value) {
    setState(() {
      for (int i = 0; i < _inputValues.length; i++) {
        if (_inputValues[i].isEmpty) {
          _inputValues[i] = value;
          break;
        }
      }
    });
  }

  void _handleBackspace() {
    setState(() {
      for (int i = _inputValues.length - 1; i >= 0; i--) {
        if (_inputValues[i].isNotEmpty) {
          _inputValues[i] = '';
          break;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
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
            "Verify Password",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              SafeArea(
                child: Column(
                  children: [
                    Center(
                      child: Image(
                        alignment: Alignment.topLeft,
                        height: screenHeight * 0.3,
                        image: AssetImage("assets/verifyPass.gif"),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: mediaWidth * 0.7,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 8),
                        child: Text(
                          "Enter the verification code we jst sent you on your email address.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.4),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Container(
                        width: mediaWidth * 0.9,
                        child: OtpPinField(
                          onSubmit: (String pin) {
                            setState(() {
                              otp = pin;
                            });
                            print("Entered OTP: $otp");
                          },
                          onChange: (String value) {
                            setState(() {
                              otp = value;
                            });
                            print("Current input: $otp");
                          },
                          maxLength: 6,
                          otpPinFieldDecoration: OtpPinFieldDecoration.custom,
                          otpPinFieldStyle: OtpPinFieldStyle(
                            defaultFieldBorderColor: Colors.grey,
                            activeFieldBorderColor: AppColor.ButtonBackColor,
                            filledFieldBackgroundColor: Colors.white,
                            fieldBorderRadius: 13,
                            fieldBorderWidth: 1,
                            textStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          fieldWidth: 50,
                          fieldHeight: 55,
                          showCursor: false,
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Center(
                      child: CustomButtonComponent(
                        text: "Verify",
                        mediaWidth: mediaWidth * 0.75,
                        textColor: otp.length == 6
                            ? Colors.white
                            : AppColor.ButtonBackColor,
                        buttonColor: otp.length == 6
                            ? AppColor.ButtonBackColor
                            : Colors.white,
                        isDarkMode: isDarkMode,
                        verticalPadding: 14,
                        onTap: () async {
                          hideKeyBoard();
                          //String otp=_inputValues.map((controller) => controller).join();
                          print("${widget.data}");
                          print("OTP${otp.length}");
                          VerifyOtChangePassRequest data =
                              VerifyOtChangePassRequest(
                            email: "${widget.data}",
                            mobileOtp: otp,
                          );
                          if (otp.isNotEmpty && otp.length == 6) {
                            Navigator.pushNamed(context, "/ChangePasswordScreen",
                                arguments: data);
                          }
                        },
                      ),
                    ),
                    //if (isLoading) CircularProgressIndicator(),
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
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    )
                  : SizedBox(),
            ],
          ),
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

  Widget _buildOtpInput(
      BuildContext context, double mediaWidth, bool isDarkMode) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          6,
          (index) => GestureDetector(
            onTap: () {
              setState(() {
                isKeypadVisible = true;
              });
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
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
              width: mediaWidth / 7.68,
              height: 55.0,
              child: Center(
                child: Text(
                  _inputValues[index],
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void isInputValid() {
    String otp = _controllers.map((controller) => controller.text).join();
    if (otp.isNotEmpty &&
        otp.length == 6 &&
        _newPasswordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _newPasswordController.text == _confirmPasswordController.text &&
        _newPasswordController.text.length >= 8) {
      isValid = true;
    } else {
      isValid = false;
    }
  }
}
