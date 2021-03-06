import 'package:flutter/material.dart';

FocusNode menuBarFocusNode = FocusNode();

FocusNode homeFocusNode = FocusNode();
List<FocusNode> newEpisodesFocusNodes = [];
List<FocusNode> newSimulcastsFocusNodes = [];
List<FocusNode> newCatalogTitlesFocusNodes = [];
List<FocusNode> topTenFocusNodes = [];
int homeRowIndex = 0;
int homeRowItemIndex = -1;

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