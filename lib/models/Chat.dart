import 'package:kopper/models/Contact.dart';

class Chat {
  String username;
  int chatId; // id used locally
  int serverChatId; // and this by the server

  Chat(
    this.username,
    this.chatId,
    this.serverChatId,
  );

  Chat.fromContact(Contact contact, int chatId) {
    Chat(contact.username, chatId, contact.conversationId);
  }

  @override
  String toString() =>
      '{ username= $username, chatId = $chatId, serverChatId = $serverChatId}';
}
