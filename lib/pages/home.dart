/*
 * Copyright 2020 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:unoffical_aod_app/caches/anime.dart';
import 'package:unoffical_aod_app/caches/home.dart';
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
    return Scaffold(
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