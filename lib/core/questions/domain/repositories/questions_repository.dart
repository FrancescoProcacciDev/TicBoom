/// Contratto di accesso alle categorie di gioco:
/// - built-in: caricate dall'asset `assets/data/questions.json`;
/// - personalizzate: create dall'utente e salvate in locale.
abstract interface class QuestionsRepository {
  /// Tutte le categorie disponibili (prima le built-in, poi le
  /// personalizzate), nell'ordine di visualizzazione.
  List<String> get categories;

  /// Domande di una categoria (lista immutabile, vuota se inesistente).
  List<String> questionsFor(String category);

  /// Numero di domande disponibili per una categoria.
  int questionCount(String category);

  /// True se la categoria è stata creata dall'utente (ed è eliminabile).
  bool isCustom(String category);

  /// True se esiste già una categoria (built-in o personalizzata) con
  /// questo nome, ignorando spazi iniziali e finali.
  bool exists(String category);

  /// Aggiunge una categoria personalizzata. Solleva [ArgumentError] se il
  /// nome collide con una categoria built-in.
  Future<void> addCustomCategory(String name, List<String> questions);

  /// Elimina una categoria personalizzata; ritorna false se non esiste.
  Future<bool> deleteCustomCategory(String category);

  /// Aggiorna una categoria personalizzata esistente, consentendone anche
  /// la rinomina. Solleva [ArgumentError] se `originalName` non è una
  /// categoria personalizzata esistente o se `newName` collide con
  /// un'altra categoria.
  Future<void> updateCustomCategory({
    required String originalName,
    required String newName,
    required List<String> questions,
  });
}
