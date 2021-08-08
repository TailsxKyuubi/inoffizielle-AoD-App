import 'dart:io';

import 'package:flutter/material.dart';
import 'package:unoffical_aod_app/widgets/lists/list.dart';
import 'package:unoffical_aod_app/widgets/navigation_bar_custom.dart';
import 'package:flutter/services.dart';
import 'package:unoffical_aod_app/caches/keycodes.dart';
import 'package:unoffical_aod_app/caches/focusnode.dart';

class ListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ListWidgetState();
}
class _ListWidgetState extends State<ListPage> {
  List<FocusNode> _focusNodes = [];
  int _focusIndex = 0;
  List<String> _focusNodeRoutes = [
    '/history',
    '/watchlist',
    '/favorites'
  ];

  _ListWidgetState() {
    this._focusNodes.add(
        FocusNode(
            onKey: handleKey
        )
    );
  }

  bool handleKey(FocusNode focusNode, RawKeyEvent event) {
    if( Platform.isAndroid && event.data is RawKeyEventDataAndroid && event.runtimeType == RawKeyUpEvent ){
      RawKeyEventDataAndroid eventDataAndroid = event.data;
      FocusScopeNode scope = FocusScope.of(context);
      switch(eventDataAndroid.keyCode){
        case KEY_DOWN:
          this._focusIndex += 4;
          if(this._focusIndex >= 2){
            //this._animeFocusIndex = this.animeFocusNodes.length - this._animeFocusIndex;
            FocusScope.of(context).requestFocus(menuBarFocusNodes.first);
            return true;
          }
          scope.requestFocus(
              this._focusNodes[this._focusIndex]
          );
          break;
        case KEY_UP:
          _focusIndex -= 4;
          if(this._focusIndex < 0){
            this._focusIndex = -1;
            FocusScope.of(context).requestFocus(searchFocusNode);
          }else{
            scope.requestFocus(
                this._focusNodes[this._focusIndex]
            );
          }
          break;
        case KEY_RIGHT:
          this._focusIndex++;
          if(this._focusIndex >= 2){
            //this._animeFocusIndex = 0;
            FocusScope.of(context).requestFocus(menuBarFocusNodes.first);
            return true;
          }
          scope.requestFocus(
              this._focusNodes[this._focusIndex]
          );
          break;
        case KEY_LEFT:
          this._focusIndex--;
          if(this._focusIndex < 0){
            this._focusIndex = -1;
            FocusScope.of(context).requestFocus(searchFocusNode);
          }else{
            scope.requestFocus(
                this._focusNodes[this._focusIndex]
            );
          }
          break;
        case KEY_MENU:
          setState(() {
            scope.requestFocus(menuBarFocusNodes.first);
          });
          this._focusIndex = 0;
          return true;
        case KEY_BACK:
          exit(0);
          return true;
        case KEY_CENTER:
          Navigator.pushNamed(
              context,
              this._focusNodeRoutes[this._focusIndex],
          );
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Radius radius = Radius.circular(2);
    double elementWidth;
    MediaQueryData mediaQuery = MediaQuery.of(context);
    if(mediaQuery.orientation == Orientation.landscape){
      elementWidth = (mediaQuery.size.width-40)*0.25-7.5;
    }else{
      elementWidth = (mediaQuery.size.width-40)*0.5-7.5;
    }
    double elementHeight = elementWidth / 16 * 9;
    return Scaffold(
      appBar: AppBar(
        title: Text('Listen'),
      ),
      bottomNavigationBar: NavigationBarCustom(this._focusNodes.first),
      body: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
        height: mediaQuery.size.height,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor
        ),
        child: Wrap(
          children: [
            ListWidget(
                'Verlauf',
                Icons.history,
                elementWidth,
                elementHeight,
                radius,
                FocusNode(),
                '/history'
            ),
            ListWidget(
                'Watchlist',
                Icons.bookmarks,
                elementWidth,
                elementHeight,
                radius,
                FocusNode(),
                '/watchlist'
            ),
            ListWidget(
                'Favoriten',
                Icons.star,
                elementWidth,
                elementHeight,
                radius,
                FocusNode(),
                '/favorites'
            ),
          ],
        ),
      ),
    );
  }

}