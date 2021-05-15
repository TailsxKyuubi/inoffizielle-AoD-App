
/*
 * Copyright 2020-2021 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'dart:convert';
import 'dart:isolate';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:unoffical_aod_app/caches/app.dart';
import 'package:unoffical_aod_app/caches/database.dart';
import 'package:unoffical_aod_app/caches/episode_progress.dart';
import 'package:unoffical_aod_app/caches/home.dart';
import 'package:unoffical_aod_app/caches/login.dart';
import 'package:unoffical_aod_app/caches/settings/settings.dart';
import 'package:unoffical_aod_app/caches/version.dart';
import 'package:unoffical_aod_app/pages/about.dart';
import 'package:unoffical_aod_app/pages/anime.dart';
import 'package:unoffical_aod_app/pages/animes.dart';
import 'package:unoffical_aod_app/pages/home.dart';
import 'package:unoffical_aod_app/pages/loading.dart';
import 'package:unoffical_aod_app/pages/login.dart';
import 'package:unoffical_aod_app/pages/settings.dart';
import 'package:unoffical_aod_app/pages/updates.dart';
import 'package:unoffical_aod_app/widgets/app_update_notification.dart';
import 'package:unoffical_aod_app/widgets/fire_os_version_error.dart';
import 'package:unoffical_aod_app/widgets/loading_connection_error.dart';
import 'package:unoffical_aod_app/widgets/player.dart';
import 'package:version/version.dart';
import 'caches/anime.dart';
import 'caches/animes.dart' as animesCache;


void main(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp(AodApp());
}

class AodApp extends StatelessWidget {
  final ReceivePort receivePort = ReceivePort();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light)
    );
    return Shortcuts(
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.select): ActivateIntent(),
        },
        child: MaterialApp(
          title: 'Inoffizielle AoD App',
          routes: <String,WidgetBuilder> {
            '/base': (BuildContext context) => BaseWidget(),
            '/home': (BuildContext context) => HomePage(),
            '/player': (BuildContext context) => PlayerWidget(),
            '/anime': (BuildContext context) => AnimePage(),
            '/animes': (BuildContext context) => AnimesPage(),
            '/settings': (BuildContext context) => SettingsPage(),
            '/about': (BuildContext context) => AboutPage(),
            '/updates': (BuildContext context) => UpdatesPage()
          },
          theme: ThemeData(
            primaryColor: Color.fromRGBO(53, 54, 56, 1),
            accentColor: Color.fromRGBO(171, 191, 57, 1),
            focusColor: Color.fromRGBO(171, 191, 57, 0.4),
            hoverColor: Color.fromRGBO(171, 191, 57, 0.4),
          ),
          home: BaseWidget(),
        )
    );
  }
}

class BaseWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoadingState();
}

class LoadingState extends State<BaseWidget>{

  List<String> dialogList = [];

  Widget startScreensScaffold(Widget content){
    return Scaffold(
        body: WillPopScope(
          onWillPop: () async => false,
          child: content,
        ),
    );
  }

  parseMessage(message, BuildContext context){
    if (message is String) {
      switch(message){
        case 'connection error':
          connectionError = true;
          showDialog(
              context: context,
              builder: (BuildContext context){
                return LoadingConnectionErrorDialog();
              },
              barrierDismissible: false
          );
          break;
        case 'login check done':
          loginDataChecked = true;
          connectionError = false;
          settings = Settings();
          break;
        case 'login storage check done':
          loginStorageChecked = true;
          break;
        case 'login success':
          loginSuccess = true;
          break;
        case 'active abo':
          aboActive = true;
          break;
        case 'inactive abo':
          aboActive = false;
          break;
        default:
          if(message.startsWith('remaining abo days:')){
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
                      (String id,anime) =>
                      animesCache.animes.addAll(
                          {
                            int.parse(id): Anime.fromMap(
                                anime.map<String, String>((key, value) =>
                                    MapEntry(key.toString(), value.toString())
                                )
                            )
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
      }
    } else if (message is Map<int,Anime>) {
      connectionError = false;
      animesCache.animes = message;
    }
    setState(() {});
  }

  void executeCheckActions(String message){
    if(message.indexOf('new version available: ') != -1){
      latestVersion = Version.parse(
          message.replaceAll('new version available: ','')
      );
      this.dialogList.add('app version outdated');
    } else if (message == 'fire os outdated') {
      this.dialogList.add('fire os outdated');
    }else if(message == 'checks completed'){
      appCheckReceivePort.close();
      showProblemDialogs();
      setState(() {});
    }
  }

  void showProblemDialogs() async{
    if(this.dialogList.contains('fire os outdated')){
      await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => FireOsVersionErrorDialog()
      );
    }
    if(this.dialogList.contains('app version outdated')){
      await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => AppUpdateNotificationDialog()
      );
    }
    bootUpPreparationsReceivePort.listen(this.processBootUpPreparations);
    FlutterIsolate.spawn(appBootUpPreparations, bootUpPreparationsReceivePort.sendPort);
  }

  void processBootUpPreparations(object) async{
    switch(object){
      case 'sharedPreferences':
        await SharedPreferences.getInstance();
        Database db = await openDatabase('iaoda.db');
        databaseHelper = DatabaseHelper(db);
        break;
      case 'continue':
        FlutterIsolate.spawn(appBootUp, bootUpReceivePort.sendPort);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays([]);
    if(appCheckIsolate == null){
      bootUpReceivePort.listen((message) => parseMessage(message, context));
      appCheckReceivePort.listen((message) => executeCheckActions(message));
      FlutterIsolate
          .spawn(appChecks, appCheckReceivePort.sendPort)
          .then((value) => appCheckIsolate = value);
    }
    print('loading widget build');
    if(loginStorageChecked && ! loginSuccess ) {
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

appChecks(SendPort sendPort) async {
  print('starting app checks');
  DeviceInfoPlugin info = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await info.androidInfo;
  if( (androidInfo.brand == 'Amazon' || androidInfo.manufacturer == 'Amazon') && androidInfo.version.sdkInt < 28 ) {
    sendPort.send('fire os outdated');
  }
  bool newVersionAvailable = await checkVersion();
  if(newVersionAvailable){
    sendPort.send('new version available: ' + latestVersion.toString());
  }
  sendPort.send('checks completed');
  print('checks completed');
}

appBootUpPreparations(SendPort sendPort) async{
  print('preparations started');
  sendPort.send('sharedPreferences');
  sendPort.send('continue');
  print('preparations finished');
}

appBootUp(SendPort sendPort) async {
  print('initialised bootup thread');
  await checkLogin();
  if(connectionError){
    sendPort.send('connection error');
  }else if(loginStorageChecked){
    sendPort.send('login storage check done');
    if(loginDataChecked){
      sendPort.send('login check done');
    }
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
      Map animes = {
        'animes': animesCache.animes.map((id, Anime anime) => MapEntry(id.toString(), anime.toMap()))
      };
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

