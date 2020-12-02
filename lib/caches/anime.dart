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