/*
 * Copyright 2020-2021 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'package:html/dom.dart' as dom;

List<Map> newEpisodes = [];
List newCatalogTitles = [];
List newSimulcastTitles = [];
List topTen = [];

parseHomePage(dom.Document doc){
  newEpisodes = [];
  newCatalogTitles = [];
  newSimulcastTitles = [];
  topTen = [];
  List<dom.Element> carousels = doc.querySelectorAll('.jcarousel-container-new');
  carousels.addAll(doc.querySelectorAll('.jcarousel-container-top10'));
  List<dom.Element> episodes = carousels[0].querySelectorAll('li');
  episodes.forEach((element) {
    List<dom.Element> a = element.querySelectorAll('a');
    Map tmpObject = {};
    tmpObject['image'] = a[0].children[0].attributes['src'];
    tmpObject['series_name'] = a[1].text;
    tmpObject['series_id'] = a[0].attributes['href']!.split('/').last;
    tmpObject['episode_number'] = element.querySelector('.neweps')!.text.replaceAll('Episode ', '');
    newEpisodes.add(tmpObject);
  });
  List<dom.Element> newTitles = carousels[1].querySelectorAll('li');
  newTitles.forEach((element) {
    List<dom.Element> a = element.querySelectorAll('a');
    Map tmpObject = {};
    tmpObject['image'] = a[0].children[0].attributes['src'];
    tmpObject['series_name'] = a[1].text;
    tmpObject['series_id'] = a[0].attributes['href']!.split('/').last;
    newCatalogTitles.add(tmpObject);
  });

  List<dom.Element> newSimulTitles = carousels[2].querySelectorAll('li');
  newSimulTitles.forEach((element) {
    List<dom.Element> a = element.querySelectorAll('a');
    Map tmpObject = {};
    tmpObject['image'] = a[0].children[0].attributes['src'];
    tmpObject['series_name'] = a[1].text;
    tmpObject['series_id'] = a[0].attributes['href']!.split('/').last;
    newSimulcastTitles.add(tmpObject);
  });

  List<dom.Element> top10 = carousels[3].querySelectorAll('li');
  top10.forEach((element) {
    List<dom.Element> a = element.querySelectorAll('a');
    Map tmpObject = {};
    tmpObject['image'] = a[0].children[0].attributes['src'];
    tmpObject['series_name'] = a[1].text;
    tmpObject['series_id'] = a[0].attributes['href']!.split('/').last;
    topTen.add(tmpObject);
  });
}