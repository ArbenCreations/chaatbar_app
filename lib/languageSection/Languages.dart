import 'package:flutter/cupertino.dart';

abstract class Languages {
  static Languages? of(BuildContext context) {
    return Localizations.of<Languages>(context, Languages);
  }

  String get appName;

  String get labelSubmit;

  String get labelEnterCode;

  String get labelSentCode;

  String get labelResendCode;

  String get labelValidate;

  String get labelName;

  String get labelLastname;

  String get labelEmail;

  String get labelDOB;

  String get labelPassword;

  String get labelConfirmPass;

  String get labelConfirm;

  String get labelLogin;

  String get labelLogout;

  String get labelHi;

  String get labelStandard;

  String get labelTotalBalance;

  String get labelINR;

  String get labelUSD;

  String get labelZero;

  String get labelAddMoney;

  String get labelSend;

  String get labelExchange;

  String get labelNews;

  String get labelHome;

  String get labelRewards;

  String get labelTransfer;

  String get labelTransaction;

  String get labelPayment;

  String get labelProfile;

  String get labelAccountDetails;

  String get labelPersonalInfo;

  String get labelEditPersonalInfo;

  String get labelSecurity;

  String get labelStepVerification;

  String get labelPaymentMethod;

  String get labelAddedCard;

  String get labelHelpSupport;

  String get labelSettings;

  String get labelVerifyEmail;

  String get labelVerifyEmailContent;

  String get labelUserId;

  String get labelChangePass;

  String get labelEmailVerified;

  String get labelEmailVerifiedContent;

  String get labelOldPass;

  String get labelNewPass;

  String get labelForgotPass;

  String get labelProceed;

  String get labelPersonalData;

  String get labelAddress;

  String get completeProfile;

  String get labelBirthdate;

  String get labelChooseDoc;

  String get labelDocNo;

  String get labelStreetName;

  String get labelStreetNo;

  String get labelCountry;

  String get labelIndia;

  String get labelState;

  String get labelCity;

  String get labelPostalCode;

  String get labelTransferContent;

  String get labelPaymentScreen;

  String get labelComingSoon;

  String get availablePayario;

  String get labelRedeemBal;

  String get labelPayarioPts;

  String get labelFirstname;

  String get labelAddressDetails;

  String get labelLanguage;

  String get labelEnterAmount;

  String get labelKYCVerification;

  String get labelVerifyYourEmail;

  String get verifyEmailSubTitle;

  String get labelEnterEmail;

  String get labelEnterOtpSentToEmail;

  String get labelMoneyTransfer;

  String get labelMoneyTransferOverview;

  String get labelPending;

  String get labelRejected;

  String get labelInComplete;

  String get labelEnterValidPhone;

  String get labelNoInternetConnection;

  String get labelSuccess;

  String get labelInvalidAccessToken;

  String get labelPhoneNumber;

  String get labelSignup;

  String get labelPasswordAlert;

  String get labelPasswordDoesntMatch;

  String get labelPleaseEnterAllDetails;

  String get labelOtpVerification;

  String get labelPleaseEnterValidPhoneNo;

  String get labelResendOtp;

  String get labelPhoneVerification;

  String get labelEnterPhoneNo;

  String get labelSendConfirmationCode;

  String get labelAlreadyHaveAnAcc;

  String get labelSelectDob;

  String get labelEnterValidDate;

  String get labelEnterDateInValidRange;

  String get labelDeleteAccount;
}
