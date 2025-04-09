import 'package:TheChaatBar/view/screens/porfile/profile_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

import '../../theme/CustomAppColor.dart';
import '../../utils/Helper.dart';
import 'homeScreen.dart';
import 'orderHistory/orderHistoryScreen.dart';

class BottomNavigation extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;

  BottomNavigation({required this.onThemeChanged});

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  int _selectedIndex = 1;
  final LocalAuthentication auth = LocalAuthentication();
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _authOnResume = false;
  bool? isUserAuthenticated;
  static List<Widget> _widgetOptions = <Widget>[];
  Color primaryColor = AppColor.Primary;
  Color? secondaryColor = Colors.red[100];
  Color? lightColor = Colors.red[50];
  int _currentIndex = 0;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      OrderHistoryScreen(),
      HomeScreen(),
      ProfileScreen(onThemeChanged: widget.onThemeChanged),
    ];
    Helper.getUserAuthenticated().then((onValue) {
      isUserAuthenticated = onValue;
    });
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.bounceIn,
    );
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    _animationController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _animationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        extendBody: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: CurvedNavigationBar(
          index: _selectedIndex,
          height: 60.0,
          backgroundColor: AppColor.BackgroundColor,
          color: AppColor.Primary, // Set the bar's background color
          animationDuration: Duration(milliseconds: 300),
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
              _onItemTapped(index);
              Future.delayed(Duration(milliseconds: 100), () {
                if (_pageController.hasClients) {
                  _pageController.animateToPage(
                    index,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                }
              });
            });
          },
          items: <Widget>[
            Icon(Icons.history, size: 26, color: Colors.white),
            Icon(Icons.home_rounded, size: 30, color: Colors.white),
            Icon(Icons.person, size: 26, color: Colors.white),
          ],
        ));
  }
}
