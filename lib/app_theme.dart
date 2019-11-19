import 'package:flutter/material.dart';

class AppTheme {
  static const Color maroon = Color(0xFF8B041F);
  static const Color blueGrey = Color(0xFF8E9AAF);
  static const Color darkerGrey = Color(0xFFB3B3B3);
  static const Color grey = Color(0xFFEFEFEF);
  static const Color pink = Color(0xFFED4856);

  static const String familyFontAirAmericana = "Air Americana";
  static const String familyFontMenlo = "Menlo";
  static const String familyFontSpaceMono = "Space Mono";
  static const String familyFontDefault = familyFontAirAmericana;

  static const fontWeightThin = FontWeight.w100;
  static const fontWeightExtraLight = FontWeight.w200;
  static const fontWeightLight = FontWeight.w300;
  static const fontWeightNormal = FontWeight.w400;
  static const fontWeightMedium = FontWeight.w500;
  static const fontWeightSemiBold = FontWeight.w600;
  static const fontWeightBold = FontWeight.w700;

  static const double fontSizeExtraSmall = 8;
  static const double fontSizeSmall = 12;
  static const double fontSizeNormal = 16;
  static const double fontSizeMid = 24;
  static const double fontSizeLarge = 32;
  static const double fontSizeExtraLarge = 64;

  static ThemeData theme() {
    return ThemeData(
        primaryColor: pink,
        fontFamily: familyFontDefault,
        backgroundColor: Colors.white,
        canvasColor: grey,
        splashColor: blueGrey,
        cardColor: darkerGrey,
        cursorColor: maroon,
        textTheme: TextTheme(
            title: TextStyle(
                fontSize: fontSizeExtraLarge, color: Colors.blue[500]),
            body1: TextStyle(fontSize: fontSizeMid),
            body2: TextStyle(fontSize: fontSizeNormal)));
  }
}
