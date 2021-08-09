import 'dart:io';

import 'package:flutter/material.dart';
import 'package:unoffical_aod_app/widgets/lists/favorites.dart';
import 'package:unoffical_aod_app/widgets/lists/history.dart';
import 'package:unoffical_aod_app/widgets/lists/watchlist.dart';
import 'package:unoffical_aod_app/widgets/navigation_bar_custom.dart';
import 'package:flutter/services.dart';
import 'package:unoffical_aod_app/caches/keycodes.dart';
import 'package:unoffical_aod_app/caches/focusnode.dart';

class ListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ListWidgetState();
}
class _ListWidgetState extends State<ListPage> with SingleTickerProviderStateMixin {
  List<FocusNode> _focusNodes = [];
  int _focusIndex = 0;
  List<String> _focusNodeRoutes = [
    '/history',
    '/watchlist',
    '/favorites'
  ];

  TabController _controller;
  @override
  void initState(){
    super.initState();
    _controller = new TabController(vsync: this, length: 3);
    appSettingsFocusIndex = 0;
    playerSettingsFocusIndex = 0;
  }

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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: Container(
          padding: EdgeInsets.only(top: 35),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor
          ),
          child: TabBar(
            controller: this._controller,
            unselectedLabelColor: Colors.white,
            labelColor: Theme.of(context).accentColor,
            tabs: [
              Padding(
                padding: EdgeInsets.only(bottom: 15,top: 10),
                child: Text('Watchlist'),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 15, top: 10),
                child: Text('Favoriten'),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 15, top: 10),
                child: Text('Verlauf'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBarCustom(this._focusNodes.first),
      body: TabBarView(
          controller: this._controller,
          children: [
            WatchlistWidget(),
            FavoritesWidget(),
            HistoryWidget()
          ]
      ),
    );
  }

}