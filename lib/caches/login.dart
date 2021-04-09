/*
 * Copyright 2020-2021 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:unoffical_aod_app/caches/app.dart';
import 'HeaderHandler.dart';
import 'package:html/parser.dart' show parse;
import 'package:unoffical_aod_app/caches/home.dart';

HeaderHandler headerHandler = HeaderHandler();
FlutterSecureStorage _storage = FlutterSecureStorage();
bool loginStorageChecked = false;
bool loginDataChecked = false;
bool loginSuccess = false;
bool aboActive = false;
int aboDaysLeft = 0;
bool connectionError = false;

Future<bool> checkLogin() async{
  print('start check login');
  String username = await _storage.read(key: 'username');
  String password = await _storage.read(key: 'password');
  print('read login data');
  loginStorageChecked = true;
  if(username == null || password == null){
    return false;
  }else if(loginSuccess){
    return true;
  }
  return await validateCredentialsAndSave(username,password);
}

Future<bool> validateCredentialsAndSave( String username, String password ) async{
  connectionError = false;
  print('generate headers');
  Map<String,String> headers = headerHandler.getHeaders();
  print('starting home page request');
  http.Response mainRes;
  try {
    mainRes = await http.get(Uri.parse('https://anime-on-demand.de/'), headers: headers);
    print('finished home page request');
  }catch(exception){
    connectionError = true;
    print('connection failed');
    return false;
  }
  Document mainDoc = parse(mainRes.body);
  parseHomePage(mainDoc);
  print('parsed home page');
  Element form = mainDoc.querySelector('form.form');
  String authenticityToken = form.querySelector('input[name=authenticity_token]').attributes['value'];
  headerHandler.decodeCookiesString(mainRes.headers['set-cookie']);
  print('generated headers for login');
  print('preparing data for login');
  Map parameterMap = {
    'utf8': '✓',
    'authenticity_token': authenticityToken,
    'user[login]': username,
    'user[password]': password,
    'user[remember_me]': '1',
    'commit': 'Einloggen'
  };
  List<String> parameterList = [];
  parameterMap.forEach((key, value) => parameterList.add(Uri.encodeQueryComponent(key)+'='+Uri.encodeQueryComponent(value)));
  String parameterString = parameterList.join('&');
  headers = headerHandler.getHeaders();
  print('data for login prepared');
  print('start login request');
  http.Response res;
  try {
    res = await http.post(
        Uri.parse('https://anime-on-demand.de/users/sign_in'),
        body: parameterString,
        headers: headers
    );
  }catch(exception){
    connectionError = true;
    return false;
  }
  print('login request completed');
  print('set internal flags');
  loginDataChecked = true;
  print('validate login request');
  if(res.statusCode == 302){
    print('writing data in secure storage');
    saveCredentials(username, password);
    headerHandler.decodeCookiesString(res.headers['set-cookie']);
    loginSuccess = true;
    return true;
  }else{
    loginSuccess = false;
    return false;
  }
}

void validateAbo(Document myAnimesPage){
  Element aboText = myAnimesPage.querySelector('.poolnote');
  if(aboText != null){
    int daysLeft = int.parse(aboText.querySelectorAll('.green')[1].text);
    if(daysLeft > 0){
      aboActive = true;
      aboDaysLeft = daysLeft;
    }
  }
}

Future<bool> saveCredentials(String username,String password) async{
  _storage.write(key: 'username', value: username);
  _storage.write(key: 'password', value: password);
  return true;
}

Future<void> logout() async{
  await _storage.delete(key: 'username');
  await _storage.delete(key: 'password');
  loginSuccess = false;
  loginDataChecked = false;
  headerHandler = HeaderHandler();
  bootUpReceivePort = null;
  bootUpIsolate = null;
}