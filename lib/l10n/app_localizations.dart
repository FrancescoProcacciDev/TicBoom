import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('it'),
  ];

  /// No description provided for @loadingFuse.
  ///
  /// In it, this message translates to:
  /// **'Caricamento miccia'**
  String get loadingFuse;

  /// No description provided for @sistemaInnescoPronto.
  ///
  /// In it, this message translates to:
  /// **'Sistema innesco pronto'**
  String get sistemaInnescoPronto;

  /// No description provided for @splashTagline.
  ///
  /// In it, this message translates to:
  /// **'Passala prima che esploda!'**
  String get splashTagline;

  /// No description provided for @edition.
  ///
  /// In it, this message translates to:
  /// **'Edition'**
  String get edition;

  /// No description provided for @passAndPlayPill.
  ///
  /// In it, this message translates to:
  /// **'Pass-and-play da tavolo'**
  String get passAndPlayPill;

  /// No description provided for @paroleSottoPressione.
  ///
  /// In it, this message translates to:
  /// **'Parole sotto pressione.'**
  String get paroleSottoPressione;

  /// No description provided for @chiHaLaBomba.
  ///
  /// In it, this message translates to:
  /// **'Chi ha la bomba perde.'**
  String get chiHaLaBomba;

  /// No description provided for @giocaSubito.
  ///
  /// In it, this message translates to:
  /// **'Gioca subito'**
  String get giocaSubito;

  /// No description provided for @regole.
  ///
  /// In it, this message translates to:
  /// **'Regole'**
  String get regole;

  /// No description provided for @setup.
  ///
  /// In it, this message translates to:
  /// **'Setup'**
  String get setup;

  /// No description provided for @multiplayerStatus.
  ///
  /// In it, this message translates to:
  /// **'Multiplayer offline fino a 20 giocatori • 1 solo smartphone'**
  String get multiplayerStatus;

  /// No description provided for @comeSiGioca.
  ///
  /// In it, this message translates to:
  /// **'Come si gioca'**
  String get comeSiGioca;

  /// No description provided for @guidaRapida.
  ///
  /// In it, this message translates to:
  /// **'Guida rapida'**
  String get guidaRapida;

  /// No description provided for @regoleEssenziali.
  ///
  /// In it, this message translates to:
  /// **'Regole essenziali in 3 semplici mosse.'**
  String get regoleEssenziali;

  /// No description provided for @zeroAttese.
  ///
  /// In it, this message translates to:
  /// **'Zero attese'**
  String get zeroAttese;

  /// No description provided for @timerSegreto.
  ///
  /// In it, this message translates to:
  /// **'Timer segreto'**
  String get timerSegreto;

  /// No description provided for @giocatoriRange.
  ///
  /// In it, this message translates to:
  /// **'2-20 giocatori'**
  String get giocatoriRange;

  /// No description provided for @sceglieIlMazzo.
  ///
  /// In it, this message translates to:
  /// **'Scegli il mazzo'**
  String get sceglieIlMazzo;

  /// No description provided for @mazzoTesto.
  ///
  /// In it, this message translates to:
  /// **'Attiva uno o più argomenti. La prontezza verbale farà la differenza.'**
  String get mazzoTesto;

  /// No description provided for @pronunciaEPassa.
  ///
  /// In it, this message translates to:
  /// **'Pronuncia e passa'**
  String get pronunciaEPassa;

  /// No description provided for @pronunciaTesto.
  ///
  /// In it, this message translates to:
  /// **'Di\' a voce alta una parola pertinente e passa immediatamente lo smartphone al giocatore successivo.'**
  String get pronunciaTesto;

  /// No description provided for @detonazioneSorpresa.
  ///
  /// In it, this message translates to:
  /// **'Detonazione a sorpresa'**
  String get detonazioneSorpresa;

  /// No description provided for @detonazioneTesto.
  ///
  /// In it, this message translates to:
  /// **'Il timer è segreto e imprevedibile (tra 15 e 60 secondi). Chi ha in mano il telefono al'**
  String get detonazioneTesto;

  /// No description provided for @detonazioneTestoFinale.
  ///
  /// In it, this message translates to:
  /// **'perde la manche.'**
  String get detonazioneTestoFinale;

  /// No description provided for @regolaDoro.
  ///
  /// In it, this message translates to:
  /// **'Regola d\'oro'**
  String get regolaDoro;

  /// No description provided for @regolaDoroTesto.
  ///
  /// In it, this message translates to:
  /// **'Niente ripetizioni nello stesso round e zero esitazioni.'**
  String get regolaDoroTesto;

  /// No description provided for @hoCapitoIniziamo.
  ///
  /// In it, this message translates to:
  /// **'Ho capito, iniziamo!'**
  String get hoCapitoIniziamo;

  /// No description provided for @tempoStimatoRound.
  ///
  /// In it, this message translates to:
  /// **'Tempo stimato per round: ~45s'**
  String get tempoStimatoRound;

  /// No description provided for @navLobby.
  ///
  /// In it, this message translates to:
  /// **'Lobby'**
  String get navLobby;

  /// No description provided for @navRooms.
  ///
  /// In it, this message translates to:
  /// **'Rooms'**
  String get navRooms;

  /// No description provided for @navVault.
  ///
  /// In it, this message translates to:
  /// **'Vault'**
  String get navVault;

  /// No description provided for @navConfig.
  ///
  /// In it, this message translates to:
  /// **'Config'**
  String get navConfig;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
