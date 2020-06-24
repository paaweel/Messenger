import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kopper/config/Paths.dart';
// import 'package:kopper/config/Urls.dart';
import 'package:kopper/utils/SharedObjects.dart';
import 'package:kopper/models/User.dart';
import 'package:kopper/models/Contact.dart';
import 'package:kopper/providers/BaseProvider.dart';
import 'package:kopper/utils/Exceptions.dart';
import 'package:kopper/config/Constants.dart';
// import 'package:requests/requests.dart';

class UserDataProvider extends BaseUserDataProvider {
  final fireStoreDb = Firestore.instance;

  @override
  Future<User> saveDetails(User user) async {

    return User(); // create a user object and return
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
    // final response = await Requests.get(Urls.getContacts());

    List<Contact> contactList = List();

    return contactList;
  }

  @override
  Future<void> addContact(String username) async {
    await getUser(username);
    //create a node with the username provided in the contacts collection
    DocumentReference ref = fireStoreDb
        .collection(Paths.usersPath)
        .document(SharedObjects.prefs.get(Constants.sessionId));
    //await to fetch user details of the username provided and set data
    var documentSnapshot = await ref.get();
    print(documentSnapshot.data);
    List<String> contacts = documentSnapshot.data['contacts'] != null
        ? List.from(documentSnapshot.data['contacts'])
        : List();
    if (contacts.contains(username)) {
      throw ContactAlreadyExistsException();
    }
    contacts.add(username);
    ref.updateData({'contacts': contacts});
  }

  @override
  Future<User> getUser(String username) async {
    String uid = await getUidByUsername(username);


    if (uid  == "-1") {
      return User();
    } else {
      throw UserNotFoundException();
    }
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
