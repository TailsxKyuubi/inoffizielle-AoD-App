/*
 * Copyright 2020-2021 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
class Anime {
  final String name;
  String imageUrl;
  String description;
  final int id;
  Anime({this.name,this.imageUrl,this.description,this.id});
  static Anime fromMap(Map<String,String> animeMap){

    return Anime(
        id: int.parse(animeMap['id']),
        name: animeMap['name'],
        description: animeMap['description'],
        imageUrl: animeMap['imageUrl']
    );
  }
  toMap(){
    return {
      'id': this.id.toString(),
      'name': this.name,
      'description': this.description,
      'imageUrl': this.imageUrl
    };
  }
}