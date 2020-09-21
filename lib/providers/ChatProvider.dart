import 'dart:async';
// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kopper/config/Constants.dart';
import 'package:kopper/config/Paths.dart';
import 'package:kopper/config/Urls.dart';
import 'package:kopper/models/Chat.dart';
import 'package:kopper/models/Contact.dart';
import 'package:kopper/models/Message.dart';
import 'package:kopper/models/User.dart';
import 'package:kopper/utils/SharedObjects.dart';
import 'package:dart_amqp/dart_amqp.dart';
import 'dart:convert';

import 'BaseProvider.dart';

class ChatProvider extends BaseChatProvider {
  Client _client;
  static int _id = 0;
  List<Chat> _chats = List<Chat>();
  StreamController _chatsController;
  // StreamSubscription<AmqpMessage> _messagesSub;

  // Map<int, StreamController<List<Message>>> _messageControlersMap;
  // Map<int, List<Message>> _messagesMap;

  ChatProvider() {
    ConnectionSettings settings = ConnectionSettings(
      host: Constants.hostName,
      port: Constants.rabbitPort,
      authProvider: PlainAuthenticator(Constants.user, Constants.password),
      virtualHost: Constants.virtualHostName,
    );
    _client = Client(settings: settings);
    // _client
    //     .channel()
    //     .then((Channel channel) => channel.exchange(
    //         Constants.incomingConvExchange, ExchangeType.TOPIC, durable: true))
    //     .then((Exchange exchange) =>
    //         exchange.bindQueueConsumer(Constants.mainQueue, null));
    createChatsStream();
  }

  void createChatsStream() {
    _chatsController = StreamController<List<Chat>>();
    _chatsController.sink.add(_chats);
  }

  @override
  Stream<List<Chat>> getChats() => _chatsController.stream;

  Stream<List<Message>> getMessages(int chatId) {
    List<String> routingKeys = ["5"];
    _client.channel().then((Channel channel) {
      return channel.exchange(
          Constants.incomingConvExchange, ExchangeType.TOPIC,
          durable: true);
    }).then((Exchange exchange) {
      print(" [*] Waiting for messages in logs. To Exit press CTRL+C");
      return exchange.bindPrivateQueueConsumer(
        routingKeys,
      );
    }).then((Consumer consumer) {
      consumer.listen((AmqpMessage event) {
        print(" [x] ${event.routingKey}:'${event.payloadAsString}'");
      });
    });

    return Stream.empty();
  }

  @override
  Future<void> sendMessage(int chatId, Message message) async {
    message.receiverUsername = getUsernameByChatId(chatId);
    message.senderUsername = SharedObjects.username;
    print(message.toMap());

    _client.channel().then((Channel channel) => channel
            .exchange(Constants.outgoingConvExchange, ExchangeType.FANOUT,
                durable: true)
            .then((Exchange exchange) {
          exchange.publish(json.encode(message.toMap()), null);
          return _client.close();
        }));
  }

  @override
  Future<int> getChatIdByUsername(String username) async {
    Chat chat = _chats.firstWhere((chat) => chat.username == username,
        orElse: () => null);
    if (chat != null) {
      return chat.chatId;
    }
    return -1;
  }

  String getUsernameByChatId(int chatId) {
    Chat chat =
        _chats.firstWhere((chat) => chat.chatId == chatId, orElse: () => null);
    return chat == null ? "" : chat.username;
  }

  @override
  Future<void> createChatIdForContact(Contact contact) async {
    contact.chatId = _id;
    Chat chat = Chat.fromContact(contact);
    _id = _id + 1;
    _chats.add(chat);
    _chatsController.sink.add(_chats);
  }
}
