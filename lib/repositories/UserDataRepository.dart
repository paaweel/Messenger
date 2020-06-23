import 'package:kopper/models/User.dart';
import 'package:kopper/providers/BaseProvider.dart';
import 'package:kopper/providers/UserDataProvider.dart';
import 'package:kopper/models/Contact.dart';

// Interacts with database, saves user data
class UserDataRepository {
  BaseUserDataProvider userDataProvider = UserDataProvider();

  Future<User> saveDetails(User user) =>
      userDataProvider.saveDetails(user);

  Future<bool> isProfileComplete() =>
      userDataProvider.isProfileComplete();

  Future<List<Contact>> getContacts() =>
      userDataProvider.getContacts();

  Future<void> addContact(String username) =>
      userDataProvider.addContact(username);

  Future<User> saveProfileDetails(String username, String profileImageUrl) =>
      userDataProvider.saveProfileDetails(username, profileImageUrl);

  Future<User> getUser(String username) => userDataProvider.getUser(username);
}