import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:watch_it/watch_it.dart';
import 'package:wow_shopping/app/config.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/backend/auth_repo.dart';
import 'package:wow_shopping/features/login/login_screen.dart';
import 'package:wow_shopping/features/main/main_screen.dart';
import 'package:wow_shopping/features/splash/splash_screen.dart';

export 'package:wow_shopping/app/config.dart';

const _appTitle = 'Shop Wow';
final navigatorKey = GlobalKey<NavigatorState>();

class ShopWowApp extends StatelessWidget with WatchItMixin {
  const ShopWowApp({
    super.key,
    required this.config,
  });

  final AppConfig config;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: appOverlayDarkIcons,
      child: FutureBuilder(
        future: di.allReady(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Theme(
              data: generateLightTheme(),
              child: const Directionality(
                textDirection: TextDirection.ltr,
                child: SplashScreen(),
              ),
            );
          } else {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              navigatorKey: navigatorKey,
              title: _appTitle,
              theme: generateLightTheme(),
              onGenerateRoute: (RouteSettings settings) {
                if (settings.name == Navigator.defaultRouteName) {
                  if (!di<AuthRepo>().isLoggedIn) {
                    return LoginScreen.route();
                  }
                  return MainScreen.route();
                } else {
                  return null; // Page not found
                }
              },
            );
          }
        },
      ),
    );
  }
}
