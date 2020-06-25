import 'package:flutter/material.dart';
import 'package:rubber/rubber.dart';
import 'ConversationPage.dart';
import 'package:kopper/widgets/InputWidget.dart';
import 'package:kopper/pages/ConversationBottomSheet.dart';
import 'package:kopper/models/Contact.dart';

class ConversationPageSlide extends StatefulWidget {
  @override
  _ConversationPageSlideState createState() =>
      _ConversationPageSlideState(startContact);

  final Contact startContact;
  const ConversationPageSlide({this.startContact});
}

class _ConversationPageSlideState extends State<ConversationPageSlide>
    with SingleTickerProviderStateMixin {
  var controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final Contact startContact;

  _ConversationPageSlideState(this.startContact);

  @override
  void initState() {
    controller = RubberAnimationController(
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            body: Column(
              children: <Widget>[
                Expanded(child: PageView.builder(
                    itemCount: 500,
                    itemBuilder: (index, context) {
                  return ConversationPage();
                })),
                Container(
                    child: GestureDetector(
                        child: InputWidget(),
                        onPanUpdate: (details) {
                          if (details.delta.dy < 0) {
                            _scaffoldKey.currentState
                                .showBottomSheet<Null>((BuildContext context) {
                              return ConversationBottomSheet();
                            });
                          }
                        }))
              ],
            )));
  }
}
