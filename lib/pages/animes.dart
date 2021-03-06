/*
 * Copyright 2020 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'package:flutter/material.dart';
import 'package:unoffical_aod_app/widgets/navigation_bar.dart';
import '../widgets/animes.dart';

class AnimesPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('Meine Animes'),
        ),
        bottomNavigationBar: NavigationBar(),
        body: AnimesWidget()
    );
  }
}