import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticboom/core/styles/app_colors.dart';
import 'package:ticboom/core/styles/app_text_styles.dart';
import 'package:ticboom/core/view/widgets/app_bottom_nav.dart';
import 'package:ticboom/core/view/widgets/app_header.dart';
import 'package:ticboom/features/settings/view/controllers/settings_controller.dart';
import 'package:ticboom/l10n/app_localizations.dart';

/// Schermata impostazioni replicata dal design reference HTML:
/// titolo + sottotitolo, sezione "Audio" con 3 switch in card e sezione
/// "Info Gioco" con la versione bundle. Gli switch persistono subito al
/// tap: nessuna CTA di salvataggio. Header condiviso + bottom nav a 2 voci.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();
    final l10n = AppLocalizations.of(context);
    // Schivata dell'header overlay: SafeArea del dispositivo + margine + altezza
    // barra (64), come in home e regole.
    final topInset = MediaQuery.paddingOf(context).top + 16 + 64;

    return Scaffold(
      backgroundColor: AppColors.surface,
      // Nav ancorata al fondo dello schermo via Scaffold: il body termina
      // sopra la barra e la safe area inferiore è gestita dalla barra stessa.
      bottomNavigationBar: const AppBottomNav(),
      body: Stack(
        children: [
          // Il viewport scrollabile riempie SEMPRE l'intero body (viewport
          // meno nav): Positioned.fill impone vincoli tight.
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: topInset, bottom: 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 448),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 8),
                        _TitleGroup(l10n: l10n),
                        const SizedBox(height: 24),
                        _AudioFeedbackSection(controller: controller),
                        const SizedBox(height: 24),
                        _GameInfoSection(l10n: l10n),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Header fisso condiviso.
          const Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: AppHeader(),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Titolo + sottotitolo
// ---------------------------------------------------------------------------

class _TitleGroup extends StatelessWidget {
  const _TitleGroup({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.impostazioni.toUpperCase(),
          style: AppTextStyles.headline.copyWith(color: AppColors.onSurface),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.impostazioniSottotitolo,
          style: AppTextStyles.body.copyWith(color: AppColors.onSurfaceVariant),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Sezione "Audio & Feedback": label mono + card con 3 switch
// ---------------------------------------------------------------------------

class _AudioFeedbackSection extends StatelessWidget {
  const _AudioFeedbackSection({required this.controller});

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              const Icon(
                Icons.sensors,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 6),
              Text(
                l10n.audioFeedback.toUpperCase(),
                style: AppTextStyles.labelMono.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Obx(
                () => _SettingRow(
                  title: l10n.effettiSonori,
                  subtitle: l10n.effettiSonoriDesc,
                  value: !controller.soundMuted.value,
                  onChanged: (_) => controller.toggleSound(),
                ),
              ),
              const _RowDivider(),
              _MusicVolumeRow(controller: controller),
              const _RowDivider(),
              Obx(
                () => _SettingRow(
                  title: l10n.vibrazioneAptica,
                  subtitle: l10n.vibrazioneApticaDesc,
                  value: controller.hapticsOn.value,
                  onChanged: (_) => controller.toggleHaptics(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(vertical: 12),
      color: AppColors.surfaceVariant.withValues(alpha: 0.4),
    );
  }
}

/// Riga impostazione: titolo + descrizione a sinistra, switch a destra.
class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.body.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        _SettingsSwitch(value: value, onChanged: onChanged),
      ],
    );
  }
}

/// Riga volume musica: titolo + descrizione in alto, slider custom sotto a
/// tutta larghezza con etichetta del valore (0 = musica disattivata).
class _MusicVolumeRow extends StatelessWidget {
  const _MusicVolumeRow({required this.controller});

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.musicaSottofondo,
            style: AppTextStyles.body.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            l10n.musicaSottofondoDesc,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 10),
          _SettingsSlider(
            value: controller.musicVolume.value,
            onChanged: controller.setMusicVolume,
          ),
        ],
      ),
    );
  }
}

/// Slider custom del volume (0-100), riutilizzabile per altre impostazioni.
/// Traccia surfaceContainerHigh, riempimento e thumb primaryContainer/on-
/// PrimaryContainer quando attivo; a 0 i colori passano a "spento"
/// (onSurfaceVariant) per rendere evidente lo stato disattivato.
class _SettingsSlider extends StatelessWidget {
  const _SettingsSlider({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  static const int _step = 5;

  @override
  Widget build(BuildContext context) {
    final active = value > 0;

    return Row(
      children: [
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 6,
              activeTrackColor: active
                  ? AppColors.primaryContainer
                  : AppColors.onSurfaceVariant,
              inactiveTrackColor: AppColors.surfaceContainerHigh,
              thumbColor: active
                  ? AppColors.onPrimaryContainer
                  : AppColors.onSurfaceVariant,
              overlayColor: AppColors.primaryContainer.withValues(
                alpha: 0.2,
              ),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
              overlayShape: const RoundSliderOverlayShape(
                overlayRadius: 16,
              ),
            ),
            child: Slider(
              value: value.toDouble(),
              min: 0,
              max: 100,
              divisions: 100 ~/ _step,
              onChanged: (newValue) =>
                  onChanged((newValue / _step).round() * _step),
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 42,
          child: Text(
            '$value%',
            textAlign: TextAlign.right,
            style: AppTextStyles.labelMono.copyWith(
              fontSize: 11,
              color: active
                  ? AppColors.primaryContainer
                  : AppColors.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

/// Switch custom replicato dall'HTML: pill 48x28, thumb 24px.
/// ON: pill primaryContainer, thumb onPrimaryContainer. OFF: pill
/// surfaceContainerHigh, thumb onSurfaceVariant.
class _SettingsSwitch extends StatelessWidget {
  const _SettingsSwitch({required this.value, required this.onChanged});

  static const double _trackWidth = 48;
  static const double _trackHeight = 28;
  static const double _thumbSize = 24;
  static const double _thumbInset = 2;

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: _trackWidth,
        height: _trackHeight,
        padding: const EdgeInsets.all(_thumbInset),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: value
              ? AppColors.primaryContainer
              : AppColors.surfaceContainerHigh,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: _thumbSize,
            height: _thumbSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: value
                  ? AppColors.onPrimaryContainer
                  : AppColors.onSurfaceVariant,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x40000000), // black @ 25% (shadow-md)
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sezione "Info Gioco": card con la riga versione bundle
// ---------------------------------------------------------------------------

class _GameInfoSection extends StatelessWidget {
  const _GameInfoSection({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              const Icon(
                Icons.info_outline,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 6),
              Text(
                l10n.infoGioco.toUpperCase(),
                style: AppTextStyles.labelMono.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.terminal,
                  size: 20,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.versioneBundle,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.versioneBundleDesc,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                l10n.versioneBundleTag,
                style: AppTextStyles.labelMono.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// CTA "SALVA PREFERENZE": rimossa. Gli switch persistono già al tap, un
// bottone di salvataggio sarebbe stato fuorviante.
// ---------------------------------------------------------------------------
