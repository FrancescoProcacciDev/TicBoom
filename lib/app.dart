import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ticboom/core/bindings/core_bindings.dart';
import 'package:ticboom/core/config/app_config.dart';
import 'package:ticboom/core/styles/app_base_theme.dart';
import 'package:ticboom/core/view/controllers/theme_controller.dart';
import 'package:ticboom/l10n/app_localizations.dart';

Future<void> bootstrapApp({required AppConfig config}) async {
  final preferences = await SharedPreferences.getInstance();
  CoreBindings(config: config, preferences: preferences).dependencies();

  runApp(const TicboomApp());
}

class TicboomApp extends StatelessWidget {
  const TicboomApp({super.key});

  @override
  Widget build(BuildContext context) {
    final config = Get.find<AppConfig>();
    final router = Get.find<GoRouter>();
    final themeController = Get.find<ThemeController>();

    return Obx(
      () => MaterialApp.router(
        title: config.displayName,
        theme: AppBaseTheme.light,
        darkTheme: AppBaseTheme.dark,
        themeMode: themeController.themeMode.value,
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }
}
