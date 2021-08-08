/*
 * Copyright 2020-2021 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:unoffical_aod_app/caches/anime.dart';
import 'package:unoffical_aod_app/caches/focusnode.dart';

class ListWidget extends StatelessWidget{
  final String title;
  final IconData icon;
  final double elementWidth;
  final double elementHeight;
  final Radius radius;
  final FocusNode _focusNode;
  final String route;

  ListWidget(this.title, this.icon, this.elementWidth,this.elementHeight,this.radius,this._focusNode, this.route);

  @override
  Widget build(BuildContext context) {
    String animeName;

    return FlatButton(
        onPressed: (){
          Navigator.pushNamed(
            context,
            this.route,
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
                      child: Icon(
                        this.icon,
                        color: Colors.white,
                        size: 50,
                      )
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
                        this.title,
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