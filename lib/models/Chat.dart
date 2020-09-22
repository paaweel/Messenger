import 'package:kopper/models/Contact.dart';
import 'package:kopper/models/Message.dart';
import 'package:kopper/models/PresentationUser.dart';

class Chat {
  int chatId; // id used locally
  int serverChatId; // id used by the server
  PresentationUser user;
  Message latestMessage = TextMessage("", 0, "", "");

  Chat({this.user, this.chatId, this.serverChatId, this.latestMessage});

  Contact contact() {
    return Contact(
        username: user.username,
        firstName: user.firstName,
        lastName: user.lastName,
        chatId: chatId,
        serverChatId: serverChatId);
  }

  Chat.fromContact(Contact contact) {
    this.chatId = contact.chatId;
    this.serverChatId = contact.serverChatId;
    this.user = PresentationUser.fromContact(contact);
  }

  @override
  String toString() =>
      '{ username= $PresentationUser, chatId = $chatId, serverChatId = $serverChatId}';
}
