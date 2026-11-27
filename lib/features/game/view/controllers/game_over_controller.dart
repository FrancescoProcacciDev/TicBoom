import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ticboom/core/game/bgm_service.dart';
import 'package:ticboom/core/game/game_service.dart';
import 'package:ticboom/core/routing/app_route.dart';
import 'package:ticboom/features/setup/view/controllers/setup_controller.dart';

/// Controller della schermata di fine partita (dopo l'esplosione della
/// bomba): mostra i secondi effettivi trascorsi e ripulisce la sessione
/// quando l'utente torna alla homepage.
class GameOverController extends GetxController {
  int elapsedSeconds = 0;

  @override
  void onInit() {
    super.onInit();
    // La fine partita non ha musica di sottofondo: solo la coda del boom.
    Get.find<BgmService>().suspend();
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

  /// Uscita dalla fine partita (home o nuova configurazione): il controller
  /// è smaltito dal ciclo di vita della pagina, quindi qui la musica di
  /// sottofondo riprende.
  @override
  void onClose() {
    Get.find<BgmService>().resume();
    super.onClose();
  }

  /// CTA "Gioca nuova partita": elimina lo stato della partita precedente
  /// e torna alla homepage (nessun timer residuo: il controller di partita
  /// è stato già disposto alla navigazione verso questa schermata).
  void goHome() {
    Get.find<GameService>().clearSession();
    if (Get.isRegistered<SetupController>()) {
      Get.delete<SetupController>(force: true);
    }
    Get.find<GoRouter>().go(AppRoute.home.path);
  }

  void goToSetup() {
    Get.find<GameService>().clearSession();
    Get.find<GoRouter>().go(AppRoute.gameConfig.path);
  }
}
