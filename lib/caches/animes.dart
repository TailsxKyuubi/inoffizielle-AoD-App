import 'dart:convert';

import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;
import 'package:unoffical_aod_app/caches/login.dart';

import 'anime.dart';

List<Anime> animes = new List<Anime>();

Future getAllAnimesV2() async{
  HtmlUnescape unescape = HtmlUnescape();
  print('starting animes request');
  http.Response res = await http.get(
    'https://anime-on-demand.de/myanimes',
    headers: headerHandler.getHeadersForGetRequest()
  );
  print('finished animes request');
  print('begin processing the data');
  dom.Document animePageDoc = parse(res.body);
  dom.Element rootElement = animePageDoc.querySelector('.three-box-container');
  print('filtered elements');
  List<dom.Element> animeElements = rootElement.querySelectorAll('.animebox');
  animeElements.forEach((dom.Element element) {
    print('begin processing anime element');
    String title = element.querySelector('h3.animebox-title').innerHtml;
    int id = int.parse(element.querySelector('.animebox-link a').attributes['href'].split('/').last);
    String imageUrl = element.querySelector('.animebox-image img').attributes['src'];
    Anime tmpAnime = Anime(
      id: id,
      name: unescape.convert(title).replaceAll('(Sub)', ''),
      imageUrl: imageUrl
    );
    animes.add(tmpAnime);
    print('finished processing anime element');
  });
  print('finished anime parsing');
  return true;
}

List<Anime> filterAnimes(String searchQuery){
  List<Anime> filteredResults = List<Anime>();
  HtmlEscape escape = HtmlEscape();
  List<String> words = searchQuery.toLowerCase().split(' ').map((String e) => escape.convert(e)).toList();
  String query = '(?=.*'+ words.join(')(?=.*') + ')';
  animes.forEach((Anime element) => element.name.toLowerCase().indexOf( RegExp( query ) ) == -1
      ? null
      : filteredResults.add(element));
  return filteredResults;
}