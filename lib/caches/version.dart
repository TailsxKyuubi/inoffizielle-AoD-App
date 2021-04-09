import 'dart:convert';
import 'dart:io';

import 'package:version/version.dart';
import 'package:xml/xml.dart';

final Version version = Version.parse('0.8.0');

Version latestVersion = version;

Future<bool> checkVersion() async{
  HttpClient client = HttpClient();
  HttpClientRequest request = await client.getUrl(Uri.parse('https://github.com/TailsxKyuubi/inoffizielle-AoD-App/releases.atom'));
  HttpClientResponse res = await request.close();
  String releasesXmlString = await res.transform(utf8.decoder).join();
  XmlDocument releasesXml = XmlDocument.parse(releasesXmlString);
  List<XmlElement> entries = releasesXml.findAllElements('entry').toList();
  for(int i=0; i<entries.length;i++){
    Version tmpVersion = Version.parse(
        entries[i].getElement('id').innerText.split('/').last
    );
    if(! tmpVersion.isPreRelease){
      int difference = tmpVersion.compareTo(version);
      if(difference > 0){
        return true;
      }
      break;
    }
  }
  return false;
}