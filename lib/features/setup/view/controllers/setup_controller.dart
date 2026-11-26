import 'dart:math';

import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ticboom/core/game/game_service.dart';
import 'package:ticboom/core/game/timer_range.dart';
import 'package:ticboom/core/questions/domain/repositories/questions_repository.dart';
import 'package:ticboom/core/routing/app_route.dart';

/// Controller della schermata di configurazione partita:
/// numero di giocatori (2-20, default 4), selezione categorie (default:
/// nessuna) e avvio partita con estrazione casuale.
class SetupController extends GetxController {
  /// Categorie disponibili (built-in + personalizzate), caricate dal
  /// [QuestionsRepository]; l'ordine definisce quello di visualizzazione.
  final categorie = RxList<String>(const []);

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

  QuestionsRepository get _questionsRepository =>
      Get.find<QuestionsRepository>();

  @override
  void onInit() {
    super.onInit();
    reloadCategorie();
  }

  /// Ricarica le categorie dal repository e rimuove dalle selezionate
  /// quelle ormai inesistenti (es. una categoria personalizzata eliminata).
  /// Pubblico: chiamato al ritorno dalle schermate di creazione/modifica.
  void reloadCategorie() {
    categorie.assignAll(_questionsRepository.categories);
    selectedCategories.removeWhere(
      (categoria) => !categorie.contains(categoria),
    );
  }

  /// Seleziona il range del detonatore.
  void selectTimerRange(TimerRange range) => timerRange.value = range;

  bool isSelectedTimerRange(TimerRange range) => timerRange.value == range;

  /// Contatore categorie selezionate (usato dalla logica "Seleziona tutte").
  int get selectedCount => selectedCategories.length;

  /// Totale categorie disponibili.
  int get totalCount => categorie.length;

  /// True se tutte le categorie predefinite sono selezionate.
  bool get allBuiltInSelected => selectedCategories.containsAll(categorieBuiltIn);

  /// Categorie built-in (griglia principale, senza le personalizzate).
  List<String> get categorieBuiltIn => [
    ...categorie.where(
      (categoria) => !_questionsRepository.isCustom(categoria),
    ),
  ];

  /// Categorie personalizzate (sezione dedicata).
  List<String> get categorieCustom => [
    ...categorie.where((categoria) => _questionsRepository.isCustom(categoria)),
  ];

  /// L'avvio è permesso solo con almeno una categoria selezionata.
  bool get canStart => selectedCategories.isNotEmpty;

  /// True se la categoria è stata creata dall'utente (ed è eliminabile).
  bool isCustom(String categoria) => _questionsRepository.isCustom(categoria);

  /// Numero di domande della categoria (mostrato sulle righe custom).
  int questionCount(String categoria) =>
      _questionsRepository.questionCount(categoria);

  /// Elimina una categoria personalizzata e aggiorna la lista.
  Future<void> deleteCustomCategory(String categoria) async {
    await _questionsRepository.deleteCustomCategory(categoria);
    reloadCategorie();
  }

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

  /// Seleziona tutte le categorie predefinite, escluse le personalizzate.
  void selectAll() => selectedCategories.addAll(Set.of(categorieBuiltIn));

  /// Sostituisce la selezione con una sola categoria predefinita a caso
  /// (le personalizzate sono escluse dall'estrazione).
  void selectRandomBuiltIn() {
    final pool = categorieBuiltIn;
    if (pool.isEmpty) {
      return;
    }
    selectedCategories.assignAll({pool[Random().nextInt(pool.length)]});
  }

  /// Deseleziona tutte le categorie predefinite, lasciando le
  /// personalizzate (blocca l'avvio finché non se ne seleziona almeno una).
  void deselectAll() => selectedCategories.removeAll(categorieBuiltIn);

  bool isSelected(String categoria) => selectedCategories.contains(categoria);

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
