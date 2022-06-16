import 'package:flutter/material.dart';
import 'package:test_jupiter/colors.dart';

TextStyle get _baseTextStyle => const TextStyle(
  height: 1.25,
  color: Colors.white,
);

ThemeData toMaterialTheme() => ThemeData(
      splashColor: TJColors.yellowColor.withOpacity(0.25),
      fontFamily: 'packages/cryptoplease_ui/DIN2014',
      textTheme: TextTheme(
        headline1: _baseTextStyle.copyWith(
          fontSize: 72,
          fontWeight: FontWeight.bold,
        ),
        headline2: _baseTextStyle.copyWith(
          fontSize: 42,
          fontWeight: FontWeight.w600,
        ),
        headline3: _baseTextStyle.copyWith(
          fontSize: 26,
          fontWeight: FontWeight.w700,
        ),
        headline4: _baseTextStyle.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        subtitle1: _baseTextStyle.copyWith(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
        subtitle2: _baseTextStyle.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        bodyText1: _baseTextStyle.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        button: _baseTextStyle.copyWith(
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
