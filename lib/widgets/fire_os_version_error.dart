/*
 * Copyright 2020-2021 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'package:flutter/material.dart';
import 'package:unoffical_aod_app/caches/app.dart';

class FireOsVersionErrorDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    const double padding = 16.0;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,

      child: Container(
          padding: EdgeInsets.only(
            top: padding*2,
            left: padding,
            right: padding,
          ),
          decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(padding),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                )
              ]),
          child: Column(
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                Text(
                  'Fire OS Versionsfehler',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                    'Die verwendete Version von FireOS wird von dieser App nicht offiziell unterstützt',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                    )
                ),
                Text(
                    'Du kannst die App weiterhin benutzen, allerdings können dabei Fehler auftreten. Es wird empfohlen deinen FireTV zu aktualisieren',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                    )
                ),
                SizedBox(height: 24.0),
                Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                        children: [
                          FlatButton(
                            onPressed: (){
                              Navigator.pop(context);
                              appCheckIsolate.resume();
                            },
                            child: Text('Hinweis schließen'),
                          ),
                        ]
                    )
                ),
              ]
          )
      ),
    );
  }
}