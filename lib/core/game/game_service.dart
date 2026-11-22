import 'dart:math';

import 'package:get/get.dart';
import 'package:ticboom/core/game/game_session.dart';
import 'package:ticboom/core/game/timer_range.dart';
import 'package:ticboom/data/questions.dart';

/// Servizio trasversale che detiene la sessione di gioco corrente:
/// lo crea il setup (startGame), lo leggono partita in corso e fine partita,
/// lo cancella la schermata di fine partita o l'abbandono.
class GameService extends GetxService {
  GameSession? _session;

  /// Sessione corrente, oppure null se nessuna partita è in corso.
  GameSession? get session => _session;

  /// Avvia una nuova partita: estrae categoria e domanda con probabilità
  /// uniforme e genera una durata casuale (segreta) nel range scelto,
  /// estremi inclusi.
  GameSession startGame({
    required int giocatori,
    required List<String> categorieSelezionate,
    required TimerRange range,
  }) {
    final random = Random();
    final categoria =
        categorieSelezionate[random.nextInt(categorieSelezionate.length)];
    final domande = gameQuestions[categoria]!;
    final domanda = domande[random.nextInt(domande.length)];

    final inizio = DateTime.now();
    // Durata casuale nel range scelto, estremi inclusi: min + nextInt(n)
    // con n = (max - min + 1).
    final durata = Duration(
      seconds:
          range.minSecondi + random.nextInt(range.maxSecondi - range.minSecondi + 1),
    );
    _session = GameSession(
      categoria: categoria,
      domanda: domanda,
      numeroGiocatori: giocatori,
      inizio: inizio,
      scadenza: inizio.add(durata),
    );
    return _session!;
  }

  /// Elimina lo stato della partita corrente (a fine partita o abbandono).
  void clearSession() => _session = null;
}
