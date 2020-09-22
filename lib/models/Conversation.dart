import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kopper/config/Constants.dart';
import 'package:kopper/models/Message.dart';
import 'package:kopper/models/User.dart';
import 'package:kopper/utils/SharedObjects.dart';

class Conversation {
  int chatId;
  int serverChatId;
  User user;
  Message latestMessage;

  Conversation(this.chatId, this.user, this.latestMessage);

  @override
  String toString() =>
      '{ user= $user, chatId = $chatId, latestMessage = $latestMessage}';
}
