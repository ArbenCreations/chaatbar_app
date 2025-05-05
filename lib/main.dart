import 'package:TheChaatBar/view/screens/authentication/forgotPassword/changePasswordScreen.dart';
import 'package:TheChaatBar/view/screens/authentication/forgotPassword/forgotPasswordScreen.dart';
import 'package:TheChaatBar/view/screens/authentication/welcomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'languageSection/AppLocalizationsDelegate.dart';
import 'languageSection/LanguageList.dart';
import 'model/request/verifyOtpChangePass.dart';
import 'model/response/createOrderResponse.dart';
import 'model/response/productListResponse.dart';
import 'model/response/successCallbackResponse.dart';
import 'model/response/vendorListResponse.dart';
import 'model/services/AuthenticationProvider.dart';
import 'model/viewModel/mainViewModel.dart';
import 'theme/CustomAppTheme.dart';
import 'view/component/my_navigator_observer.dart';
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

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
bool isFlutterLocalNotificationsInitialized = false;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await setupFlutterNotifications();
  print('Handling a background message ${message.messageId}');
}

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) return;

  channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await setupFlutterNotifications();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    FlutterLocalNotificationsPlugin().cancelAll();
  });
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
          locale: const Locale('en'),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            AppLocalizationsDelegate()
          ],
          supportedLocales: LanguageList.all,
          theme: AppTheme.getAppTheme(),
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
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
            '/BottomNavigation': (context) => BottomNavigation(),
            '/RegisterScreen': (context) => RegisterScreen(),
            '/EditProfileScreen': (context) => EditProfileScreen(),
            '/CouponsScreen': (context) => CouponsScreen(),
            '/EditInformationScreen': (context) => EditInformationScreen(),
            '/ForgotPasswordScreen': (context) => ForgotPasswordScreen(),
            '/WelcomeScreen': (context) => WelcomeScreen(),
            '/ProfileScreen': (context) => ProfileScreen(),
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
}
