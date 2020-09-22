import 'Conversation.dart';

class Contact {
  String username;
  String firstName;
  int serverChatId;
  int chatId;
  String lastName;

  Contact(
      {this.username,
      this.lastName,
      this.firstName,
      this.chatId,
      this.serverChatId});

  factory Contact.fromJson(Map<String, dynamic> contactJson) {
    print(contactJson);
    var c = Contact(
        firstName: contactJson['firstName'] as String,
        lastName: contactJson['lastName'] as String,
        serverChatId: contactJson['conversationID'] as int,
        username: contactJson['username'] as String);
    if (c.lastName == null) c.lastName = "Smith";
    return c;
  }

  factory Contact.fromConversation(Conversation conversation) {
    return Contact(
        username: conversation.user.username,
        chatId: conversation.chatId,
        firstName: conversation.user.firstName,
        lastName: conversation.user.lastName,
        serverChatId: conversation.serverChatId);
  }

  @override
  String toString() {
    return '{ name: $firstName, username: $username}';
  }

  String getFirstName() => firstName;

  String getLastName() => lastName == null ? "" : lastName;
}
