import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import 'package:ticboom/core/styles/app_colors.dart';
import 'package:ticboom/core/styles/app_text_styles.dart';
import 'package:ticboom/core/view/widgets/app_snack_bar.dart';
import 'package:ticboom/features/setup/view/controllers/custom_category_controller.dart';
import 'package:ticboom/features/setup/view/controllers/setup_controller.dart';
import 'package:ticboom/l10n/app_localizations.dart';

/// Schermata di creazione/modifica di una categoria personalizzata: nome e
/// lista di domande (nessun numero minimo). Con [editName] non nullo la
/// pagina è in modalità modifica. Il controller vive con la pagina.
class CustomCategoryPage extends StatefulWidget {
  const CustomCategoryPage({super.key, this.editName});

  /// Nome della categoria da modificare; null in modalità creazione.
  final String? editName;

  @override
  State<CustomCategoryPage> createState() => _CustomCategoryPageState();
}

class _CustomCategoryPageState extends State<CustomCategoryPage> {
  late final CustomCategoryController controller;

  @override
  void initState() {
    super.initState();
    // Il ciclo di vita del controller è legato a QUESTA pagina (l'app usa
    // go_router senza GetMaterialApp, quindi GetX non smaltisce i controller
    // a fine rotta). Se resta registrato un esemplare di una visita
    // precedente, lo si chiude prima di registrarne uno nuovo.
    if (Get.isRegistered<CustomCategoryController>()) {
      Get.delete<CustomCategoryController>(force: true);
    }
    controller = Get.put(
      CustomCategoryController(originalName: widget.editName),
    );
  }

  @override
  void dispose() {
    Get.delete<CustomCategoryController>(force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final titolo = widget.editName != null
        ? l10n.modificaCategoriaTitolo
        : l10n.nuovaCategoriaTitolo;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(l10n: l10n, titolo: titolo),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l10n.nomeCategoriaLabel,
                        style: AppTextStyles.titleCard.copyWith(
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: controller.nameController,
                        textCapitalization: TextCapitalization.sentences,
                        maxLength: 40,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.onSurface,
                        ),
                        decoration: InputDecoration(
                          hintText: l10n.nomeCategoriaHint,
                          errorText: controller.nameExists.value
                              ? l10n.nomeDuplicato
                              : null,
                          filled: true,
                          fillColor: AppColors.surfaceContainer,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.outlineVariant,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.domandeCategoria,
                            style: AppTextStyles.titleCard.copyWith(
                              color: AppColors.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      for (final entry
                          in controller.questionFields.asMap().entries)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: TextField(
                                  // La chiave segue il controller: se un campo
                                  // viene rimosso, lo stato dei rimasti resta
                                  // associato al controller giusto.
                                  key: ValueKey<TextEditingController>(
                                    entry.value,
                                  ),
                                  controller: entry.value,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  style: AppTextStyles.body.copyWith(
                                    color: AppColors.onSurface,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: l10n.domandaHint,
                                    filled: true,
                                    fillColor: AppColors.surfaceContainer,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: AppColors.outlineVariant,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                tooltip: l10n.eliminaDomanda,
                                icon: const Icon(Icons.remove_circle_outline),
                                color: AppColors.onSurfaceVariant,
                                onPressed: controller.questionFields.length > 1
                                    ? () => controller.removeQuestionField(
                                        entry.key,
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      Center(
                        child: TextButton.icon(
                          onPressed: controller.addQuestionField,
                          icon: const Icon(Icons.add, size: 18),
                          label: Text(
                            l10n.aggiungiDomanda,
                            style: AppTextStyles.labelAction.copyWith(
                              color: AppColors.primaryContainer,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.secondaryContainer,
                          foregroundColor: AppColors.onSecondaryContainer,
                        ),
                        onPressed: controller.canSave.value ? _salva : null,
                        child: Text(l10n.salvaCategoria),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Salva la categoria, aggiorna la lista nel setup e torna indietro.
  Future<void> _salva() async {
    final l10n = AppLocalizations.of(context);
    final salvata = await controller.save();
    if (!salvata || !mounted) {
      return;
    }
    // Aggiorna la lista della schermata di configurazione: il controller
    // del setup resta registrato tra le rotte, va ricaricato a mano.
    if (Get.isRegistered<SetupController>()) {
      Get.find<SetupController>().reloadCategorie();
    }
    showAppSnackBar(context, l10n.categoriaSalvata);
    Get.find<GoRouter>().pop();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header con freccia di ritorno e titolo
// ─────────────────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({required this.l10n, required this.titolo});

  final AppLocalizations l10n;
  final String titolo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 24, 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            color: AppColors.onSurface,
            onPressed: () => Get.find<GoRouter>().pop(),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              titolo,
              style: AppTextStyles.titleCard.copyWith(
                color: AppColors.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
