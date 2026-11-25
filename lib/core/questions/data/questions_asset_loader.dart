import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

/// Caricatore delle categorie built-in dagli asset JSON
/// `assets/data/questions_<codice lingua>.json`
/// (mappa `categoria -> lista di domande`; le chiavi di categoria sono
/// canoniche e identiche in ogni lingua).
abstract final class QuestionsAssetLoader {
  static const String assetBase = 'assets/data/questions';

  /// Legge l'asset della lingua indicata (già risolta su una lingua
  /// supportata dal chiamante) e lo normalizza: chiavi della mappa e liste
  /// di stringhe non modificabili.
  static Future<Map<String, List<String>>> load({
    required String languageCode,
  }) async {
    final raw = await rootBundle.loadString('${assetBase}_$languageCode.json');
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map(
      (categoria, domande) => MapEntry(
        categoria,
        (domande as List<dynamic>)
            .map((domanda) => domanda.toString())
            .toList(growable: false),
      ),
    );
  }
}
