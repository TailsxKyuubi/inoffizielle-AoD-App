/*
 * Copyright 2020-2021 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unoffical_aod_app/caches/database.dart';
import 'package:unoffical_aod_app/caches/login.dart';

import 'anime.dart';

Map<int,Anime> animes = Map<int,Anime>();
AnimesLocalCache animesLocalCache;

// Vielleicht für den Offline Modus interessant
class AnimesLocalCache {
  Map<int, Anime> _elements = {};

  AnimesLocalCache();
  static Future<AnimesLocalCache> init() async{
    AnimesLocalCache localCache = AnimesLocalCache();
    List<Map<String,dynamic>> animeMap = await databaseHelper.query('SELECT * FROM animes');
    animeMap.forEach((Map element) {
      Anime tmpAnime = Anime.fromMap(element);
      localCache._elements.addAll({tmpAnime.id:tmpAnime});
    });
    return localCache;
  }


  Map<int,Anime> getAll() => _elements;

  Anime getSingle(int id) {
    if(this._elements.containsKey(id)){
      return this._elements[id];
    }
    return null;
  }
}

Future getAllAnimesV2() async{
  print('starting animes request');
  http.Response res;
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  try {
    res = await http.get(
        Uri.parse('https://anime-on-demand.de/myanimes'),
        headers: headerHandler.getHeadersForGetRequest()
    );
  }catch(exception){
    connectionError = true;
    return false;
  }
  print('finished animes request');
  print('begin processing the data');
  dom.Document animePageDoc = parse(res.body);
  parseAnimePage(animePageDoc, sharedPreferences);
  validateAbo(animePageDoc);
  if( ! aboActive ){
    print('inactive abo detected');
    http.Response resAllAnimePage;
    try {
      resAllAnimePage = await http.get(
          Uri.parse('https://anime-on-demand.de/animes'),
          headers: headerHandler.getHeadersForGetRequest()
      );
    }catch(exception){
      connectionError = true;
      return false;
    }
    dom.Document docAllAnimePage = parse(resAllAnimePage.body);
    parseAnimePage(docAllAnimePage, sharedPreferences);
  }
  print('starting sorting anime');

  SplayTreeMap<String,Anime> st = SplayTreeMap.from(animes.map((key, value) => MapEntry(value.name, value)));
  animes.clear();
  animes.addAll(st.map((key, value) => MapEntry(value.id, value)));
  print('finished anime parsing');
  return true;
}

void parseAnimePage(dom.Document animePageDoc, SharedPreferences sharedPreferences) async{
  HtmlUnescape unescape = HtmlUnescape();
  dom.Element rootElement = animePageDoc.querySelector('.three-box-container');
  print('filtered elements');
  if(rootElement != null){
    List<dom.Element> animeElements = rootElement.querySelectorAll('.animebox');
    animeElements.forEach((dom.Element element) async {
      print('begin processing anime element');
      String title = element
          .querySelector('h3.animebox-title')
          .innerHtml;
      if( ! animes.containsKey( title ) ) {
        int id = int.parse(element.querySelector('.animebox-link a').attributes['href'].split('/').last);
        String imageUrl = element
            .querySelector('.animebox-image img')
            .attributes['src'];

        Uint8List existingImage/* = Utf8Encoder().convert(sharedPreferences.getString('anime.' + id.toString() + '.sm_image'))*/;
        if (existingImage == null) {
          Uri imageUri = Uri.parse(imageUrl);
          http.Response imgRes = await http.get(imageUri, headers: headerHandler.getHeadersForGetRequest());
          existingImage = imgRes.bodyBytes;
          //sharedPreferences.setString('anime.' + id.toString() + '.image', Utf8Decoder().convert(existingImage));
        }
        Anime tmpAnime = Anime(
            id: id,
            name: unescape.convert(title).replaceAll('(Sub)', ''),
            image: existingImage
        );
        animes.addAll({id: tmpAnime});
      }
      print('finished processing anime element');
    });
  }
}

Map<int,Anime> filterAnimes(String searchQuery){
  Map<int,Anime> filteredResults = Map<int,Anime>();
  HtmlEscape escape = HtmlEscape();
  List<String> words = searchQuery.toLowerCase().split(' ').map((String e) => escape.convert(e)).toList();
  String query = '(?=.*'+ words.join(')(?=.*') + ')';
  animes.forEach((int id,Anime element) => element.name.toLowerCase().indexOf( RegExp( query ) ) == -1
      ? null
      : filteredResults.addAll({id:element}));
  return filteredResults;
}