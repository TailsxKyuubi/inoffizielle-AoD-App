import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:unoffical_aod_app/caches/focusnode.dart';
import 'package:unoffical_aod_app/caches/keycodes.dart';
import 'package:unoffical_aod_app/widgets/navigation_element.dart';

class NavigationBarCustom extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NavigationBarCustomState();
}

class _NavigationBarCustomState extends State<NavigationBarCustom> {

  @override
  Widget build(BuildContext context) {
    return Container (
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor
        ),
        child: RawKeyboardListener(
            focusNode: menuBarFocusNode,
            onKey: (RawKeyEvent event){
              if(Platform.isAndroid && event.data is RawKeyEventDataAndroid && event.runtimeType == RawKeyUpEvent ){
                RawKeyEventDataAndroid eventDataAndroid = event.data;
                FocusScopeNode scope = FocusScope.of(context);
                switch(eventDataAndroid.keyCode){
                  case KEY_LEFT:
                    if(menuBarIndex > 0){
                      menuBarIndex--;
                    }
                    break;
                  case KEY_RIGHT:
                    if(menuBarIndex < 2){
                      menuBarIndex++;
                    }
                    break;
                }
              }
            },
            child: Row(
              children: [
                NavigationElement(
                  label: 'Startseite',
                  routeName: '/home',
                  icon: Icons.home,
                  focusNode: menuBarElementsFocusNodes.first,
                  onPressed: (){
                    Navigator.pushReplacementNamed(context, '/home');
                    homeRowIndex = 0;
                    homeRowItemIndex = 0;
                    FocusScope.of(context).requestFocus(homeFocusNode);
                  },
                ),
                NavigationElement(
                  label: 'Anime',
                  routeName: '/animes',
                  icon: Icons.video_library,
                  focusNode: menuBarElementsFocusNodes[1],
                  onPressed: (){
                    Navigator.pushReplacementNamed(context, '/animes');
                    animeFocusNodesIndex = -1;
                    FocusScope.of(context).requestFocus(animeFocusNode);
                  },
                ),
                NavigationElement(
                  label: 'Einstellungen',
                  routeName: '/settings',
                  icon: Icons.settings,
                  focusNode: menuBarElementsFocusNodes[2],
                  onPressed: (){
                    Navigator.pushReplacementNamed(context, '/settings');
                  },
                )
              ],
            )
        )
    );
  }
}