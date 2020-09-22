import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
import 'package:requests/requests.dart';

import 'BaseProvider.dart';

class ChatProvider extends BaseChatProvider {
  // internal chat id assignment
  static int _id = 0;

  //rabbit mq
  ConnectionSettings _rabbitSettings;
  Client _client;

  // chats
  List<Chat> _chats = List<Chat>();
  StreamController _chatsController;

  // messages
  var _clientsMap = Map<int, Client>();
  var _messagesMap = Map<int, List<Message>>();
  var _streamControllerMap = Map<int, StreamController>();

  ChatProvider() {
    _rabbitSettings = ConnectionSettings(
      host: Constants.hostName,
      port: Constants.rabbitPort,
      authProvider: PlainAuthenticator(Constants.user, Constants.password),
      virtualHost: Constants.virtualHostName,
    );
    _client = Client(settings: _rabbitSettings);
    createChatsStream();
  }

  void createChatsStream() {
    _chatsController = StreamController<List<Chat>>.broadcast(
      // emit data when new widget asks for a stream
      onListen: () => _chatsController.sink.add(_chats),
    );
  }

  @override
  Stream<List<Chat>> getChats() {
    return _chatsController.stream;
  }

  Stream<List<Message>> getMessages(int chatId) {
    if (_streamControllerMap.containsKey(chatId))
      return _streamControllerMap[chatId].stream;

    Chat chat = getChatById(chatId);
    if (chat == null) return Stream.empty();

    _streamControllerMap[chat.serverChatId] = StreamController<List<Message>>();

    prepareStream(chat.serverChatId, chat);

    List<String> routingKeys = [chat.serverChatId.toString()];
    _clientsMap[chat.serverChatId].channel().then((Channel channel) {
      return channel.exchange(
          Constants.incomingConvExchange, ExchangeType.TOPIC,
          durable: true);
    }).then((Exchange exchange) {
      return exchange.bindPrivateQueueConsumer(
        routingKeys,
      );
    }).then((Consumer consumer) {
      consumer.listen((AmqpMessage event) {
        var message = parsePayload(event.payload);
        if (message.isSelf == false) addMessage(chat.serverChatId, message);
      });
    });

    return _streamControllerMap[chat.serverChatId].stream;
  }

  Future<List<Message>> loadPreviousMessages(String contactUsername) async {
    return await Requests.get(
      Urls.getMessages(SharedObjects.userId, contactUsername),
      headers: {HttpHeaders.authorizationHeader: Urls.getToken()},
    ).then((response) {
      if (response.hasError) {
        return List<Message>();
      }

      var msgs = List<Message>();
      var messagesJson = response.json();
      messagesJson.forEach((message) {
        var messageObject = Message.fromServerJson(message);
        messageObject.isSelf =
            (SharedObjects.username == messageObject.senderUsername);
        msgs.insert(0, messageObject);
      });

      return msgs;
    });
  }

  Future<void> prepareStream(int id, Chat chat) async {
    _clientsMap[id] = Client(settings: _rabbitSettings);
    _messagesMap[id] = await loadPreviousMessages(chat.user.username);
    _streamControllerMap[id].sink.add(_messagesMap[id]);
  }

  Message parsePayload(Uint8List payload) {
    var payloadString = String.fromCharCodes(payload);
    var message = Message.fromRabbitJson(json.decode(payloadString));
    message.isSelf = (SharedObjects.username == message.senderUsername);
    return message;
  }

  void addMessage(int serverChatId, Message message) {
    if (_messagesMap[serverChatId].isNotEmpty) {
      var lastMessage = _messagesMap[serverChatId].first;
      if (lastMessage == message) {
        return;
      }
    }
    _messagesMap[serverChatId].insert(0, message);
    _streamControllerMap[serverChatId].sink.add(_messagesMap[serverChatId]);
  }

  @override
  Future<void> sendMessage(int chatId, Message message) async {
    message.receiverUsername = getUsernameByChatId(chatId);
    message.senderUsername = SharedObjects.username;

    _client.channel().then((Channel channel) => channel
            .exchange(Constants.outgoingConvExchange, ExchangeType.FANOUT,
                durable: true)
            .then((Exchange exchange) {
          print(json.encode(message.toMap()));
          exchange.publish(json.encode(message.toMap()), null);
          return _client.close();
        }));

    var chat = getChatById(chatId);
    message.isSelf = true;
    addMessage(chat.serverChatId, message);
  }

  @override
  Future<int> getChatIdByUsername(String username) async {
    Chat chat = _chats.firstWhere((chat) => chat.user.username == username,
        orElse: () => null);
    if (chat != null) {
      return chat.chatId;
    }
    return -1;
  }

  String getUsernameByChatId(int chatId) {
    Chat chat = getChatById(chatId);
    return chat == null ? "" : chat.user.username;
  }

  @override
  Future<void> createChatIdForContact(Contact contact) async {
    contact.chatId = _id;
    Chat chat = Chat.fromContact(contact);
    _id = _id + 1;
    _chats.add(chat);
    _chatsController.sink.add(_chats);
  }

  Chat getChatById(int chatId) {
    Chat chat =
        _chats.firstWhere((chat) => chat.chatId == chatId, orElse: () => null);
    return chat;
  }
}
