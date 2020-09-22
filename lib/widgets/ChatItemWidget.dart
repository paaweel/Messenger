import 'package:flutter/material.dart';
import 'package:kopper/config/Palette.dart';
import 'package:intl/intl.dart';
import 'package:kopper/models/Message.dart';

class ChatItemWidget extends StatelessWidget {
  final Message message;

  ChatItemWidget(this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          buildMessageContainer(message.isSelf, message, context),
          buildTimeStamp(message.isSelf, message, context),
        ],
      ),
    );
  }

  Row buildMessageContainer(
      bool isSelf, Message message, BuildContext context) {
    double lrEdgeInsets = 1.0;
    double tbEdgeInsets = 1.0;
    if (message is TextMessage) {
      lrEdgeInsets = 15.0;
      tbEdgeInsets = 10.0;
    }
    return Row(
      children: <Widget>[
        Container(
          child: buildMessageContent(isSelf, message, context),
          padding: EdgeInsets.fromLTRB(
              lrEdgeInsets, tbEdgeInsets, lrEdgeInsets, tbEdgeInsets),
          constraints: BoxConstraints(maxWidth: 200.0),
          decoration: BoxDecoration(
              color: isSelf
                  ? Palette.selfMessageBackgroundColor
                  : Palette.otherMessageBackgroundColor,
              borderRadius: BorderRadius.circular(8.0)),
          margin: EdgeInsets.only(
              right: isSelf ? 10.0 : 0, left: isSelf ? 0 : 10.0),
        )
      ],
      mainAxisAlignment: isSelf
          ? MainAxisAlignment.end
          : MainAxisAlignment.start, // aligns the chatitem to right end
    );
  }

  buildMessageContent(bool isSelf, Message message, BuildContext context) {
    if (message is TextMessage) {
      return Text(
        message.text,
        style: TextStyle(
            color:
                isSelf ? Palette.selfMessageColor : Palette.otherMessageColor),
      );
    }
  }

  Row buildTimeStamp(bool isSelf, Message message, BuildContext context) {
    return Row(
        mainAxisAlignment:
            isSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
              DateFormat('dd MMM kk:mm').format(
                  DateTime.fromMillisecondsSinceEpoch(message.timeStamp)),
              style: Theme.of(context).textTheme.caption,
            ),
            margin: EdgeInsets.only(
                left: isSelf ? 5.0 : 0.0,
                right: isSelf ? 0.0 : 5.0,
                top: 5.0,
                bottom: 5.0),
          )
        ]);
  }
}
