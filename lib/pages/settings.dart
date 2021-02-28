/*
 * Copyright 2020 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unoffical_aod_app/caches/focusnode.dart';
import 'package:unoffical_aod_app/caches/keycodes.dart';
import 'package:unoffical_aod_app/widgets/navigation_bar.dart';
import 'package:unoffical_aod_app/widgets/settings/app.dart';
import 'package:unoffical_aod_app/widgets/settings/player.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
      RawKeyboardListener(
          focusNode: FocusNode(),
          autofocus: true,
          onKey: (event){
            print('triggered');
            FocusScopeNode scope = FocusScope.of(context);
            if(scope.hasPrimaryFocus){
              print('has primary focus');
              scope.requestFocus(appSettingsFocusNodes.first);
            }else{
              if( Platform.isAndroid && event.data is RawKeyEventDataAndroid && event.runtimeType == RawKeyUpEvent ){
                RawKeyEventDataAndroid eventDataAndroid = event.data;
                switch(eventDataAndroid.keyCode){
                  case KEY_UP:
                    appSettingsFocusIndex--;
                    playerSettingsFocusIndex--;
                    break;
                  case KEY_DOWN:
                    appSettingsFocusIndex--;
                    playerSettingsFocusIndex--;
                    break;
                }
              }
            }
          },
          child: DefaultTabController(
              length: 2,
              child: Scaffold(
                bottomNavigationBar: NavigationBar(),
                appBar: AppBar(
                  title: Text('Einstellungen'),
                  bottom: TabBar(
                    unselectedLabelColor: Colors.white,
                    labelColor: Theme.of(context).accentColor,
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
          )
      );
  }

}