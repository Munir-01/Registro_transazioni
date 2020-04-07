import 'package:flutter/foundation.dart'; //abbaimo messo foundation.dart perche è questa estensione che contiene "@required"

class Transazioni {  // abbiamo 4 parametri che identificano ogni acquisto, e dovrebbero essere final, perchè una volta decisi non dovrebbero cambiare
 final String titolo; //@rquired fa in modo che sia obbligatorio il parametro selezionato 
 final String id;
 final double prezzo;
 final DateTime data;

  Transazioni({@required this.titolo, @required this.id, @required this.prezzo, @required this.data}); //creiamo un costruttore di tipo "named arguments", in modo tale da specificare di cosa parlo (in questo caso specifico con this.)
}


