/*
 * Copyright 2020 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the 4-Clause BSD License
 */
import 'package:flutter/material.dart';
import 'package:unoffical_aod_app/caches/settings/settings.dart';

class AppSettingsWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppSettingsState();
}

class AppSettingsState extends State<AppSettingsWidget>{
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
              onChanged: (bool value) {
                setState(() {
                  settings.appSettings.setKeepSession(value);
                });
              },
              value: settings.appSettings.keepSession,
            ),
          ),
        ],
      ),
    );
  }
}