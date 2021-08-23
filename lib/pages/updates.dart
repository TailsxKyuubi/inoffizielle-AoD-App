/*
 * Copyright 2020-2021 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unoffical_aod_app/caches/keycodes.dart';
import 'package:unoffical_aod_app/caches/version.dart' as versionCache;

class UpdatesPage extends StatelessWidget {
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
        title: Text('Updates'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(
          top: 20,
          bottom: 20,
        ),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(5),
              child: Text(
                'Du verwendest die Version '+versionCache.version.toString() +' der App',
                style: TextStyle(
                    color: Colors.white
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: Text(
                'Die aktuellen Versionen zur App gibts unter https://github.com/TailsxKyuubi/inoffizielle-AoD-App',
                style: TextStyle(
                    color: Colors.white
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: Text(
                'Aktuelle News zur App gibts unter https://twitter.com/TailsxKyuubi',
                style: TextStyle(
                    color: Colors.white
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}