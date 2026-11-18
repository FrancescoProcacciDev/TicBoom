// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'App';

  @override
  String get homeMenuTitle => 'HOME MENU';

  @override
  String get partyModeReady => 'PARTY MODE READY';

  @override
  String get play => 'PLAY';

  @override
  String get howToPlay => 'HOW TO PLAY';

  @override
  String get settings => 'SETTINGS';

  @override
  String get multiplayerBadge => 'LOCAL MULTIPLAYER • 2-20 PLAYERS';

  @override
  String get navParty => 'PARTY';

  @override
  String get navSetup => 'SETUP';

  @override
  String get navRules => 'RULES';

  @override
  String get navSettings => 'SETTINGS';

  @override
  String get partyGameEsplosivo => 'EXPLOSIVE PARTY GAME';

  @override
  String get splashHeadline => 'Pass it before';

  @override
  String get splashHeadlineAccent => 'it explodes!';

  @override
  String get splashSubtitle =>
      'The frantic pass-and-play party board game to make sparks fly with your friends.';

  @override
  String get explosionAlertLevel => 'EXPLOSION ALERT LEVEL 10';

  @override
  String get loadingFuse => 'Loading fuse';
}
