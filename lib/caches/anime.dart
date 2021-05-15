/*
 * Copyright 2020-2021 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'dart:typed_data';

class Anime {
  final String name;
  Uint8List image;
  String description;
  final int id;
  Anime({this.name,this.image,this.description,this.id});
  static Anime fromMap(Map<String,dynamic> animeMap){

    return Anime(
        id: int.parse(animeMap['id']),
        name: animeMap['name'],
        description: animeMap['description'],
        image: animeMap['image']
    );
  }
  toMap(){
    return {
      'id': this.id.toString(),
      'name': this.name,
      'description': this.description,
      'image': this.image
    };
  }
}