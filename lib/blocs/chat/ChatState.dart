part of "ChatBloc.dart";

@immutable
abstract class ChatState extends Equatable {
  ChatState([List props = const <dynamic>[]]) : super(props);
}

class InitialChatState extends ChatState {}

class FetchedChatListState extends ChatState {
  final List<Chat> chatList;

  FetchedChatListState(this.chatList) : super([chatList]);

  @override
  String toString() => 'FetchedChatListState';
}

class FetchedMessagesState extends ChatState {
  final List<Message> messages;
  final String username;
  FetchedMessagesState(this.messages, this.username)
      : super([messages, username]);
  @override
  String toString() => 'FetchedMessagesState';
}

class MessagesAcknowelged extends ChatState {
  @override
  String toString() => 'MessagesAcknowelged';
}

class ErrorState extends ChatState {
  final Exception exception;
  ErrorState(this.exception) : super([exception]);

  @override
  String toString() => 'ErrorState';
}

class FetchedContactDetailsState extends ChatState {
  final User user;

  FetchedContactDetailsState(this.user) : super([user]);

  @override
  String toString() => 'FetchedContactDetailsState';
}

class PageChangedState extends ChatState {
  final int index;
  final Chat activeChat;
  PageChangedState(this.index, this.activeChat) : super([index, activeChat]);

  @override
  String toString() => 'PageChangedState';
}
