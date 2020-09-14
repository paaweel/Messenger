import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kopper/models/Message.dart';
import 'package:meta/meta.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:kopper/config/Constants.dart';
import 'package:kopper/config/Paths.dart';
import 'package:kopper/repositories/ChatRepository.dart';
import 'package:kopper/repositories/StorageRepository.dart';
import 'package:kopper/repositories/UserDataRepository.dart';
import 'package:kopper/utils/Exceptions.dart';
import 'package:kopper/utils/SharedObjects.dart';
import 'package:kopper/models/User.dart';
import 'package:kopper/models/Chat.dart';

part 'ChatEvent.dart';
part 'ChatState.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;
  final UserDataRepository userDataRepository;
  final StorageRepository storageRepository;

  StreamSubscription messagesSubscription;
  StreamSubscription chatsSubscription;
  int activeChatId;

  ChatBloc(
      {this.chatRepository, this.userDataRepository, this.storageRepository})
      : assert(chatRepository != null),
        assert(userDataRepository != null),
        assert(storageRepository != null);

  @override
  ChatState get initialState => InitialChatState();

  @override
  Stream<ChatState> mapEventToState(
    ChatEvent event,
  ) async* {
    print(event);
    if (event is FetchChatListEvent) {
      yield* mapFetchChatListEventToState(event);
    }
    if (event is ReceivedChatsEvent) {
      yield FetchedChatListState(event.chatList);
    }
    if (event is PageChangedEvent) {
      activeChatId = event.activeChat.chatId;
    }
    if (event is FetchConversationDetailsEvent) {
      add(FetchMessagesEvent(event.chat));
      yield* mapFetchConversationDetailsEventToState(event);
    }
    if (event is FetchMessagesEvent) {
      yield* mapFetchMessagesEventToState(event);
    }
    if (event is ReceivedMessagesEvent) {
      print(event.messages);
      yield FetchedMessagesState(event.messages);
    }
    if (event is SendTextMessageEvent) {
      Message message = TextMessage(
          event.message,
          DateTime.now().millisecondsSinceEpoch,
          SharedObjects.prefs.getString(Constants.sessionName),
          SharedObjects.prefs.getString(Constants.sessionUsername));
      await chatRepository.sendMessage(activeChatId, message);
    }
  }

  Stream<ChatState> mapFetchChatListEventToState(
      FetchChatListEvent event) async* {
    try {
      chatsSubscription?.cancel();
      chatsSubscription = chatRepository
          .getChats()
          .listen((chats) => add(ReceivedChatsEvent(chats)));
    } on KopperException catch (exception) {
      print(exception.errorMessage());
      yield ErrorState(exception);
    }
  }

  Stream<ChatState> mapFetchMessagesEventToState(
      FetchMessagesEvent event) async* {
    try {
      yield InitialChatState();
      int chatId =
          await chatRepository.getChatIdByUsername(event.chat.username);
      messagesSubscription?.cancel();
      messagesSubscription = chatRepository
          .getMessages(chatId)
          .listen((messages) => add(ReceivedMessagesEvent(messages)));
    } on KopperException catch (exception) {
      print(exception.errorMessage());
      yield ErrorState(exception);
    }
  }

  Stream<ChatState> mapFetchConversationDetailsEventToState(
      FetchConversationDetailsEvent event) async* {
    User user = await userDataRepository.getUser(event.chat.username);
    print(user);
    yield FetchedContactDetailsState(user);
  }

  @override
  Future<void> close() {
    messagesSubscription.cancel();

    return super.close();
  }
}
