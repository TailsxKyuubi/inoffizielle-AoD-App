import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unoffical_aod_app/caches/episode_progress.dart';
import 'package:unoffical_aod_app/caches/home.dart';
import 'package:unoffical_aod_app/caches/login.dart';
import 'package:unoffical_aod_app/caches/settings/settings.dart';
import 'package:unoffical_aod_app/pages/about.dart';
import 'package:unoffical_aod_app/pages/anime.dart';
import 'package:unoffical_aod_app/pages/animes.dart';
import 'package:unoffical_aod_app/pages/home.dart';
import 'package:unoffical_aod_app/pages/loading.dart';
import 'package:unoffical_aod_app/pages/login.dart';
import 'package:unoffical_aod_app/pages/settings.dart';
import 'package:unoffical_aod_app/widgets/player.dart';
import 'caches/anime.dart';
import 'caches/animes.dart' as animesCache;
import 'package:flutter_isolate/flutter_isolate.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(AodApp());
}

class AodApp extends StatelessWidget {
  final ReceivePort receivePort = ReceivePort();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inoffizielle AoD App',
      routes: <String,WidgetBuilder> {
        '/base': (BuildContext context) => BaseWidget(),
        '/home': (BuildContext context) => HomePage(),
        '/player': (BuildContext context) => PlayerWidget(),
        '/anime': (BuildContext context) => AnimePage(),
        '/animes': (BuildContext context) => AnimesPage(),
        '/settings': (BuildContext context) => SettingsPage(),
        '/about': (BuildContext context) => AboutPage()
      },
      theme: ThemeData(
          primaryColor: Color.fromRGBO(53, 54, 56, 1),
          accentColor: Color.fromRGBO(171, 191, 57, 1)
      ),
      //home: AnimesPage(),
      home: BaseWidget(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BaseWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoadingState();
}

class LoadingState extends State<BaseWidget>{

  final ReceivePort receivePort = ReceivePort();
  LoadingState(){
    if( ! loginDataChecked && ! loginSuccess ) {
      receivePort.listen((message) {
        if (message is String) {
          if (message == 'login check done') {
            loginDataChecked = true;
            settings = Settings();
          } else if (message == 'login success') {
            loginSuccess = true;
          } else {
            Map<String, dynamic> data;
            try {
              data = jsonDecode(message);
            } catch (e) {
              print('isnt a json string');
              print(e.toString());
              print(message);
            }
            if (data.containsKey('cookies')) {
              headerHandler.cookies =
                  data['cookies'].map<String, String>((String key, value) =>
                      MapEntry(key, value.toString()));
              headerHandler.writeCookiesInHeader();
            } else if (data.containsKey('animes')) {
              data['animes'].forEach(
                      (anime) =>
                      animesCache.animes.add(
                          Anime.fromMap(
                              anime.map<String, String>((key, value) =>
                                  MapEntry(key.toString(), value.toString())))
                      )
              );
              episodeProgressCache = EpisodeProgressCache();
            } else if (data.containsKey('newEpisodes')) {
              newEpisodes.addAll(
                  List.from(data['newEpisodes'])
              );
            } else if (data.containsKey('newCatalogTitles')) {
              newCatalogTitles.addAll(data['newCatalogTitles']);
            } else if (data.containsKey('newSimulcastTitles')) {
              newSimulcastTitles.addAll(data['newSimulcastTitles']);
            } else if (data.containsKey('topTen')) {
              topTen.addAll(data['topTen']);
            } else {
              print('data contains unknown key');
            }
          }
        } else if (message is List<Anime>) {
          animesCache.animes = message;
        }
        setState(() {});
      });
      FlutterIsolate.spawn(appBootUp, receivePort.sendPort);
    }
  }
  triggerStateUpdate(){
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays([]);
    print('loading widget build');
    if(loginDataChecked && ! loginSuccess ) {
      return LoginPage();
    }else if(loginSuccess && animesCache.animes == null){
      return LoadingPage();
    }else if(loginSuccess && animesCache.animes != null && animesCache.animes.isNotEmpty){
      return HomePage();
    }else{
      return LoadingPage();
    }
  }
}

appBootUp(SendPort sendPort) async {
  print('initialised bootup thread');
  await checkLogin();
  sendPort.send('login check done');
  if(loginSuccess){
    sendPort.send('login success');
    sendPort.send(jsonEncode({'cookies': headerHandler.cookies}));
    sendPort.send(jsonEncode({'newEpisodes': newEpisodes}));
    sendPort.send(jsonEncode({'newCatalogTitles':newCatalogTitles}));
    sendPort.send(jsonEncode({'newSimulcastTitles':newSimulcastTitles}));
    sendPort.send(jsonEncode({'topTen':topTen}));
    await animesCache.getAllAnimesV2();
    sendPort.send(jsonEncode({'animes':animesCache.animes.map((anime) => anime.toMap()).toList()}));
  }
}

checkForStateChangeLogin(SendPort sendPort){
  print('checkForStateChange start');

  while(!loginSuccess){
    sleep(Duration(milliseconds: 100));
  }
  sendPort.send('');
  print('checkForStateChange end');
}