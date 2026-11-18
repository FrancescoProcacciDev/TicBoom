import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ticboom/core/routing/app_route.dart';
import 'package:ticboom/core/routing/guards/onboarding_redirect.dart';
import 'package:ticboom/core/routing/go_router_observer.dart';
import 'package:ticboom/core/view/widgets/app_shell.dart';
import 'package:ticboom/features/home/view/bindings/home_bindings.dart';
import 'package:ticboom/features/home/view/pages/home_page.dart';
import 'package:ticboom/features/onboarding/view/bindings/onboarding_bindings.dart';
import 'package:ticboom/features/onboarding/view/pages/onboarding_page.dart';
import 'package:ticboom/features/profile/view/bindings/profile_bindings.dart';
import 'package:ticboom/features/profile/view/pages/profile_page.dart';
import 'package:ticboom/features/splash/view/bindings/splash_bindings.dart';
import 'package:ticboom/features/splash/view/pages/splash_page.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter buildShellRouter() {
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
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.home.path,
                name: AppRoute.home.name,
                pageBuilder: (context, state) {
                  const HomeBindings().dependencies();
                  return const MaterialPage(child: HomePage());
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.profile.path,
                name: AppRoute.profile.name,
                pageBuilder: (context, state) {
                  const ProfileBindings().dependencies();
                  return const MaterialPage(child: ProfilePage());
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
