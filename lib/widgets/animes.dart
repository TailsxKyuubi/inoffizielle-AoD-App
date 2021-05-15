/*
 * Copyright 2020-2021 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unoffical_aod_app/caches/anime.dart';
import 'package:unoffical_aod_app/caches/focusnode.dart';
import 'package:unoffical_aod_app/caches/keycodes.dart';
import 'package:unoffical_aod_app/widgets/animes/anime.dart';
import 'package:unoffical_aod_app/widgets/navigation_bar_custom.dart';
import '../caches/animes.dart' as animes;

class AnimesWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AnimesWidgetState();
}

class _AnimesWidgetState extends State<AnimesWidget> {
  TextEditingController _controller = TextEditingController();
  Map<int,Anime> searchResult = animes.animesLocalCache.getAll();
  ScrollController _scrollController = ScrollController();
  List<FocusNode> animeFocusNodes = [];
  List<int> _focusNodeAnimeMapping = [];

  FocusNode mainFocusNode;

  int _animeFocusIndex = 0;
  _AnimesWidgetState(){
    this._controller.addListener(onTextInput);
    animes.animes.forEach((_,__) => this.animeFocusNodes.add(
        FocusNode(
            onKey: handleKey
        )
    ));
  }

  bool handleKey(FocusNode focusNode, RawKeyEvent event){
    if( Platform.isAndroid && event.data is RawKeyEventDataAndroid && event.runtimeType == RawKeyUpEvent ){
      RawKeyEventDataAndroid eventDataAndroid = event.data;
      FocusScopeNode scope = FocusScope.of(context);
      switch(eventDataAndroid.keyCode){
        case KEY_DOWN:
          this._animeFocusIndex += 4;
          if(this._animeFocusIndex >= searchResult.length){
            //this._animeFocusIndex = this.animeFocusNodes.length - this._animeFocusIndex;
            FocusScope.of(context).requestFocus(menuBarFocusNodes.first);
            return true;
          }
          scope.requestFocus(
              this.animeFocusNodes[this._animeFocusIndex]
          );
          break;
        case KEY_UP:
          _animeFocusIndex -= 4;
          if(this._animeFocusIndex < 0){
            this._animeFocusIndex = -1;
            FocusScope.of(context).requestFocus(searchFocusNode);
          }else{
            scope.requestFocus(
                this.animeFocusNodes[this._animeFocusIndex]
            );
          }
          break;
        case KEY_RIGHT:
          this._animeFocusIndex++;
          if(this._animeFocusIndex >= searchResult.length){
            //this._animeFocusIndex = 0;
            FocusScope.of(context).requestFocus(menuBarFocusNodes.first);
            return true;
          }
          scope.requestFocus(
              this.animeFocusNodes[this._animeFocusIndex]
          );
          break;
        case KEY_LEFT:
          this._animeFocusIndex--;
          if(this._animeFocusIndex < 0){
            this._animeFocusIndex = -1;
            FocusScope.of(context).requestFocus(searchFocusNode);
          }else{
            scope.requestFocus(
                this.animeFocusNodes[this._animeFocusIndex]
            );
          }
          break;
        case KEY_MENU:
          setState(() {
            scope.requestFocus(menuBarFocusNodes.first);
          });
          this._animeFocusIndex = 0;
          this._scrollController.jumpTo(0);
          return true;
        case KEY_BACK:
          exit(0);
          return true;
        case KEY_CENTER:
          Navigator.pushNamed(
              context,
              '/anime',
              arguments: animes.animes[this._focusNodeAnimeMapping[this._animeFocusIndex]]
          );
      }
      this._scrollController.jumpTo(
          (this.animeFocusNodes.indexOf(scope.focusedChild) / 4).floor() * scope.focusedChild.size.height,
      );
    }
    return true;
  }

  onTextInput(){
    setState(() {
      if(this._controller.text.length >= 1){
        this.searchResult = animes.filterAnimes(this._controller.text);
      }else if(this._controller.text.isEmpty){
        this.searchResult = animes.animes;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    /*SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);*/
    int i = 0;
    double elementWidth;
    MediaQueryData mediaQuery = MediaQuery.of(context);
    if(mediaQuery.orientation == Orientation.landscape){
      elementWidth = (mediaQuery.size.width-40)*0.25-7.5;
    }else{
      elementWidth = (mediaQuery.size.width-40)*0.5-7.5;
    }

    this._focusNodeAnimeMapping.clear();

    double elementHeight = elementWidth / 16 * 9;
    Radius radius = Radius.circular(2);
    List<Widget> animeList = [];
    this.searchResult.forEach(
            (int id,Anime anime) {
          this._focusNodeAnimeMapping.add(id);
          animeList.add(
              AnimeSmallWidget(
                  anime,
                  elementWidth,
                  elementHeight,
                  radius,
                  this.animeFocusNodes[i++]
              )
          );
        }
    );

    this.mainFocusNode = FocusNode();
    return RawKeyboardListener(
        focusNode: this.mainFocusNode,
        autofocus: true,
        onKey: (RawKeyEvent event){
          if(this.mainFocusNode.hasPrimaryFocus){
            FocusScope.of(context).requestFocus(this.animeFocusNodes.first);
          }
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              title: Text('Meine Anime'),
              brightness: Brightness.dark,
            ),
            bottomNavigationBar: NavigationBarCustom(this.animeFocusNodes.first),
            body: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor
                ),
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(left: 20, right: 20),
                child: ListView(
                    controller: _scrollController,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(
                              Radius.circular(5)
                          ),

                          child: Container(
                            height: 40,
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                                color: Colors.grey
                            ),
                            child: TextField(
                              controller: this._controller,
                              focusNode: searchFocusNode,
                              cursorColor: Theme.of(context).accentColor,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: -14),
                                hintText: 'Suche',
                                hintStyle: TextStyle(
                                    color: Colors.white
                                ),
                              ),
                              style: TextStyle(
                                  color: Colors.white
                              ),
                              textInputAction: TextInputAction.next,
                              onEditingComplete: (){
                                setState(() {
                                  print('Editing Complete');
                                  this._animeFocusIndex = 0;
                                  FocusScope.of(context).requestFocus(animeFocusNodes.first);
                                });
                              },
                              onSubmitted: (_){
                                setState(() {
                                  print('search submitted');
                                  this._animeFocusIndex = 0;
                                  FocusScope.of(context).requestFocus(animeFocusNodes.first);
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only( top: 10, bottom: 10 ),
                          child: Wrap(
                            direction: Axis.horizontal,
                            children: animeList,
                          )
                      )
                    ]
                )
            )
        )
    );
  }
}