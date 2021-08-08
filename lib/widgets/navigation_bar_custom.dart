/*
 * Copyright 2020-2021 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unoffical_aod_app/caches/focusnode.dart';
import 'package:unoffical_aod_app/caches/keycodes.dart';
import 'package:unoffical_aod_app/widgets/navigation_element.dart';

class NavigationBarCustom extends StatefulWidget {
  final FocusNode firstFocusNode;

  NavigationBarCustom(this.firstFocusNode);
  @override
  State<StatefulWidget> createState() => _NavigationBarCustomState(this.firstFocusNode);

}

class _NavigationBarCustomState extends State<NavigationBarCustom> {

  int _itemIndex = 0;

  final FocusNode firstFocusNode;

  _NavigationBarCustomState(this.firstFocusNode);

  @override
  void initState(){
    this.generateFocusNodes();
    super.initState();
  }

  void generateFocusNodes(){
    menuBarFocusNodes.clear();
    for(int i = 0; i < 4; i++){
      menuBarFocusNodes.add(
          FocusNode(
              onKey: handleKeys
          )
      );
    }
  }

  bool handleKeys(FocusNode focusNode, RawKeyEvent keyEvent){
    if(Platform.isAndroid && keyEvent.data is RawKeyEventDataAndroid && keyEvent.runtimeType == RawKeyUpEvent){
      RawKeyEventDataAndroid keyEventData = keyEvent.data;
      bool positionChanged = false;
      switch(keyEventData.keyCode){
        case KEY_RIGHT:
          this._itemIndex++;
          if(this._itemIndex > 3){
            this._itemIndex = 0;
          }
          positionChanged = true;
          break;
        case KEY_LEFT:
          this._itemIndex--;
          if(this._itemIndex < 0){
            this._itemIndex = 3;
          }
          positionChanged = true;
          break;
        case KEY_CENTER:
          switch(this._itemIndex){
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/animes');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/lists');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/settings');
              break;
          }
          return true;
        case KEY_MENU:
        case KEY_UP:
          FocusScope.of(context).requestFocus(this.firstFocusNode);
          setState(() {});
          break;
      }
      if(positionChanged){
        FocusScope.of(context).requestFocus(menuBarFocusNodes[this._itemIndex]);
        setState(() {});
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
        child: Row(
          children: [
            NavigationElement(
              icon: Icons.home,
              label: 'Startseite',
              routeName: '/home',
              focusNode: menuBarFocusNodes[0],
              onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
              first: true
            ),
            NavigationElement(
              icon: Icons.video_library,
              label: 'Anime',
              focusNode: menuBarFocusNodes[1],
              routeName: '/animes',
              onPressed: () => Navigator.pushReplacementNamed(context, '/animes'),
              first: false,
            ),
            NavigationElement(
              icon: Icons.list,
              label: 'Listen',
              focusNode: menuBarFocusNodes[2],
              routeName: '/lists',
              onPressed: () => Navigator.pushReplacementNamed(context, '/lists'),
              first: false,
            ),
            NavigationElement(
              icon: Icons.settings,
              label: 'Einstellungen',
              routeName: '/settings',
              focusNode: menuBarFocusNodes[3],
              onPressed: () => Navigator.pushReplacementNamed(context, '/settings'),
              first: false,
            ),
          ],
        )
    );
  }
}