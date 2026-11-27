import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticboom/core/utils/app_key_store.dart';

/// Helper statico per il feedback tattile: chiede lo switch "Vibrazione
/// Aptica" persistito nelle impostazioni (AppKeyStore.hapticsEnabled) prima
/// di inviare il colpo. Chiave assente => vibrazione attiva (default).
abstract final class AppHaptics {
  static const _defaultEnabled = true;

  /// Colpo tattile di intensità media (CTA principali).
  static Future<void> mediumImpact() async {
    if (!_enabled()) {
      return;
    }
    await HapticFeedback.mediumImpact();
  }

  /// Colpo tattile leggero (navigazioni secondarie).
  static Future<void> lightImpact() async {
    if (!_enabled()) {
      return;
    }
    await HapticFeedback.lightImpact();
  }

  /// True se lo switch aptico è attivo. Lettura sincrona: SharedPreferences
  /// è già caricato dai core bindings prima di ogni schermata.
  static bool _enabled() {
    final preferences = Get.find<SharedPreferences>();
    return preferences.getBool(AppKeyStore.hapticsEnabled) ?? _defaultEnabled;
  }
}
