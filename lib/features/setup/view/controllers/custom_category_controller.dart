import 'package:flutter/widgets.dart' show TextEditingController;
import 'package:get/get.dart';

import 'package:ticboom/core/questions/domain/repositories/questions_repository.dart';

/// Controller della schermata di creazione/modifica di una categoria
/// personalizzata: nome + lista di domande a scelta libera (nessun numero
/// minimo). Con [originalName] non nullo è in modalità modifica e precompila
/// i campi. Il ciclo di vita è legato alla pagina (initState/dispose).
class CustomCategoryController extends GetxController {
  CustomCategoryController({this.originalName}) {
    nameController.addListener(_valida);
    _aggiungiCampoDomanda();
    // Modalità modifica: precompila nome e domande esistenti.
    if (originalName != null) {
      nameController.text = originalName!;
      final domande = _questionsRepository.questionsFor(originalName!);
      for (var i = 0; i < domande.length; i++) {
        if (i == 0) {
          questionFields.first.text = domande[i];
        } else {
          _aggiungiCampoDomanda(testo: domande[i]);
        }
      }
      _valida();
    }
  }

  /// Nome della categoria in modifica; null in modalità creazione.
  final String? originalName;

  final nameController = TextEditingController();

  /// Un campo di testo per ogni domanda inserita (almeno uno).
  final questionFields = RxList<TextEditingController>();

  /// La categoria è salvabile: nome non vuoto, almeno una domanda
  /// compilata e nessun conflitto con una categoria esistente.
  final canSave = false.obs;

  /// True se il nome inserito collide con una categoria esistente.
  final nameExists = false.obs;

  QuestionsRepository get _questionsRepository =>
      Get.find<QuestionsRepository>();

  /// Aggiunge un campo (vuoto, o precompilato) per una nuova domanda.
  void addQuestionField() => _aggiungiCampoDomanda();

  void _aggiungiCampoDomanda({String? testo}) {
    final controller = TextEditingController(text: testo);
    controller.addListener(_valida);
    questionFields.add(controller);
    _valida();
  }

  /// Rimuove il campo alla posizione indicata (mai l'ultimo rimasto).
  void removeQuestionField(int index) {
    if (questionFields.length <= 1) {
      return;
    }
    final controller = questionFields.removeAt(index);
    controller.removeListener(_valida);
    controller.dispose();
    _valida();
  }

  void _valida() {
    final nome = nameController.text.trim();
    final domande = domandeCompilate;

    // In modalità modifica il nome corrente non è un duplicato di sé stesso.
    nameExists.value =
        nome.isNotEmpty &&
        nome != originalName &&
        _questionsRepository.exists(nome);

    canSave.value = nome.isNotEmpty && domande.isNotEmpty && !nameExists.value;
  }

  /// Le domande compilate (spazi.trimmati, vuote scartate).
  List<String> get domandeCompilate => [
    for (final controller in questionFields)
      if (controller.text.trim().isNotEmpty) controller.text.trim(),
  ];

  /// Salva la categoria (creazione o modifica); ritorna true se l'operazione
  /// è andata a buon fine.
  Future<bool> save() async {
    if (!canSave.value) {
      return false;
    }
    if (originalName == null) {
      await _questionsRepository.addCustomCategory(
        nameController.text.trim(),
        domandeCompilate,
      );
    } else {
      await _questionsRepository.updateCustomCategory(
        originalName: originalName!,
        newName: nameController.text.trim(),
        questions: domandeCompilate,
      );
    }
    return true;
  }

  @override
  void onClose() {
    for (final controller in questionFields) {
      controller.removeListener(_valida);
      controller.dispose();
    }
    questionFields.clear();
    nameController.removeListener(_valida);
    nameController.dispose();
    super.onClose();
  }
}
