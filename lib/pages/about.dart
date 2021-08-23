/*
 * Copyright 2020-2021 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unoffical_aod_app/caches/keycodes.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        leading: FlatButton(
          focusNode: FocusNode(
            onKey: (FocusNode focusNode,RawKeyEvent event){
              if(Platform.isAndroid && event.data is RawKeyEventDataAndroid && event.runtimeType == RawKeyUpEvent){
                RawKeyEventDataAndroid eventData = event.data as RawKeyEventDataAndroid;
                if(eventData.keyCode == KEY_CENTER){
                  Navigator.pop(context);
                }
              }
              return true;
            }
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(
              Icons.arrow_back,
              color: Colors.white
          ),
        ),
        title: Text('Über die App'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor
        ),
        child: Column(
          children: [
            Image.asset(
              'images/logo.png',
              scale: 6,
            ),
            Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  'Developed by:',
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),
                )
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                'TailsxKyuubi',
                textAlign: TextAlign.start,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                'Special Thanks:',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                'Tami',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                'Licensed with the AGPL License',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 20),
                child: GestureDetector(
                  onTap:() => launch('https://anime-on-demand.de/datenschutz'),
                  child: Text(
                    'Datenschutz',
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 20
                    ),
                  ),
                )
            )
          ],
        ),
      ),
    );
  }

}