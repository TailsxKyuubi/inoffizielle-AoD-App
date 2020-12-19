/*
 * Copyright 2020 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'package:flutter/material.dart';
import 'package:unoffical_aod_app/widgets/drawer.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor
        ),
        child: Column(
          children: [
            Image.asset(
              'images/logo.png',
              scale: 6,
            ),
            Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  'Developed by:',
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),
                )
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                'TailsxKyuubi',
                textAlign: TextAlign.start,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                'Special Thanks:',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                'Tami',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                'Licensed with the AGPL License',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 20),
                child: GestureDetector(
                  onTap:() => launch('https://anime-on-demand.de/datenschutz'),
                  child: Text(
                    'Datenschutz',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 20
                    ),
                  ),
                )
            )
          ],
        ),
      ),
    );
  }

}