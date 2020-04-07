import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveFlatButton extends StatelessWidget {
  final String testoSulBottoneData;
  final Function selettoreDataBottone;

  AdaptiveFlatButton(this.testoSulBottoneData, this.selettoreDataBottone);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS //creazione pulsante selezione data per IOS
        ? CupertinoButton(
            child: Text(
              testoSulBottoneData,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 18,
              ),
            ),
            onPressed: selettoreDataBottone,
          )
        : FlatButton(
            textColor: Theme.of(context).primaryColor,
            child: Text(
              testoSulBottoneData,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 18,
              ),
            ),
            onPressed: selettoreDataBottone,
          );
  }
}
