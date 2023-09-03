import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:wow_shopping/app/app.dart';
import 'package:wow_shopping/setup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setup();
  await initializeDateFormatting();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  Intl.defaultLocale = PlatformDispatcher.instance.locale.toLanguageTag();
  runApp(const ShopWowApp(
    config: AppConfig(
      env: AppEnv.dev,
    ),
  ));
}
