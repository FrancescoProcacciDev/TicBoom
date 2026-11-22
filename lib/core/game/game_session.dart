/// Sessione di una partita TicBoom: immutabile, creata all'avvio della
/// manche e distrutta a fine partita (esplosione o abbandono).
///
/// `scadenza` è il momento effettivo in cui la bomba esplode: il timer di
/// gioco si basa sulla comparazione con `DateTime.now()`, così il conteggio
/// resta corretto anche se l'app passa in background.
class GameSession {
  const GameSession({
    required this.categoria,
    required this.domanda,
    required this.numeroGiocatori,
    required this.inizio,
    required this.scadenza,
  });

  /// Categoria estratta all'avvio della manche (chiave di gameQuestions).
  final String categoria;

  /// Domanda estratta: fissa per tutta la durata della manche.
  final String domanda;

  /// Numero di giocatori scelto nella configurazione.
  final int numeroGiocatori;

  /// Momento di inizio della manche (base per il tempo effettivo trascorso).
  final DateTime inizio;

  /// Momento di scadenza della bomba (segreto: non esporre ai giocatori).
  final DateTime scadenza;

  /// Secondi effettivi trascorsi dall'inizio della manche (usato nella
  /// schermata di fine partita, dove la durata della bomba viene rivelata).
  int get secondiTrascorsi => DateTime.now().difference(inizio).inSeconds;
}
