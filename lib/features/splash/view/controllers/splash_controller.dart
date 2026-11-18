import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticboom/core/routing/app_route.dart';
import 'package:ticboom/core/utils/app_key_store.dart';
import 'package:ticboom/l10n/app_localizations.dart';

/// Controller della splash screen con caricamento REALE a step.
///
/// La barra non è un timer finto: il progresso sale solo quando un task di
/// avvio vero viene completato (pesi: prefs ~15%, logo asset ~35%, l10n ~20%,
/// warm-up + buffer ~30%). La navigazione verso la home avviene SOLO quando
/// tutti i task sono terminati (anche in errore: si logga e si prosegue,
/// mai bloccare l'utente su una splash rotta) E la durata minima di visibilità
/// del brand (~2,5s) è rispettata. Un timeout di sicurezza (5s) porta comunque
/// a home se qualcosa si blocca.
class SplashController extends GetxController {
  /// Durata minima di visibilità della splash (brand visibility), combinata
  /// col tempo reale dei task: se i task finiscono prima, il residuo è solo
  /// buffer di visibilità, non "caricamento".
  static const Duration _minSplashDuration = Duration(milliseconds: 2500);

  /// Timeout di sicurezza complessivo: dopo 5s si va comunque a home.
  static const Duration _safetyTimeout = Duration(seconds: 5);

  /// Ciclo dei puntini di caricamento (400ms nel riferimento HTML).
  static const Duration _dotsTick = Duration(milliseconds: 400);

  /// Percentuale mostrata al completamento di ciascun task:
  /// prefs 15% → logo 50% → l10n 70% → warm-up/buffer 100%.
  static const List<int> _stepPercents = [15, 50, 70, 100];

  /// Frame iniziale dei puntini ('...', come nel markup HTML).
  static const int _startDotFrame = 2;
  static const int _dotFrameCount = 4;

  /// Percentuale corrente della miccia (0-100), aggornata per step
  /// COMPLETATO (mai a tick arbitrari). Le transizioni visive sono smussate
  /// dal TweenAnimationBuilder nella pagina.
  final percent = 0.obs;

  /// Indice del frame dei puntini corrente.
  final dotFrame = _startDotFrame.obs;

  bool _navigated = false;
  late final DateTime _startedAt;
  Timer? _dotsTimer;
  Timer? _safetyTimer;

  @override
  void onInit() {
    super.onInit();
    _startedAt = DateTime.now();
    _startDots();
    _safetyTimer = Timer(_safetyTimeout, goHome);
    unawaited(_runStartupTasks());
  }

  @override
  void onClose() {
    _dotsTimer?.cancel();
    _safetyTimer?.cancel();
    super.onClose();
  }

  /// Sequenza reale di avvio: ogni task aggiorna il progresso solo quando
  /// è terminato (in successo o fallimento loggato).
  Future<void> _runStartupTasks() async {
    // Task 1 (~15%): configurazione/preferenze.
    try {
      await _readStartupPreferences();
    } catch (e, s) {
      _logStepFailure('lettura preferenze', e, s);
    }
    percent.value = _stepPercents[0];

    // Task 2 (~35%): decodifica asset grafici principali.
    try {
      await _decodeLogoAsset();
    } catch (e, s) {
      _logStepFailure('decodifica logo', e, s);
    }
    percent.value = _stepPercents[1];

    // Task 3 (~20%): verifica risorse localizzate.
    try {
      await _verifyLocalizedResources();
    } catch (e, s) {
      _logStepFailure('risorse localizzate', e, s);
    }
    percent.value = _stepPercents[2];

    // Task 4 (~30% residuo): warm-up reale + buffer di durata minima.
    try {
      await _warmUpHomeResources();
    } catch (e, s) {
      _logStepFailure('warm-up risorse home', e, s);
    }
    percent.value = _stepPercents[3];

    goHome();
  }

  /// Task 1 (~15%): lettura configurazione/preferenze.
  ///
  /// Le SharedPreferences sono già aperte da App prima di runApp
  /// (app.dart: `await SharedPreferences.getInstance()`); qui si verifica
  /// che le chiavi realmente usate dall'app siano leggibili:
  /// - [AppKeyStore.onboardingAccepted]: letto dal guard onboarding;
  /// - [AppKeyStore.soundFxMuted]: letto da HomeController.
  Future<void> _readStartupPreferences() async {
    final preferences = Get.find<SharedPreferences>();
    final onboardingAccepted =
        preferences.getBool(AppKeyStore.onboardingAccepted) ?? false;
    final soundFxMuted = preferences.getBool(AppKeyStore.soundFxMuted);
    debugPrint(
      'Splash: preferenze leggibili '
      '(onboardingAccepted=$onboardingAccepted, soundFxMuted=$soundFxMuted).',
    );
  }

  /// Task 2 (~35%): decodifica reale dell'asset logo che la splash mostra.
  ///
  /// Carica i byte da rootBundle e li decodifica con il codec dell'engine
  /// (dart:ui instantiateImageCodec), attendendo il primo frame.
  Future<void> _decodeLogoAsset() async {
    final data = await rootBundle.load('assets/images/logo.jpg');
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    debugPrint(
      'Splash: logo decodificato (${frame.image.width}x${frame.image.height}).',
    );
    frame.image.dispose();
    codec.dispose();
  }

  /// Task 3 (~20%): verifica che le risorse localizzate siano risolvibili.
  ///
  /// Prima via rootBundle (gli .arb in lib/l10n NON sono asset bundle: il
  /// pubspec dichiara solo assets/images/, quindi il tentativo diretto
  /// fallisce e si logga), poi — fallback reale — verificando a runtime che
  /// AppLocalizations risolva una chiave usata dalla splash.
  Future<void> _verifyLocalizedResources() async {
    try {
      final raw = await rootBundle.loadString('lib/l10n/app_it.arb');
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      if (decoded.containsKey('loadingFuse')) {
        debugPrint('Splash: app_it.arb valido, chiavi l10n presenti.');
        return;
      }
    } catch (e) {
      // Atteso: gli .arb non sono asset bundle; si prosegue col fallback.
      debugPrint(
        'Splash: app_it.arb non è un asset bundle ($e); '
        'verifica via AppLocalizations.',
      );
    }

    await WidgetsBinding.instance.endOfFrame;
    final context = Get.context;
    if (context == null || !context.mounted) {
      throw StateError('Contesto non pronto per AppLocalizations.');
    }
    final l10n = AppLocalizations.of(context);
    if (l10n.loadingFuse.isEmpty) {
      throw StateError('Chiavi l10n della splash non risolvibili.');
    }
    debugPrint('Splash: chiavi AppLocalizations risolte a runtime.');
  }

  /// Task 4 (~30% residuo): warm-up reale + buffer di durata minima.
  ///
  /// - Pre-cache del logo nel Flutter ImageCache (quello usato da Image.asset
  ///   della hero): reale warm-up, evita jank al primo paint.
  /// - Il residuo è un buffer che porta la durata totale a ~2,5s. NON è un
  ///   timer finto di caricamento: serve solo a garantire una durata minima
  ///   di visibilità del brand, così la splash non lampeggia se i task reali
  ///   finiscono prima (task di "margin/buffer" dichiarato).
  Future<void> _warmUpHomeResources() async {
    final context = Get.context;
    if (context != null && context.mounted) {
      await precacheImage(
        const AssetImage('assets/images/logo.jpg'),
        context,
      );
    }
    final remaining = _minSplashDuration - DateTime.now().difference(_startedAt);
    if (remaining > Duration.zero) {
      await Future<void>.delayed(remaining);
    }
  }

  /// Logga il fallimento di un task e prosegue: la navigazione non viene
  /// mai bloccata da una splash rotta.
  void _logStepFailure(String task, Object error, StackTrace stackTrace) {
    debugPrint('Splash: task "$task" fallito, si prosegue comunque: $error');
    debugPrint('$stackTrace');
  }

  /// Ciclo dei puntini: '.', '..', '...', '' (400ms, come nel riferimento).
  void _startDots() {
    _dotsTimer = Timer.periodic(_dotsTick, (timer) {
      dotFrame.value = (dotFrame.value + 1) % _dotFrameCount;
    });
  }

  /// Naviga verso la home una sola volta (guard anti doppio nav), chiamata
  /// solo dopo che tutti i task sono terminati e la durata minima è
  /// rispettata, oppure dal timeout di sicurezza.
  void goHome() {
    if (_navigated) {
      return;
    }
    _navigated = true;
    Get.find<GoRouter>().go(AppRoute.home.path);
  }
}
