import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:peach_cars/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peach_cars/providers/locale_provider.dart';
import 'package:peach_cars/providers/theme_provider.dart';
import 'package:peach_cars/screens/buy_car_screen.dart';
import 'package:peach_cars/screens/car_detail_screen.dart';
import 'package:peach_cars/screens/home_screen.dart';
import 'package:peach_cars/screens/login_screen.dart';
import 'package:peach_cars/screens/onboarding_screen.dart';
import 'package:peach_cars/screens/peach_processes_screen.dart';
import 'package:peach_cars/screens/profile_screen.dart';
import 'package:peach_cars/screens/refer_friend_screen.dart';
import 'package:peach_cars/screens/register_screen.dart';
import 'package:peach_cars/screens/sell_car_screen.dart';
import 'package:peach_cars/screens/splash_screen.dart';
import 'package:peach_cars/screens/wishlist_screen.dart';
import 'package:peach_cars/utilites/navigation.dart';
import 'package:peach_cars/utilites/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: PeachCarsApp()));
}

class PeachCarsApp extends ConsumerWidget {
  const PeachCarsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      title: 'Peach Cars',
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.navigatorKey,
      theme: PeachTheme.light,
      darkTheme: PeachTheme.dark,
      themeMode: themeMode,
      locale: locale,
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
        Locale('sw'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: AppRoutes.splash,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRoutes.splash:
            return _route(const SplashScreen(), settings);
          case AppRoutes.onboarding:
            return _route(const OnboardingScreen(), settings);
          case AppRoutes.login:
            return _route(const LoginScreen(), settings);
          case AppRoutes.register:
            return _route(const RegisterScreen(), settings);
          case AppRoutes.home:
            return _route(const HomeScreen(), settings);
          case AppRoutes.buyCar:
            final filter = settings.arguments as String?;
            return _route(BuyCarScreen(initialFilter: filter), settings);
          case AppRoutes.carDetail:
            final carId = settings.arguments as String;
            return _route(CarDetailScreen(carId: carId), settings);
          case AppRoutes.wishlist:
            return _route(const WishlistScreen(), settings);
          case AppRoutes.sellCar:
            return _route(const SellCarScreen(), settings);
          case AppRoutes.profile:
            return _route(const ProfileScreen(), settings);
          case AppRoutes.referFriend:
            return _route(const ReferFriendScreen(), settings);
          case AppRoutes.peachProcesses:
            return _route(const PeachProcessesScreen(), settings);
          default:
            return _route(const SplashScreen(), settings);
        }
      },
    );
  }

  PageRouteBuilder _route(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) => FadeTransition(
        opacity: CurvedAnimation(parent: anim, curve: Curves.easeIn),
        child: child,
      ),
      transitionDuration: const Duration(milliseconds: 220),
    );
  }
}
