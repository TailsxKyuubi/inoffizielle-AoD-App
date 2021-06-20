/*
 * Copyright 2020-2021 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;
import 'package:unoffical_aod_app/caches/database.dart';
import 'package:unoffical_aod_app/caches/login.dart';

import 'anime.dart';

AnimesLocalCache animesLocalCache;

class AnimesLocalCache {
  List<Anime> _elements = [];

  static Future<AnimesLocalCache> init() async{
    AnimesLocalCache localCache = AnimesLocalCache();
    List<Map<String,dynamic>> animeMap = await databaseHelper.query('SELECT * FROM animes');
    if (animeMap.length > 0) {
      animeMap.forEach((Map element) {
        Anime tmpAnime = Anime.fromMap(element);
        localCache._elements.add(tmpAnime);
      });
    }
    if (localCache._elements.length == 0) {
      await localCache.updateAnimes();
    } else {
      Timer.run(localCache.updateAnimes);
    }
    Timer.periodic(Duration(hours: 1), (_) => localCache.updateAnimes());
    return localCache;
  }

  Future<dom.Document> _getAnimePage() async {
    print('starting animes request');
    http.Response res;
    try {
      res = await http.get(
          Uri.parse('https://anime-on-demand.de/myanimes'),
          headers: headerHandler.getHeadersForGetRequest()
      );
    } catch (exception) {
      connectionError = true;
      return null;
    }
    dom.Document animePageDoc = parse(res.body);
    print('finished animes request');
    return animePageDoc;
  }

  Future<void> updateAnimes() async {
    dom.Document animePageDoc = await this._getAnimePage();

    print('begin processing the data');

    List<Anime> animes = await parseAnimePage(animePageDoc);
    validateAbo(animePageDoc);
    print(aboDaysLeft);
    print(loginSuccess);
    print(loginDataChecked);
    if( ! aboActive ){
      print('inactive abo detected');
      http.Response resAllAnimePage;
      try {
        resAllAnimePage = await http.get(
            Uri.parse('https://anime-on-demand.de/animes'),
            headers: headerHandler.getHeadersForGetRequest()
        );
      } catch(exception) {
        connectionError = true;
        return false;
      }
      dom.Document docAllAnimePage = parse(resAllAnimePage.body);
      await parseAnimePage(docAllAnimePage);
    }
    print('starting sorting anime');

    List<Anime> animeToDelete = this._elements.where((existingAnime) => animes.indexWhere((element) => existingAnime.id == element.id) == -1).toList();
    List<Anime> animeToAdd = animes.where((newAnime) => this._elements.indexWhere((element) => newAnime.id == element.id) == -1).toList();
    print('löse unterschiede auf in anime datenbank auf');
    animeToAdd.forEach((element) {
      databaseHelper.insert(
          'animes',
          {
            'anime_id': element.id,
            'name': element.name,
            'image': element.image
          }
      );
      //databaseHelper.query('INSERT INTO animes (anime_id,name,image) VALUES ('+element.id.toString()+',\'' + element.name + '\',\'' + element.image.toString() + '\');');
      print('Bild für ID ' + element.id.toString() + ': ' + element.image.toString());
    });

    animeToDelete.forEach((element) {
      databaseHelper.query('DELETE FROM animes WHERE anime_id = ' + element.id.toString() + ';');
    });
    this._elements = animes;

    print('sortiere animes');
    this._elements.sort((firstAnime, secondAnime) => firstAnime.name.compareTo(secondAnime.name));

    print('finished anime parsing');
    return true;
  }

  Future<List<Anime>> parseAnimePage(dom.Document animePageDoc) async {
    HtmlUnescape unescape = HtmlUnescape();
    dom.Element rootElement = animePageDoc.querySelector('.three-box-container');
    print('filtered elements');
    if(rootElement != null){
      List<dom.Element> animeElements = rootElement.querySelectorAll('.animebox');
      List<Anime> animes = [];
      for ( int a = 0; a < animeElements.length; a++)  {
        dom.Element element = animeElements[a];
        print('begin processing anime element');
        int id = int.parse(element.querySelector('.animebox-link a').attributes['href'].split('/').last);
        String title = element
            .querySelector('h3.animebox-title')
            .innerHtml
            .trim();
        String imageUrl = element
            .querySelector('.animebox-image img')
            .attributes['src'];

        Uri imageUri = Uri.parse(imageUrl);
        http.Response imgRes = await http.get(
            imageUri,
            headers: headerHandler.getHeadersForGetRequest()
        );
        Uint8List existingImage = imgRes.bodyBytes;
        Anime tmpAnime = Anime(
            id: id,
            name: unescape.convert(title).replaceAll('(Sub)', ''),
            image: existingImage
        );

        animes.add(tmpAnime);
        print('finished processing anime element');
      }
      return animes;
    }
    return [];
  }

  List<Anime> getAll() => _elements;

  Anime getSingle(int id) {
    int searchedAnimeIndex = this._elements.indexWhere((element) => element.id == id);
    if(searchedAnimeIndex >= 0){
      return this._elements[id];
    }
    return null;
  }
}

List<Anime> filterAnimes(String searchQuery){
  List<Anime> filteredResults = [];
  HtmlEscape escape = HtmlEscape();
  List<String> words = searchQuery.toLowerCase().split(' ').map((String e) => escape.convert(e)).toList();
  String query = '(?=.*'+ words.join(')(?=.*') + ')';

  animesLocalCache.getAll().where((element) => element.name.toLowerCase().indexOf( RegExp( query )) == -1);
  return filteredResults;
}