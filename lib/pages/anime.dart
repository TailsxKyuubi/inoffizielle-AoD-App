/*
 * Copyright 2020 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:unoffical_aod_app/caches/anime.dart';
import 'package:unoffical_aod_app/widgets/anime.dart';

class AnimePage extends StatelessWidget {
  AnimePage();

  @override
  Widget build(BuildContext context) {
    Object anime = ModalRoute.of(context)!.settings.arguments!;
    if(anime is Anime){
      return AnimeWidget(anime);
    }
    exit(0);
  }
}

