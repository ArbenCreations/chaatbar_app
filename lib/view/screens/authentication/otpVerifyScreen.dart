import 'package:TheChaatBar/model/apis/apiResponse.dart';
import 'package:TheChaatBar/model/request/otpVerifyRequest.dart';
import 'package:TheChaatBar/model/response/signUpVerifyResponse.dart';
import 'package:TheChaatBar/model/viewModel/mainViewModel.dart';
import 'package:TheChaatBar/theme/CustomAppColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:otp_pin_field/otp_pin_field.dart';
import 'package:provider/provider.dart';

import '../../../../languageSection/Languages.dart';
import '../../../utils/Util.dart';
import '../../component/connectivity_service.dart';
import '../../component/custom_button_component.dart';
import '../../component/custom_circular_progress.dart';
import '../../component/toastMessage.dart';

class OTPVerifyScreen extends StatefulWidget {
  final String? data;

  OTPVerifyScreen({Key? key, this.data}) : super(key: key);

  @override
  _OTPVerifyScreenState createState() => _OTPVerifyScreenState();
}

class _OTPVerifyScreenState extends State<OTPVerifyScreen> {
  List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  final List<String> _otp = List.generate(6, (_) => '');

  String dropdownValue = "";
  bool isValid = false;
  bool resendOtp = false;
  late DateTime endTime;
  String phoneNo = "";
  late double mediaWidth;
  bool isLoading = false;
  List<String> _inputValues = ['', '', '', '', '', ''];
  var _connectivityService = ConnectivityService();
  String otp = '';

  @override
  void initState() {
    super.initState();
    isValid = false;
    resendOtp = false;
    endTime = DateTime.now().add(const Duration(minutes: 3, seconds: 0));
    for (var i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus && _controllers[i].text.isEmpty) {
          _controllers[i].selection = TextSelection(
              baseOffset: 0, extentOffset: _controllers[i].text.length);
        }
      });
    }
  }

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
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  Future<Widget> getOtpResponseDataWidget(
      BuildContext context, ApiResponse apiResponse) async {
    SignUpVerifyResponse? signUpVerifyResponse =
        apiResponse.data as SignUpVerifyResponse?;
    var message = apiResponse?.message.toString();
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("OtpVerify ${signUpVerifyResponse?.token}");
        CustomToast.showToast(
            context: context,
            message: "Signup completed. Please Login to continue.");

        Navigator.pushReplacementNamed(context, "/LoginScreen", arguments: "");

        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        CustomToast.showToast(context: context, message: message);
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

  Widget getResendOtpResponse(BuildContext context, ApiResponse apiResponse) {
    /* PhoneVerifyResponse? phoneVerifyResponse =
        apiResponse.data as PhoneVerifyResponse?;*/
    var message = apiResponse?.message.toString();
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        // print("rwrwr ${phoneVerifyResponse?.mobileOtp}");
        //Call Toast
        CustomToast.showToast(context: context, message: message);
        // Navigate to the new screen after receiving the response
        return Container(); // Return an empty container as you'll navigate away
      case Status.ERROR:
        CustomToast.showToast(context: context, message: apiResponse?.message);
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
    mediaWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    ApiResponse apiResponse = Provider.of<MainViewModel>(context).response;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  color: AppColor.BackgroundColor,
                  width: mediaWidth,
                  height: screenHeight * 0.15,
                  margin: EdgeInsets.zero,
                  child: _buildLabelText(
                      context,
                      "${Languages.of(context)?.labelOtpVerification}",
                      22,
                      true),
                  alignment: AlignmentDirectional.center,
                ),
                Center(
                  child: Image(
                    alignment: Alignment.topLeft,
                    height: screenHeight * 0.15,
                    image: AssetImage("assets/verifyPass.gif"),
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Expanded(
                  child: Container(
                    width: mediaWidth,
                    height: screenHeight * 0.72,
                    margin: EdgeInsets.zero,
                    child: Card(
                      color: AppColor.BackgroundColor,
                      margin: EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Center(
                              child: _buildLabelText(
                                  context,
                                  Languages.of(context)!.labelEnterCode,
                                  12,
                                  true),
                            ),
                          ),
                          SizedBox(height: 4),
                          Center(
                            child: _buildLabelText(
                                context,
                                "${Languages.of(context)!.labelSentCode} ${widget.data}",
                                12,
                                false),
                          ),
                          SizedBox(height: 22),
                          // _buildOtpInput(context, mediaWidth, isDarkMode),
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
                                otpPinFieldDecoration:
                                    OtpPinFieldDecoration.custom,
                                otpPinFieldStyle: OtpPinFieldStyle(
                                  defaultFieldBorderColor: Colors.grey,
                                  activeFieldBorderColor:
                                      AppColor.ButtonBackColor,
                                  filledFieldBackgroundColor: Colors.white,
                                  fieldBorderRadius: 13,
                                  fieldBorderWidth: 0.8,
                                  textStyle: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                fieldWidth: 45,
                                fieldHeight: 50,
                                showCursor: false,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 24),
                            child: Row(
                              children: [
                                resendOtp
                                    ? const SizedBox.shrink()
                                    : _buildLabelText(
                                        context,
                                        "${Languages.of(context)!.labelResendCode} ",
                                        14,
                                        true),
                                _countdownTimer(),
                                Spacer(),
                                //if (resendOtp) _resendOtpButton(context)
                              ],
                            ),
                          ),
                          SizedBox(height: 50),
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
                                if (otp.isNotEmpty && otp.length == 6) {
                                  const maxDuration = Duration(seconds: 2);
                                  print("otp $otp");
                                  if (otp.isNotEmpty && otp.length == 6) {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    bool isConnected =
                                        await _connectivityService
                                            .isConnected();
                                    if (!isConnected) {
                                      setState(() {
                                        isLoading = false;
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                '${Languages.of(context)?.labelNoInternetConnection}'),
                                            duration: maxDuration,
                                          ),
                                        );
                                      });
                                    } else {
                                      OtpVerifyRequest phoneRequest =
                                          OtpVerifyRequest(
                                              customer: CustomerOtpVerify(
                                        phoneNumber: "${widget.data}",
                                        mobileOtp: otp,
                                      ));
                                      await Provider.of<MainViewModel>(context,
                                              listen: false)
                                          .signUpOtpVerifyData(
                                              "/api/v1/app/temp_customers/verify_customer_signup",
                                              phoneRequest);

                                      ApiResponse apiResponse =
                                          Provider.of<MainViewModel>(context,
                                                  listen: false)
                                              .response;
                                      getOtpResponseDataWidget(
                                          context, apiResponse);
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            '${Languages.of(context)?.labelPleaseEnterValidPhoneNo}'),
                                        duration: maxDuration,
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          ),

                          /* CustomNumberKeyboard(onKeyTap: (value) async {
                            if (value == "clear") {
                              _handleBackspace();
                            } else if (value == "submit") {
                              String otp = _inputValues
                                  .map((controller) => controller)
                                  .join();
                              print("$otp");
                              if (otp.isNotEmpty && otp.length == 6) {
                                const maxDuration = Duration(seconds: 2);
                                print("otp $otp");
                                if (otp.isNotEmpty && otp.length == 6) {
                                  setState(() {
                                    isLoading = true;
                                  });

                                  bool isConnected =
                                      await _connectivityService.isConnected();
                                  if (!isConnected) {
                                    setState(() {
                                      isLoading = false;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              '${Languages.of(context)?.labelNoInternetConnection}'),
                                          duration: maxDuration,
                                        ),
                                      );
                                    });
                                  } else {
                                    OtpVerifyRequest phoneRequest =
                                        OtpVerifyRequest(
                                            customer: CustomerOtpVerify(
                                      phoneNumber: "${widget.data}",
                                      mobileOtp: otp,
                                    ));
                                    await Provider.of<MainViewModel>(context,
                                            listen: false)
                                        .signUpOtpVerifyData(
                                            "/api/v1/app/temp_customers/verify_customer_signup",
                                            phoneRequest);

                                    ApiResponse apiResponse =
                                        Provider.of<MainViewModel>(context,
                                                listen: false)
                                            .response;
                                    getOtpResponseDataWidget(
                                        context, apiResponse);
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          '${Languages.of(context)?.labelPleaseEnterValidPhoneNo}'),
                                      duration: maxDuration,
                                    ),
                                  );
                                }
                              }
                            } else {
                              _handleKeyTap(value);
                            }
                          }),*/
                          //_buildFooter(context),
                        ],
                      ),
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
                    ModalBarrier(dismissible: false, color: Colors.transparent),
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

  Widget _countdownTimer() {
    return resendOtp
        ? const SizedBox.shrink()
        : TimerCountdown(
            endTime: endTime,
            format: CountDownTimerFormat.minutesSeconds,
            enableDescriptions: false,
            spacerWidth: 2,
            timeTextStyle: TextStyle(fontWeight: FontWeight.w600),
            onEnd: () {
              setState(() {
                resendOtp = true;
              });
            },
          );
  }

  Widget _buildOtpInput(
      BuildContext context, double mediaWidth, bool isDarkMode) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          6,
          (index) => Container(
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                  color: isDarkMode ? Colors.grey : Colors.black54, width: 0.4),
              borderRadius: BorderRadius.circular(6),
            ),
            width: mediaWidth / 8.1,
            height: 62.0,
            child: Center(
              child: Text(
                _inputValues[index],
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleOnChange(int index, String value) {
    setState(() {
      _otp[index] = value;
    });

    // Move focus based on input
    if (value.isNotEmpty) {
      if (index < _focusNodes.length - 1) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      }
    } else {
      if (index > 0) {
        FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
      }
    }

    String otpString = _otp.join('');
    if (otpString.length == 6) {
      isValid = true;
    } else {
      isValid = false;
    }
  }

  /* Widget _buildOtpInput(
      BuildContext context, double mediaWidth, bool isDarkMode) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          6,
          (index) => Container(
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                        color: isDarkMode ? Colors.grey : Colors.black54,
                        width: 0.4),
                    bottom: BorderSide(
                        color: isDarkMode ? Colors.grey : Colors.black54,
                        width: 0.4),
                    right: BorderSide(
                        color: isDarkMode ? Colors.grey : Colors.black54,
                        width: 0.4),
                    left: BorderSide(
                        color: isDarkMode ? Colors.grey : Colors.black54,
                        width: 0.4)),
                borderRadius: BorderRadius.circular(6)),
            width: mediaWidth / 8.1,
            height: 62.0,
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              autofocus: index == 0,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              maxLength: 1,
              decoration: InputDecoration(
                counterText: "", // Remove the counter text
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 20),
              onChanged: (value) {
                _handleOnChange(index, value);
              },
            ),
          ),
        ),
      ),
    );
  }
*/

  void _handleKeyEvent(RawKeyEvent event, int index) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.backspace) {
        if (_controllers[index].text.isEmpty && index > 0) {
          _focusNodes[index].unfocus();
          _focusNodes[index - 1].requestFocus();
        }
      }
    }
  }

  void _handleTextChange(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index].unfocus();
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }
  }

  _buildLabelText(BuildContext context, String text, int size, bool isBold) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: size.toDouble(),
        fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Widget _resendOtpButton(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          phoneNo = widget.data as String;
          // PhoneRequest phoneRequest = PhoneRequest(
          //     customer: Customer(
          //         phoneNumber: phoneNo, mobileOtp: "", countryId: null));
          /*  await Provider.of<MainViewModel>(context, listen: false)
              .PhoneVerifyData(
                  "/api/v1/app/temp_customers/initiate_customer", phoneRequest); */
          ApiResponse apiResponse =
              Provider.of<MainViewModel>(context, listen: false).response;
          getResendOtpResponse(context, apiResponse);
        },
        child: Text(
          "${Languages.of(context)?.labelResendOtp}",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
          ),
        ));
  }
/*void restartTimer() {
    countDownTimer.cancel();
    startTimer();
  }*/
}
