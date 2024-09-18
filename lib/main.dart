import 'package:flutter/material.dart';
import 'package:shortpath/pages/home_screen.dart';

void main() {
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: false,
      ),//here
    home: HomeScreen(),));
}


