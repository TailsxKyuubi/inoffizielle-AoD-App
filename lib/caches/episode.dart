/*
 * Copyright 2020-2021 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'dart:typed_data';

class Episode {
  String name;
  String number = '';
  Uri imageUrl;
  Uint8List image;
  int mediaId;
  List<String> playlistUrl = [];
  List<String> languages = [];
  String noteText = '';
}