/*
 * Copyright 2020-2021 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'package:flutter/material.dart';

List<FocusNode> menuBarFocusNodes = [];

FocusNode homeFocusNode = FocusNode();

FocusNode searchFocusNode = FocusNode();
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