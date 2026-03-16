import 'package:flutter/material.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String buyCar = '/buy-car';
  static const String carDetail = '/car-detail';
  static const String wishlist = '/wishlist';
  static const String sellCar = '/sell-car';
  static const String profile = '/profile';
  static const String referFriend = '/refer-friend';
  static const String peachProcesses = '/peach-processes';
}

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<dynamic> pushNamed(String route, {Object? arguments}) {
    return navigatorKey.currentState!
        .pushNamed(route, arguments: arguments);
  }

  static Future<dynamic> pushReplacementNamed(String route,
      {Object? arguments}) {
    return navigatorKey.currentState!
        .pushReplacementNamed(route, arguments: arguments);
  }

  static Future<dynamic> pushNamedAndRemoveUntil(String route,
      {Object? arguments}) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      route,
      (r) => false,
      arguments: arguments,
    );
  }

  static void pop([dynamic result]) {
    navigatorKey.currentState!.pop(result);
  }
}
