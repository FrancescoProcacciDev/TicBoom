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

  /// No description provided for @multiplayerStatus.
  ///
  /// In it, this message translates to:
  /// **'Party Game, gioca con i tuoi amici • 1 solo smartphone'**
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
  /// **'Il timer è segreto e imprevedibile. Chi ha in mano il telefono al'**
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

  /// No description provided for @setupEyebrow.
  ///
  /// In it, this message translates to:
  /// **'CONFIGURAZIONE SALA'**
  String get setupEyebrow;

  /// No description provided for @setupTitle.
  ///
  /// In it, this message translates to:
  /// **'PREPARA LA PARTITA'**
  String get setupTitle;

  /// No description provided for @setupSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Seleziona giocatori e categorie per armare il detonatore.'**
  String get setupSubtitle;

  /// No description provided for @giocatoriAlTavolo.
  ///
  /// In it, this message translates to:
  /// **'Giocatori al tavolo'**
  String get giocatoriAlTavolo;

  /// No description provided for @partecipanti.
  ///
  /// In it, this message translates to:
  /// **'PARTECIPANTI'**
  String get partecipanti;

  /// No description provided for @rangeAmmissibile.
  ///
  /// In it, this message translates to:
  /// **'Range ammissibile: 2 - 20'**
  String get rangeAmmissibile;

  /// No description provided for @riduciGiocatori.
  ///
  /// In it, this message translates to:
  /// **'Riduci giocatori'**
  String get riduciGiocatori;

  /// No description provided for @aumentaGiocatori.
  ///
  /// In it, this message translates to:
  /// **'Aumenta giocatori'**
  String get aumentaGiocatori;

  /// No description provided for @scegliLeCategorie.
  ///
  /// In it, this message translates to:
  /// **'Scegli le categorie'**
  String get scegliLeCategorie;

  /// No description provided for @domandeDisponibili.
  ///
  /// In it, this message translates to:
  /// **'{count} domande'**
  String domandeDisponibili(int count);

  /// No description provided for @selezionaTutte.
  ///
  /// In it, this message translates to:
  /// **'Seleziona tutte'**
  String get selezionaTutte;

  /// No description provided for @deselezionaTutte.
  ///
  /// In it, this message translates to:
  /// **'Deseleziona tutte'**
  String get deselezionaTutte;

  /// No description provided for @categoriaCasuale.
  ///
  /// In it, this message translates to:
  /// **'Categoria casuale'**
  String get categoriaCasuale;

  /// No description provided for @categoriaAnimali.
  ///
  /// In it, this message translates to:
  /// **'Animali'**
  String get categoriaAnimali;

  /// No description provided for @categoriaCiboBevande.
  ///
  /// In it, this message translates to:
  /// **'Cibo e bevande'**
  String get categoriaCiboBevande;

  /// No description provided for @categoriaCalcio.
  ///
  /// In it, this message translates to:
  /// **'Calcio'**
  String get categoriaCalcio;

  /// No description provided for @categoriaAnime.
  ///
  /// In it, this message translates to:
  /// **'Anime'**
  String get categoriaAnime;

  /// No description provided for @categoriaGeografia.
  ///
  /// In it, this message translates to:
  /// **'Geografia'**
  String get categoriaGeografia;

  /// No description provided for @categoriaFilmSerieTv.
  ///
  /// In it, this message translates to:
  /// **'Film e serie TV'**
  String get categoriaFilmSerieTv;

  /// No description provided for @categoriaMusica.
  ///
  /// In it, this message translates to:
  /// **'Musica'**
  String get categoriaMusica;

  /// No description provided for @categoriaVideogiochi.
  ///
  /// In it, this message translates to:
  /// **'Videogiochi'**
  String get categoriaVideogiochi;

  /// No description provided for @categoriaVitaQuotidiana.
  ///
  /// In it, this message translates to:
  /// **'Vita quotidiana'**
  String get categoriaVitaQuotidiana;

  /// No description provided for @categoriaCulturaGenerale.
  ///
  /// In it, this message translates to:
  /// **'Cultura generale'**
  String get categoriaCulturaGenerale;

  /// No description provided for @categoriaSupereroiFumetti.
  ///
  /// In it, this message translates to:
  /// **'Supereroi e fumetti'**
  String get categoriaSupereroiFumetti;

  /// No description provided for @categoriaParoleLettere.
  ///
  /// In it, this message translates to:
  /// **'Parole e lettere'**
  String get categoriaParoleLettere;

  /// No description provided for @categoriaPersonalizzata.
  ///
  /// In it, this message translates to:
  /// **'Categoria personalizzata'**
  String get categoriaPersonalizzata;

  /// No description provided for @categoriaPersonalizzataDesc.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi i tuoi lemmi o regole del gruppo'**
  String get categoriaPersonalizzataDesc;

  /// No description provided for @categoriePersonalizzate.
  ///
  /// In it, this message translates to:
  /// **'Categorie personalizzate'**
  String get categoriePersonalizzate;

  /// No description provided for @modificaCategoriaTitolo.
  ///
  /// In it, this message translates to:
  /// **'Modifica categoria'**
  String get modificaCategoriaTitolo;

  /// No description provided for @nuovaCategoriaTitolo.
  ///
  /// In it, this message translates to:
  /// **'Nuova categoria'**
  String get nuovaCategoriaTitolo;

  /// No description provided for @nomeCategoriaLabel.
  ///
  /// In it, this message translates to:
  /// **'Nome categoria'**
  String get nomeCategoriaLabel;

  /// No description provided for @nomeCategoriaHint.
  ///
  /// In it, this message translates to:
  /// **'Es. Citazioni famose'**
  String get nomeCategoriaHint;

  /// No description provided for @nomeDuplicato.
  ///
  /// In it, this message translates to:
  /// **'Esiste già una categoria con questo nome'**
  String get nomeDuplicato;

  /// No description provided for @domandeCategoria.
  ///
  /// In it, this message translates to:
  /// **'Domande'**
  String get domandeCategoria;

  /// No description provided for @domandaHint.
  ///
  /// In it, this message translates to:
  /// **'Es. Cose che trovi in spiaggia'**
  String get domandaHint;

  /// No description provided for @aggiungiDomanda.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi domanda'**
  String get aggiungiDomanda;

  /// No description provided for @eliminaDomanda.
  ///
  /// In it, this message translates to:
  /// **'Elimina domanda'**
  String get eliminaDomanda;

  /// No description provided for @salvaCategoria.
  ///
  /// In it, this message translates to:
  /// **'Salva categoria'**
  String get salvaCategoria;

  /// No description provided for @categoriaSalvata.
  ///
  /// In it, this message translates to:
  /// **'Categoria aggiunta!'**
  String get categoriaSalvata;

  /// No description provided for @categoriaEliminata.
  ///
  /// In it, this message translates to:
  /// **'Categoria eliminata!'**
  String get categoriaEliminata;

  /// No description provided for @eliminaCategoriaTitolo.
  ///
  /// In it, this message translates to:
  /// **'Eliminare la categoria?'**
  String get eliminaCategoriaTitolo;

  /// No description provided for @eliminaCategoriaTesto.
  ///
  /// In it, this message translates to:
  /// **'\"{name}\" verrà rimossa insieme alle sue domande.'**
  String eliminaCategoriaTesto(String name);

  /// No description provided for @eliminaCategoriaConferma.
  ///
  /// In it, this message translates to:
  /// **'Elimina'**
  String get eliminaCategoriaConferma;

  /// No description provided for @eliminaCategoriaAnnulla.
  ///
  /// In it, this message translates to:
  /// **'Annulla'**
  String get eliminaCategoriaAnnulla;

  /// No description provided for @detonatoreCasuale.
  ///
  /// In it, this message translates to:
  /// **'Detonatore casuale'**
  String get detonatoreCasuale;

  /// No description provided for @detonatoreDescrizione.
  ///
  /// In it, this message translates to:
  /// **'L\'algoritmo calcola una durata segreta ad ogni turno.'**
  String get detonatoreDescrizione;

  /// No description provided for @iniziaPartita.
  ///
  /// In it, this message translates to:
  /// **'INIZIA PARTITA'**
  String get iniziaPartita;

  /// No description provided for @partitaInCorsoTitle.
  ///
  /// In it, this message translates to:
  /// **'DETONAZIONE IN CORSO'**
  String get partitaInCorsoTitle;

  /// No description provided for @rispondiEPassa.
  ///
  /// In it, this message translates to:
  /// **'Rispondi a voce alta e passa subito lo smartphone!'**
  String get rispondiEPassa;

  /// No description provided for @bombaInMano.
  ///
  /// In it, this message translates to:
  /// **'Bomba in mano'**
  String get bombaInMano;

  /// No description provided for @toccaAChiHaIlTelefono.
  ///
  /// In it, this message translates to:
  /// **'Tocca a chi ha il telefono'**
  String get toccaAChiHaIlTelefono;

  /// No description provided for @inGioco.
  ///
  /// In it, this message translates to:
  /// **'IN GIOCO'**
  String get inGioco;

  /// No description provided for @passaIlTelefono.
  ///
  /// In it, this message translates to:
  /// **'PASSA IL TELEFONO'**
  String get passaIlTelefono;

  /// No description provided for @nessunaRipetizione.
  ///
  /// In it, this message translates to:
  /// **'Nessuna ripetizione ammessa'**
  String get nessunaRipetizione;

  /// No description provided for @ticLabel.
  ///
  /// In it, this message translates to:
  /// **'TIC...'**
  String get ticLabel;

  /// No description provided for @tacLabel.
  ///
  /// In it, this message translates to:
  /// **'TAC!'**
  String get tacLabel;

  /// No description provided for @abbandonoTitolo.
  ///
  /// In it, this message translates to:
  /// **'Abbandonare la partita?'**
  String get abbandonoTitolo;

  /// No description provided for @abbandonoTesto.
  ///
  /// In it, this message translates to:
  /// **'Se esci, il timer si interrompe e la sessione termina.'**
  String get abbandonoTesto;

  /// No description provided for @abbandonoConferma.
  ///
  /// In it, this message translates to:
  /// **'Abbandona'**
  String get abbandonoConferma;

  /// No description provided for @abbandonoAnnulla.
  ///
  /// In it, this message translates to:
  /// **'Continua a giocare'**
  String get abbandonoAnnulla;

  /// No description provided for @detonazioneConfermata.
  ///
  /// In it, this message translates to:
  /// **'DETONAZIONE CONFERMATA'**
  String get detonazioneConfermata;

  /// No description provided for @bombaEsplosaMessaggio.
  ///
  /// In it, this message translates to:
  /// **'La bomba è esplosa tra le tue mani!'**
  String get bombaEsplosaMessaggio;

  /// No description provided for @sconfittaDelRound.
  ///
  /// In it, this message translates to:
  /// **'Sconfitta del round'**
  String get sconfittaDelRound;

  /// No description provided for @haiIlTelefonoInMano.
  ///
  /// In it, this message translates to:
  /// **'Hai il telefono in mano!'**
  String get haiIlTelefonoInMano;

  /// No description provided for @tempoLabel.
  ///
  /// In it, this message translates to:
  /// **'Tempo'**
  String get tempoLabel;

  /// No description provided for @secondiResistiti.
  ///
  /// In it, this message translates to:
  /// **'{count}s resistiti'**
  String secondiResistiti(int count);

  /// No description provided for @giocaNuovaPartita.
  ///
  /// In it, this message translates to:
  /// **'GIOCA NUOVA PARTITA'**
  String get giocaNuovaPartita;

  /// No description provided for @rigiochiManche.
  ///
  /// In it, this message translates to:
  /// **'Rigiochi subito la manche'**
  String get rigiochiManche;

  /// No description provided for @tornaAllaHome.
  ///
  /// In it, this message translates to:
  /// **'TORNA ALLA HOME'**
  String get tornaAllaHome;

  /// No description provided for @impostazioni.
  ///
  /// In it, this message translates to:
  /// **'Impostazioni'**
  String get impostazioni;

  /// No description provided for @impostazioniSottotitolo.
  ///
  /// In it, this message translates to:
  /// **'Personalizza l\'esperienza di gioco.'**
  String get impostazioniSottotitolo;

  /// No description provided for @audioFeedback.
  ///
  /// In it, this message translates to:
  /// **'Audio'**
  String get audioFeedback;

  /// No description provided for @effettiSonori.
  ///
  /// In it, this message translates to:
  /// **'Effetti Sonori'**
  String get effettiSonori;

  /// No description provided for @effettiSonoriDesc.
  ///
  /// In it, this message translates to:
  /// **'Suono ticchettio ed esplosione ad alta dinamica'**
  String get effettiSonoriDesc;

  /// No description provided for @musicaSottofondo.
  ///
  /// In it, this message translates to:
  /// **'Musica di Sottofondo'**
  String get musicaSottofondo;

  /// No description provided for @musicaSottofondoDesc.
  ///
  /// In it, this message translates to:
  /// **'Beat lounge di tensione con progressione bpm'**
  String get musicaSottofondoDesc;

  /// No description provided for @vibrazioneAptica.
  ///
  /// In it, this message translates to:
  /// **'Vibrazione Aptica'**
  String get vibrazioneAptica;

  /// No description provided for @vibrazioneApticaDesc.
  ///
  /// In it, this message translates to:
  /// **'Colpi tattili ad ogni secondo e scarica al detonare'**
  String get vibrazioneApticaDesc;

  /// No description provided for @infoGioco.
  ///
  /// In it, this message translates to:
  /// **'Info Gioco'**
  String get infoGioco;

  /// No description provided for @versioneBundle.
  ///
  /// In it, this message translates to:
  /// **'Versione Bundle'**
  String get versioneBundle;

  /// No description provided for @versioneBundleDesc.
  ///
  /// In it, this message translates to:
  /// **'Architettura Minimal detonatore'**
  String get versioneBundleDesc;

  /// No description provided for @versioneBundleTag.
  ///
  /// In it, this message translates to:
  /// **'v1.0.0'**
  String get versioneBundleTag;

  /// No description provided for @salvaPreferenze.
  ///
  /// In it, this message translates to:
  /// **'Salva Preferenze'**
  String get salvaPreferenze;

  /// No description provided for @preferenzeSincronizzate.
  ///
  /// In it, this message translates to:
  /// **'Preferenze sincronizzate con successo.'**
  String get preferenzeSincronizzate;
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
