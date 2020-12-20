/*
 * Copyright 2020 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
class HeaderHandler {
  Map<String,String> _headers = {
    'User-Agent': 'inoffizielle AoD App/0.6',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
    'Accept-Language': 'de,en-US;q=0.7,en;q=0.3',
    'Accept-Encoding': 'gzip, deflate, br',
    'Content-Type': 'application/x-www-form-urlencoded',
    'Upgrade-Insecure-Requests': '1',
    'Pragma': 'no-cache',
    'Cache-Control': 'no-cache',
    'Referer':'https://anime-on-demand.de/',
    'Origin':'https://anime-on-demand.de'
  };
  Map<String,String> cookies = {};

  Map<String,String> getHeaders(){
    return this._headers;
  }

  Map<String,String> getHeadersForGetRequest(){
    Map<String,String> headers = this._headers;
    headers.remove('Content-Type');
    return headers;
  }

  writeCookiesInHeader(){
    this._headers['Cookie'] = '';
    this.cookies.forEach((String key,String value){
      this._headers['Cookie'] += key+'='+value+'; ';
    });
  }

  setCookie(String key,String value){
    this.cookies[key] = value;
  }

  decodeCookiesString(cookieString){
    List<String> cookies = cookieString.split(RegExp(',(?![(,&^(Mon\ ,|Tue\ ,|Wed\ ,|Thu\ ,|Fri\ ,|Sat\ ,|Sun\ ,))])'));
    cookies.forEach((String cookie){
      List cookieMap = cookie.split(';')[0].split('=');
      this.cookies[cookieMap[0]] = cookieMap[1];
    });
    writeCookiesInHeader();
  }
}