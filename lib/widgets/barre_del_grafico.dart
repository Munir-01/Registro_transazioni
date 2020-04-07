import 'package:flutter/material.dart';

class BarreGrafico extends StatelessWidget {
  final String etichettaGiorno;
  final double importoTotaleGiorno;
  final double percentualeImportoTotale;

  BarreGrafico(this.etichettaGiorno, this.importoTotaleGiorno,
      this.percentualeImportoTotale);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, vincoli) {
        //ctx = context | vincoli= vincoli applicati al widget che sono altezza e largezza (height and width)
        return Column(
          children: <Widget>[
            Container(
              height: vincoli.maxHeight * 0.15,
              child: FittedBox(
                //fittedBox evita che un testo o nel nostro caso, una cifra molto grande sul grafico vada a capo doo aver raggiunto il llimite di spazio disponibile.
                //con fittedBox, semplicemente, si rimpiccioliscono i caratteri
                child: Text('€ ${importoTotaleGiorno.toStringAsFixed(0)}'),
              ),
            ),
            //toStringAsFixed = sistema i numeri decimali per NON farli vedere come ad es: 9.999999999999999
            // con 0 rimuovo i decimali
            SizedBox(height: vincoli.maxHeight * 0.05),
            Container(
              height: vincoli.maxHeight * 0.6,
              width: 10,
              child: Stack(
                //Stack permette di mettere dei widget uno sopra l'altro (nel vero senso della parola, li sovrappone)
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.0),
                      color: Color.fromRGBO(220, 220, 220,
                          1), //RGBO funziona esattamente come il set dei colori rgb, solo che aggiunge anche l'opacità
                      borderRadius: BorderRadius.circular(
                          10), //con border radius diamo forma circolare ai singoli contenitori del grafico di ogni giorno
                    ),
                  ),
                  FractionallySizedBox(
                    heightFactor: percentualeImportoTotale,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: vincoli.maxHeight * 0.05,
            ),
            Container(
              height: vincoli.maxHeight * 0.15,
              child: FittedBox(
                child: Text(etichettaGiorno),
              ),
            )
          ],
        );
      },
    );
  }
}
