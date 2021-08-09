/*
 * Copyright 2020-2021 TailsxKyuubi
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
import 'package:unoffical_aod_app/widgets/navigation_bar_custom.dart';

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

  List<FocusNode> _newEpisodesFocusNodes = [];
  List<FocusNode> _newSimulcastsFocusNodes = [];
  List<FocusNode> _newCatalogTitlesFocusNodes = [];
  List<FocusNode> _topTenFocusNodes = [];

  FocusNode mainFocusNode;

  int rowIndex = 0;
  int itemIndex = 0;

  double elementHeight = 0;
  double elementWidth = 0;

  @override
  void initState(){
    newEpisodes.forEach((_) => this._newEpisodesFocusNodes.add(
        FocusNode(
            onKey: handleKeyEvent
        )
    ));
    newSimulcastTitles.forEach((_) => this._newSimulcastsFocusNodes.add(
        FocusNode(
            onKey: handleKeyEvent
        )
    ));
    newCatalogTitles.forEach((_) => this._newCatalogTitlesFocusNodes.add(
        FocusNode(
            onKey: handleKeyEvent
        )
    ));
    topTen.forEach((_) => this._topTenFocusNodes.add(
        FocusNode(
            onKey: handleKeyEvent
        )
    ));
    super.initState();
  }

  List<FocusNode> getRowList(){
    switch(this.rowIndex){
      case 3:
        return this._topTenFocusNodes;
      case 2:
        return this._newCatalogTitlesFocusNodes;
      case 1:
        return this._newSimulcastsFocusNodes;
      case 0:
      default:
        return this._newEpisodesFocusNodes;
    }
  }

  bool increaseRowIndex(){
    this.rowIndex++;
    this.itemIndex = 0;
    if(this.rowIndex > 3){
      this.rowIndex = 0;
      setState(() {
        FocusScope.of(context).requestFocus(menuBarFocusNodes.first);
      });
      return false;
    }
    return true;
  }

  void decreaseRowIndex(){
    this.rowIndex--;
    this.itemIndex = 0;
    if(this.rowIndex < 0){
      this.rowIndex = 3;
    }
  }

  bool handleKeyEvent(FocusNode focusNode, RawKeyEvent keyEvent){
    if( Platform.isAndroid && keyEvent.data is RawKeyEventDataAndroid && keyEvent.runtimeType == RawKeyUpEvent ){
      RawKeyEventDataAndroid keyEventData = keyEvent.data;
      bool positionChanged = false;
      switch(keyEventData.keyCode){
        case KEY_DOWN:
          positionChanged = this.increaseRowIndex();
          break;
        case KEY_RIGHT:
          this.itemIndex++;
          positionChanged = true;
          if((this.getRowList().length-1) < this.itemIndex){
            this.increaseRowIndex();
            positionChanged = this.increaseRowIndex();
          }
          break;
        case KEY_UP:
          this.decreaseRowIndex();
          positionChanged = true;
          break;
        case KEY_LEFT:
          this.itemIndex--;
          if(this.itemIndex < 0){
            this.decreaseRowIndex();
          }
          positionChanged = true;
          break;
        case KEY_CENTER:
          print('triggered key center');
          List list = [];
          switch(this.rowIndex){
            case 0:
              list = newEpisodes;
              break;
            case 1:
              list = newSimulcastTitles;
              break;
            case 2:
              list = newCatalogTitles;
              break;
            case 3:
              list = topTen;
              break;
            default:
              list = newEpisodes;
          }
          Map e = list[this.itemIndex];
          Navigator.pushNamed(
            context,
            '/anime',
            arguments: Anime(
              name: e['series_name'],
              id: int.parse(e['series_id']),
            ),
          );
          break;
        case KEY_MENU:
          this._scrollController.jumpTo(0);
          setState(() {
            FocusScope.of(context).requestFocus(menuBarFocusNodes.first);
          });
          this.rowIndex = 0;
          this.itemIndex = 0;
          return true;
        case KEY_BACK:
          exit(0);
          return true;
      }
      if(positionChanged){
        FocusScope.of(context).requestFocus(this.getRowList()[this.itemIndex]);
        ScrollController controller;
        switch(this.rowIndex){
          case 0:
            controller = this._newEpisodesScrollController;
            break;
          case 1:
            controller = this._newSimulcastsScrollController;
            break;
          case 2:
            controller = this._newCatalogTitlesScrollController;
            break;
          case 3:
            controller = this._topTenScrollController;
            break;
        }
        this._scrollController.jumpTo(elementHeight*this.rowIndex);
        controller.jumpTo(elementWidth*this.itemIndex);
      }
    }
    return true;
  }

  void generateFocusNodes(){
    List<FocusNode> list = this.getRowList();
    list[this.itemIndex] = FocusNode(
        onKey: handleKeyEvent
    );
  }

  @override
  Widget build(BuildContext context) {
    if(MediaQuery.of(context).orientation == Orientation.portrait) {
      this.elementWidth = MediaQuery.of(context).size.width / 7 * 3;
    }else if( MediaQuery.of(context).size.height < 480 ){
      this.elementWidth = MediaQuery.of(context).size.width / 8 * 2;
    }else{
      this.elementWidth = MediaQuery.of(context).size.width / 11 * 2;
    }
    this.elementHeight = elementWidth / 16 * 9 + 40;

    int newEpisodesCount = 0;
    int newSimulcastsCount = 0;
    int newCatalogTitlesCount = 0;
    int topTenCount = 0;

    this.mainFocusNode = FocusNode();

    return RawKeyboardListener(
        focusNode: this.mainFocusNode,
        autofocus: true,
        onKey: (RawKeyEvent event){
          if(this.mainFocusNode.hasPrimaryFocus){
            FocusScope.of(context).requestFocus(this._newEpisodesFocusNodes.first);
          }
        },
        child: Scaffold(
            bottomNavigationBar: NavigationBarCustom(this._newEpisodesFocusNodes.first),
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
                        height: elementHeight+14,
                        child: ListView(
                          controller: _newEpisodesScrollController,
                          scrollDirection: Axis.horizontal,
                          children: newEpisodes.map<Widget>((e){
                            Uri url = Uri.parse(e['image']);
                            //String seriesName = e['series_name'].split(':')[0];
                            String animeName;
                            int limiter = 14;
                            int maxLimiter = 16;
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
                                focusNode: this._newEpisodesFocusNodes[newEpisodesCount++],
                                //focusNode: FocusNode(),
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
                        height: elementHeight-8,
                        child: ListView(
                          controller: _newSimulcastsScrollController,
                          scrollDirection: Axis.horizontal,
                          children: newSimulcastTitles.map<Widget>((e){
                            Uri url = Uri.parse(e['image']);
                            //String seriesName = e['series_name'].split(':')[0];
                            String animeName;
                            int limiter = 14;
                            int maxLimiter = 16;
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
                                focusNode: _newSimulcastsFocusNodes[newSimulcastsCount++],
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
                        height: elementHeight-10,
                        child: ListView(
                          controller: _newCatalogTitlesScrollController,
                          scrollDirection: Axis.horizontal,
                          children: newCatalogTitles.map<Widget>((e){
                            Uri url = Uri.parse(e['image']);
                            //String seriesName = e['series_name'].split(':')[0];
                            String animeName;
                            int limiter = 14;
                            int maxLimiter = 16;
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
                                focusNode: _newCatalogTitlesFocusNodes[newCatalogTitlesCount++],
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
                        height: elementHeight-10,
                        margin: EdgeInsets.only(bottom: 10),
                        child: ListView(
                          controller: _topTenScrollController,
                          scrollDirection: Axis.horizontal,
                          children: topTen.map<Widget>((e){
                            Uri url = Uri.parse(e['image']);
                            //String seriesName = e['series_name'].split(':')[0];
                            String animeName;
                            int limiter = 14;
                            int maxLimiter = 16;
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
                                focusNode: _topTenFocusNodes[topTenCount++],
                                focusColor: Theme.of(context).accentColor,
                                padding: EdgeInsets.all(3),
                                child: Container(
                                    width: elementWidth,
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
        )
      //)
    );
  }
}