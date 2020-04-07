import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transazioni.dart';

class ListaTransazioni extends StatelessWidget {
  final List<Transazioni> transazioni;
  final Function eliminaTransazione;

  ListaTransazioni(this.transazioni,
      this.eliminaTransazione); //con this. e final function sopra ci ricolleghiamo a '_eliminaTransazione' nel main.dart

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350, // definiamo l'altezza del contenitore
      child: transazioni
              .isEmpty // verifica delle presenza o meno di eventuali transazioni
          ? LayoutBuilder(
              builder: (ctx, vincoli) {
                return Column(
                  //stilizzazione del messaggio della pagina vuota
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Nessuna spesa!',
                      style: Theme.of(context)
                          .textTheme
                          .title, //puntatore dello stile predefinito nel main file
                    ),
                    SizedBox(
                      //con questo regolo la distanza fra la scritta e l'immagine
                      height: 5,
                    ),
                    Container(
                      height: vincoli.maxHeight * 0.5,
                      child: Image.asset(
                        'assets/images/empty-box.png',
                        fit: BoxFit
                            .cover, //rende l'immagine adatta allo schermo perchè altrimenti sarebbe troppo grande
                      ),
                    )
                  ],
                );
              },
            )
          : ListView.builder(
            
              // se ci sono transazioni si esegue questo
              //ListView ci permette lo scorrimento CORRETTO SOLO SE definiamo l'laltezza del contenitore, altrimenti esegue uno scorrimento infinito
              itemBuilder: (valoreContesto, indexDelValoreContesto) {
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.all(6),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      radius: 30,
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: FittedBox(
                          child: Text(
                            '€ ${transazioni[indexDelValoreContesto].prezzo}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      transazioni[indexDelValoreContesto].titolo,
                      style: Theme.of(context).textTheme.title,
                    ),
                    subtitle: Text(
                      DateFormat.yMMMMd()
                          .format(transazioni[indexDelValoreContesto].data),
                    ),
                    trailing: MediaQuery.of(context).size.width > 450
                        ? FlatButton.icon(
                            //.icon è un cortuttore speciale che ci permette di mettere del testo affianco a un icona, in questo caso, il tutto su un bottone
                            textColor: Theme.of(context).errorColor,
                            icon: Icon(Icons.delete),
                            onPressed: () => eliminaTransazione(
                                transazioni[indexDelValoreContesto].id),
                            label: Text('Elimina'),
                          )
                        : IconButton(
                            icon: Icon(Icons.delete),
                            color: Theme.of(context).errorColor,
                            onPressed: () => eliminaTransazione(
                                //IMPORTANTE! onPressed non passa alcun argomento! per elimnare correttamente serve l'argomento con dentro
                                transazioni[indexDelValoreContesto]
                                    .id), //id, quindi utilizziamo questa sintassi per farlo!
                          ),
                  ),
                );

                //DA QUA IN POI IL VECCHIO METODO DI VISUALIZZAZIONE DELLE TRANSAZIONI

                // return Card(
                //   //inizio modellazione card
                //   child: Row(
                //     children: <Widget>[
                //       Container(
                //         //ti serve per contenere dentro il child Text di transazioneSingola e stilizzarlo a piacimento
                //         margin:
                //             EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                //         decoration: BoxDecoration(
                //           border: Border.all(
                //             color: Theme.of(context)
                //                 .primaryColor, //collegamento tramie la classe "Theme" a ThemeData nel file main.dart, per controllare i colori
                //             width: 2,
                //           ),
                //         ),
                //         padding: EdgeInsets.all(10),

                //         child: Text(
                //           '€ ${transazioni[indexDelValoreContesto].prezzo.toStringAsFixed(2)}',
                //           //toStringAsFixed, in questo caso DECIDE quanti numeri decimali abbiamo dopo la virgola (in questo caso 2)
                //           // transazioneSingola.prezzo.toString(), => evito di allungare troppo, e grazie alla sintassi speciale
                //           style: TextStyle(
                //             //GUARDA LA LEZIONE "WORKING WITH LISTWIEVS PER CAPIRE MEGLIO IL PASSAGGIO NELLA RIGA 33 E 14"
                //             // del $, faccio un interpolazione che mi da lo stesso risultato
                //             fontWeight: FontWeight.bold,
                //             color: Theme.of(context).primaryColor,
                //             fontSize: 20,
                //           ),
                //         ),
                //       ),
                //       Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: <Widget>[
                //           Container(
                //             child: Text(
                //               transazioni[indexDelValoreContesto].titolo,
                //               style: Theme.of(context)
                //                   .textTheme
                //                   .title, // punto lo stile del testo gia regolato a inzio del main dart file per i titoli delle transazioni
                //             ),
                //           ),
                //           Container(
                //             child: Text(
                //               DateFormat.yMMMMd().format(transazioni[
                //                       indexDelValoreContesto]
                //                   .data), // DateFormate e il relativo .format sono forniti dal pacchetto intl, messo anche nel .yaml file
                //               style: TextStyle(
                //                 //stilizzazione data
                //                 color: Colors.grey,
                //               ),
                //             ),
                //           ), // fine modellazione della card mischiata con colonne righe (come da schema sul quaderno)
                //         ],
                //       ),
                //     ],
                //   ),
                // );

                //FINE VECCHIO METODO
              },
              itemCount: transazioni.length, //quante transazioni abbiamo
            ),
    );
  }
}
