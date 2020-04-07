
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:registro_transazioni/widgets/adaptive_flat_button.dart';



class NuoveTransizioni extends StatefulWidget {
  final Function aggiungiNuoveTransizioni;

  NuoveTransizioni(this.aggiungiNuoveTransizioni);
  @override
  _NuoveTransizioniState createState() => _NuoveTransizioniState();
}

class _NuoveTransizioniState extends State<NuoveTransizioni> {
  final _titoloController = TextEditingController();
  final _importoController = TextEditingController();
  DateTime _dataSelezionata; // non è final perchè la data può cambiare

  void _confermaDati() {
    if (_importoController.text.isEmpty) {
      return;
    }
    final titoloInserito = _titoloController.text;
    final importoInserito = double.parse(_importoController
        .text); //double.parse coverte il valore importo controller (text) in un valore double (quindi a decimali), cosa importante per il prezzo

    if (titoloInserito.isEmpty ||
        importoInserito <= 0 ||
        _dataSelezionata == null) {
      //controllo dei valori per evitare errori
      return; // se i valori sono errati, return fa in modo che si stoppi la funzione e quindi darà errore e non aggiungerà nessun elemento nella lista transazioni
    }

    widget.aggiungiNuoveTransizioni(
      titoloInserito,
      importoInserito,
      _dataSelezionata,
    );
    Navigator.of(context)
        .pop(); //fa in modo che il fogli a comparsa si chiuda dopo aver inserito i dati della nuova transazione
  }

  void _selettoreData() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then(
        //then ci serve per prendere la data inserita
        (dataInserita) {
      if (dataInserita == null) {
        // con questo if facciamo un controllo, e riavviamo il processo nel caso la data inserita fosse nulla
        return;
      }
      setState(() {
        // dobbiamo mettere il setstate per aggiornare l'interfaccia UI. SETSTATE È IL TRIGGER PER DIRE A FLUTTER DI AGGIORNARE IL WIDGET!!
        _dataSelezionata = dataInserita;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      //in questo caso ci serve per scorrere nel foglio a comparsa (per aggiungere una transazione) quando è aperta la tastiera e non si vedono i campi sottostanti
      //il vantaggio è che puoi riemire più campi senza dover sempre chiudere e riaprire la tastiera
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
            top: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom +
                10, //viewInsets da informazioni su qualsiasi cosa giri sulla nostra vista (tipicamente è la soft keyboard del cellulare), mentre bottom ci dice quanto spazio è occupato da quella tastiera (la soft keyboard)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                cursorColor: Colors.orange,
                decoration: InputDecoration(labelText: 'Titolo'),
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 18,
                ),
                controller: _titoloController,
                onSubmitted: (_) =>
                    _confermaDati(), //(_) accetta il valore che ci da confermaDati ma NON lo utlizza
                //onChanged: (chiaveUtente){    // chiaveUtente è di tipo string ma non ce bisogno di specificarlo perche dart lo capisce autonomamente se
                //inputTitolo = chiaveUtente; // messo in quella posizione
                // },
              ),
              TextField(
                cursorColor: Colors.orange,
                decoration: InputDecoration(labelText: 'Importo'),
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 18,
                ),
                controller: _importoController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) =>
                    _confermaDati(), // mettendo il () davanti a conferma dati possiamo far partire automaticamente la fuzione premendo sulla tastiera
                // del cellulare il pulsante invio. questo perchè () se ricordi, fa partire la funzione automaticamente.
                // onChanged: (chiaveUtente){
                //  inputImporto = chiaveUtente;
                // },

              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Flexible(
                      fit: FlexFit.tight,
                      child: Text(
                        _dataSelezionata == null
                            ? 'Nessuna data inserita'
                            : DateFormat.yMMMMd().format(
                                _dataSelezionata), // ce bisogno del format per visualizzare correttamente la data sulla UI
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 18,
                        ),
                      ),
                    ),
                  AdaptiveFlatButton('Scegli data', _selettoreData),  
                  ],
                ),
              ),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
                onPressed:
                    _confermaDati, // qui, a differenza di TextField, non mettiamo (), e bisognerà cliccare perforza sul pulsante "aggiungi transazione" per triggerarlo
                child: Text(
                  'Aggiungi transazione',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
