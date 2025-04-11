import 'package:TheChaatBar/utils/Helper.dart';
import 'package:TheChaatBar/view/component/CustomAlert.dart';
import 'package:TheChaatBar/view/screens/authentication/forgotPassword/changePasswordScreen.dart';
import 'package:TheChaatBar/view/screens/authentication/forgotPassword/forgotPasswordScreen.dart';
import 'package:TheChaatBar/view/screens/authentication/welcomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'languageSection/AppLocalizationsDelegate.dart';
import 'languageSection/LanguageList.dart';
import 'model/request/verifyOtpChangePass.dart';
import 'model/response/createOrderResponse.dart';
import 'model/response/notificationOtpResponse.dart';
import 'model/response/productListResponse.dart';
import 'model/response/successCallbackResponse.dart';
import 'model/response/vendorListResponse.dart';
import 'model/services/AuthenticationProvider.dart';
import 'model/services/PushNotificationService.dart';
import 'model/viewModel/mainViewModel.dart';
import 'theme/CustomAppColor.dart';
import 'theme/CustomAppTheme.dart';
import 'view/component/my_navigator_observer.dart';
import 'view/component/toastMessage.dart';
import 'view/screens/authentication/forgotPassword/otp_forgot_pass_screen.dart';
import 'view/screens/authentication/loginScreen.dart';
import 'view/screens/authentication/otpVerifyScreen.dart';
import 'view/screens/authentication/registerScreen.dart';
import 'view/screens/authentication/splashScreen.dart';
import 'view/screens/bottomNavigation.dart';
import 'view/screens/choose_locality_screen.dart';
import 'view/screens/homeScreen.dart';
import 'view/screens/order/cartScreen.dart';
import 'view/screens/order/coupons_screen.dart';
import 'view/screens/order/itemDetailScreen.dart';
import 'view/screens/order/itemOverviewScreen.dart';
import 'view/screens/order/menuScreen.dart';
import 'view/screens/order/paymentCardScreen.dart';
import 'view/screens/order/paymentSuccessfulScreen.dart';
import 'view/screens/order/product_detail_screen.dart';
import 'view/screens/orderHistory/activeOrdersScreen.dart';
import 'view/screens/porfile/edit_info_screen.dart';
import 'view/screens/porfile/edit_profile_screen.dart';
import 'view/screens/porfile/profile_screen.dart';
import 'view/screens/vendor_screen.dart';
import 'view/screens/vendorsListScreen.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await setupFlutterNotifications();
  print('Handling a background message ${message.messageId}');
}

late AndroidNotificationChannel channel;
bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Initialize Firebase
  await Firebase.initializeApp();

  // Handle background messages
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Setup interaction with notifications
  await PushNotificationService().setupInteractedMessage();

  // Request notification permissions
  final permissionStatus = await Permission.notification.status;
  if (permissionStatus.isDenied) {
    await Permission.notification.request();
  }

  var retrievedToken = await Helper.getUserToken();
  // Get initial message
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    print("FirebaseMessaging:: $initialMessage");
  }

  // Set preferred orientations and run app
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(MyApp(initialMessage: null));

  // Clear all notifications when app is resumed or opened
  WidgetsBinding.instance.addPostFrameCallback((_) {
    FlutterLocalNotificationsPlugin().cancelAll();
  });
}

class MyApp extends StatefulWidget {
  final RemoteMessage? initialMessage;

  MyApp({this.initialMessage});

  @override
  _MyAppState createState() => _MyAppState(initialMessage);
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  Locale _locale = const Locale('en');
  late String? _appTheme = 'Light';
  final RemoteMessage? initialMessage;

  ThemeMode _themeMode = ThemeMode.system;

  _MyAppState(this.initialMessage);

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  void _toggleTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  void setupNotificationHandlers(BuildContext context) {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      CustomAlert.showToast(context: context, message: "$message");
      // Navigate to the ProfileScreen when the notification is clicked
      final notificationResponse =
          NotificationOtpResponse.fromJson(message.data);
      /* Navigator.push(
        navigatorKey.currentState!.context,
        MaterialPageRoute(
            builder: (context) => NotificationOtpScreen(
              data: notificationResponse,
            )),
      );*/
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColor.AppBar,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ));
    return MultiProvider(
      providers: [
        Provider<FirebaseAuth>(
          create: (_) => FirebaseAuth.instance,
        ),
        ChangeNotifierProvider<AuthenticationProvider>(
          create: (context) =>
              AuthenticationProvider(context.read<FirebaseAuth>()),
        ),
        ChangeNotifierProvider(create: (context) => MainViewModel()),
      ],
      child: MaterialApp(
          navigatorObservers: [MyNavigatorObserver()],
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          title: 'Chaat_Bar',
          locale: _locale,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            AppLocalizationsDelegate()
          ],
          onGenerateRoute: (settings) {
            if (settings.name == '/CartScreen') {
              return _createPopupRoute();
            }
            return null;
          },
          supportedLocales: LanguageList.all,
          theme: AppTheme.getAppTheme(),
          initialRoute: '/',
          routes: {
            '/': (context) {
              NotificationOtpResponse? notificationResponse =
                  NotificationOtpResponse(otp: "", notificationType: "");
              if (initialMessage?.data != null) {
                notificationResponse =
                    NotificationOtpResponse.fromJson(initialMessage!.data);
              }
              return SplashScreen(data: notificationResponse);
            },
            '/ChooseLocalityScreen': (context) {
              final args =
                  ModalRoute.of(context)?.settings.arguments as String?;
              return ChooseLocalityScreen(
                data: args ?? '',
              );
            },
            '/VendorsListScreen': (context) => VendorsListScreen(),
            '/LoginScreen': (context) => LoginScreen(),
            '/ActiveOrdersScreen': (context) => ActiveOrdersScreen(),
            '/VendorScreen': (context) => VendorScreen(),
            '/HomeScreen': (context) => HomeScreen(),
            '/BottomNavigation': (context) =>
                BottomNavigation(onThemeChanged: _toggleTheme),
            '/RegisterScreen': (context) => RegisterScreen(),
            '/EditProfileScreen': (context) => EditProfileScreen(),
            '/CouponsScreen': (context) => CouponsScreen(),
            '/EditInformationScreen': (context) => EditInformationScreen(),
            '/ForgotPasswordScreen': (context) => ForgotPasswordScreen(),
            '/WelcomeScreen': (context) => WelcomeScreen(),
            '/ProfileScreen': (context) => ProfileScreen(
                  onThemeChanged: _toggleTheme,
                ),
            '/CartScreen': (context) {
              return CartScreen();
            },
            '/ProductDetailScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as ProductData;
              return ProductDetailScreen(
                data: args,
              );
            },
            '/MenuScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as VendorData;
              return MenuScreen(
                data: args,
              );
            },
            '/OTPVerifyScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as String?;
              return OTPVerifyScreen(
                data: args,
              );
            },
            '/PaymentSuccessfulScreen': (context) {
              final args = ModalRoute.of(context)!.settings.arguments
                  as SuccessCallbackResponse?;
              return PaymentSuccessfulScreen(data: args);
            },
            '/ItemOverviewScreen': (context) {
              final args = ModalRoute.of(context)!.settings.arguments
                  as CreateOrderResponse?;
              return ItemOverviewScreen(data: args);
            },
            '/ItemDetailScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as OrderDetails;
              return ItemDetailScreen(order: args);
            },
            '/OtpForgotPassScreen': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as String?;
              return OtpForgotPassScreen(data: args);
            },
            '/ChangePasswordScreen': (context) {
              final args = ModalRoute.of(context)!.settings.arguments
                  as VerifyOtChangePassRequest?;
              return ChangePasswordScreen(data: args);
            },
            '/PaymentCardScreen': (context) {
              final args = ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>?;
              return PaymentCardScreen(
                data: args?['data'] as String?,
                orderData: args?['orderData'] as CreateOrderResponse,
              );
            },
          }),
    );
  }

  void _fetchData() async {
    await Future.delayed(Duration(milliseconds: 2));
    var selectedLanguage = await Helper.getLocale();
    var selectedAppTheme = 'Light';
    print(selectedLanguage.languageCode);
    Helper.getAppThemeMode().then((appTheme) {
      setState(() {
        selectedAppTheme =
            "$appTheme" != "null" ? "$appTheme" : selectedAppTheme;
        _appTheme = '$selectedAppTheme';

        if ("$_appTheme" == "Default") {
          print("value $_appTheme");
          _toggleTheme(ThemeMode.system);
        } else if ("$_appTheme" == "Light") {
          _toggleTheme(ThemeMode.light);
        } else if ("$_appTheme" == "Dark") {
          _toggleTheme(ThemeMode.dark);
        } else {
          _toggleTheme(ThemeMode.light);
        }
      });
    });
    // Ensure that setState is called synchronously after the async work is done
    if (mounted) {
      setState(() {
        _locale = Locale(selectedLanguage.languageCode);
      });
    }
  }

  Route _createPopupRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => CartScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Scale transition for pop-up effect
        const begin = 0.0;
        const end = 1.0;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return ScaleTransition(
          scale: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
