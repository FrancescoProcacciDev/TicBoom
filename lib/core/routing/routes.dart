import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ticboom/core/routing/app_route.dart';
import 'package:ticboom/core/routing/guards/onboarding_redirect.dart';
import 'package:ticboom/core/routing/go_router_observer.dart';
import 'package:ticboom/features/game/view/pages/game_over_page.dart';
import 'package:ticboom/features/game/view/pages/game_play_page.dart';
import 'package:ticboom/features/home/view/bindings/home_bindings.dart';
import 'package:ticboom/features/home/view/pages/home_page.dart';
import 'package:ticboom/features/onboarding/view/bindings/onboarding_bindings.dart';
import 'package:ticboom/features/onboarding/view/pages/onboarding_page.dart';
import 'package:ticboom/features/party_rooms/view/pages/party_rooms_page.dart';
import 'package:ticboom/features/profile/view/bindings/profile_bindings.dart';
import 'package:ticboom/features/profile/view/pages/profile_page.dart';
import 'package:ticboom/features/rules/view/bindings/rules_bindings.dart';
import 'package:ticboom/features/rules/view/pages/rules_page.dart';
import 'package:ticboom/features/settings/view/pages/settings_page.dart';
import 'package:ticboom/features/setup/view/pages/custom_category_page.dart';
import 'package:ticboom/features/setup/view/pages/setup_page.dart';
import 'package:ticboom/features/setup/view/bindings/setup_bindings.dart';
import 'package:ticboom/features/splash/view/bindings/splash_bindings.dart';
import 'package:ticboom/features/splash/view/pages/splash_page.dart';
import 'package:ticboom/features/vault_records/view/pages/vault_records_page.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter buildRootRouter() {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoute.splash.path,
    observers: [GoRouterObserver()],
    redirect: redirectOnboardingGuard,
    routes: [
      GoRoute(
        path: AppRoute.splash.path,
        name: AppRoute.splash.name,
        pageBuilder: (context, state) {
          const SplashBindings().dependencies();
          return const MaterialPage(child: SplashPage());
        },
      ),
      GoRoute(
        path: AppRoute.onboarding.path,
        name: AppRoute.onboarding.name,
        pageBuilder: (context, state) {
          const OnboardingBindings().dependencies();
          return const MaterialPage(child: OnboardingPage());
        },
      ),
      GoRoute(
        path: AppRoute.home.path,
        name: AppRoute.home.name,
        pageBuilder: (context, state) {
          const HomeBindings().dependencies();
          return const MaterialPage(child: HomePage());
        },
      ),
      GoRoute(
        path: AppRoute.profile.path,
        name: AppRoute.profile.name,
        pageBuilder: (context, state) {
          const ProfileBindings().dependencies();
          return const MaterialPage(child: ProfilePage());
        },
      ),
      GoRoute(
        path: AppRoute.gameConfig.path,
        name: AppRoute.gameConfig.name,
        pageBuilder: (context, state) {
          const SetupBindings().dependencies();
          return const MaterialPage(child: SetupPage());
        },
      ),
      GoRoute(
        path: AppRoute.customCategory.path,
        name: AppRoute.customCategory.name,
        pageBuilder: (context, state) {
          // Nessun binding: il CustomCategoryController è registrato e
          // smaltito dal ciclo di vita della pagina stessa (initState/dispose).
          // `extra` = nome della categoria da modificare (assente: creazione).
          final nomeModifica = state.extra as String?;
          return MaterialPage(
            child: CustomCategoryPage(editName: nomeModifica),
          );
        },
      ),
      GoRoute(
        path: AppRoute.gamePlay.path,
        name: AppRoute.gamePlay.name,
        pageBuilder: (context, state) {
          // Nessun binding: il GamePlayController è registrato e smaltito
          // dal ciclo di vita della pagina stessa (initState/dispose).
          return const MaterialPage(child: GamePlayPage());
        },
      ),
      GoRoute(
        path: AppRoute.gameOver.path,
        name: AppRoute.gameOver.name,
        pageBuilder: (context, state) {
          // Nessun binding: il GameOverController è registrato e smaltito
          // dal ciclo di vita della pagina stessa (initState/dispose).
          return const MaterialPage(child: GameOverPage());
        },
      ),
      GoRoute(
        path: AppRoute.howToPlayRules.path,
        name: AppRoute.howToPlayRules.name,
        pageBuilder: (context, state) {
          const RulesBindings().dependencies();
          return const MaterialPage(child: RulesPage());
        },
      ),
      GoRoute(
        path: AppRoute.gameSettings.path,
        name: AppRoute.gameSettings.name,
        pageBuilder: (context, state) {
          return const MaterialPage(child: SettingsPage());
        },
      ),
      GoRoute(
        path: AppRoute.partyRooms.path,
        name: AppRoute.partyRooms.name,
        pageBuilder: (context, state) {
          return const MaterialPage(child: PartyRoomsPage());
        },
      ),
      GoRoute(
        path: AppRoute.vaultRecords.path,
        name: AppRoute.vaultRecords.name,
        pageBuilder: (context, state) {
          return const MaterialPage(child: VaultRecordsPage());
        },
      ),
    ],
  );
}
