import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:ticboom/core/questions/domain/repositories/questions_repository.dart';
import 'package:ticboom/core/utils/app_key_store.dart';

/// Implementazione del [QuestionsRepository]:
/// - le categorie built-in arrivano dall'asset JSON, caricate all'avvio
///   dell'app e tenute in memoria;
/// - le categorie personalizzate sono persistite in SharedPreferences
///   come mappa JSON `nome -> lista di domande`.
class QuestionsRepositoryImpl implements QuestionsRepository {
  QuestionsRepositoryImpl({
    required Map<String, List<String>> builtInQuestions,
    required this._preferences,
  }) : _builtIn = Map.of(builtInQuestions) {
    _custom.addAll(_readCustom());
  }

  final Map<String, List<String>> _builtIn;
  final Map<String, List<String>> _custom = {};
  final SharedPreferences _preferences;

  @override
  List<String> get categories => [..._builtIn.keys, ..._custom.keys];

  @override
  List<String> questionsFor(String category) {
    final domande = _builtIn[category] ?? _custom[category];
    return domande == null ? const [] : List.unmodifiable(domande);
  }

  @override
  int questionCount(String category) => questionsFor(category).length;

  @override
  bool isCustom(String category) => _custom.containsKey(category);

  @override
  bool exists(String category) =>
      _builtIn.containsKey(category.trim()) ||
      _custom.containsKey(category.trim());

  @override
  Future<void> addCustomCategory(String name, List<String> questions) async {
    final nome = name.trim();
    if (nome.isEmpty) {
      throw ArgumentError.value(name, 'name', 'Il nome non può essere vuoto.');
    }
    if (_builtIn.containsKey(nome)) {
      throw ArgumentError.value(
        nome,
        'name',
        'Il nome collide con una categoria built-in.',
      );
    }
    _custom[nome] = questions
        .map((domanda) => domanda.trim())
        .where((domanda) => domanda.isNotEmpty)
        .toList(growable: false);
    await _persist();
  }

  @override
  Future<bool> deleteCustomCategory(String category) async {
    final rimossa = _custom.remove(category.trim()) != null;
    if (rimossa) {
      await _persist();
    }
    return rimossa;
  }

  @override
  Future<void> updateCustomCategory({
    required String originalName,
    required String newName,
    required List<String> questions,
  }) async {
    final vecchioNome = originalName.trim();
    final nome = newName.trim();
    if (!_custom.containsKey(vecchioNome)) {
      throw ArgumentError.value(
        vecchioNome,
        'originalName',
        'Non è una categoria personalizzata esistente.',
      );
    }
    if (nome.isEmpty) {
      throw ArgumentError.value(
        newName,
        'newName',
        'Il nome non può essere vuoto.',
      );
    }
    if (nome != vecchioNome && exists(nome)) {
      throw ArgumentError.value(
        nome,
        'newName',
        'Il nome collide con un\'altra categoria.',
      );
    }
    _custom.remove(vecchioNome);
    _custom[nome] = questions
        .map((domanda) => domanda.trim())
        .where((domanda) => domanda.isNotEmpty)
        .toList(growable: false);
    await _persist();
  }

  /// Legge le categorie personalizzate salvate; un JSON corrotto o
  /// inatteso viene semplicemente ignorato (nessuna categoria).
  Map<String, List<String>> _readCustom() {
    final raw = _preferences.getString(AppKeyStore.customCategories);
    if (raw == null || raw.isEmpty) {
      return const {};
    }
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map(
        (nome, domande) => MapEntry(
          nome,
          (domande as List<dynamic>)
              .map((domanda) => domanda.toString())
              .toList(growable: false),
        ),
      );
    } catch (_) {
      return const {};
    }
  }

  Future<void> _persist() {
    return _preferences.setString(
      AppKeyStore.customCategories,
      jsonEncode(_custom),
    );
  }
}
