/*
 * Copyright 2020 TailsxKyuubi
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
import '../caches/animes.dart' as animes;

class AnimesWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AnimesWidgetState();
}

class _AnimesWidgetState extends State<AnimesWidget> {
  TextEditingController _controller = TextEditingController();
  Map<String,Anime> searchResult = animes.animes;
  ScrollController _scrollController = ScrollController();
  _AnimesWidgetState(){
    this._controller.addListener(onTextInput);
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
    double elementHeight = elementWidth / 16 * 9;
    Radius radius = Radius.circular(2);
    List<Widget> animeList = [];
    this.searchResult.forEach(
            (String title,Anime anime) => animeList.add(
            AnimeSmallWidget(
                anime,
                elementWidth,
                elementHeight,
                radius,
                ++i
            )
        )
    );
    return RawKeyboardListener(
        focusNode: animeFocusNode,
        autofocus: true,
        onKey: ( RawKeyEvent event ){
          if( Platform.isAndroid && event.data is RawKeyEventDataAndroid && event.runtimeType == RawKeyUpEvent ){
            RawKeyEventDataAndroid eventDataAndroid = event.data;
            FocusScopeNode scope = FocusScope.of(context);
            if(animeFocusNode.hasPrimaryFocus){
              setState(() {
                print('primary focus lies on root Node');
                animeFocusNode.unfocus();
                scope.requestFocus(animeFocusNodes.first);
              });
            }else{
              //scope.unfocus();
              switch(eventDataAndroid.keyCode){
                case KEY_DOWN:
                  if( animeFocusNodes.contains( scope.focusedChild ) ){

                    animeFocusNodesIndex += 4;
                    if(animeFocusNodesIndex >= searchResult.length){
                      animeFocusNodesIndex = animeFocusNodes.length - animeFocusNodesIndex;
                    }
                    scope.requestFocus(
                        animeFocusNodes[
                        animeFocusNodesIndex
                        ]
                    );
                  }
                  break;
                case KEY_UP:
                  if( animeFocusNodes.contains( scope.focusedChild ) ){
                    animeFocusNodesIndex -= 4;
                    if(animeFocusNodesIndex < 0){
                      animeFocusNodesIndex = -1;
                      FocusScope.of(context).requestFocus(searchFocusNode);
                    }else{
                      scope.requestFocus(
                          animeFocusNodes[
                          animeFocusNodesIndex
                          ]
                      );
                    }
                  }
                  break;
                case KEY_RIGHT:
                  if( animeFocusNodes.contains( scope.focusedChild ) ){
                    animeFocusNodesIndex++;
                    if(animeFocusNodesIndex >= searchResult.length){
                      animeFocusNodesIndex = 0;
                    }
                    scope.requestFocus(
                        animeFocusNodes[
                        animeFocusNodesIndex
                        ]
                    );
                  }
                  break;
                case KEY_LEFT:
                  if( animeFocusNodes.contains( scope.focusedChild ) ){
                    animeFocusNodesIndex--;
                    if(animeFocusNodesIndex < 0){
                      animeFocusNodesIndex = -1;
                      FocusScope.of(context).requestFocus(searchFocusNode);
                    }else{
                      scope.requestFocus(
                          animeFocusNodes[
                          animeFocusNodesIndex
                          ]
                      );
                    }
                  }
                  break;
              }
              if(eventDataAndroid.keyCode == KEY_MENU){
                ScaffoldState scaffold = Scaffold.of(context);
                if( ! scaffold.isDrawerOpen ){
                  scope.requestFocus(menuBarFocusNode);
                }
              }
              this._scrollController.animateTo(
                  (animeFocusNodes.indexOf(scope.focusedChild) / 4).floor() * scope.focusedChild.size.height,
                  curve: Curves.easeIn,
                  duration: Duration(milliseconds: 200)
              );
            }
          }
        },
        child: Container(
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
                              animeFocusNodesIndex = 0;
                              FocusScope.of(context).requestFocus(animeFocusNode);
                            });
                          },
                          onSubmitted: (_){
                            setState(() {
                              print('search submitted');
                              animeFocusNodesIndex = 0;
                              FocusScope.of(context).requestFocus(animeFocusNode);
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  RawKeyboardListener(
                      focusNode: FocusNode(),
                      child: Container(
                          margin: EdgeInsets.only( top: 10, bottom: 10 ),
                          child: Wrap(
                            direction: Axis.horizontal,
                            children: animeList,
                          )
                      )
                  )
                ]
            )
        )
    );
  }
}