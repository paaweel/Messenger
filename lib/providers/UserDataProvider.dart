import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kopper/config/Paths.dart';
import 'package:kopper/config/Urls.dart';
// import 'package:kopper/config/Urls.dart';
import 'package:kopper/utils/SharedObjects.dart';
import 'package:kopper/models/User.dart';
import 'package:kopper/models/Contact.dart';
import 'package:kopper/providers/BaseProvider.dart';
import 'package:kopper/utils/Exceptions.dart';
import 'package:kopper/config/Constants.dart';
import 'package:requests/requests.dart';
import 'dart:convert';

class UserDataProvider extends BaseUserDataProvider {
  final fireStoreDb = Firestore.instance;

  @override
  Future<User> saveDetails(User user) async {
    return User();
  }

  @override
  Future<User> saveProfileDetails(
      String username, String profileImageUrl) async {
    return User(); // create a user object and return it
  }

  @override
  Future<bool> isProfileComplete() async {
    return true;
  }

  @override
  Future<List<Contact>> getContacts() async {
    List<Contact> contactList = List();

    final response = await Requests.get(
      Urls.getContacts(SharedObjects.userId),
      headers: {HttpHeaders.authorizationHeader: Urls.getToken()},
    );

    if (response.hasError) {
      return contactList;
    }

    var jsons = response.json();
    jsons.forEach((contactJson) {
      print(contactJson);
      // var decoded = json.decode(contactJson);
      contactList.add(Contact.fromJson(contactJson));
    });
    return contactList;
  }

  @override
  Future<void> addContact(String username) async {
    List<Contact> contactsList = await getContacts();

    try {
      if ((contactsList.firstWhere((contact) => contact.username == username,
              orElse: () => null)) !=
          null) {
        throw ContactAlreadyExistsException();
      }
    } catch (_, stacktrace) {
      print(stacktrace);
      return;
    }

    final response = await Requests.post(
      Urls.getContacts(SharedObjects.userId),
      body: username,
      bodyEncoding: RequestBodyEncoding.JSON,
      headers: {HttpHeaders.authorizationHeader: Urls.getToken()},
    );
    print(response.hasError);
  }

  @override
  Future<User> getUser(String username) async {
    final response = await Requests.get(
      Urls.getUsers,
      bodyEncoding: RequestBodyEncoding.JSON,
      headers: {HttpHeaders.authorizationHeader: Urls.getToken()},
    );

    var json = response.json();
    User match;
    json.forEach((user) {
      if (user["username"] == username) match = User.fromJson(user);
    });

    return match;
  }

  @override
  Future<String> getUidByUsername(String username) async {
    //get reference to the mapping using username
    DocumentReference ref =
        fireStoreDb.collection(Paths.usernameUidMapPath).document(username);
    DocumentSnapshot documentSnapshot = await ref.get();
    print(documentSnapshot.exists);
    //check if uid mapping for supplied username exists
    if (documentSnapshot != null &&
        documentSnapshot.exists &&
        documentSnapshot.data['uid'] != null) {
      return documentSnapshot.data['uid'];
    } else {
      throw UsernameMappingUndefinedException();
    }
  }
}
