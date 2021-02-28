/*
 * Copyright 2020 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unoffical_aod_app/caches/anime.dart';
import 'package:unoffical_aod_app/caches/focusnode.dart';
import 'package:unoffical_aod_app/caches/home.dart';
import 'package:unoffical_aod_app/caches/keycodes.dart';
import 'package:unoffical_aod_app/widgets/navigation_bar.dart';

class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {
  ScrollController _scrollController = ScrollController();
  ScrollController _newEpisodesScrollController = ScrollController();
  ScrollController _newSimulcastsScrollController = ScrollController();
  ScrollController _newCatalogTitlesScrollController = ScrollController();
  ScrollController _topTenScrollController = ScrollController();

  List<FocusNode> newEpisodesFocusNodes = [];
  List<FocusNode> newSimulcastsFocusNodes = [];
  List<FocusNode> newCatalogTitlesFocusNodes = [];
  List<FocusNode> topTenFocusNodes = [];

  List<FocusNode> _getRowFocusNodesByIndex(int index){
    switch(index){
      case 1:
        return newEpisodesFocusNodes;
      case 2:
        return newSimulcastsFocusNodes;
      case 3:
        return newCatalogTitlesFocusNodes;
      case 4:
        return topTenFocusNodes;
      default:
        return newEpisodesFocusNodes;
    }
  }


  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double elementWidth;
    if(MediaQuery.of(context).orientation == Orientation.portrait){
      elementWidth = MediaQuery.of(context).size.width / 7 * 3;
    }else{
      elementWidth = MediaQuery.of(context).size.width / 11 * 2;
    }
    double elementHeight = elementWidth / 16 * 9 + 40;
    int newEpisodesCount = 0;
    int newSimulcastsCount = 0;
    int newCatalogTitlesCount = 0;
    int topTenCount = 0;
    return /*RawKeyboardListener(
        focusNode: homeFocusNode,
        autofocus: true,
        onKey: (RawKeyEvent event){
          print('onKey triggered');
          if( Platform.isAndroid && event.data is RawKeyEventDataAndroid && event.runtimeType == RawKeyUpEvent ){
            RawKeyEventDataAndroid eventDataAndroid = event.data;
            FocusScopeNode scope = FocusScope.of(context);
            if(homeFocusNode.hasPrimaryFocus){
              print('primary focus lies on root Node');
              scope.unfocus();
              scope.requestFocus(newEpisodesFocusNodes.first);
              homeRowIndex = 1;
            }else if(menuBarFocusNode.hasFocus){
              switch(eventDataAndroid.keyCode){
                case KEY_RIGHT:
                  break;
                case KEY_LEFT:

                  break;
                case KEY_UP:
                  homeRowIndex = 1;
                  homeRowItemIndex = 0;
                  break;
              }
            }else{
              switch(eventDataAndroid.keyCode){
                case KEY_UP:
                  homeRowIndex--;
                  switch(homeRowIndex) {
                    case 0:
                      homeRowIndex = 1;
                      scope.requestFocus(newEpisodesFocusNodes.first);
                      break;
                    case 1:
                      scope.requestFocus(newEpisodesFocusNodes.first);
                      break;
                    case 2:
                      scope.requestFocus(newSimulcastsFocusNodes.first);
                      break;
                    case 3:
                      scope.requestFocus(newCatalogTitlesFocusNodes.first);
                      break;
                  }
                  print('homeRowIndex: $homeRowIndex');
                  print('homeRowItemIndex: $homeRowItemIndex');
                  homeRowItemIndex = 0;
                  break;
                case KEY_DOWN:
                  homeRowIndex++;
                  switch(homeRowIndex){
                    case 2:
                      scope.requestFocus(newSimulcastsFocusNodes.first);
                      break;
                    case 3:
                      scope.requestFocus(newCatalogTitlesFocusNodes.first);
                      break;
                    case 4:
                      scope.requestFocus(topTenFocusNodes.first);
                      break;
                    case 5:
                      homeRowIndex = 4;
                      scope.requestFocus(topTenFocusNodes.first);
                      break;
                  }
                  print('homeRowIndex: $homeRowIndex');
                  print('homeRowItemIndex: $homeRowItemIndex');
                  homeRowItemIndex = 0;
                  break;
                case KEY_LEFT:
                case KEY_RIGHT:
                  if( eventDataAndroid.keyCode == KEY_LEFT ){
                    homeRowItemIndex--;
                  }else{
                    homeRowItemIndex++;
                  }
                  List<FocusNode> focusNodes = _getRowFocusNodesByIndex(homeRowIndex);
                  if(homeRowItemIndex < 0){
                    //homeRowIndex--;
                    homeRowItemIndex++;
                  }else if(homeRowItemIndex >= focusNodes.length){
                    //homeRowIndex += 1;
                    homeRowItemIndex--;
                  }
                  print('homeRowIndex: $homeRowIndex');
                  print('homeRowItemIndex: $homeRowItemIndex');
                  //focusNodes = _getRowFocusNodesByIndex(homeRowIndex);
                  scope.requestFocus(focusNodes[homeRowItemIndex]);
                  break;
                case KEY_MENU:
                  scope.requestFocus(menuBarFocusNode);
                  break;
              }

              ScrollController controller;
              switch(homeRowIndex){
                case 1:
                  controller = _newEpisodesScrollController;
                  break;
                case 2:
                  controller = _newSimulcastsScrollController;
                  break;
                case 3:
                  controller = _newCatalogTitlesScrollController;
                  break;
                case 4:
                  controller = _topTenScrollController;
                  break;
              }
              controller.animateTo(elementWidth*homeRowItemIndex, curve: Curves.ease, duration: Duration(milliseconds: 300));
              this._scrollController.animateTo((elementHeight+40)*(homeRowIndex-1), duration: Duration(milliseconds: 300), curve: Curves.ease);
            }
            //setState(() {});
          }
        },
        child:*/  Scaffold(
        appBar: AppBar(
          title: Text('Startseite'),
          /*leading: FlatButton(
            onPressed: () {
              FocusScope.of(context).requestFocus(menuBarFocusNode);
            },
            child: Icon(
                Icons.menu,
                color: Colors.white
            ),
          ),*/
        ),
        bottomNavigationBar: NavigationBar(),
        //drawer: DrawerWidget(),
        body: Container(
          padding: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor
          ),
          child: ListView(
              controller: _scrollController,
              children:[
                Container(
                  margin: EdgeInsets.only(
                      bottom: 10,left: 10
                  ),
                  child: Text(
                    'NEUE EPISODEN',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 20,
                      fontFamily: 'Cabin Condensed',
                    ),
                  ),
                ),
                Container(
                    height: elementHeight+10,
                    child: ListView(
                      controller: _newEpisodesScrollController,
                      scrollDirection: Axis.horizontal,
                      children: newEpisodes.map<Widget>((e){
                        Uri url = Uri.parse(e['image']);
                        //String seriesName = e['series_name'].split(':')[0];
                        String animeName;
                        int limiter = 14;
                        int maxLimiter = 17;
                        if(e['series_name'].length > limiter){
                          int index = e['series_name'].indexOf(' ',limiter);
                          if(index != -1 && index <= maxLimiter) {
                            animeName = e['series_name'].substring(
                                0, e['series_name'].indexOf(' ', limiter)) + ' ...';
                          }else if(index > maxLimiter || e['series_name'].length > maxLimiter){
                            animeName = e['series_name'].substring(0,maxLimiter) + ' ...';
                          }else{
                            animeName = e['series_name'];
                          }
                        }else{
                          animeName = e['series_name'];
                        }

                        return FlatButton(
                            focusColor: Theme.of(context).accentColor,
                            padding: EdgeInsets.all(3),
                            onPressed: (){
                              Navigator.pushNamed(
                                context,
                                '/anime',
                                arguments: Anime(
                                  name: e['series_name'],
                                  id: int.parse(e['series_id']),
                                ),
                              );
                            },
                            //focusNode: newEpisodesFocusNodes[newEpisodesCount++],
                            focusNode: FocusNode(),
                            child: Container(
                                width: elementWidth,
                                //margin: EdgeInsets.only(right: 5,left: 5),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(5)
                                    ),
                                    child: Column(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: 'https://'+url.host+url.path,
                                          width: elementWidth,
                                          height: elementHeight-40,
                                        ),
                                        Container(
                                          width: elementWidth,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).accentColor,
                                          ),
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 2,
                                                  vertical: 3
                                              ),
                                              child: Text(
                                                animeName,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Theme.of(context).primaryColor
                                                ),
                                              )
                                          ),
                                        ),
                                        Container(
                                            width: elementWidth,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 3
                                            ),
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(66,69,68,1),
                                            ),
                                            child: Text
                                              (
                                              'Folge ' + e['episode_number']
                                                  .replaceAll('GRATIS','')
                                                  .replaceAll('(Dub-Upgrade)',''),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white
                                              ),
                                            )
                                        )
                                      ],
                                    )
                                )
                            )
                        );
                      }).toList(),
                    )
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10,left: 10,top: 15),
                  child: Text(
                    'NEUE SIMULCASTS',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 20,
                      fontFamily: 'Cabin Condensed',
                    ),
                  ),
                ),
                Container(
                    height: elementHeight-12,
                    child: ListView(
                      controller: _newSimulcastsScrollController,
                      scrollDirection: Axis.horizontal,
                      children: newSimulcastTitles.map<Widget>((e){
                        Uri url = Uri.parse(e['image']);
                        //String seriesName = e['series_name'].split(':')[0];
                        String animeName;
                        int limiter = 14;
                        int maxLimiter = 17;
                        if(e['series_name'].length > limiter){
                          int index = e['series_name'].indexOf(' ',limiter);
                          if(index != -1 && index <= maxLimiter) {
                            animeName = e['series_name'].substring(
                                0, e['series_name'].indexOf(' ', limiter)) + ' ...';
                          }else if(index > maxLimiter || e['series_name'].length > maxLimiter){
                            animeName = e['series_name'].substring(0,maxLimiter) + ' ...';
                          }else{
                            animeName = e['series_name'];
                          }
                        }else{
                          animeName = e['series_name'];
                        }
                        return FlatButton(
                            focusColor: Theme.of(context).accentColor,
                            padding: EdgeInsets.all(3),
                            onPressed: (){
                              Navigator.pushNamed(
                                context,
                                '/anime',
                                arguments: Anime(
                                  name: e['series_name'],
                                  id: int.parse(e['series_id']),
                                ),
                              );
                            },
                            //focusNode: newSimulcastsFocusNodes[newSimulcastsCount++],
                            focusNode: FocusNode(),
                            child: Container(
                                width: elementWidth,
                                //margin: EdgeInsets.only(right: 5,left: 5),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(5)
                                    ),
                                    child: Column(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: 'https://'+url.host+url.path,
                                          width: elementWidth,
                                          height: elementHeight-40,
                                        ),
                                        Container(
                                          width: elementWidth,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).accentColor,
                                          ),
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 2,
                                                  vertical: 3
                                              ),
                                              child: Text(
                                                animeName,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Theme.of(context).primaryColor
                                                ),
                                              )
                                          ),
                                        ),
                                      ],
                                    )
                                )
                            )
                        );
                      }).toList(),
                    )
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10,left: 10,top: 15),
                  child: Text(
                    'NEUE ANIME-TITEL',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 20,
                      fontFamily: 'Cabin Condensed',
                    ),
                  ),
                ),
                Container(
                    height: elementHeight-12,
                    child: ListView(
                      controller: _newCatalogTitlesScrollController,
                      scrollDirection: Axis.horizontal,
                      children: newCatalogTitles.map<Widget>((e){
                        Uri url = Uri.parse(e['image']);
                        //String seriesName = e['series_name'].split(':')[0];
                        String animeName;
                        int limiter = 14;
                        int maxLimiter = 17;
                        if(e['series_name'].length > limiter){
                          int index = e['series_name'].indexOf(' ',limiter);
                          if(index != -1 && index <= maxLimiter) {
                            animeName = e['series_name'].substring(
                                0, e['series_name'].indexOf(' ', limiter)) + ' ...';
                          }else if(index > maxLimiter || e['series_name'].length > maxLimiter){
                            animeName = e['series_name'].substring(0,maxLimiter) + ' ...';
                          }else{
                            animeName = e['series_name'];
                          }
                        }else{
                          animeName = e['series_name'];
                        }
                        return FlatButton(
                          //focusNode: newCatalogTitlesFocusNodes[newCatalogTitlesCount++],
                            focusNode: FocusNode(),
                            focusColor: Theme.of(context).accentColor,
                            padding: EdgeInsets.all(3),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/anime',
                                arguments: Anime(
                                  name: e['series_name'],
                                  id: int.parse(e['series_id']),
                                ),
                              );
                            },
                            child: Container(
                                width: elementWidth,
                                //margin: EdgeInsets.only(right: 5,left: 5),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(5)
                                    ),
                                    child: Column(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: 'https://'+url.host+url.path,
                                          width: elementWidth,
                                          height: elementHeight-40,
                                        ),
                                        Container(
                                          width: elementWidth,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).accentColor,
                                          ),
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 2,
                                                  vertical: 3
                                              ),
                                              child: Text(
                                                animeName,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Theme.of(context).primaryColor
                                                ),
                                              )
                                          ),
                                        ),
                                      ],
                                    )
                                )
                            )
                        );
                      }).toList(),
                    )
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10,left: 10,top: 15),
                  child: Text(
                    'ANIME TOP 10',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 20,
                      fontFamily: 'Cabin Condensed',
                    ),
                  ),
                ),
                Container(
                    height: elementHeight-12,
                    margin: EdgeInsets.only(bottom: 10),
                    child: ListView(
                      controller: _topTenScrollController,
                      scrollDirection: Axis.horizontal,
                      children: topTen.map<Widget>((e){
                        Uri url = Uri.parse(e['image']);
                        //String seriesName = e['series_name'].split(':')[0];
                        String animeName;
                        int limiter = 14;
                        int maxLimiter = 17;
                        if(e['series_name'].length > limiter){
                          int index = e['series_name'].indexOf(' ',limiter);
                          if(index != -1 && index <= maxLimiter) {
                            animeName = e['series_name'].substring(
                                0, e['series_name'].indexOf(' ', limiter)) + ' ...';
                          }else if(index > maxLimiter || e['series_name'].length > maxLimiter){
                            animeName = e['series_name'].substring(0,maxLimiter) + ' ...';
                          }else{
                            animeName = e['series_name'];
                          }
                        }else{
                          animeName = e['series_name'];
                        }
                        return FlatButton(
                            onPressed: (){
                              Navigator.pushNamed(
                                context,
                                '/anime',
                                arguments: Anime(
                                  name: e['series_name'],
                                  id: int.parse(e['series_id']),
                                ),
                              );
                            },
                            //focusNode: topTenFocusNodes[topTenCount++],
                            focusColor: Theme.of(context).accentColor,
                            padding: EdgeInsets.all(3),
                            child: Container(
                                width: elementWidth,
                                margin: EdgeInsets.only(right: 5,left: 5),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(5)
                                    ),
                                    child: Column(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: 'https://'+url.host+url.path,
                                          width: elementWidth,
                                          height: elementHeight-40,
                                        ),
                                        Container(
                                          width: elementWidth,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).accentColor,
                                          ),
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 2,
                                                  vertical: 3
                                              ),
                                              child: Text(
                                                animeName,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Theme.of(context).primaryColor
                                                ),
                                              )
                                          ),
                                        ),
                                      ],
                                    )
                                )
                            )
                        );
                      }).toList(),
                    )
                )
              ]
          ),
        )
      //)
    );
  }
}