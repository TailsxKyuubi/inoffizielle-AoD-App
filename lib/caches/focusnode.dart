import 'package:flutter/material.dart';

List<FocusNode> menuBarFocusNodes = [];

FocusNode homeFocusNode = FocusNode();

FocusNode searchFocusNode = FocusNode();
List<FocusNode> animeFocusNodes = [];
int animeFocusNodesIndex = -1;
FocusNode animeFocusNode = FocusNode();

FocusNode settingsFocusNode = FocusNode();
List<FocusNode> appSettingsFocusNodes = [
  FocusNode(),
  FocusNode(),
  FocusNode()
];
int appSettingsFocusIndex = -1;

List<FocusNode> playerSettingsFocusNodes = [
  FocusNode(),
  FocusNode(),
  FocusNode()
];
int playerSettingsFocusIndex = -1;