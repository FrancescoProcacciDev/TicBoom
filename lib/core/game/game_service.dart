import 'dart:math';

import 'package:get/get.dart';
import 'package:ticboom/core/game/game_session.dart';
import 'package:ticboom/core/game/timer_range.dart';
import 'package:ticboom/core/questions/domain/repositories/questions_repository.dart';

/// Servizio trasversale che detiene la sessione di gioco corrente:
/// lo crea il setup (startGame), lo leggono partita in corso e fine partita,
/// lo cancella la schermata di fine partita o l'abbandono.
class GameService extends GetxService {
  GameService({required this._questionsRepository});

  final QuestionsRepository _questionsRepository;
  final Random _random = Random();

  /// Mazzo della singola categoria: domande già mescolate, consumate una
  /// alla volta. Vive solo in memoria del servizio (registrato all'avvio
  /// dell'app): ad ogni avvio dell'app il mazzo si ricrea pieno, quindi
  /// chiudendo e riaprendo l'app si può ripescare tutta la categoria.
  final Map<String, List<String>> _decks = {};

  GameSession? _session;

  /// Sessione corrente, oppure null se nessuna partita è in corso.
  GameSession? get session => _session;

  /// Avvia una nuova partita: estrae la categoria in modo uniforme tra
  /// quelle selezionate (con almeno una domanda), pesca la domanda dal
  /// mazzo mescolato della categoria e genera una durata casuale (segreta)
  /// nel range scelto, estremi inclusi.
  GameSession startGame({
    required int giocatori,
    required List<String> categorieSelezionate,
    required TimerRange range,
  }) {
    final categoria = _pickCategoria(categorieSelezionate);
    final domanda = _drawQuestion(categoria);

    final inizio = DateTime.now();
    // Durata casuale nel range scelto, estremi inclusi: min + nextInt(n)
    // con n = (max - min + 1).
    final durata = Duration(
      seconds:
          range.minSecondi +
          _random.nextInt(range.maxSecondi - range.minSecondi + 1),
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

  /// Estrae la categoria in modo uniforme tra quelle selezionate che
  /// hanno almeno una domanda disponibile.
  String _pickCategoria(List<String> categorieSelezionate) {
    final disponibili = [
      for (final categoria in categorieSelezionate)
        if (_questionsRepository.questionCount(categoria) > 0) categoria,
    ];
    if (disponibili.isEmpty) {
      throw StateError('Nessuna categoria selezionata ha domande disponibili.');
    }
    return disponibili[_random.nextInt(disponibili.length)];
  }

  /// Pesca la prossima domanda dal mazzo della categoria: il mazzo nasce
  /// mescolando tutte le domande della categoria e si consuma una domanda
  /// alla volta; esaurito, si ricrea mescolando di nuovo. Così una domanda
  /// non si ripete finché il mazzo non si esaurisce.
  String _drawQuestion(String categoria) {
    var mazzo = _decks[categoria];
    if (mazzo == null || mazzo.isEmpty) {
      mazzo = List.of(_questionsRepository.questionsFor(categoria))
        ..shuffle(_random);
      _decks[categoria] = mazzo;
    }
    return mazzo.removeLast();
  }

  /// Elimina lo stato della partita corrente (a fine partita o abbandono).
  void clearSession() => _session = null;
}
