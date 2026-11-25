import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

/// Caricatore delle categorie built-in dall'asset JSON
/// `assets/data/questions.json` (mappa `categoria -> lista di domande`).
abstract final class QuestionsAssetLoader {
  static const String assetPath = 'assets/data/questions.json';

  /// Legge l'asset e lo normalizza: chiavi della mappa e liste di stringhe
  /// non modificabili.
  static Future<Map<String, List<String>>> load() async {
    final raw = await rootBundle.loadString(assetPath);
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
