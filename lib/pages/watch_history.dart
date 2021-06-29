import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unoffical_aod_app/caches/episode_history.dart';
import 'package:unoffical_aod_app/caches/episode_progress.dart';
import 'package:unoffical_aod_app/widgets/navigation_bar_custom.dart';

class WatchHistoryPage extends StatelessWidget {
  final rootFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBarCustom(rootFocusNode),
      appBar: AppBar(
        title: Text('Verlauf'),
      ),
      body: ListView(
          children: episodeProgressCache.getAll().map((EpisodeHistory episodeHistory){
            return Row(
              children: [

              ],
            );
          }).toList()
      ),
    );
  }

}