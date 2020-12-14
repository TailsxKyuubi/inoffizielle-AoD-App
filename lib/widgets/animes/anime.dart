/*
 * Copyright 2020 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:unoffical_aod_app/caches/anime.dart';
import 'package:unoffical_aod_app/caches/animes.dart';

class AnimeSmallWidget extends StatelessWidget{
  final Anime _anime;
  final double elementWidth;
  final int i;
  final double elementHeight;
  final Radius radius;

  AnimeSmallWidget(this._anime,this.elementWidth,this.elementHeight,this.radius,this.i);

  @override
  Widget build(BuildContext context) {
    String animeName;
    int limiter = 14;
    int maxLimiter = 17;
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
    return GestureDetector(
        onTap: (){
          Navigator.pushNamed(
            context,
            '/anime',
            arguments: this._anime
          );
        },
        child: Container(
            width: elementWidth,
            margin: EdgeInsets.only(
              top: 10,
              right: i % 2 == 1 ? 10 : 0,
              bottom: animes.length == i?10:0,
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
                    child: CachedNetworkImage(
                      imageUrl: this._anime.imageUrl,
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