import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ticboom/core/game/game_service.dart';
import 'package:ticboom/core/routing/app_route.dart';

/// Controller della schermata di fine partita (dopo l'esplosione della
/// bomba): mostra i secondi effettivi trascorsi e ripulisce la sessione
/// quando l'utente torna alla homepage.
class GameOverController extends GetxController {
  int elapsedSeconds = 0;

  @override
  void onInit() {
    super.onInit();
    final session = Get.find<GameService>().session;
    if (session == null) {
      // Nessuna sessione (accesso diretto o già ripulita): torna alla home.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.find<GoRouter>().go(AppRoute.home.path);
      });
      return;
    }
    elapsedSeconds = session.secondiTrascorsi;
  }

  /// CTA "Gioca nuova partita": elimina lo stato della partita precedente
  /// e torna alla homepage (nessun timer residuo: il controller di partita
  /// è stato già disposto alla navigazione verso questa schermata).
  void goHome() {
    Get.find<GameService>().clearSession();
    Get.find<GoRouter>().go(AppRoute.home.path);
  }
}
