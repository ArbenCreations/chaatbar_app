import 'package:TheChaatBar/model/apis/apiResponse.dart';
import 'package:TheChaatBar/model/request/signUpRequest.dart';
import 'package:TheChaatBar/model/response/signUpInitializeResponse.dart';
import 'package:TheChaatBar/model/viewModel/mainViewModel.dart';
import 'package:TheChaatBar/view/screens/authentication/sign_in_with_google.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../languageSection/Languages.dart';
import '../../../../theme/CustomAppColor.dart';
import '../../../../utils/Helper.dart';
import '../../../utils/Util.dart';
import '../../component/CustomAlert.dart';
import '../../component/connectivity_service.dart';
import '../../component/custom_button_component.dart';
import '../../component/custom_circular_progress.dart';

class RegisterScreen extends StatefulWidget {
  final String? userId; // Define the 'data' parameter here

  RegisterScreen({Key? key, this.userId}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late double mediaWidth;
  late double screenHeight;
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;
  bool sheetPasswordVisible = false;
  bool sheetConfirmPasswordVisible = false;
  bool isLoading = false;
  var _connectivityService = ConnectivityService();
  static const maxDuration = Duration(seconds: 2);

  bool inputValid = false;
  bool isDarkMode = false;
  String? deviceToken;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Helper.getFirebaseToken().then((token) {
      setState(() {
        deviceToken = token;
      });
    });
    passwordVisible = true;
    confirmPasswordVisible = true;
    sheetPasswordVisible = true;
    sheetConfirmPasswordVisible = true;
    inputValid = false;
    isDarkMode = false;
  }

  void _isValidInput() {
    //print(input);
    if (_emailController.text.isNotEmpty &&
        _nameController.text.isNotEmpty &&
        _lastNameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _passwordController.text.length >= 8 &&
        _passwordController.text == _confirmPasswordController.text &&
        EmailValidator.validate(_emailController.text)) {
      setState(() {
        inputValid = true;
      });
    } else {
      setState(() {
        inputValid = false;
      });
    }
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _sheetPhoneController = TextEditingController();
  final TextEditingController _sheetPasswordController =
      TextEditingController();
  final TextEditingController _sheetConfirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    mediaWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    ApiResponse apiResponse = Provider.of<MainViewModel>(context).response;
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        Navigator.pushReplacementNamed(context, "/LoginScreen");
      },
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            hideKeyBoard();
          },
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/backtwo.png"), fit: BoxFit.fill)),
            child: Stack(
              children: [
                CustomScrollView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Container(
                        height: 100,
                        width: mediaWidth,
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        )),
                      ),
                    ),
                    SliverFillRemaining(
                      hasScrollBody: false,
                      fillOverscroll: true,
                      child: Container(
                        height: screenHeight,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Register",
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18.0, vertical: 10),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    buildTextInput(
                                        context,
                                        "Enter ${Languages.of(context)!.labelName}",
                                        _nameController,
                                        Icons.account_box_outlined),
                                    SizedBox(width: 5),
                                    buildTextInput(
                                        context,
                                        "Enter ${Languages.of(context)!.labelLastname}",
                                        _lastNameController,
                                        Icons.account_box_outlined),
                                    _buildEmailInput(
                                        context,
                                        "Your ${Languages.of(context)!.labelEmail}",
                                        _emailController,
                                        Icons.email_outlined),
                                    _buildPhoneInput(
                                        context,
                                        "Your ${Languages.of(context)!.labelPhoneNumber}",
                                        _phoneController,
                                        Icons.call),
                                    _buildPasswordTextField(
                                        context,
                                        Languages.of(context)!.labelPassword,
                                        _passwordController,
                                        passwordVisible,
                                        isDarkMode,
                                        "password",
                                        Icons.password),
                                    _buildPasswordTextField(
                                        context,
                                        Languages.of(context)!.labelConfirmPass,
                                        _confirmPasswordController,
                                        confirmPasswordVisible,
                                        isDarkMode,
                                        "confirmPassword",
                                        Icons.verified_user),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: _buildConfirmButton(context, null),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Center(
                                child: Text(
                              "OR",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            )),
                            SizedBox(
                              height: 5,
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: () async {
                                  User? user = await signInWithGoogle(
                                      context, "$deviceToken");

                                  if (user != null) {
                                    _showModal(context, user);
                                    print("Signed in: ${user.displayName}");
                                  }
                                },
                                child: Container(
                                  height: 50,
                                  width: mediaWidth * 0.55,
                                  margin: EdgeInsets.symmetric(
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColor.Primary,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        "assets/google_logo.png",
                                        width: 22,
                                        color: Colors.white,
                                        fit: BoxFit.fill,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 8.0),
                                        alignment: Alignment.center,
                                        child: Text('Sign up with Google',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Have an account?",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black54),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, "/LoginScreen");
                                    },
                                    child: Text(
                                      "Sign in",
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ],
                            ),
                          ],
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
                            child: CustomCircularProgress(),
                          ),
                        ],
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _checkValidInput() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    String? emailError = validateEmail(email);
    String? passwordError = validatePasswordMessage(password);

    if (emailError == null && passwordError == null) {
      setState(() {
        inputValid = true;
      });
    } else {
      if (_emailController.text.isEmpty && _emailController.text.length > 2) {
        CustomAlert.showToast(
            context: context, message: emailError, duration: maxDuration);
      } else if (_nameController.text.isEmpty) {
        CustomAlert.showToast(
            context: context,
            message: "Please enter name",
            duration: maxDuration);
      } else if (_lastNameController.text.isEmpty) {
        CustomAlert.showToast(
            context: context,
            message: "Please enter last name",
            duration: maxDuration);
      } else if (_emailController.text.isEmpty) {
        CustomAlert.showToast(
            context: context,
            message: "Please enter email address",
            duration: maxDuration);
      } else if (_phoneController.text.isEmpty) {
        CustomAlert.showToast(
            context: context,
            message: "Please enter phone number",
            duration: maxDuration);
      } else if (_passwordController.text.isEmpty) {
        CustomAlert.showToast(
            context: context,
            message: "Please enter password",
            duration: maxDuration);
      } else if (_confirmPasswordController.text.isEmpty) {
        CustomAlert.showToast(
            context: context,
            message: "Please enter confirm password",
            duration: maxDuration);
      } else if (_passwordController.text != _confirmPasswordController.text) {
        CustomAlert.showToast(
            context: context,
            message: "${Languages.of(context)?.labelPasswordDoesntMatch}",
            duration: maxDuration);
      } else if (passwordError != null && _passwordController.text.length > 3) {
        CustomAlert.showToast(
            context: context, message: passwordError, duration: maxDuration);
      } else if (_confirmPasswordController.text.isEmpty &&
          _confirmPasswordController.text.length > 3) {
        CustomAlert.showToast(
            context: context, message: passwordError, duration: maxDuration);
      }
      setState(() {
        inputValid = false;
      });
    }
  }

  String? validateEmail(String email) {
    if (email.isEmpty) {
      return "Email cannot be empty";
    }

    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(email)) {
      return "Enter a valid email address";
    }

    return null; // Email is valid
  }

  bool validatePassword(String password) {
    String pattern =
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$&*~]).{8,}$';

    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(password);
  }

  String? validatePasswordMessage(String password) {
    if (password.isEmpty) {
      return "Password cannot be empty";
    } else if (password.length < 8) {
      return "Password must be at least 8 characters long";
    } else if (!RegExp(r'[a-z]').hasMatch(password)) {
      return "Password must contain at least one lowercase letter";
    } else if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return "Password must contain at least one uppercase letter";
    } else if (!RegExp(r'[0-9]').hasMatch(password)) {
      return "Password must contain at least one number";
    } else if (!RegExp(r'[!@#\$&*~]').hasMatch(password)) {
      return "Password must contain at least one special character (!@#\$&*~)";
    }
    return null; // Password is valid
  }

  Widget _buildEmailInput(BuildContext context, String text,
      TextEditingController emailController, IconData icon) {
    return Container(
      width: mediaWidth,
      margin: EdgeInsets.symmetric(vertical: 6.0),
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        border: Border.all(
            color: isDarkMode ? Colors.grey : Colors.white, width: 0.4),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.01),
            // Shadow color
            offset: Offset(0, 1),
            // Adjust X and Yoffset to match Figma
            blurRadius: 10,
            // Adjust this for more/less blur
            spreadRadius: 0.6, // Adjust spread if needed
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
            maxLength: 30,
            style: TextStyle(fontSize: 14),
            decoration: InputDecoration(
              border: InputBorder.none,
              errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 0.4)),
              hintText: text,
              hintStyle: TextStyle(fontSize: 11, color: Colors.grey),
              counterText: "",
              icon: Icon(
                icon,
                size: 14,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter an email address";
              }
              final emailRegex =
                  RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
              if (!emailRegex.hasMatch(value)) {
                return "Please enter a valid email address";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneInput(BuildContext context, String text,
      TextEditingController emailController, IconData icon) {
    return Container(
      width: mediaWidth,
      margin: EdgeInsets.symmetric(vertical: 6.0),
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        border: Border.all(
            color: isDarkMode ? Colors.grey : Colors.white, width: 0.4),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.01),
            // Shadow color
            offset: Offset(0, 1),
            // Adjust X and Yoffset to match Figma
            blurRadius: 10,
            // Adjust this for more/less blur
            spreadRadius: 0.6, // Adjust spread if needed
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            maxLength: 10,
            style: TextStyle(fontSize: 14),
            decoration: InputDecoration(
              border: InputBorder.none,
              errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 0.4)),
              hintText: text,
              hintStyle: TextStyle(fontSize: 11, color: Colors.grey),
              counterText: "",
              icon: Icon(
                icon,
                size: 14,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty || value.length != 10) {
                return "Please enter a valid phone number";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget buildTextInput(BuildContext context, String text,
      TextEditingController nameController, IconData icon) {
    return Container(
      width: mediaWidth,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        border: Border.all(
          color: isDarkMode ? Colors.grey : Colors.white,
          width: 0.4,
        ),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.01),
            offset: Offset(0, 1),
            blurRadius: 10,
            spreadRadius: 0.6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: nameController,
            style: TextStyle(fontSize: 14),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Enter your $text",
              hintStyle: TextStyle(fontSize: 11, color: Colors.grey),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 16.0, horizontal: 0.0),
              // Adjust padding
              icon: Icon(
                icon,
                size: 14,
              ),
              counterText: "",
              errorStyle: TextStyle(fontSize: 11, height: 1),
              // Reduces error text size
              errorMaxLines: 2,
              // Allows error messages to wrap properly
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 0.4),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter a $text";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordTextField(
      BuildContext context,
      String text,
      TextEditingController passwordController,
      bool visibility,
      bool isDarkMode,
      String type,
      IconData icon) {
    return Container(
      width: mediaWidth,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        border: Border.all(
          color: isDarkMode ? Colors.grey : Colors.white,
          width: 0.4,
        ),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.01),
            offset: Offset(0, 1),
            blurRadius: 10,
            spreadRadius: 0.6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: passwordController,
            obscureText: visibility,
            style: TextStyle(fontSize: 14),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: text,
              hintStyle: TextStyle(fontSize: 11, color: Colors.grey),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 16.0, horizontal: 0.0),
              // Adjust padding
              icon: Icon(
                icon,
                size: 14,
              ),
              counterText: "",
              errorStyle: TextStyle(fontSize: 11, height: 1),
              // Reduces error text size
              errorMaxLines: 2,
              // Allows error messages to wrap properly
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 0.4),
              ),
              suffixIcon: GestureDetector(
                child: Icon(
                  visibility ? Icons.visibility : Icons.visibility_off,
                  size: 16,
                ),
                onTap: () {
                  setState(
                    () {
                      if (type == "password") {
                        passwordVisible = !passwordVisible;
                      } else if (type == "confirmPassword") {
                        confirmPasswordVisible = !confirmPasswordVisible;
                      } else if (type == "sheetPassword") {
                        sheetPasswordVisible = !sheetPasswordVisible;
                      } else if (type == "sheetConfirmPassword") {
                        sheetConfirmPasswordVisible =
                            !sheetConfirmPasswordVisible;
                      }
                    },
                  );
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "$text is required";
              }
              if (!hasMinLength(value)) {
                return "$text must be at least 8 characters long";
              }
              if (!hasUppercase(value)) {
                return "$text must contain at least one uppercase letter";
              }
              if (!hasDigit(value)) {
                return "$text must contain at least one digit";
              }
              if (!hasSpecialCharacter(value)) {
                return "$text must contain at least one special character";
              }
              if (_passwordController.text != _confirmPasswordController.text) {
                return "Password doesn't match";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context, User? user) {
    return MaterialButton(
      onPressed: () async {
        //_checkValidInput();
        _isValidInput();
        if (_formKey.currentState?.validate() == true) {
        } else {
          print("Not Validated");
        }
        if (inputValid) {
          _signUp(user);
        }
      },
      color: AppColor.ButtonBackColor,
      minWidth: mediaWidth * 0.55,
      padding: EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          side: BorderSide(width: 0.1, color: Colors.white)),
      child: Text(
        Languages.of(context)!.labelSignup,
        style: TextStyle(fontSize: 14, color: Colors.white),
      ),
    );
  }

  void Validate(String email) {
    bool isValid = EmailValidator.validate(email);
    print(isValid);
  }

  _signUp(User? user) async {
    hideKeyBoard();
    _isValidInput();
    print(_nameController.text);
    if (inputValid) {
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
        SignUpRequest request = SignUpRequest(
            customer: CustomerSignUp(
          deviceToken: "deviceToken",
          email: _emailController.text,
          password: _passwordController.text,
          firstName: _nameController.text,
          lastName: _lastNameController.text,
          phoneNumber: _phoneController.text,
        ));

        await Provider.of<MainViewModel>(context, listen: false).signUpData(
            "api/v1/app/temp_customers/initiate_temp_customer", request);
        ApiResponse apiResponse =
            Provider.of<MainViewModel>(context, listen: false).response;
        getSignUpResponse(context, apiResponse, request);
      }
    }
  }

  Future<void> _saveChanges(
      String phoneNo, String password, BuildContext context, User? user) async {
    hideKeyBoard();

    SignUpRequest request = SignUpRequest(
        customer: CustomerSignUp(
      deviceToken: deviceToken,
      password: password,
      email: "${user?.email}",
      firstName: extractNames("${user?.displayName}", true),
      lastName: extractNames("${user?.displayName}", false),
      phoneNumber: phoneNo,
    ));

    await Provider.of<MainViewModel>(context, listen: false).signUpData(
        "api/v1/app/temp_customers/initiate_temp_customer", request);
    ApiResponse apiResponse =
        Provider.of<MainViewModel>(context, listen: false).response;
    getSignUpResponse(context, apiResponse, request);
  }

  Future<Widget> getSignUpResponse(BuildContext context,
      ApiResponse apiResponse, SignUpRequest request) async {
    SignUpInitializeResponse? signUpResponse =
        apiResponse.data as SignUpInitializeResponse?;
    String? message = apiResponse.message.toString();
    setState(() {
      isLoading = false;
    });
    switch (apiResponse.status) {
      case Status.LOADING:
        return Center(child: CircularProgressIndicator());
      case Status.COMPLETED:
        print("GetSetUpAccountWidget : ${signUpResponse?.phoneNumber}");
        await Helper.savePassword(_passwordController.text);

        if (_phoneController.text.isNotEmpty) {
          Navigator.pushNamed(context, "/OTPVerifyScreen",
              arguments: "${_phoneController.text}");
        } else {
          Navigator.pushNamed(context, "/OTPVerifyScreen",
              arguments: "${request.customer?.phoneNumber}");
        }
        return Container();
      case Status.ERROR:
        if (message.contains("Invalid Request")) {
          message =
              "Something went wrong, Please signup normally for the time being";
        }
        //Navigator.pop(context);
        CustomAlert.showToast(context: context, message: message);
        return Center(
          child: Text('Try again later..'),
        );
      case Status.INITIAL:
      default:
        return Center(
          child: Text(''),
        );
    }
  }

  void _showModal(BuildContext context, User? user) {
    showDialog<void>(
        context: context,
        barrierDismissible: true,
        useSafeArea: true,
        builder: (BuildContext context) {
          bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
          TextEditingController phoneController = TextEditingController();
          TextEditingController passwordController = TextEditingController();
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 10),
            title: Text("Please enter following details to proceed"),
            content: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 2,
                  ),
                  Text("Signing up as: ${user?.displayName}"),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    "Email : ${user?.email}",
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                    margin: EdgeInsets.symmetric(vertical: 4.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color:
                            isDarkMode ? AppColor.CardDarkColor : Colors.white,
                        border: Border.all(color: Colors.grey, width: 0.5)),
                    child: Row(
                      children: [
                        SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            style: TextStyle(
                              fontSize: 12.0,
                            ),
                            obscureText: false,
                            obscuringCharacter: "*",
                            controller: phoneController,
                            onChanged: (value) {},
                            onSubmitted: (value) {},
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: Languages.of(context)!.labelPhoneNumber,
                              hintStyle:
                                  TextStyle(fontSize: 13, color: Colors.grey),
                              icon: Icon(
                                Icons.call,
                                size: 16,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              CustomButtonComponent(
                  text: "Continue",
                  mediaWidth: MediaQuery.of(context).size.width,
                  textColor: Colors.white,
                  buttonColor: AppColor.Primary,
                  isDarkMode: isDarkMode,
                  verticalPadding: 10,
                  onTap: () {
                    _saveChanges(
                        phoneController.text, "googlesign1", context, user);
                  })
            ],
            actionsAlignment: MainAxisAlignment.center,
          );
        });
  }
}
