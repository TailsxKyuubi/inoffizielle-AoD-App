/*
 * Copyright 2020-2021 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unoffical_aod_app/caches/focusnode.dart';
import 'package:unoffical_aod_app/caches/global_key.dart';
import 'package:unoffical_aod_app/caches/keycodes.dart';
import 'package:unoffical_aod_app/caches/login.dart';
import 'package:unoffical_aod_app/caches/settings/settings.dart';
import 'package:unoffical_aod_app/widgets/navigation_bar_custom.dart';
import 'package:unoffical_aod_app/widgets/settings/app.dart';
import 'package:unoffical_aod_app/widgets/settings/custom_dropdown.dart';
import 'package:unoffical_aod_app/widgets/settings/player.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsPageState();

}

class _SettingsPageState extends State<SettingsPage> with SingleTickerProviderStateMixin {

  TabController _controller;
  bool _qualityDropdownOpen = false;

  @override
  void initState(){
    super.initState();
    generateFocusNodes();
    _controller = new TabController(vsync: this, length: 2);
    appSettingsFocusIndex = 0;
    playerSettingsFocusIndex = 0;
  }

  void generateFocusNodes(){
    appSettingsFocusNodes.clear();
    playerSettingsFocusNodes.clear();
    for(int i = 0;i < 4;i++){
      appSettingsFocusNodes.add(
          FocusNode(
              onKey: handleKeyAppSettings
          )
      );
    }
    for(int i = 0;i < 3;i++){
      playerSettingsFocusNodes.add(
          FocusNode(
              onKey: handleKeyPlayerSettings
          )
      );
    }
  }

  bool handleKeyPlayerSettings(FocusNode focusNode, RawKeyEvent event){
    if(Platform.isAndroid && event.data is RawKeyEventDataAndroid && event.runtimeType == RawKeyUpEvent){
      RawKeyEventDataAndroid eventData = event.data;
      print(playerSettingsFocusIndex);
      switch(eventData.keyCode){
        case KEY_UP:
          playerSettingsFocusIndex--;
          if(playerSettingsFocusIndex < 0){
            playerSettingsFocusIndex = 2;
          }
          break;
        case KEY_DOWN:
          playerSettingsFocusIndex++;
          print(playerSettingsFocusIndex);
          if(playerSettingsFocusIndex > 2){
            playerSettingsFocusIndex = 0;
          }
          break;
        case KEY_RIGHT:
        case KEY_LEFT:
          appSettingsFocusIndex = 0;
          this._controller.animateTo(0);
          FocusScope.of(context).requestFocus(appSettingsFocusNodes.first);
          return true;
        case KEY_CENTER:
          switch(playerSettingsFocusIndex){
            case 0:
              setState(() {
                settings.playerSettings.setAlwaysShowProgress(!settings.playerSettings.alwaysShowProgress);
              });
              break;
            case 1:
              CustomDropdownButtonState state = qualityDropdownKey.currentState;
              if(! this._qualityDropdownOpen){
                state.callTap();
                this._qualityDropdownOpen = true;
              }else{
                this._qualityDropdownOpen = false;
              }
              return false;
            case 2:
              setState(() {
                settings.playerSettings.setSaveEpisodeProgress(!settings.playerSettings.saveEpisodeProgress);
              });
              return false;
          }
          break;
        case KEY_BACK:
          exit(0);
          break;
        case KEY_MENU:
          setState(() {
            FocusScope.of(context).requestFocus(menuBarFocusNodes.first);
            appSettingsFocusIndex = 0;
            playerSettingsFocusIndex = 0;
          });
          return true;
      }
      FocusScope.of(context).requestFocus(
          playerSettingsFocusNodes[playerSettingsFocusIndex]
      );
    }
    return true;
  }

  bool handleKeyAppSettings(FocusNode focusNode, RawKeyEvent event){
    if(Platform.isAndroid && event.data is RawKeyEventDataAndroid && event.runtimeType == RawKeyUpEvent){
      RawKeyEventDataAndroid eventData = event.data;
      switch(eventData.keyCode){
        case KEY_UP:
          appSettingsFocusIndex--;
          if(appSettingsFocusIndex < 0){
            appSettingsFocusIndex = 3;
          }
          break;
        case KEY_DOWN:
          appSettingsFocusIndex++;
          if(appSettingsFocusIndex > 3){
            appSettingsFocusIndex = 0;
          }
          break;
        case KEY_RIGHT:
        case KEY_LEFT:
          playerSettingsFocusIndex = 0;
          this._controller.animateTo(1);
          FocusScope.of(context).requestFocus(playerSettingsFocusNodes.first);
          return true;
        case KEY_CENTER:
          switch(appSettingsFocusIndex){
            case 0:
              setState(() {
                settings.appSettings.setKeepSession(!settings.appSettings.keepSession);
              });
              break;
            case 1:
              logout().then((_){
                Navigator.pushReplacementNamed(context, '/base');
              });
              return true;
            case 2:
              Navigator.pushNamed(context, '/about');
              return true;
            case 3:
              Navigator.pushNamed(context, '/updates');
              return true;
          }
          break;
        case KEY_BACK:
          exit(0);
          break;
        case KEY_MENU:
          setState(() {
            FocusScope.of(context).requestFocus(menuBarFocusNodes.first);
          });
          appSettingsFocusIndex = 0;
          playerSettingsFocusIndex = 0;
          return true;
      }
      FocusScope.of(context).requestFocus(
          appSettingsFocusNodes[appSettingsFocusIndex]
      );
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBarCustom(this._controller.index == 0
          ? appSettingsFocusNodes.first
          : playerSettingsFocusNodes.first
      ),
      appBar: AppBar(
        title: Text('Einstellungen'),
        bottom: TabBar(
          controller: this._controller,
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
        //height: MediaQuery.of(context).size.height,
        child: TabBarView(
          controller: this._controller,
            children: [
              AppSettingsWidget(),
              PlayerSettingsWidget()
            ]
        ),
      ),
    );
  }
}