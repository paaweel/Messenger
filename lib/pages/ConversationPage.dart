import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kopper/blocs/chat/ChatBloc.dart';
import 'package:kopper/config/Palette.dart';
import 'package:kopper/models/Chat.dart';
import 'package:kopper/widgets/ChatAppBar.dart';
import 'package:kopper/widgets/ChatListWidget.dart';
import 'dart:ui';

class ConversationPage extends StatefulWidget {
  final Chat chat;

  @override
  _ConversationPageState createState() => _ConversationPageState(chat);

  const ConversationPage(this.chat);
}

class _ConversationPageState extends State<ConversationPage>
    with AutomaticKeepAliveClientMixin {
  final Chat chat;
  ChatBloc chatBloc;
  _ConversationPageState(this.chat);

  @override
  void initState() {
    super.initState();
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
        SizedBox.fromSize(size: Size.fromHeight(100), child: ChatAppBar(chat))
      ],
    );
    // return Column(children: <Widget>[
    //   Expanded(flex: 2, child: ChatAppBar()), // Custom app bar for chat screen
    //   Expanded(
    //       flex: 11,
    //       child: Container(
    //         color: Palette.chatBackgroundColor,
    //         child: ChatListWidget(),
    //       ))
    // ]
    // );
  }

  @override
  bool get wantKeepAlive => true;
}
