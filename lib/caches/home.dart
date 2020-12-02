import 'package:html/dom.dart';

List<Map> newEpisodes = [];
List newCatalogTitles = [];
List newSimulcastTitles = [];
List topTen = [];

parseHomePage(Document doc){
  List<Element> carousels = doc.querySelectorAll('.jcarousel-container-new');
  carousels.addAll(doc.querySelectorAll('.jcarousel-container-top10'));
  List<Element> episodes = carousels[0].querySelectorAll('li');
  episodes.forEach((element) {
    List<Element> a = element.querySelectorAll('a');
    Map tmpObject = {};
    tmpObject['image'] = a[0].children[0].attributes['src'];
    tmpObject['series_name'] = a[1].text;
    tmpObject['series_id'] = a[0].attributes['href'].split('/').last;
    tmpObject['episode_number'] = element.querySelector('.neweps').text.replaceAll('Episode ', '');
    newEpisodes.add(tmpObject);
  });
  List<Element> newTitles = carousels[1].querySelectorAll('li');
  newTitles.forEach((element) {
    List<Element> a = element.querySelectorAll('a');
    Map tmpObject = {};
    tmpObject['image'] = a[0].children[0].attributes['src'];
    tmpObject['series_name'] = a[1].text;
    tmpObject['series_id'] = a[0].attributes['href'].split('/').last;
    newCatalogTitles.add(tmpObject);
  });

  List<Element> newSimulTitles = carousels[2].querySelectorAll('li');
  newSimulTitles.forEach((element) {
    List<Element> a = element.querySelectorAll('a');
    Map tmpObject = {};
    tmpObject['image'] = a[0].children[0].attributes['src'];
    tmpObject['series_name'] = a[1].text;
    tmpObject['series_id'] = a[0].attributes['href'].split('/').last;
    newSimulcastTitles.add(tmpObject);
  });

  List<Element> top10 = carousels[3].querySelectorAll('li');
  top10.forEach((element) {
    List<Element> a = element.querySelectorAll('a');
    Map tmpObject = {};
    tmpObject['image'] = a[0].children[0].attributes['src'];
    tmpObject['series_name'] = a[1].text;
    tmpObject['series_id'] = a[0].attributes['href'].split('/').last;
    topTen.add(tmpObject);
  });
}