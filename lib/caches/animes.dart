/*
 * Copyright 2020 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'dart:collection';
import 'dart:convert';

import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;
import 'package:unoffical_aod_app/caches/login.dart';

import 'anime.dart';

Map<String,Anime> animes = Map<String,Anime>();

Future getAllAnimesV2() async{
  print('starting animes request');
  http.Response res;
  try {
    res = await http.get(
        'https://anime-on-demand.de/myanimes',
        headers: headerHandler.getHeadersForGetRequest()
    );
  }catch(exception){
    connectionError = true;
    return false;
  }
  print('finished animes request');
  print('begin processing the data');
  dom.Document animePageDoc = parse(res.body);
  parseAnimePage(animePageDoc);
  validateAbo(animePageDoc);
  if( aboActive == true ){
    print('inactive abo detected');
    http.Response resAllAnimePage;
    try {
      resAllAnimePage = await http.get(
          'https://anime-on-demand.de/animes',
          headers: headerHandler.getHeadersForGetRequest()
      );
    }catch(exception){
      connectionError = true;
      return false;
    }
    dom.Document docAllAnimePage = parse(resAllAnimePage.body);
    parseAnimePage(docAllAnimePage);
  }
  print('starting sorting anime');
  SplayTreeMap<String,Anime> st = SplayTreeMap.from(animes);
  animes.clear();
  animes.addAll(st);
  print('finished anime parsing');
  return true;
}

void parseAnimePage(dom.Document animePageDoc){
  HtmlUnescape unescape = HtmlUnescape();
  dom.Element rootElement = animePageDoc.querySelector('.three-box-container');
  print('filtered elements');
  if(rootElement != null){
    List<dom.Element> animeElements = rootElement.querySelectorAll('.animebox');
    animeElements.forEach((dom.Element element) {
      print('begin processing anime element');
      String title = element
          .querySelector('h3.animebox-title')
          .innerHtml;
      if( ! animes.containsKey( title ) ) {
        String? url = element.querySelector('.animebox-link a').attributes['href'];
        if(url == null){
          return;
        }
        int id = int.parse(url.split('/').last);
        String? imageUrl = element
            .querySelector('.animebox-image img')
            .attributes['src'];
        Anime tmpAnime = Anime(
            id: id,
            name: unescape.convert(title).replaceAll('(Sub)', ''),
            imageUrl: imageUrl
        );
        animes.addAll({title: tmpAnime});
      }
      print('finished processing anime element');
    });
  }
}

Map<String,Anime> filterAnimes(String searchQuery){
  Map<String,Anime> filteredResults = Map<String,Anime>();
  HtmlEscape escape = HtmlEscape();
  List<String> words = searchQuery.toLowerCase().split(' ').map((String e) => escape.convert(e)).toList();
  String query = '(?=.*'+ words.join(')(?=.*') + ')';
  animes.forEach((String title,Anime element) => element.name?.toLowerCase().indexOf( RegExp( query ) ) == -1
      ? null
      : filteredResults.addAll({title:element}));
  return filteredResults;
}