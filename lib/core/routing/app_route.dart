enum AppRoute {
  splash('/splash'),
  onboarding('/onboarding'),
  home('/home'),
  profile('/profile'),
  gameConfig('/game-config'),
  howToPlayRules('/how-to-play-rules'),
  gameSettings('/game-settings');

  final String path;

  const AppRoute(this.path);
}
