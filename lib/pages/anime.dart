import 'package:flutter/material.dart';
import 'package:unoffical_aod_app/caches/anime.dart';
import 'package:unoffical_aod_app/widgets/anime.dart';

class AnimePage extends StatelessWidget {
  AnimePage();

  @override
  Widget build(BuildContext context) {
    final Anime anime = ModalRoute.of(context).settings.arguments;
    return AnimeWidget(anime);
  }
}

