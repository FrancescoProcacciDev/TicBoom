// TODO(ripristino): card selettore giocatori (stepper 2-20, default 4),
// nascosta dalla pagina finché non serve. Al riattivamento: decommentare
// gli import qui sotto, il codice, e l'uso in setup_page.dart.
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ticboom/core/styles/app_colors.dart';
// import 'package:ticboom/core/styles/app_text_styles.dart';
// import 'package:ticboom/features/setup/view/controllers/setup_controller.dart';
// import 'package:ticboom/l10n/app_localizations.dart';
//
// class PlayersCard extends StatelessWidget {
//   const PlayersCard({super.key, required this.controller});

//   final SetupController controller;

//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context);
//     return Obx(
//       () => Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: AppColors.surfaceContainer,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: AppColors.outlineVariant),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   l10n.giocatoriAlTavolo,
//                   style: AppTextStyles.titleCard.copyWith(
//                     color: AppColors.onSurface,
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 10,
//                     vertical: 4,
//                   ),
//                   decoration: BoxDecoration(
//                     color: AppColors.surfaceContainerHigh,
//                     borderRadius: BorderRadius.circular(999),
//                   ),
//                   child: Text(
//                     '${controller.playerCount.value} ${l10n.partecipanti}',
//                     style: AppTextStyles.labelMono.copyWith(
//                       color: AppColors.primaryContainer,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text(
//               l10n.rangeAmmissibile,
//               style: AppTextStyles.body.copyWith(
//                 color: AppColors.onSurfaceVariant,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 StepperButton(
//                   icon: Icons.remove,
//                   semanticLabel: l10n.riduciGiocatori,
//                   onPressed: controller.decrementPlayers,
//                 ),
//                 Expanded(
//                   child: Column(
//                     children: [
//                       Text(
//                         '${controller.playerCount.value}',
//                         style: AppTextStyles.displayHero.copyWith(
//                           color: AppColors.primaryContainer,
//                           fontSize: 44,
//                           height: 1.0,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         l10n.giocatoriAlTavolo,
//                         style: AppTextStyles.labelMono.copyWith(
//                           color: AppColors.onSurfaceVariant,
//                           fontSize: 9,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 StepperButton(
//                   icon: Icons.add,
//                   semanticLabel: l10n.aumentaGiocatori,
//                   onPressed: controller.incrementPlayers,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class StepperButton extends StatelessWidget {
//   const StepperButton({
//     super.key,
//     required this.icon,
//     required this.semanticLabel,
//     required this.onPressed,
//   });

//   final IconData icon;
//   final String semanticLabel;
//   final VoidCallback onPressed;

//   @override
//   Widget build(BuildContext context) {
//     return Semantics(
//       label: semanticLabel,
//       button: true,
//       child: IconButton(
//         onPressed: onPressed,
//         icon: Icon(icon),
//         style: IconButton.styleFrom(
//           backgroundColor: AppColors.surfaceContainerHigh,
//           foregroundColor: AppColors.primaryContainer,
//           shape: const CircleBorder(),
//           padding: const EdgeInsets.all(14),
//         ),
//       ),
//     );
//   }
// }
