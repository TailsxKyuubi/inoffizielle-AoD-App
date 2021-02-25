/*
 * Copyright 2020 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unoffical_aod_app/caches/settings/settings.dart';

class PlayerSettingsWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _PlayerSettingsState();

}

class _PlayerSettingsState extends State<PlayerSettingsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor
        ),
        child: ListView(
          children: [
            ListTile(
              title: Text(
                'Fortschritt immer anzeigen',
                style: TextStyle(
                    color: Colors.white
                ),
              ),
              trailing: Switch(
                onChanged: (bool value) {
                  setState(() {
                    settings!.playerSettings!.setAlwaysShowProgress(value);
                  });
                },
                value: settings!.playerSettings!.alwaysShowProgress,
              ),
            ),
            ListTile(
              title: Text(
                'Videoqualität',
                style: TextStyle(
                    color: Colors.white
                ),
              ),
              trailing: DropdownButton<String>(
                onChanged: (value) {

                  setState(() {
                    settings!.playerSettings!.setDefaultQuality(int.parse(value!));
                  });
                },
                value: settings!.playerSettings!.defaultQuality.toString(),
                style: TextStyle(
                  color: Colors.white,
                ),
                dropdownColor: Theme.of(context).primaryColor,
                items: [
                  DropdownMenuItem(
                    value: '0',
                    child: Text(
                      'Auto',
                    ),
                  ),
                  DropdownMenuItem(
                    value: '360',
                    child: Text(
                      '360p',
                    ),
                  ),
                  DropdownMenuItem(
                    value: '480',
                    child: Text(
                      '480p',
                    ),
                  ),
                  DropdownMenuItem(
                    value: '576',
                    child: Text(
                      '576p',
                    ),
                  ),
                  DropdownMenuItem(
                    value: '720',
                    child: Text(
                      '720p',
                    ),
                  ),
                  DropdownMenuItem(
                    value: '1080',
                    child: Text(
                      '1080p',
                    ),
                  ),
                  DropdownMenuItem(
                    value: '1081',
                    child: Text(
                      '1080p+',
                      style: TextStyle(
                        //color: Theme.of(context).accentColor
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text(
                'Folgenfortschritt speichern',
                style: TextStyle(
                    color: Colors.white
                ),
              ),
              trailing: Switch(
                onChanged: (bool value) {
                  setState(() {
                    settings!.playerSettings!.setSaveEpisodeProgress(value);
                  });
                },
                value: settings!.playerSettings!.saveEpisodeProgress,
              ),
            ),
          ],
        )
    );
  }
}