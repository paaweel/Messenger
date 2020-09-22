import 'package:flutter/material.dart';
import 'package:kopper/models/Chat.dart';
import 'ChatItemWidget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kopper/blocs/chat/ChatBloc.dart';
import 'package:kopper/models/Message.dart';

class ChatListWidget extends StatefulWidget {
  final Chat chat;

  ChatListWidget(this.chat);

  @override
  _ChatListWidgetState createState() => _ChatListWidgetState(chat);
}

class _ChatListWidgetState extends State<ChatListWidget> {
  final ScrollController listScrollController = ScrollController();
  List<Message> messages = List();
  final Chat chat;
  ChatBloc chatBloc;

  _ChatListWidgetState(this.chat);

  @override
  void initState() {
    super.initState();
    chatBloc = BlocProvider.of<ChatBloc>(context);
    listScrollController.addListener(() {
      double maxScroll = listScrollController.position.maxScrollExtent;
      double currentScroll = listScrollController.position.pixels;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
        bloc: chatBloc,
        listener: (context, state) {
          print('chatlist');
          print(state);
          if (state is FetchedMessagesState) {
            print('Received Messages');
            if (state.username == chat.user.username) {
              setState(() {
                messages = state.messages;
              });
            }
          }
        },
        child: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemBuilder: (context, index) => ChatItemWidget(messages[index]),
          itemCount: messages.length,
          reverse: true,
          controller: listScrollController,
        ));
  }

  Future<void> scrollToBottom() async {
    listScrollController.animateTo(
        0.0, //listScrollController.position.maxScrollExtent,
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn);
  }
}
