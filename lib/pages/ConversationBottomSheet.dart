import 'package:flutter/material.dart';
import 'package:kopper/config/Palette.dart';
import 'package:kopper/config/Styles.dart';
import 'package:kopper/widgets/ChatRowWidget.dart';
import 'package:kopper/widgets/NavigationPillWidget.dart';

class ConversationBottomSheet extends StatefulWidget {
  @override
  _ConversationBottomSheetState createState() =>
      _ConversationBottomSheetState();

  const ConversationBottomSheet();
}

class _ConversationBottomSheetState extends State<ConversationBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: ListView(children: <Widget>[
              GestureDetector(
                  child: ListView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    children: <Widget>[
                      NavigationPillWidget(),
                      Center(child: Text('Messages', style: Styles.textHeading)),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                  onVerticalDragEnd: (details) {
                    print("onVerticalDragEnd");
                    if (details.primaryVelocity > 60) {
                      Navigator.pop(context);
                    }
                  },
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: 5,
                separatorBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(left: 75, right: 20),
                    child: Divider(
                      color: Palette.accentColor,
                    )),
                itemBuilder: (context, index) {
                  return ChatRowWidget();
                },
              )
            ])));
  }
}
