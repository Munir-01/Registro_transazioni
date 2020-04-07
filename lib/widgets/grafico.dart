import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './barre_del_grafico.dart';
import '../models/transazioni.dart';

class Grafico extends StatelessWidget {
  final List<Transazioni> transazioniSettimana;

  Grafico(this.transazioniSettimana);

  List<Map<String, Object>> get gruppoDiTransazioniGrafico {
    return List.generate(
      7,
      (index) {
        final giornoSettimanale = DateTime.now().subtract(
          Duration(days: index),
        );
        var sommaSettimanaleTot = 0.0;
        for (var i = 0; i < transazioniSettimana.length; i++) {
          if (transazioniSettimana[i].data.day == giornoSettimanale.day &&
              transazioniSettimana[i].data.month == giornoSettimanale.month &&
              transazioniSettimana[i].data.year == giornoSettimanale.year) {
            sommaSettimanaleTot += transazioniSettimana[i].prezzo;
          }
        }
        return {
          'Giorno': DateFormat.E().format(giornoSettimanale).substring(0,
              1), //substring accorcia i nomi dei giorni in una sola lettera quindi in questo caso
          //partono dalla lettera 0 (la prima) e finiscono alla lettera 1 (esattamente quella dopo) quindi si vedrà solo la prima lettera
          'Importo': sommaSettimanaleTot,
        };
      },
    ).reversed.toList();// in questo modo diamo un orine ai giorni della settimana nel grafico
  }

  double get totSpesa {
    return gruppoDiTransazioniGrafico.fold(
        //con fold si cambiano i valori che si ottengono dal return (lezione 101)
        0.0, // valore iniziale
        (somma, ogetto) {
      return somma + ogetto['Importo']; // modifica del valore
    });
  }

  @override
  Widget build(BuildContext context) {
    print(gruppoDiTransazioniGrafico);
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: gruppoDiTransazioniGrafico.map((datiTransazioniSettimana) {
            return Flexible(//con Flexible evito il caso in cui l'inserimento di cifre alte vada a schiacciare le altre barre del grafico
              fit: FlexFit.tight,// tight evita lo schiacciamento delle altre barre del grafico e obbliga ogni barra a usare solo il suo spazio disponibile
                        child: BarreGrafico(
                datiTransazioniSettimana['Giorno'],
                datiTransazioniSettimana['Importo'],
                //il "totSpesa == 0 ? 0.0 :" fa in modo tale che il grafico non si inceppi mandando in errore l'app, perche quando fai restart, senza questo paragone,
                // sarebbe come dividere 'importo' / totSpesa, e totSpesa al riavvio è uguale a 0 e non è mai una buona idea dividere per 0.
                //questa comparazione booleana è come se dicesse:
                //"se totSpesa = 0.0 allora eseguimi sul grafico 0.0, ALTRIMENTI eseguimi il calcolo 'importo' / totSpesa"
                //e così evitiamo l'errore!
                totSpesa == 0.0 ? 0.0 : (datiTransazioniSettimana['Importo'] as double) / totSpesa,
              ),
            ); // as double ci permette di usare il / in questo caso, altrimenti non sarebbe possibile
          }).toList(),
        ),
      ),
    );
  }
}
