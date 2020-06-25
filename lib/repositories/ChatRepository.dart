import 'package:kopper/models/Chat.dart';
import 'package:kopper/models/Message.dart';
import 'package:kopper/providers/BaseProvider.dart';
import 'package:kopper/providers/ChatProvider.dart';
import 'package:kopper/models/User.dart';

class ChatRepository{
  BaseChatProvider chatProvider = ChatProvider();
  Stream<List<Chat>> getChats() => chatProvider.getChats();
  Stream<List<Message>> getMessages(String chatId) => chatProvider.getMessages(chatId);
  Future<void> sendMessage(String chatId, Message message) => chatProvider.sendMessage(chatId, message);
  Future<String> getChatIdByUsername(String username) => chatProvider.getChatIdByUsername(username);
  Future<void> createChatIdForContact(User user) => chatProvider.createChatIdForContact(user);
} 