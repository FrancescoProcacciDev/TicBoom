/// Domande di gioco, definite direttamente in Dart (nessun database):
/// ogni categoria è associata alla propria lista di domande.
///
/// Struttura volutamente semplice ed espandibile: per aggiungere domande
/// basta estendere le liste esistenti; per aggiungere categorie basta
/// aggiungere nuove chiavi alla mappa.
const Map<String, List<String>> gameQuestions = {
  'ANIMALI': [
    'Animali che iniziano con la lettera A',
    'Animali che vivono in acqua',
    'Animali che possono volare',
    'Animali che vivono nella savana',
    'Animali che hanno quattro zampe',
    'Animali che iniziano con la lettera C',
    'Animali che si trovano in una fattoria',
    'Animali che depongono le uova',
    'Animali che vivono nella foresta',
    'Animali che hanno le corna',
  ],
  'CIBO E BEVANDE': [
    'Cibi che iniziano con la lettera P',
    'Frutti di colore rosso',
    'Piatti tipici della cucina italiana',
    'Bevande analcoliche',
    'Ingredienti che si possono mettere sulla pizza',
    'Dolci che contengono cioccolato',
    'Cibi che si mangiano a colazione',
    'Tipi di pasta',
    'Frutti tropicali',
    'Cibi che si mangiano con le mani',
  ],
  'CALCIO': [
    'Squadre che giocano o hanno giocato in Serie A',
    'Calciatori brasiliani',
    "Calciatori che hanno vinto il Pallone d'Oro",
    'Squadre che hanno vinto la Champions League',
    'Calciatori italiani',
    'Squadre della Premier League',
    'Calciatori che hanno giocato nel Real Madrid',
    'Portieri famosi',
    'Nazionali che hanno partecipato ai Mondiali',
    'Calciatori che hanno giocato nella Juventus',
  ],
  'ANIME': [
    'Personaggi di Naruto',
    'Personaggi di One Piece',
    'Personaggi di Dragon Ball',
    'Personaggi di Demon Slayer',
    'Personaggi di Jujutsu Kaisen',
    'Personaggi anime che combattono con una spada',
    'Personaggi anime con i capelli bianchi',
    'Personaggi di Attack on Titan',
    'Anime che hanno più di 50 episodi',
    'Personaggi anime che utilizzano poteri legati al fuoco',
  ],
};
