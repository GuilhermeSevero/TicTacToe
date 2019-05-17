import 'package:flutter/material.dart';

class GameButton {
  final id;
  String text;
  Color bg;
  bool enabled;
  int value;

  GameButton(
      {this.id, this.text = "", this.bg = Colors.grey, this.enabled = true, this.value = 0});
}
