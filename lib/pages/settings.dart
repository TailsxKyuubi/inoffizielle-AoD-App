/*
 * Copyright 2020 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unoffical_aod_app/widgets/drawer.dart';
import 'package:unoffical_aod_app/widgets/navigation_bar.dart';
import 'package:unoffical_aod_app/widgets/settings/app.dart';
import 'package:unoffical_aod_app/widgets/settings/player.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
      DefaultTabController(
          length: 2,
          child: Scaffold(
            drawer: DrawerWidget(),
            appBar: AppBar(
              title: Text('Einstellungen'),
              bottom: TabBar(
                tabs: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10,top: 10),
                    child: Text('App'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10,top: 10),
                    child: Text('Player'),
                  ),
                ],
              ),
            ),
            body: Container(
              height: MediaQuery.of(context).size.height,
              child: TabBarView(
                  children: [
                    AppSettingsWidget(),
                    PlayerSettingsWidget()
                  ]
              ),
            ),
          )
      );
  }

}