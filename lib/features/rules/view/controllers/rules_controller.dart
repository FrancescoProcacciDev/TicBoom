import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ticboom/core/routing/app_route.dart';

/// Controller della schermata "Come si gioca": solo navigazione (il contenuto
/// è statico). La CTA "HO CAPITO, INIZIAMO!" riporta al menu principale
/// (l'utente da qui "inizia", torna al menu).
class RulesController extends GetxController {
  /// CTA "Ho capito, iniziamo!": torna al menu principale.
  void goHome() => Get.find<GoRouter>().go(AppRoute.home.path);

  /// Navigazione indietro allo stack precedente.
  void goBack() => Get.back<void>();
}
