/*
 * Copyright 2020 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'package:flutter/material.dart';
import 'package:unoffical_aod_app/caches/focusnode.dart';
import 'package:unoffical_aod_app/caches/login.dart';
import 'package:unoffical_aod_app/caches/settings/settings.dart';

class AppSettingsWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppSettingsState();
}

class AppSettingsState extends State<AppSettingsWidget> {
  FocusNode aboutFocusNode = FocusNode();
  FocusNode logoutFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: ListView(
        children: [
          ListTile(
            title: Text(
              'Sitzung merken (WIP)',
              style: TextStyle(
                  color: Colors.white
              ),
            ),
            trailing: Switch(
              focusColor: Theme.of(context).accentColor,
              onChanged: (bool value) {
                setState(() {
                  settings.appSettings.setKeepSession(value);
                });
              },
              value: settings.appSettings.keepSession,
            ),
          ),
          FlatButton(
            focusColor: Theme.of(context).accentColor,
            focusNode: this.logoutFocusNode,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Text(
                'Logout',
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.normal
                ),
              ),
            ),
            onPressed: () async{
              await logout();
              Navigator.pushReplacementNamed(context, '/base');
            },
          ),
          FlatButton(
            focusColor: Theme.of(context).accentColor,
            focusNode: this.aboutFocusNode,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Text(
                'Über die App',
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.normal,
                ),
              ),
            ),
            onPressed: (){
              Navigator.pushNamed(context, '/about');
            },
          ),
        ],
      ),
    );
  }
}