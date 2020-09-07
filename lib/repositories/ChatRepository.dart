import 'package:kopper/models/Chat.dart';
import 'package:kopper/models/Contact.dart';
import 'package:kopper/models/Message.dart';
import 'package:kopper/providers/BaseProvider.dart';
import 'package:kopper/providers/ChatProvider.dart';
import 'package:kopper/models/User.dart';

class ChatRepository {
  BaseChatProvider chatProvider = ChatProvider();

  Stream<List<Chat>> getChats() => chatProvider.getChats();
  Stream<List<Message>> getMessages(int chatId) =>
      chatProvider.getMessages(chatId);
  Future<void> sendMessage(int chatId, Message message) =>
      chatProvider.sendMessage(chatId, message);
  Future<int> getChatIdByUsername(String username) =>
      chatProvider.getChatIdByUsername(username);
  Future<void> createChatIdForContact(String username) =>
      chatProvider.createChatIdForContact(username);
}
