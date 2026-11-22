import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ticboom/core/game/game_service.dart';
import 'package:ticboom/core/game/timer_range.dart';
import 'package:ticboom/core/routing/app_route.dart';
import 'package:ticboom/data/questions.dart';

/// Controller della schermata di configurazione partita:
/// numero di giocatori (2-20, default 4), selezione categorie (default:
/// tutte) e avvio partita con estrazione casuale.
class SetupController extends GetxController {
  /// Chiavi canoniche delle categorie mostrate nella griglia (stesse chiavi
  /// di [gameQuestions]); l'ordine definisce quello di visualizzazione.
  static const List<String> categorie = [
    'ANIME',
    'ANIMALI',
    'CIBO E BEVANDE',
    'CALCIO',
  ];

  static const int giocatoriMinimi = 2;
  static const int giocatoriMassimi = 20;
  static const int giocatoriDefault = 4;

  final playerCount = giocatoriDefault.obs;
  // All'avvio nessuna categoria è selezionata: l'utente ne sceglie almeno
  // una per poter avviare la partita (CTA disabilitata fino ad allora).
  final selectedCategories = RxSet<String>();

  // Range del detonatore: selezione mutuamente esclusiva tra i range
  // disponibili (default: quello classico 45s - 120s).
  final timerRange = TimerRange.classico.obs;

  /// Seleziona il range del detonatore.
  void selectTimerRange(TimerRange range) => timerRange.value = range;

  bool isSelectedTimerRange(TimerRange range) =>
      timerRange.value == range;

  // Categoria personalizzata: visibile ma completamente disabilitata in
  // questa versione.
  final isCustomCategoryEnabled = false.obs;

  /// Contatore categorie selezionate (per il "X/4" in UI).
  int get selectedCount => selectedCategories.length;

  /// Totale categorie disponibili (per il denominatore del contatore).
  int get totalCount => categorie.length;

  /// L'avvio è permesso solo con almeno una categoria selezionata.
  bool get canStart => selectedCategories.isNotEmpty;

  void incrementPlayers() {
    if (playerCount.value < giocatoriMassimi) {
      playerCount.value++;
    }
  }

  void decrementPlayers() {
    if (playerCount.value > giocatoriMinimi) {
      playerCount.value--;
    }
  }

  /// Seleziona/deseleziona una categoria (multi-selezione consentita).
  void toggleCategory(String categoria) {
    if (selectedCategories.contains(categoria)) {
      selectedCategories.remove(categoria);
    } else {
      selectedCategories.add(categoria);
    }
  }

  /// Seleziona tutte le categorie.
  void selectAll() => selectedCategories.assignAll(Set.of(categorie));

  /// Deseleziona tutte le categorie (blocca l'avvio finché non se ne
  /// seleziona almeno una).
  void deselectAll() => selectedCategories.clear();

  bool isSelected(String categoria) =>
      selectedCategories.contains(categoria);

  /// Avvia la partita: delega l'estrazione al GameService e naviga alla
  /// schermata di partita in corso.
  void startGame() {
    if (!canStart) {
      return;
    }
    final gameService = Get.find<GameService>();
    gameService.startGame(
      giocatori: playerCount.value,
      categorieSelezionate: selectedCategories.toList(growable: false),
      range: timerRange.value,
    );
    Get.find<GoRouter>().go(AppRoute.gamePlay.path);
  }
}
