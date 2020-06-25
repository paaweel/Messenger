import 'package:flutter/material.dart';
import 'ChatItemWidget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kopper/blocs/chat/ChatBloc.dart';
import 'package:kopper/models/Message.dart';

class ChatListWidget extends StatefulWidget {
  @override
  _ChatListWidgetState createState() => _ChatListWidgetState();
}

class _ChatListWidgetState extends State<ChatListWidget> {
  final ScrollController listScrollController = ScrollController();
  List<Message> messages = List();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
      print('chatlist');
      print(state);
      if (state is FetchedMessagesState) {
        messages = state.messages;
        print(state.messages);
      }
      return ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemBuilder: (context, index) => ChatItemWidget(messages[index]),
        itemCount: messages.length,
        reverse: true,
        controller: listScrollController,
      );
    });
  }
}
