// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loadingFuse => 'Loading fuse';

  @override
  String get sistemaInnescoPronto => 'Fuse system ready';

  @override
  String get splashTagline => 'Pass it before it explodes!';

  @override
  String get edition => 'Edition';

  @override
  String get passAndPlayPill => 'Table pass-and-play';

  @override
  String get paroleSottoPressione => 'Words under pressure.';

  @override
  String get chiHaLaBomba => 'Whoever holds the bomb loses.';

  @override
  String get giocaSubito => 'Play now';

  @override
  String get regole => 'Rules';

  @override
  String get multiplayerStatus =>
      'Party game, play with your friends • 1 smartphone only';

  @override
  String get comeSiGioca => 'How to play';

  @override
  String get guidaRapida => 'Quick guide';

  @override
  String get regoleEssenziali => 'Essential rules in 3 simple moves.';

  @override
  String get zeroAttese => 'Zero waiting';

  @override
  String get timerSegreto => 'Secret timer';

  @override
  String get sceglieIlMazzo => 'Pick your deck';

  @override
  String get mazzoTesto =>
      'Enable one or more topics. Quick thinking makes the difference.';

  @override
  String get pronunciaEPassa => 'Say it and pass';

  @override
  String get pronunciaTesto =>
      'Say a relevant word out loud and immediately pass the smartphone to the next player.';

  @override
  String get detonazioneSorpresa => 'Surprise detonation';

  @override
  String get detonazioneTesto =>
      'The timer is secret and unpredictable. Whoever is holding the phone at';

  @override
  String get detonazioneTestoFinale => 'loses the round.';

  @override
  String get regolaDoro => 'Golden rule';

  @override
  String get regolaDoroTesto =>
      'No repeats in the same round and zero hesitation.';

  @override
  String get hoCapitoIniziamo => 'Got it, let\'s start!';

  @override
  String get tempoStimatoRound => 'Estimated time per round: ~45s';

  @override
  String get navLobby => 'Lobby';

  @override
  String get navRooms => 'Rooms';

  @override
  String get navVault => 'Vault';

  @override
  String get navConfig => 'Config';

  @override
  String get setupEyebrow => 'ROOM SETUP';

  @override
  String get setupTitle => 'PREPARE THE MATCH';

  @override
  String get setupSubtitle =>
      'Select players and categories to arm the detonator.';

  @override
  String get giocatoriAlTavolo => 'Players at the table';

  @override
  String get partecipanti => 'PLAYERS';

  @override
  String get rangeAmmissibile => 'Admissible range: 2 - 20';

  @override
  String get riduciGiocatori => 'Decrease players';

  @override
  String get aumentaGiocatori => 'Increase players';

  @override
  String get scegliLeCategorie => 'Pick the categories';

  @override
  String domandeDisponibili(int count) {
    return '$count questions';
  }

  @override
  String get selezionaTutte => 'Select all';

  @override
  String get deselezionaTutte => 'Deselect all';

  @override
  String get categoriaCasuale => 'Random category';

  @override
  String get categoriaAnimali => 'Animals';

  @override
  String get categoriaCiboBevande => 'Food & drinks';

  @override
  String get categoriaCalcio => 'Football';

  @override
  String get categoriaAnime => 'Anime';

  @override
  String get categoriaGeografia => 'Geography';

  @override
  String get categoriaFilmSerieTv => 'Movies & TV';

  @override
  String get categoriaMusica => 'Music';

  @override
  String get categoriaVideogiochi => 'Video games';

  @override
  String get categoriaVitaQuotidiana => 'Everyday life';

  @override
  String get categoriaCulturaGenerale => 'General knowledge';

  @override
  String get categoriaSupereroiFumetti => 'Superheroes & comics';

  @override
  String get categoriaParoleLettere => 'Words & letters';

  @override
  String get categoriaPersonalizzata => 'Custom category';

  @override
  String get categoriaPersonalizzataDesc => 'Add your own terms or house rules';

  @override
  String get categoriePersonalizzate => 'Custom categories';

  @override
  String get modificaCategoriaTitolo => 'Edit category';

  @override
  String get nuovaCategoriaTitolo => 'New category';

  @override
  String get nomeCategoriaLabel => 'Category name';

  @override
  String get nomeCategoriaHint => 'E.g. Famous quotes';

  @override
  String get nomeDuplicato => 'A category with this name already exists';

  @override
  String get domandeCategoria => 'Questions';

  @override
  String get domandaHint => 'E.g. Things you find at the beach';

  @override
  String get aggiungiDomanda => 'Add question';

  @override
  String get eliminaDomanda => 'Remove question';

  @override
  String get salvaCategoria => 'Save category';

  @override
  String get categoriaSalvata => 'Category added!';

  @override
  String get categoriaEliminata => 'Category deleted!';

  @override
  String get eliminaCategoriaTitolo => 'Delete category?';

  @override
  String eliminaCategoriaTesto(String name) {
    return '\"$name\" will be removed along with its questions.';
  }

  @override
  String get eliminaCategoriaConferma => 'Delete';

  @override
  String get eliminaCategoriaAnnulla => 'Cancel';

  @override
  String get detonatoreCasuale => 'Random detonator';

  @override
  String get detonatoreDescrizione =>
      'The algorithm computes a secret duration every round.';

  @override
  String get iniziaPartita => 'START MATCH';

  @override
  String get partitaInCorsoTitle => 'DETONATION IN PROGRESS';

  @override
  String get rispondiEPassa =>
      'Answer out loud and pass the smartphone right away!';

  @override
  String get bombaInMano => 'Bomb in hand';

  @override
  String get toccaAChiHaIlTelefono => 'Whoever holds the phone';

  @override
  String get inGioco => 'IN PLAY';

  @override
  String get passaIlTelefono => 'PASS THE PHONE';

  @override
  String get nessunaRipetizione => 'No repeats allowed';

  @override
  String get ticLabel => 'TIC...';

  @override
  String get tacLabel => 'TAC!';

  @override
  String get abbandonoTitolo => 'Leave the match?';

  @override
  String get abbandonoTesto =>
      'If you leave, the timer stops and the session ends.';

  @override
  String get abbandonoConferma => 'Leave';

  @override
  String get abbandonoAnnulla => 'Keep playing';

  @override
  String get detonazioneConfermata => 'DETONATION CONFIRMED';

  @override
  String get bombaEsplosaMessaggio => 'The bomb exploded in your hands!';

  @override
  String get sconfittaDelRound => 'Round lost';

  @override
  String get haiIlTelefonoInMano => 'You were holding the phone!';

  @override
  String get tempoLabel => 'Time';

  @override
  String secondiResistiti(int count) {
    return '${count}s survived';
  }

  @override
  String get giocaNuovaPartita => 'NEW MATCH';

  @override
  String get rigiochiManche => 'Replay the round now';

  @override
  String get tornaAllaHome => 'BACK TO HOME';

  @override
  String get impostazioni => 'Settings';

  @override
  String get impostazioniSottotitolo => 'Customize your gaming experience.';

  @override
  String get audioFeedback => 'Audio';

  @override
  String get effettiSonori => 'Sound Effects';

  @override
  String get effettiSonoriDesc => 'Ticking and high-dynamic explosion sound';

  @override
  String get musicaSottofondo => 'Background Music';

  @override
  String get musicaSottofondoDesc => 'Tense lounge beat with bpm progression';

  @override
  String get vibrazioneAptica => 'Haptic Vibration';

  @override
  String get vibrazioneApticaDesc =>
      'Tactile taps every second and discharge on detonation';

  @override
  String get infoGioco => 'Game Info';

  @override
  String get versioneBundle => 'Bundle Version';

  @override
  String get versioneBundleDesc => 'Minimal detonator architecture';

  @override
  String get versioneBundleTag => 'v1.0.0';
}
