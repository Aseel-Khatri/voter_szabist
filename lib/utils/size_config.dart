import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class SizeConfig {
  static double _screenWidth=0.0;
  static double _screenHeight=0.0;

  static double heightMultiplier=0.0;
  static double widthMultiplier=0.0;
  static bool isPortrait = true;
  static bool isMobilePortrait = false;

  void init(BoxConstraints constraints) {
//    if (orientation == Orientation.portrait) {
    _screenWidth = constraints.maxWidth;
    _screenHeight = constraints.maxHeight;
    isPortrait = true;
    if (_screenWidth < 450) {
      isMobilePortrait = true;
    }
//    } else {
//      _screenWidth = constraints.maxHeight;
//      _screenHeight = constraints.maxWidth;
//      isPortrait = false;
//      isMobilePortrait = false;
//    }
    widthMultiplier = _screenWidth / 100;
    heightMultiplier = _screenHeight / 100;
  }
}