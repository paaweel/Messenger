import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kopper/config/Constants.dart';
import 'package:kopper/config/Paths.dart';
import 'package:kopper/models/Chat.dart';
import 'package:kopper/models/Message.dart';
import 'package:kopper/models/User.dart';
import 'package:kopper/utils/SharedObjects.dart';
import 'package:dart_amqp/dart_amqp.dart';

import 'BaseProvider.dart';

class ChatProvider extends BaseChatProvider {
  Client _client;

  ChatProvider({Firestore fireStoreDb});

  @override
  Stream<List<Chat>> getChats() {
    return Stream.empty();
    // String uId = SharedObjects.prefs.getString(Constants.sessionUid);
    // return fireStoreDb
    //     .collection(Paths.usersPath)
    //     .document(uId)
    //     .snapshots()
    //     .transform(StreamTransformer<DocumentSnapshot, List<Chat>>.fromHandlers(
    //         handleData: (DocumentSnapshot documentSnapshot,
    //                 EventSink<List<Chat>> sink) =>
    //             mapDocumentToChat(documentSnapshot, sink)));
  }

  // void mapDocumentToChat(
  //   DocumentSnapshot documentSnapshot, EventSink sink) async {
  // List<Chat> chats = List();
  // Map data = documentSnapshot.data['chats'];
  // if(data!=null){
  // data.forEach((key, value) => chats.add(Chat(key, value)));
  // sink.add(chats);
  // }
  // }

  Stream<List<Message>> getMessages(String chatId) {
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

  void mapDocumentToMessage(QuerySnapshot querySnapshot, EventSink sink) async {
    // List<Message> messages = List();

    // for (DocumentSnapshot document in querySnapshot.documents) {
    //   messages.add(Message.fromFireStore(document));
    // }
    // sink.add(messages);
  }

  @override
  Future<void> sendMessage(String chatId, Message message) async {
    print("Sending message to ");
    print(chatId);
    print(message.toString());
    // DocumentReference chatDocRef =
    //     fireStoreDb.collection(Paths.chatsPath).document(chatId);
    // CollectionReference messagesCollection =
    //     chatDocRef.collection(Paths.messagesPath);
    // messagesCollection.add(message.toMap());
    // await chatDocRef.updateData({'latestMessage': message.toMap()});
  }

  @override
  Future<String> getChatIdByUsername(String username) async {
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
    return "1";
  }

  @override
  Future<void> createChatIdForContact(User user) async {
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

  // Future<String> createChatIdForUsers(
  //     String selfUsername, String contactUsername) async {
  //   CollectionReference collectionReference =
  //       fireStoreDb.collection(Paths.chatsPath);
  //   DocumentReference documentReference = await collectionReference.add({
  //     'members': [selfUsername, contactUsername]
  //   });
  //   return documentReference.documentID;
  // }
}
