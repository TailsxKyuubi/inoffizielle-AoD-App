
/*
 * Copyright 2020 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:unoffical_aod_app/caches/app.dart';
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
import 'package:unoffical_aod_app/widgets/loading_connection_error.dart';
import 'package:unoffical_aod_app/widgets/player.dart';
import 'caches/anime.dart';
import 'caches/animes.dart' as animesCache;


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
          primaryColor: const Color.fromRGBO(53, 54, 56, 1),
          accentColor: const Color.fromRGBO(171, 191, 57, 1)
      ),
      home: BaseWidget(),
    );
  }
}

class BaseWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoadingState();
}

class LoadingState extends State<BaseWidget>{

  triggerStateUpdate(){
    setState(() {});
  }

  Widget startScreensScaffold(Widget content){
    return Scaffold(
          body: WillPopScope(
            onWillPop: () async => false,
            child: content,
        )
    );
  }

  parseMessage(message, BuildContext context){

        if (message is String) {
          if(message == 'connection error'){
            connectionError = true;
            showDialog(
                context: context,
                child: LoadingConnectionErrorDialog(),
            );
          } else if (message == 'login check done') {
            loginDataChecked = true;
            connectionError = false;
            settings = Settings();
          } else if (message == 'login success') {
            loginSuccess = true;
          }else if(message == 'active abo') {
            aboActive = true;
          }else if(message == 'inactive abo'){
            aboActive = false;
          }else if(message.startsWith('remaining abo days:')){
            aboDaysLeft = int.parse(message.split(':')[1]);
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
                      (String title,anime) =>
                      animesCache.animes.addAll(
                          {
                            title: Anime.fromMap(
                                anime.map<String, String>((key, value) =>
                                    MapEntry(key.toString(), value.toString())))
                          }
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
        } else if (message is Map<String,Anime>) {
          connectionError = false;
          animesCache.animes = message;
        }
        setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays([]);
    if(bootUpReceivePort == null){
      bootUpReceivePort = ReceivePort();
      bootUpReceivePort.listen((message) => parseMessage(message, context));
      FlutterIsolate.spawn(appBootUp, bootUpReceivePort.sendPort);
    }
    print('loading widget build');
    if(loginDataChecked && ! loginSuccess ) {
      return startScreensScaffold(LoginPage());
    }else if(loginSuccess && animesCache.animes == null){
      return startScreensScaffold(LoadingPage());
    }else if(loginSuccess && animesCache.animes != null && animesCache.animes.isNotEmpty){
      return HomePage();
    }else{
      return startScreensScaffold(LoadingPage());
    }
  }
}

appBootUp(SendPort sendPort) async {
  print('initialised bootup thread');
  await checkLogin();
  if(connectionError){
    sendPort.send('connection error');
  }else{
    sendPort.send('login check done');
  }
  if(loginSuccess){
    sendPort.send('login success');
    sendPort.send(jsonEncode({'cookies': headerHandler.cookies}));
    sendPort.send(jsonEncode({'newEpisodes': newEpisodes}));
    sendPort.send(jsonEncode({'newCatalogTitles':newCatalogTitles}));
    sendPort.send(jsonEncode({'newSimulcastTitles':newSimulcastTitles}));
    sendPort.send(jsonEncode({'topTen':topTen}));
    await animesCache.getAllAnimesV2();
    if(connectionError){
      sendPort.send('connection error');
    }else{
      Map<String,dynamic> animes = Map<String,dynamic>();
        animes.addEntries(
            [
              MapEntry(
                  'animes',
                  animesCache.animes.map((title, Anime anime) => MapEntry(title, anime.toMap()) )
              )
            ]
        );
      sendPort.send(jsonEncode(animes));
    }
    if(aboActive){
      sendPort.send('active abo');
      sendPort.send('remaining abo days:'+aboDaysLeft.toString());
    }else{
      sendPort.send('inactive abo');
    }
  }
}

