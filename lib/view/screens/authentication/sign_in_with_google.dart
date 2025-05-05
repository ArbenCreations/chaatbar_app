import 'package:TheChaatBar/model/request/signUpWithGoogleRequest.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../../../languageSection/Languages.dart';
import '../../../../model/apis/apiResponse.dart';
import '../../../../model/request/editProfileRequest.dart';
import '../../../../model/response/loginResponse.dart';
import '../../../../model/response/profileResponse.dart';
import '../../../../model/viewModel/mainViewModel.dart';
import '../../../../theme/CustomAppColor.dart';
import '../../../../utils/Helper.dart';
import '../../../../utils/Util.dart';
import '../../component/CustomAlert.dart';
import '../../component/custom_button_component.dart';
import '../../component/session_expired_dialog.dart';
import '../../component/toastMessage.dart';

Future<User?> signInWithGoogle(context, String deviceToken) async {
  try {
    await GoogleSignIn().signOut();
    // Start the sign-in process
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      // The user canceled the sign-in
      return null;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    print("idToken: ${googleAuth.idToken}");

    // Sign in with Firebase using the credential
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    //_showModal(context, userCredential.user);
   // _signInWithGoogle(userCredential.user, "${googleAuth.idToken}", context, deviceToken);

    // Return the signed-in user
    return userCredential.user;
  } catch (e) {
    print('Error signing in with Google: $e');
    return null;
  }
}

Future<void> _signInWithGoogle(User? user, String idToken, BuildContext context,
    String deviceToken) async {
  //Navigator.pushNamed(context, "/VendorScreen");
  const maxDuration = Duration(seconds: 2);
  if (user != null) {
    SignUpWithGoogleRequest request = SignUpWithGoogleRequest(
        customer: CustomerSignUpWithGoogle(
            email: "${user.email}",
            idToken: idToken,
            firstName: extractNames("${user.displayName}", true),
            lastName: extractNames("${user.displayName}", false),
            deviceToken: deviceToken,
            loginType: "google",
            phoneNumber: ""));

    await Provider.of<MainViewModel>(context, listen: false)
        .signInWithGoogle("/api/v1/app/customers/google_sign_in", request);

    ApiResponse apiResponse =
        Provider.of<MainViewModel>(context, listen: false).response;
    getSignInResponse(context, apiResponse, user);
  }
}

Future<void> getSignInResponse(
    BuildContext context, ApiResponse apiResponse, User? user) async {
  LoginResponse? mediaList = apiResponse.data as LoginResponse?;

  switch (apiResponse.status) {
    case Status.LOADING:
      return;
    case Status.COMPLETED:
      print("GetSignInResponse : ${mediaList}");
      ProfileResponse data = ProfileResponse(
        phoneNumber: mediaList?.customer?.phoneNumber,
        id: mediaList?.customer?.id,
        email: mediaList?.customer?.email,
        lastName: mediaList?.customer?.lastName,
        firstName: mediaList?.customer?.firstName,
      );
      Helper.saveProfileDetails(data);
      print("mediaList?.newUser : ${mediaList?.newUser}");

      String token = "${mediaList?.token}";
      print("token :: $token ");
      bool isSaved = await Helper.saveUserToken(token);

      // Check if the token was saved successfully
      if (isSaved) {

      } else {
        print('Failed to save token.');
      }
      if (mediaList?.newUser == true) {
        //_showModal(context, user, "${mediaList?.customer?.id}");
      } else {
        Navigator.pushReplacementNamed(context, "/VendorsListScreen");
      }

      break;
      break;
// Return an empty container as you'll navigate away
    case Status.ERROR:
      print("message : ${apiResponse.message}");
      CustomAlert.showToast(context: context, message: apiResponse.message);
      return;
    case Status.INITIAL:
      return;
    default:
      return;
  }
}

Future<void> _saveChanges(
    String phoneNo, BuildContext context, String userId, User? user) async
{
  hideKeyBoard();

  EditProfileRequest request = EditProfileRequest(
    phoneNumber: phoneNo,
    email: "${user?.email}",
    firstName: extractNames("${user?.displayName}", true),
    lastName: extractNames("${user?.displayName}", false),
  );
  await Future.delayed(Duration(milliseconds: 2));
  await Provider.of<MainViewModel>(context, listen: false)
      .editProfile("/api/v1/app/customers/$userId/update_profile", request);
  ApiResponse apiResponse =
      Provider.of<MainViewModel>(context, listen: false).response;
  getProfileResponse(context, apiResponse);
}

Future<Widget> getProfileResponse(
    BuildContext context, ApiResponse apiResponse) async {
  ProfileResponse? mediaList = apiResponse.data as ProfileResponse?;
  print("apiResponse${apiResponse.status}");
  switch (apiResponse.status) {
    case Status.LOADING:
      return Center(child: CircularProgressIndicator());
    case Status.COMPLETED:
      await Helper.saveProfileDetails(mediaList);
      Navigator.pushReplacementNamed(context, "/VendorsListScreen");
      return Container(); // Return an empty container as you'll navigate away
    case Status.ERROR:
      // _fetchDataFromPref();
      print("Message : ${apiResponse.message}");
      if (nonCapitalizeString("${apiResponse.message}") ==
          nonCapitalizeString(
              "${Languages.of(context)?.labelInvalidAccessToken}")) {
        SessionExpiredDialog.showDialogBox(context: context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Something went wrong.'),
            duration: Duration(seconds: 2),
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

void _showModal(BuildContext context, User? user) {
  showDialog<void>(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
        TextEditingController phoneController = TextEditingController();
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 10),
          title: Text("Please enter following details to proceed"),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 5),
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
                      color: isDarkMode ? AppColor.CardDarkColor : Colors.white,
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
                )
                /*_buildPasswordInput(
                      context,
                      Languages.of(context)!.labelPassword,
                      _sheetPasswordController,
                      Icon(
                        Icons.password,
                        size: 16,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      sheetPasswordVisible,
                      isDarkMode,
                      "sheetPassword"),
                  _buildPasswordInput(
                      context,
                      Languages.of(context)!.labelConfirmPass,
                      _sheetConfirmPasswordController,
                      Icon(
                        Icons.password,
                        size: 16,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      sheetConfirmPasswordVisible,
                      isDarkMode,
                      "sheetConfirmPassword"),*/
                ,
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
                  //_saveChanges(phoneController.text, context, userId, user);
                })
          ],
          actionsAlignment: MainAxisAlignment.center,
        );
      });
}
