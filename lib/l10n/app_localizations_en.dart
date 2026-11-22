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
  String get setup => 'Setup';

  @override
  String get multiplayerStatus =>
      'Offline multiplayer up to 20 players • 1 single smartphone';

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
  String get giocatoriRange => '2-20 players';

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
      'The timer is secret and unpredictable (between 15 and 60 seconds). Whoever is holding the phone at';

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
  String get categoriaAnimali => 'Animals';

  @override
  String get categoriaCiboBevande => 'Food & drinks';

  @override
  String get categoriaCalcio => 'Football';

  @override
  String get categoriaAnime => 'Anime';

  @override
  String get categoriaPersonalizzata => '+ Custom category';

  @override
  String get categoriaPersonalizzataDesc => 'Add your own terms or house rules';

  @override
  String get detonatoreCasuale => 'Random detonator';

  @override
  String get detonatoreDescrizione =>
      'The algorithm computes a secret duration every round.';

  @override
  String get iniziaPartita => 'START MATCH';

  @override
  String get attive => 'active';

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
}
