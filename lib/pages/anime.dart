/*
 * Copyright 2020 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the 4-Clause BSD License
 */
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

