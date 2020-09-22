import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kopper/config/Assets.dart';
import 'package:kopper/config/Palette.dart';
import 'package:kopper/config/Transitions.dart';
import 'package:kopper/models/Chat.dart';
import 'package:kopper/models/Message.dart';
import 'package:kopper/models/Contact.dart';
import 'package:kopper/pages/ConversationPageSlide.dart';

class ChatRowWidget extends StatelessWidget {
  final Chat chat;

  ChatRowWidget(this.chat);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          SlideLeftRoute(
              page: ConversationPageSlide(startContact: chat.contact()))),
      child: Container(
          color: Theme.of(context).primaryColor,
          padding: EdgeInsets.fromLTRB(15, 10, 0, 10),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 8,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: Image.asset(
                            Assets.user,
                          ).image,
                        ),
                        width: 61.0,
                        height: 61.0,
                        padding: const EdgeInsets.all(1.0),
                        // borde width
                        decoration: new BoxDecoration(
                          color: Theme.of(context).accentColor, // border color
                          shape: BoxShape.circle,
                        )),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(chat.user.name(),
                            style: Theme.of(context).textTheme.body1),
                        messageContent(context, chat.latestMessage)
                      ],
                    ))
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      DateFormat('kk:mm').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              chat.latestMessage.timeStamp)),
                      style: Theme.of(context).textTheme.caption,
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }

  messageContent(context, Message latestMessage) {
    if (latestMessage is TextMessage)
      return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            latestMessage.isSelf
                ? Icon(
                    Icons.done,
                    size: 12,
                    color: Palette.greyColor,
                  )
                : Container(),
            SizedBox(
              width: 2,
            ),
            Text(
              latestMessage.text,
              style: Theme.of(context).textTheme.caption,
            )
          ]);
  }
}
