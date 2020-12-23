/*
 * Copyright 2020 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unoffical_aod_app/caches/anime.dart';
import 'package:unoffical_aod_app/caches/episode.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;
import 'package:unoffical_aod_app/caches/episode_progress.dart';
import 'package:unoffical_aod_app/caches/login.dart';
import 'package:unoffical_aod_app/caches/settings/settings.dart';
import 'package:unoffical_aod_app/transfermodels/player.dart';
import 'package:wakelock/wakelock.dart';
import 'package:html_unescape/html_unescape.dart';

class AnimeWidget extends StatefulWidget {
  final Anime anime;
  AnimeWidget(this.anime);
  @override
  State<StatefulWidget> createState() => AnimeWidgetState(this.anime);
}


class AnimeWidgetState extends State<AnimeWidget>{
  Anime _anime;
  List<Episode> episodes = [];
  String _csrf;
  bool movie = false;
  bool showFullDescription = false;
  PlayerTransfer _nextEpisode;
  bool bootUp = true;

  Future getAnime() async{
    print('get anime init');
    http.Response res;
    try {
      res = await http.get('https://anime-on-demand.de/anime/' + this._anime.id.toString(),headers: headerHandler.getHeaders());
    }catch(exception){
      connectionError = true;
      return false;
    }
    dom.Document doc = parse(res.body);
    headerHandler.decodeCookiesString(res.headers['set-cookie']);
    this._csrf = doc.querySelector('meta[name=csrf-token]').attributes['content'];
    List<dom.Element> episodesRaw = doc.querySelectorAll('div.three-box.episodebox.flip-container');
    if(episodesRaw.isEmpty){
      movie = true;
      episodesRaw = doc.querySelectorAll('.two-column-container');
    }
    this._anime.imageUrl = doc.querySelector('img.fullwidth-image.anime-top-image').attributes['src'];
    this._anime.description = parse(doc.querySelector('div[itemprop=description] > p').innerHtml).documentElement.text.replaceAll('\n', '');
    print('init anime episodes iterating');
    List<Episode> episodes = [];
    episodesRaw.forEach((element) {
      List<dom.Element> playButtons = element.querySelectorAll('input.highlight.streamstarter_html5');
      print('start anime episodes play button count');

      print('end anime episodes play button count');
      Episode tmpEpisode = Episode();
      print('start anime episodes play button parsing');
      if(playButtons.length > 0){
        tmpEpisode.mediaId = int.tryParse(playButtons[0].attributes['data-playlist'].split('/')[2]);
      }
      playButtons.forEach((dom.Element playButton) {
        tmpEpisode.languages.add(playButton.attributes['value']);
        tmpEpisode.playlistUrl.add('https://anime-on-demand.de' +
            playButton.attributes['data-playlist']);
      });

      String tmpNameString;
      if(movie){
        tmpEpisode.name = doc.querySelector('h1[itemprop=name]').text;
        tmpEpisode.imageUrl = Uri.parse(doc.querySelector('img.anime-top-image').attributes['src']);
      } else {
        dom.Element content = element.querySelector('.three-box-content');
        if(content.children.last.className.isEmpty){
          tmpEpisode.noteText = content.children.last.text;
        }
        tmpEpisode.imageUrl = Uri.parse(element.querySelector('.episodebox-image').children[0].attributes['src']);
        tmpNameString = element
            .querySelector('h3.episodebox-title')
            .innerHtml
            .replaceAll('<br>', ' - ');
        List<String> tmpNameList = tmpNameString.split(' - ');
        if(tmpNameList.length > 1){
          tmpEpisode.name = tmpNameList[1];
        }else{
          tmpEpisode.name = '';
        }
        tmpEpisode.number = tmpNameList[0].replaceAll(RegExp('(?:OVA\ |Episode\ )'), '');
      }
      print('end anime episodes play button parsing');
      episodes.add(tmpEpisode);
    });
    this.episodes = episodes;

    if(settings.playerSettings.saveEpisodeProgress){
      int episodesCounter = 0;
      this.episodes.forEach((Episode episode) {
        int langCounter = 0;
        episode.languages.forEach((String lang) {
          if(episodeProgressCache.getEpisodeDuration(episode.mediaId,lang).inSeconds > 0){
            this._nextEpisode = PlayerTransfer(
                episode,
                langCounter,
                this._csrf,
                this._anime,
                episodesCounter,
                episodes.length
            );
            langCounter++;
          }
        });
        episodesCounter++;
      });
      if(this._nextEpisode == null){
        this._nextEpisode = PlayerTransfer(
            this.episodes[0],
            0,
            this._csrf,
            this._anime,
            0,
            this.episodes.length
        );
      }
    }
    print('end anime episodes iterating');
  }

  AnimeWidgetState(Anime anime) {
    Wakelock.disable();
    this._anime = anime;
    this.getAnime().then((element){
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    /*SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);*/
    /*SystemChrome.setEnabledSystemUIOverlays([
      SystemUiOverlay.top,
      SystemUiOverlay.bottom
    ]);*/

    if(connectionError){
      /*showDialog(
          context: context,
          child: AnimeLoadingConnectionErrorDialog(this._anime),
      );*/

    }
    WidgetsBinding.instance.addPostFrameCallback((_){
      connectionError = false;
      this.getAnime().then((element){
        setState(() {});
      });
    });
    if(this.episodes.isNotEmpty){
      HtmlUnescape unescape = HtmlUnescape();
      double firstWidth = (MediaQuery.of(context).size.width - 30) * 0.5;
      double secondWidth = firstWidth - 5;
      int gerCount = -1;
      int japCount = -1;
      return Scaffold(
        appBar: AppBar(
          title: Text(this._anime.name),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        floatingActionButton:settings.playerSettings.saveEpisodeProgress && aboActive
            ? FloatingActionButton(
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).accentColor
            ),
            child: Icon(
                Icons.play_arrow,
                color: Theme.of(context).primaryColor
            ),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/player',arguments: this._nextEpisode);
          },
        )
            : Container(),
        body: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor
            ),
            child: ListView(
                children: [
                  CachedNetworkImage(
                      imageUrl: this._anime.imageUrl
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        right: 15,left: 15,top: 10
                    ),
                    child: Text(
                      showFullDescription || this._anime.description.length <= 150
                          ?this._anime.description
                          :this._anime.description.substring(0,this._anime.description.indexOf(' ',150)) + ' ...',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  this._anime.description.length > 150
                      ? Container(
                        margin: EdgeInsets.only(
                            right: 15,left: 15
                        ),
                        child:
                        GestureDetector(
                          onTap: (){
                            this.showFullDescription = !this.showFullDescription;
                            setState(() {});
                          },
                          child: Text(
                            showFullDescription
                                ? 'Weniger anzeigen'
                                : 'Mehr anzeigen',
                            style: TextStyle(
                                color: Theme.of(context).accentColor
                            ),
                          ),
                        )
                    )
                      : Container(),
                  !aboActive
                      ? Container(
                          margin: EdgeInsets.only(
                              right: 15,left: 15,top: 10
                          ),
                          child: Text(
                            'Ohne Premium Abo hast du gegebenenfalls nur eingeschränkt Zugriff auf die Inhalte',
                            style: TextStyle(
                                color: Colors.redAccent
                            ),
                          )
                        )
                      : Container(),
                  Container(
                    margin: EdgeInsets.only(
                      top: 10,
                      left: 10,
                      right: 10,
                    ),
                    height: 1,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(0,0,0,0),
                              Theme.of(context).accentColor,
                              Theme.of(context).accentColor,
                              Color.fromRGBO(0,0,0,0)
                            ]
                        )
                    ),
                  ),
                  ListView(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    children: this.episodes.map((Episode episode) {
                      int gerIndex = ++gerCount;
                      int japIndex = ++japCount;
                      return Padding(
                          padding: EdgeInsets.only(
                              top:10,
                              bottom: 10,
                              left: 15,
                              right: 15
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: (MediaQuery.of(context).size.width-30) * 0.5,
                                    child: CachedNetworkImage(
                                        imageUrl: 'https://'+episode.imageUrl.host+episode.imageUrl.path
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 10
                                        ),
                                        child: ! this.movie
                                            ? Text(
                                          'Folge ' + episode.number,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.start,
                                        ): Container(),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 10
                                        ),
                                        width: (MediaQuery.of(context).size.width-30)*0.5-10,
                                        child: Text(
                                          unescape.convert(episode.name),
                                          softWrap: true,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Container(
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                          onTap: (){
                                            if(episode.languages.indexOf('Deutsch') != -1) {
                                              Navigator.pushNamed(
                                                  context,
                                                  '/player',
                                                  arguments: PlayerTransfer(
                                                      episode,
                                                      0,
                                                      this._csrf,
                                                      this._anime,
                                                      gerIndex,
                                                      this.episodes.length
                                                  )
                                              );
                                            }
                                          },
                                          child: Container(
                                            width: firstWidth,
                                            margin: EdgeInsets.only(
                                                top: 5,
                                                left: 0
                                            ),
                                            padding: EdgeInsets.only(
                                              top: 5,
                                              bottom: 5,
                                            ),
                                            decoration: BoxDecoration(
                                                color: episode.languages.length > 0 && episode.languages[0] == 'Deutsch' ? Theme.of(context).accentColor : Colors.grey
                                            ),
                                            child: Row(
                                                children: [
                                                  Icon(
                                                      Icons.play_arrow
                                                  ),
                                                  Text(
                                                    'Deutsch',
                                                    textAlign: TextAlign.center,
                                                  )
                                                ]
                                            ),
                                          )
                                      ),
                                      GestureDetector(
                                          onTap: (){
                                            if(episode.languages.indexOf('Japanisch (UT)') != -1){
                                              Navigator.pushNamed(
                                                  context,
                                                  '/player',
                                                  arguments: PlayerTransfer(
                                                      episode,
                                                      episode.languages.indexOf('Japanisch (UT)'),
                                                      this._csrf,
                                                      this._anime,
                                                      japIndex,
                                                      this.episodes.length
                                                  )
                                              );
                                            }
                                          },
                                          child: Container(
                                            width: secondWidth,
                                            margin: EdgeInsets.only(
                                                top: 5,
                                                left: 5
                                            ),
                                            padding: EdgeInsets.only(
                                              top: 5,
                                              bottom: 5,
                                            ),
                                            decoration: BoxDecoration(
                                                color: episode.languages.indexOf('Japanisch (UT)') != -1
                                                    ? Theme.of(context).accentColor
                                                    : Colors.grey
                                            ),
                                            child: Row(
                                                children: [
                                                  Icon(
                                                      Icons.play_arrow
                                                  ),
                                                  Text(
                                                    'Japanisch (UT)',
                                                    textAlign: TextAlign.center,
                                                  )
                                                ]
                                            ),
                                          )
                                      )
                                    ],
                                  )
                              ),
                              episode.noteText.isNotEmpty
                                  ? Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text(
                                    episode.noteText,
                                    style: TextStyle(
                                        color: Colors.white
                                    ),
                                  )
                              )
                                  : Container()
                            ],
                          )
                      );
                    }
                    ).toList(),
                  )
                ]
            )
        ),
      );
    }else {
      return Scaffold(
        appBar: AppBar(
          title: Text(this._anime.name),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor
          ),
          child: Center(
            child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "Die Episodenliste wird geladen",
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "Bitte warten",
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  ),
                ]
            ),
          ),
        ),
      );
    }
  }
}