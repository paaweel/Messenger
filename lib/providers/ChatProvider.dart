import 'dart:async';
// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kopper/config/Constants.dart';
import 'package:kopper/config/Paths.dart';
import 'package:kopper/config/Urls.dart';
import 'package:kopper/models/Chat.dart';
import 'package:kopper/models/Message.dart';
import 'package:kopper/models/User.dart';
import 'package:kopper/utils/SharedObjects.dart';
import 'package:dart_amqp/dart_amqp.dart';

import 'BaseProvider.dart';

class ChatProvider extends BaseChatProvider {
  Client _client;

  List<Chat> _chats = List<Chat>();

  StreamController _chatsController;

  static int id = 0;

  ChatProvider() {
    ConnectionSettings settings =
        ConnectionSettings(
          host: Urls.host,
          port: 52376,
          authProvider: PlainAuthenticator(Constants.user, Constants.password),
          virtualHost: Constants.hostName,

          );
    _client = Client(settings: settings);
    // _client.channel()
    //   .then((Channel channel) => channel.exchange(Constants.incomingConvExchange, ExchangeType.TOPIC, durable: true))
    //   .then((Exchange exchange) => exchange.bindQueueConsumer(Constants.mainQueue));
    createChatsStream();
  }

  void createChatsStream() {
    _chatsController = StreamController<List<Chat>>();
    _chatsController.sink.add(_chats);
  }

  @override
  Stream<List<Chat>> getChats() => _chatsController.stream;

  Stream<List<Message>> getMessages(int chatId) {
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
    return Stream.empty();
  }
  
  @override
  Future<void> sendMessage(int chatId, Message message) async {
    print("Sending message to ");
    print(chatId);
    print(message.toString());
    _client.channel()
      .then((Channel channel) => channel.exchange(Constants.outgoingConvExchange, ExchangeType.FANOUT, durable: true)
      .then((Exchange exchange) {
        exchange.publish("Testing 1-2-3", null);
        return _client.close();
      })
    );
    // DocumentReference chatDocRef =
    //     fireStoreDb.collection(Paths.chatsPath).document(chatId);
    // CollectionReference messagesCollection =
    //     chatDocRef.collection(Paths.messagesPath);
    // messagesCollection.add(message.toMap());
    // await chatDocRef.updateData({'latestMessage': message.toMap()});
  }

  @override
  Future<int> getChatIdByUsername(String username) async {
    
    // String uId = SharedObjects.prefs.getString(Constants.sessionUid);
    // String selfUsername =
    //     SharedObjects.prefs.getString(Constants.sessionUsername);
    // DocumentReference userRef =
    //     fireStoreDb.collection(Paths.usersPath).document(uId);
    // DocumentSnapshot documentSnapshot = await userRef.get();
    // String chatId = documentSnapshot.data['chats'][username];
    // if (chatId == null) {
    //   chatId = await createChatIdForUsers(selfUsername, username);
    //   userRef.updateData({
    //     'chats': {username: chatId}
    //   });
    // }

    Chat chat = _chats.firstWhere((chat) => chat.username == username, orElse: () => null);
    if (chat != null) {
      return chat.chatId;
    }
    else {
      createChatIdForContact(username);
      return id - 1;
    }
  }

  @override
  Future<void> createChatIdForContact(String username) async {
    Chat chat = Chat(username, id);
    id = id + 1;
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
