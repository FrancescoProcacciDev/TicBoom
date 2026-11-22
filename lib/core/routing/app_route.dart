enum AppRoute {
  splash('/splash'),
  onboarding('/onboarding'),
  home('/home'),
  profile('/profile'),
  gameConfig('/game-config'),
  howToPlayRules('/how-to-play-rules'),
  gameSettings('/app-settings'),
  partyRooms('/party-rooms'),
  vaultRecords('/vault-records');

  final String path;

  const AppRoute(this.path);
}
