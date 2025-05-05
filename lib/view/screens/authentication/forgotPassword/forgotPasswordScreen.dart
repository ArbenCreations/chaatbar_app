import 'package:TheChaatBar/theme/CustomAppColor.dart';
import 'package:TheChaatBar/view/screens/authentication/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../languageSection/Languages.dart';
import '../../../../model/apis/apiResponse.dart';
import '../../../../model/request/createOtpChangePass.dart';
import '../../../../model/response/createOtpChangePassResponse.dart';
import '../../../../model/viewModel/mainViewModel.dart';
import '../../../../utils/Helper.dart';
import '../../../../utils/Util.dart';
import '../../../component/CustomAlert.dart';
import '../../../component/connectivity_service.dart';
import '../../../component/session_expired_dialog.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late double mediaWidth;
  late double screenHeight;
  bool isLoading = false;
  bool newPasswordVisible = false;
  bool confirmPasswordVisible = false;
  bool isValid = false;
  bool isOtpBoxVisible = false;
  String otp = '';
  bool phoneNumberValid = false;
  bool isDarkMode = false;
  String selectedItem = "";

  final TextEditingController _emailController = TextEditingController();
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

  Future<Widget> generateOtpResponse(
      BuildContext context, ApiResponse apiResponse) async {
    CreateOtpChangePassResponse? mediaList =
        apiResponse.data as CreateOtpChangePassResponse?;
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        String data = "${mediaList?.email}";
        CustomAlert.showToast(context: context, message: mediaList?.message);
        Future.delayed(Duration(milliseconds: 150), () {
          Navigator.pushNamed(context, "/OtpForgotPassScreen", arguments: data);
        });
        setState(() {
          isOtpBoxVisible = true;
        });

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
          child: Text('Please try again later!!!'),
        );
      case Status.INITIAL:
      default:
        return Center(
          child: Text(''),
        );
    }
  }

  Future<Widget> verifyOtpResponse(
      BuildContext context, ApiResponse apiResponse) async {
    final mediaList = apiResponse.data;
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        CustomAlert.showToast(context: context, message: mediaList.message);
        Helper.clearAllSharedPreferences();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false,
        );

        return Container();
      case Status.ERROR:
        if (nonCapitalizeString("${apiResponse.message}") ==
            nonCapitalizeString(
                "${Languages.of(context)?.labelInvalidAccessToken}"))
          SessionExpiredDialog.showDialogBox(context: context);
        return Center();
      case Status.INITIAL:
      default:
        return Center(
          child: Text(''),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    mediaWidth = MediaQuery.of(context).size.width;
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            _buildForgotPasswordWidget(),
            if (isLoading) _buildLoadingIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildForgotPasswordWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center, // Align items from top
            children: [
              Text(
                "Forgot Password?",
                style: TextStyle(
                  color: AppColor.ButtonBackColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Image.asset(
                "assets/forgot_icon.png",
                height: 200,
                fit: BoxFit.fitWidth,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Enter the registered email address",
                style: TextStyle(
                  color: AppColor.ButtonBackColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                "We will email you an otp to reset your password",
                style: TextStyle(
                  color: AppColor.ButtonBackColor,
                  fontSize: 11,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 17),
              _buildEmailTextField(),
              SizedBox(height: 30),
              _buildResetPasswordButton(),
              SizedBox(height: 15),
              _buildBackToLoginButton(),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailTextField() {
    return Container(
      height: 55,
      width: mediaWidth * 0.85,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      margin: EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: isDarkMode ? AppColor.CardDarkColor : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.07),
            offset: Offset(0, 1),
            blurRadius: 5,
            spreadRadius: 0.6,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.email_outlined,
            color: AppColor.ButtonBackColor,
            size: 16,
          ),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              style: TextStyle(fontSize: 16.0, color: Colors.black),
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'e.g-john@example.com',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                border: InputBorder.none,
                counterText: "",
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResetPasswordButton() {
    return MaterialButton(
      minWidth: mediaWidth * 0.7,
      elevation: 5,
      padding: EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: AppColor.ButtonBackColor,
      onPressed: _onResetPasswordPressed,
      child: Text(
        "Reset Password",
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildBackToLoginButton() {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushReplacementNamed("/LoginScreen"),
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.arrow_back,
              color: AppColor.ButtonBackColor,
              size: 20,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "Back to Login",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onResetPasswordPressed() async {
    hideKeyBoard();
    if (_emailController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      var email = _emailController.text;
      CreateOtpChangePassRequest request =
          CreateOtpChangePassRequest(email: email);

      await Provider.of<MainViewModel>(context, listen: false)
          .CreateOtpChangePass(
              "/api/v1/app/customers/gen_otp_for_reset_pass", request);
      ApiResponse apiResponse =
          Provider.of<MainViewModel>(context, listen: false).response;
      generateOtpResponse(context, apiResponse);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(Languages.of(context)!.labelEnterValidPhone),
      ));
    }
  }

  Widget _buildLoadingIndicator() {
    return Stack(
      children: [
        ModalBarrier(dismissible: false, color: Colors.transparent),
        Center(child: CircularProgressIndicator()),
      ],
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
