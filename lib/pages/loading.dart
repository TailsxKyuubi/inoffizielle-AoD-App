/*
 * Copyright 2020 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'package:flutter/material.dart';
import '../caches/login.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Color.fromRGBO(53, 54, 56, 1),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.1),
            ),
            Image.asset('images/logo.png',scale: orientation == Orientation.landscape?4:3,),
            orientation == Orientation.portrait
                ? Flexible(child: Container())
                : Container(),
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                loginDataChecked?'Animeliste wird geladen':'Anmeldedaten werden überprüft',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            SpinKitThreeBounce(
                color: Theme.of(context).accentColor,
                size: 40
            )
          ],
        )
    );
  }

}