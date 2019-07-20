import 'package:flutter/material.dart';
import 'package:ttnmapper_app/constants.dart';
import 'package:ttnmapper_app/screens/home_screen.dart';
import 'package:ttnmapper_app/util/color_util.dart';

void main() => runApp(TtnMapperApp());

class TtnMapperApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            primarySwatch:
            MaterialColor(Constants.primaryColor, ColorUtil.color),
            fontFamily: 'Montserrat'),
        home: HomeScreen());
  }
}
