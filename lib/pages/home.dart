/*
 * Copyright 2020 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unoffical_aod_app/caches/anime.dart';
import 'package:unoffical_aod_app/caches/home.dart';
import 'package:unoffical_aod_app/widgets/drawer.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double elementWidth = MediaQuery.of(context).size.width / 7 * 3;
    double elementHeight = elementWidth / 16 * 9 + 40;
    return Scaffold(
        appBar: AppBar(
          title: Text('Startseite'),
        ),
        drawer: DrawerWidget(),
        body: Container(
          padding: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor
          ),
          child: ListView(
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
                    height: elementHeight+5,
                    child: ListView(
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
                        return GestureDetector(
                            onTap: (){
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
                    height: elementHeight-18,
                    child: ListView(
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
                        return GestureDetector(
                            onTap: (){
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
                    height: elementHeight-18,
                    child: ListView(
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
                        return GestureDetector(
                            onTap: (){
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
                    height: elementHeight-18,
                    margin: EdgeInsets.only(bottom: 10),
                    child: ListView(
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
                        return GestureDetector(
                            onTap: (){
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
        ));
  }

}