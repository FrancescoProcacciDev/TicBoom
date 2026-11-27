import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ticboom/core/config/app_config.dart';
import 'package:ticboom/core/game/bgm_service.dart';
import 'package:ticboom/core/game/game_service.dart';
import 'package:ticboom/core/game/sound_fx_service.dart';
import 'package:ticboom/core/questions/data/repo_impl/questions_repository_impl.dart';
import 'package:ticboom/core/questions/domain/repositories/questions_repository.dart';
import 'package:ticboom/core/routing/routes.dart' as root_routes;
import 'package:ticboom/core/routing/shell_routes.dart' as shell_routes;
import 'package:ticboom/core/view/controllers/theme_controller.dart';
import 'package:ticboom/core/view/data/repo_impl/theme_repository_shared_prefs_impl.dart';
import 'package:ticboom/core/view/domain/repositories/theme_repository.dart';
import 'package:ticboom/core/view/domain/use_cases/get_theme_mode.dart';
import 'package:ticboom/core/view/domain/use_cases/set_theme_mode.dart';
import 'package:ticboom/features/onboarding/data/repo_impl/onboarding_repository_shared_prefs_impl.dart';
import 'package:ticboom/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:ticboom/features/onboarding/domain/use_cases/get_onboarding_state.dart';
import 'package:ticboom/features/onboarding/domain/use_cases/set_onboarding_state.dart';
import 'package:ticboom/core/network/dio.dart';

class CoreBindings implements Bindings {
  const CoreBindings({
    required this.config,
    required this.preferences,
    required this.builtInQuestions,
  });

  final AppConfig config;
  final SharedPreferences preferences;
  final Map<String, List<String>> builtInQuestions;

  @override
  void dependencies() {
    Get.put<AppConfig>(config, permanent: true);
    Get.put<SharedPreferences>(preferences, permanent: true);
    Get.put<Dio>(provideDio(appConfig: config), permanent: true);
    Get.put<QuestionsRepository>(
      QuestionsRepositoryImpl(
        builtInQuestions: builtInQuestions,
        preferences: preferences,
      ),
      permanent: true,
    );
    Get.put<GameService>(
      GameService(questionsRepository: Get.find<QuestionsRepository>()),
      permanent: true,
    );
    Get.put<SoundFxService>(SoundFxService(), permanent: true);
    Get.put<BgmService>(BgmService(), permanent: true);
    Get.put<ThemeRepository>(
      ThemeRepositorySharedPrefsImpl(preferences),
      permanent: true,
    );
    Get.put<GetThemeModeUseCase>(
      GetThemeModeUseCase(Get.find<ThemeRepository>()),
      permanent: true,
    );
    Get.put<SetThemeModeUseCase>(
      SetThemeModeUseCase(Get.find<ThemeRepository>()),
      permanent: true,
    );
    Get.put<OnboardingRepository>(
      OnboardingRepositorySharedPrefsImpl(preferences),
      permanent: true,
    );
    Get.put<GetOnboardingStateUseCase>(
      GetOnboardingStateUseCase(Get.find<OnboardingRepository>()),
      permanent: true,
    );
    Get.put<SetOnboardingStateUseCase>(
      SetOnboardingStateUseCase(Get.find<OnboardingRepository>()),
      permanent: true,
    );
    Get.put<ThemeController>(
      ThemeController(
        getThemeMode: Get.find<GetThemeModeUseCase>(),
        setThemeModeUseCase: Get.find<SetThemeModeUseCase>(),
      ),
      permanent: true,
    );

    final router = config.routerShape == 'shell'
        ? shell_routes.buildShellRouter()
        : root_routes.buildRootRouter();
    Get.put<GoRouter>(router, permanent: true);
  }
}
