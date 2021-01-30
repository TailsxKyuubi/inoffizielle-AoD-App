import 'package:flutter/material.dart';

FocusNode menuBarFocusNode = FocusNode();

List<FocusNode> menuBarElementsFocusNodes = [
  FocusNode(),
  FocusNode(),
  FocusNode()
];
int menuBarIndex = 0;

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