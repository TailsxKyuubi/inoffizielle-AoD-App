/*
 * Copyright 2020 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'package:flutter/material.dart';
import 'package:unoffical_aod_app/widgets/drawer.dart';

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
            Padding(
              padding: EdgeInsets.only( top: MediaQuery.of(context).size.height*0.2 ),
              child: Text(
                'Inoffizielle',
                style: TextStyle(
                    fontFamily: 'Planet Kosmos',
                    fontSize: 40,
                    color: Color.fromRGBO(171, 191, 57, 1)
                ),
              ),
            ),
            Text(
              'AoD App',
              style: TextStyle(
                  fontFamily: 'Planet Kosmos',
                  fontSize: 40,
                  color: Color.fromRGBO(171, 191, 57, 1)
              ),
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
                'Licensed with the BSD License',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}