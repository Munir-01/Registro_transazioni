import 'dart:io'; //Per IOS
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart'; //Per IOS
import 'package:flutter/material.dart';

import './widgets/grafico.dart';
import './widgets/nuove_transazioni.dart';
import './widgets/lista_transazioni.dart';
import './models/transazioni.dart';

void main() {
  // SystemChrome.setPreferredOrientations([ //questo serve per bloccare il dispositivo e far funzionare l'app solo in verticale, in caso ci fosse necessità
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //tolgo il banner del debug
      theme: ThemeData(
        primarySwatch: Colors
            .orange, //genera delle sfumature di un colore scelto automaticamente sulla UI senza cambiare manualmente dappertutto
        accentColor: Colors.grey,
        fontFamily: 'Quicksand',
        //da qui fino ad appBarTheme regolo il font che avremo come titolo per le transazioni
        textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
              button: TextStyle(color: Colors.white),
            ),
        //DA QUA FINO A fontWeight, eseguo questa serie di comandi che dicono a flutter "mettimi questo preciso font su tu tte le eventuali app bar"
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
      title: 'Flutter app',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
// creazione della classe MyHomePage
//String inputTitolo;
//String inputImporto;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void initState(){
  Widget _buildBody (BuildContext context){
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('transazioni').snapshots(),
      builder: (context, snapshot){
        if (!snapshot.hasData)
        return null;
        print("no dati");
      },
    );
  }
  super.initState();
  }
  //faccio get
  final List<Transazioni> _transazioniUtente = [
    
    // Transazioni(
    //   id: 'Transazione2',
    //   titolo: 'Pantaloni nuovi',
    //   prezzo: 25.99,
    //   data: DateTime.now(),
    // ),
    //RICHIAMO GET

  ];


  bool _switchDelGrafico = false;

  List<Transazioni> get _transazioniRecentiGrafico {
    //tramite il where e i suoi comandi all'interno, filtriamo le transazioni e accettiamo solo quelle
    return _transazioniUtente.where(
      // degli ultimi 7 giorni per il grafico. Si poteva fare anche con un ciclo for.
      (transazioni) {
        return transazioni.data.isAfter(
          DateTime.now().subtract(
            Duration(days: 7),
          ),
        );
      },
    ).toList();
  }

  void _aggiungiNuovaTransazione(String titoloTransazione,
      double importoTransazione, DateTime dataInserita) {
   
      final nuovaTransazione = Transazioni(
        titolo: titoloTransazione,
        prezzo: importoTransazione,
        data: dataInserita,
        id: DateTime.now().toString(),
        /*DateTime.now().toString() ---> il contenuto vecchio di id*/
      );
      setState(
        () {
          _transazioniUtente.add(
              nuovaTransazione); //con questo .add AGGIUNGIAMO a _transazioniUtente i valori stabiliti in nuovaTransazione.
        }, // .add perchè non si poteva fare _transazioniUtente = nuovaTransazione siccome _transazionUtenti è
        // un valore final e non può cambiare
      );
    } 
    
  
  void _startAggiungiTransazione(BuildContext contestoStart) {
    showModalBottomSheet(
      context: contestoStart,
      builder: (_) {
        return GestureDetector(
          child: NuoveTransizioni(_aggiungiNuovaTransazione),
          onTap: () {},
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _eliminaTransazione(String id) {
    setState(() {
      _transazioniUtente.removeWhere((transazioni) {
        return transazioni.id == id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(
        context); //MediaQuery è una proprietà di orientamento dello schermo, infatti qua la usiamo ad esempio con ".size" e ".height"
    final inclinazioneDispositivo =
        mediaQuery.orientation == Orientation.landscape;
    // La classe PreferredSizeWidget serve per non dare errore nei ".preferredsize" sotto, perchè Dart non è in gradoì di scoprirlo da solo il valore di preferredSize
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Registro spese'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              //.min serve per dire all'app bar di IOS di prendere il minor spazio possibile per l'app bar, per farci stare anche de testo centrale
              //perchè normalmente se non si specifica .min, procede prendendo il massimo dello spazio e coprendo quindi tutto, facendo sparire il testo
              //dell'app bar e mostrando solo il pulsantino + in alto per aggiungere una transazione
              children: <Widget>[
                //creiamo un app bar personalizzata solo per IOS perchè copiare quella per android non va bene, da errore
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startAggiungiTransazione(context),
                )
              ],
            ),
          )
        : AppBar(
            title: Text('Registro spese'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _startAggiungiTransazione(context),
              ),
            ],
          );
    final listaTransazioniWidget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding
                  .top) * //stessa cosa anche qua per il padding e per appBar
          0.7,
      child: ListaTransazioni(_transazioniUtente, _eliminaTransazione),
    );

//creo una variabile di tipo FINAL che sarà il corpo della pagina dell'app, e lo nomineremo sia nel caso la piattaforma sia IOS che nel caso sia Android
//SafeArea serve per far rispettare gli spazi del grafico e degli atri widget nella pagina principale dell'app (su IOS)

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        //rende la tastiera "scrollabile" ed evita problemi di interferenza visiva con il textField, quindi non lo copre. In questo modo
        child: Column(
          //risolvo anche il problema della striscia nera e gialla che compare quando apri la tastiera per inserire i dati della transazione
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (inclinazioneDispositivo)
              Row(
                //if (...) è una sinstassi speciale che accorcia ed è come se dicessi "se (...) è vero allora fai quello che dico sotto"
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Mostra il grafico',
                    style: Theme.of(context).textTheme.title,
                  ),
                  Switch.adaptive(
                    //.adaptive regola la grafica del pulsante switch in base alla piattaforma in cui siamo (Android o IOS)
                    activeColor: Theme.of(context)
                        .accentColor, //per regolare il colore dello switch, discorso valido anche per IOS
                    value: _switchDelGrafico,
                    onChanged: (valoreSwitch) {
                      setState(
                        () {
                          _switchDelGrafico = valoreSwitch;
                        },
                      );
                    },
                  ),
                ],
              ),
            if (!inclinazioneDispositivo) // se inclinazionedeldispositivo è diversa dalla condizione stabilita ALLORA FAI:
              Container(
                height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding
                            .top) * //il padding in questo caso, è il riempimento automatico della UI che da flutter e se ne tiene conto
                    0.3, // in questo caso come se fosse la status bar, quindi '.top'. Così facendo elimineremo quel pezzo di padding
                child: Grafico(_transazioniRecentiGrafico),
              ),
            if (!inclinazioneDispositivo)
              listaTransazioniWidget, //se inclinazione del dispositivo è diversa dalla condizione stabilita mostrami anche la lista transazioni (cerca lista transazioni widget per capire meglio)
            if (inclinazioneDispositivo) //se inclinazione del dispositivo è vera, quindi rispetta le condizioni, allora esegui la parte sotto
              _switchDelGrafico
                  ? Container(
                      height: (mediaQuery.size.height -
                              appBar.preferredSize.height -
                              mediaQuery.padding
                                  .top) * //il padding in questo caso, è il riempimento automatico della UI che da flutter e se ne tiene conto
                          0.7, // in questo caso come se fosse la status bar, quindi '.top'. Così facendo elimineremo quel pezzo di padding
                      child: Grafico(_transazioniRecentiGrafico),
                    )
                  : listaTransazioniWidget,
          ],
        ),
      ),
    );

    return Platform.isIOS //logica di riconoscimento della piattaforma
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation: FloatingActionButtonLocation
                .centerFloat, //posizione del pulsante
            floatingActionButton: Platform
                    .isIOS //verifichiamo la piattaforma in cui gira l'app. se è ios allora si verifica il primo caso altrimenti il secondo
                ? Container()
                : FloatingActionButton(
                    //creazione del pulsante
                    child: Icon(Icons.add),
                    onPressed: () => _startAggiungiTransazione(context),
                    backgroundColor: Colors.orange,
                  ),
          );
  }
}
