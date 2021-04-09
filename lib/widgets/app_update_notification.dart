/*
 * Copyright 2020-2021 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'package:flutter/material.dart';
import 'package:unoffical_aod_app/caches/app.dart';
import 'package:unoffical_aod_app/transfermodels/player.dart';
import 'package:unoffical_aod_app/caches/playercache.dart' as playerCache;
import 'package:unoffical_aod_app/caches/settings/settings.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdateNotificationDialog extends StatelessWidget {

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
          child:
          Column(
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                Center(
                  child: Text(
                    'Neue Version verfügbar',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Text('Für die App ist eine neue Version verfügbar.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                    )
                ),
                SizedBox(height: 24.0),
                Align(
                    alignment: Alignment.bottomRight,
                    child: Flex(
                        direction: Axis.horizontal,
                        children: [
                          Flexible(
                            child: FlatButton(
                              onPressed: (){
                                launch('https://github.com/TailsxKyuubi/inoffizielle-AoD-App/releases');
                              },
                              child: Text('Update herunterladen'),
                            ),
                          ),
                          Flexible(
                            child: FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  appCheckIsolate.resume();
                                },
                                child: Center(
                                    child: Text('Hinweis schließen')
                                )
                            ),
                          )
                        ]
                    )
                ),
              ]
          )
      ),
    );
  }
}