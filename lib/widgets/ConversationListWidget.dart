import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kopper/blocs/chat/ChatBloc.dart';
import 'package:kopper/blocs/contacts/ContactsBloc.dart';
import 'package:kopper/models/Conversation.dart';
import 'package:kopper/models/Chat.dart';
import 'ChatRowWidget.dart';

class ConversationListWidget extends StatefulWidget {
  @override
  State createState() => _ConversationListWidgetState();
}

class _ConversationListWidgetState extends State<ConversationListWidget> {
  ChatBloc chatBloc;
  List<Chat> chats = List();

  @override
  void initState() {
    chatBloc = BlocProvider.of<ChatBloc>(context);
    chatBloc.add(FetchChatListEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
      if (state is FetchingContactsState) {
        return Center(child: CircularProgressIndicator());
      } else if (state is FetchedChatListState) {
        chats = state.chatList;
      }
      return ListView.builder(
          shrinkWrap: true,
          itemCount: chats.length,
          itemBuilder: (context, index) => ChatRowWidget(chats[index]));
    });
  }
}
