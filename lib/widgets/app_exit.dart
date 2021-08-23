/*
 * Copyright 2020-2021 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:unoffical_aod_app/caches/app.dart';

class AppExitDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    const double padding = 16.0;
    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
          padding: EdgeInsets.only(
            top: padding*2,
            left: padding,
            right: padding,
          ),
          decoration: new BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5),
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
                  'App beenden?',
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                    'Willst du wirklich die App beenden?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 16.0,
                    )
                ),
                SizedBox(height: 24.0),
                Row(
                    children: [
                      TextButton(
                        onPressed: (){
                          exit(0);
                        },
                        child: Text(
                          'App beenden',
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                          appCheckIsolate.resume();
                        },
                        child: Text(
                          'Hinweis schließen',
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                    ]
                ),
              ]
          )
      ),
    );
  }
}