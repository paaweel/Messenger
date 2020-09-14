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
  List<StreamController> _messagesController;

  ChatProvider() {
    ConnectionSettings settings = ConnectionSettings(
      host: Constants.hostName,
      port: Constants.rabbitPort,
      authProvider: PlainAuthenticator(Constants.user, Constants.password),
      virtualHost: Constants.virtualHostName,
    );
    _client = Client(settings: settings);
    _client
        .channel()
        .then((Channel channel) => channel.exchange(
            Constants.incomingConvExchange, ExchangeType.TOPIC, durable: true))
        .then((Exchange exchange) =>
            exchange.bindQueueConsumer(Constants.mainQueue, null));
    createChatsStream();
  }

  void createChatsStream() {
    _chatsController = StreamController<List<Chat>>();
    _chatsController.sink.add(_chats);
  }

  @override
  Stream<List<Chat>> getChats() => _chatsController.stream;

  Stream<List<Message>> getMessages(int chatId) {
    Chat chat =
        _chats.firstWhere((chat) => chat.chatId == chatId, orElse: () => null);

    // _client
    //     .channel()
    //     .then((Channel channel) => channel.basicReturnListener((message) {
    //           print(message.payloadAsString);
    //         }));
    _client
        .channel()
        .then((Channel channel) => channel
                .exchange(Constants.incomingConvExchange, ExchangeType.TOPIC,
                    durable: true)
                .then((Exchange exchange) {
              exchange.bindPrivateQueueConsumer(["5"]);
            }))
        .then((Consumer consumer) => consumer.consumer);

    return Stream.empty();
    // // _client.channel().then((Channel channel) => channel.)
    // _client
    //     .channel() // auto-connect to localhost:5672 using guest credentials
    //     .then((Channel channel) => channel.queue("hello"))
    //     .then((Queue queue) => queue.consume())
    //     .then((Consumer consumer) => consumer.listen((AmqpMessage message) {
    //           // Get the payload as a string
    //           print(" [x] Received string: ${message.payloadAsString}");

    //           // Or unserialize to json
    //           print(" [x] Received json: ${message.payloadAsJson}");

    //           // Or just get the raw data as a Uint8List
    //           print(" [x] Received raw: ${message.payload}");

    //           // The message object contains helper methods for
    //           // replying, ack-ing and rejecting
    //           message.reply("world");
    //         }));
    // DocumentReference chatDocRef =
    //     fireStoreDb.collection(Paths.chatsPath).document(chatId);
    // CollectionReference messagesCollection =
    //     chatDocRef.collection(Paths.messagesPath);
    // return messagesCollection
    //     .orderBy('timeStamp', descending: true)
    //     .snapshots()
    //     .transform(StreamTransformer<QuerySnapshot, List<Message>>.fromHandlers(
    //         handleData:
    //             (QuerySnapshot querySnapshot, EventSink<List<Message>> sink) =>
    //                 mapDocumentToMessage(querySnapshot, sink)));
  }

  @override
  Future<void> sendMessage(int chatId, Message message) async {
    print("Sending message: `" +
        message.toString() +
        "` to userId: " +
        chatId.toString());

    message.receiverUsername = getUsernameByChatId(chatId);
    message.senderUsername = SharedObjects.username;

    _client.channel().then((Channel channel) => channel
            .exchange(Constants.outgoingConvExchange, ExchangeType.FANOUT,
                durable: true)
            .then((Exchange exchange) {
          exchange.publish(json.encode(message.toMap()), null);
          return _client.close();
        }));
    // DocumentReference chatDocRef =
    //     fireStoreDb.collection(Paths.chatsPath).document(chatId);
    // CollectionReference messagesCollection =
    //     chatDocRef.collection(Paths.messagesPath);
    // messagesCollection.add(message.toMap());
    // await chatDocRef.updateData({'latestMessage': message.toMap()});
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
    Chat chat = Chat.fromContact(contact, _id);
    _id = _id + 1;
    _chats.add(chat);
    _chatsController.sink.add(_chats);
    // String contactUid = user.documentId;
    // String contactUsername = user.username;
    // String uId = SharedObjects.prefs.getString(Constants.sessionUid);
    // String selfUsername = SharedObjects.prefs.getString(Constants.sessionUsername);
    // CollectionReference usersCollection = fireStoreDb.collection(Paths.usersPath);
    // DocumentReference userRef = usersCollection.document(uId);
    // DocumentReference contactRef = usersCollection.document(contactUid);
    // DocumentSnapshot userSnapshot = await userCRef.get();
    // if(userSnapshot.data['chats']==null|| userSnapshot.data['chats'][contactUsername]==null){
    // String chatId = await createChatIdForUsers(selfUsername, contactUsername);
    // await userRef.setData({
    //     'chats': {contactUsername: chatId}
    //   },merge:true );
    // await contactRef.setData({
    //   'chats': {selfUsername: chatId}
    // },merge: true);
    // }
  }
}
