import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:todoo/screens/createNew.dart';
import 'package:todoo/screens/home_sc.dart';
import 'package:todoo/screens/welcome_screen.dart';

Color pink = Color.fromRGBO(236, 137, 137, 0.9294117647058824);
Color white = Color.fromRGBO(248, 245, 239, 1.0);
Color blue = Color.fromRGBO(72, 43, 173, 1.0);
Color grey = Color.fromRGBO(151, 152, 199, 0.4588235294117647);
Color yellow = Color.fromRGBO(253, 157, 12, 1);

Map<String, Widget Function(BuildContext)> myroutes = {
  "/": (context) => Welcome(),
  "/home": (context) => Home(),
  "/CreateNew": (context) => CreateNew(),
};
