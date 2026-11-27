/// Range di durata della bomba selezionabile nella configurazione della
/// partita. Estremi inclusi; la durata estratta resta comunque segreta.
class TimerRange {
  const TimerRange(this.minSecondi, this.maxSecondi);

  final int minSecondi;
  final int maxSecondi;

  /// Range "rapido": la bomba esplode tra 30 e 100 secondi.
  static const TimerRange rapido = TimerRange(30, 100);

  /// Range "classico": la bomba esplode tra 45 e 120 secondi.
  // static const TimerRange classico = TimerRange(45, 120);
  // TIMER PER TEST
  static const TimerRange classico = TimerRange(3, 3);

  /// Range disponibili in configurazione (facilmente estendibile).
  static const List<TimerRange> disponibili = [rapido, classico];

  /// Etichetta numerica del range, identica in tutte le lingue
  /// (es. "45s - 120s").
  String get label => '${minSecondi}s - ${maxSecondi}s';
}
