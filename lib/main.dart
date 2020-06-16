import 'package:flutter/material.dart';
import 'config/Palette.dart';
// import 'pages/ConversationPageSlide.dart';
import 'pages/RegisterPage.dart';

void main() => runApp(Kopper());

class Kopper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Kopper",
      theme: ThemeData(
        primaryColor: Palette.primaryColor,
//        primarySwatch: Palette.primaryColor,
      ),
      home: RegisterPage()//ConversationPageSlide(),
    );
  }
}