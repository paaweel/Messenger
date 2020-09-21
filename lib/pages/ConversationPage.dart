import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kopper/blocs/chat/ChatBloc.dart';
import 'package:kopper/config/Palette.dart';
import 'package:kopper/models/Chat.dart';
import 'package:kopper/models/Contact.dart';
import 'package:kopper/widgets/ChatAppBar.dart';
import 'package:kopper/widgets/ChatListWidget.dart';
import 'dart:ui';

class ConversationPage extends StatefulWidget {
  final Chat chat;
  final Contact contact;

  @override
  _ConversationPageState createState() => _ConversationPageState(chat);

  const ConversationPage({this.chat, this.contact});
}

class _ConversationPageState extends State<ConversationPage>
    with AutomaticKeepAliveClientMixin {
  Chat chat;
  Contact contact;
  ChatBloc chatBloc;
  _ConversationPageState(this.chat);

  @override
  void initState() {
    super.initState();
    if (contact != null)
      chat = Chat(
          username: contact.username,
          serverChatId: contact.serverChatId,
          chatId: contact.chatId);
    print('init of $chat');
    chatBloc = BlocProvider.of<ChatBloc>(context);
    chatBloc.add(FetchConversationDetailsEvent(chat));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print('building chat: $chat');
    return Stack(
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(top: 100),
            color: Palette.chatBackgroundColor,
            child: ChatListWidget(chat)),
        SizedBox.fromSize(
            size: Size.fromHeight(100),
            child: ChatAppBar(
              chat: chat,
              contact: contact,
            ))
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
