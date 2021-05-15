/*
 * Copyright 2020-2021 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:unoffical_aod_app/caches/anime.dart';
import 'package:unoffical_aod_app/caches/focusnode.dart';

class AnimeSmallWidget extends StatelessWidget{
  final Anime _anime;
  final double elementWidth;
  final double elementHeight;
  final Radius radius;
  final FocusNode _focusNode;

  AnimeSmallWidget(this._anime,this.elementWidth,this.elementHeight,this.radius,this._focusNode);

  @override
  Widget build(BuildContext context) {
    String animeName;
    int limiter = 14;
    int maxLimiter = 16;
    if(this._anime.name.length > limiter){
      int index = this._anime.name.indexOf(' ',limiter);
      if(index != -1 && index <= maxLimiter) {
        animeName = this._anime.name.substring(
            0, this._anime.name.indexOf(' ', limiter)) + ' ...';
      }else if(index > maxLimiter || this._anime.name.length > maxLimiter){
        animeName = this._anime.name.substring(0,maxLimiter) + ' ...';
      }else{
        animeName = this._anime.name;
      }
    }else{
      animeName = this._anime.name;
    }
    return FlatButton(
        onPressed: (){
          Navigator.pushNamed(
            context,
            '/anime',
            arguments: this._anime
          );
        },
        focusNode: _focusNode,
        focusColor: Theme.of(context).accentColor,
        padding: EdgeInsets.all(3.5),
        child: Container(
            width: elementWidth,
            margin: EdgeInsets.only(
              //right: i % 4 != 0 ? 10 : 0,
              bottom: 0,
            ),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black,
                      offset: Offset(0.5, 0.5),
                      blurRadius: 3.0
                  )
                ],
                color: Theme.of(context).primaryColor
            ),
            child: Column(
              children: [
                ClipRRect (
                  borderRadius: BorderRadius.only(
                      topLeft: radius,
                      topRight: radius
                  ),
                  child: Container(
                    width: double.maxFinite,
                    height: elementHeight,
                    child: Image.memory(
                      this._anime.image,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                ClipRRect(
                    borderRadius: BorderRadius.only(
                        bottomLeft: radius,
                        bottomRight: radius
                    ),
                    child: Container (
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          color: Theme.of(context).accentColor
                      ),
                      padding: EdgeInsets.only(
                          top: 3,
                          right: 3,
                          left: 3,
                          bottom: 3
                      ),
                      child: Text(
                        this._anime.name.length > 15
                            ? animeName
                            : this._anime.name,
                        textAlign: TextAlign.center,
                      ),
                    )
                ),
              ],
            )
        )
    );
  }

}