import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ticboom/core/bindings/core_bindings.dart';
import 'package:ticboom/core/config/app_config.dart';
import 'package:ticboom/core/questions/data/questions_asset_loader.dart';
import 'package:ticboom/core/styles/app_base_theme.dart';
import 'package:ticboom/core/utils/app_key_store.dart';
import 'package:ticboom/core/view/controllers/theme_controller.dart';
import 'package:ticboom/l10n/app_localizations.dart';

Future<void> bootstrapApp({required AppConfig config}) async {
  final preferences = await SharedPreferences.getInstance();
  final builtInQuestions = await QuestionsAssetLoader.load(
    languageCode: _risolviLinguaDomandi(),
  );

  // ONBOARDING TEMPORANEAMENTE BYPASSATO: rimuovere per riattivare.
  // Scrive la stessa chiave usata dall'onboarding feature
  // (SetOnboardingStateUseCase → OnboardingRepositorySharedPrefsImpl
  // → AppKeyStore.onboardingAccepted), così il guard
  // redirectOnboardingGuard lascia passare direttamente alla home.
  await preferences.setBool(AppKeyStore.onboardingAccepted, true);

  CoreBindings(
    config: config,
    preferences: preferences,
    builtInQuestions: builtInQuestions,
  ).dependencies();

  runApp(const TicboomApp());
}

/// Lingua delle domande built-in: segue la lingua del dispositivo,
/// risolta sulle lingue supportate dall'app (fallback: la prima, inglese).
String _risolviLinguaDomandi() {
  final codice = PlatformDispatcher.instance.locale.languageCode;
  final supportata = AppLocalizations.supportedLocales.any(
    (locale) => locale.languageCode == codice,
  );
  return supportata
      ? codice
      : AppLocalizations.supportedLocales.first.languageCode;
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
