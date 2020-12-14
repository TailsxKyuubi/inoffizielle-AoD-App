/*
 * Copyright 2020 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'package:flutter/material.dart';
import 'package:unoffical_aod_app/caches/login.dart';
class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromRGBO(53, 54, 56, 1),
            ),
            child: Text(
              'Inoffizielle AoD App',
              style: TextStyle(
                color: Color.fromRGBO(171, 191, 58, 1),
                fontSize: 24,
                fontFamily: 'Planet Kosmos',
              ),
            ),
          ),
          ListTile(
            title: Text('Startseite'),
            onTap: () => Navigator.pushReplacementNamed(context, '/home'),
          ),
          ListTile(
            title: Text('Animes'),
            onTap: () => Navigator.pushReplacementNamed(context, '/animes'),
          ),
          ListTile(
            title: Text('Einstellungen'),
            onTap: () => Navigator.pushReplacementNamed(context, '/settings'),
          ),
          ListTile(
            title: Text('Über die App'),
            onTap: () => Navigator.pushReplacementNamed(context, '/about'),
          ),
          ListTile(
            title: Text('Logout'),
            onTap: (){
              logout().then((value) => Navigator.pushNamed(context, '/base'));
            },
          ),
        ],
      ),
    );
  }

}