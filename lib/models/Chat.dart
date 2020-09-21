import 'package:kopper/models/Contact.dart';

class Chat {
  String username;
  int chatId; // id used locally
  int serverChatId; // id used by the server

  Chat({this.username, this.chatId, this.serverChatId});

  Chat.fromContact(Contact contact) {
    this.username = contact.username;
    this.chatId = contact.chatId;
    this.serverChatId = contact.serverChatId;
  }

  @override
  String toString() =>
      '{ username= $username, chatId = $chatId, serverChatId = $serverChatId}';
}
