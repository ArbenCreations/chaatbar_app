import 'package:flutter/cupertino.dart';

class MyNavigatorObserver extends NavigatorObserver {
  final Map<String, VoidCallback> callbacks = {};

  void registerCallback(String routeName, VoidCallback callback) {
    callbacks[routeName] = callback;
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final previousRouteName = previousRoute?.settings.name;
    if (previousRouteName != null && callbacks.containsKey(previousRouteName)) {
      callbacks[previousRouteName]?.call();
    }
  }
}
