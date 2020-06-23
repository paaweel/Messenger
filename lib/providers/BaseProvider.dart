import 'dart:io';

import 'package:kopper/models/User.dart';
import 'package:kopper/models/Contact.dart';

abstract class BaseAuthenticationProvider{
  Future<User> signIn(User user);
  Future<User> logIn(String username, String password);
  Future<void> logOutUser();
  Future<User> getCurrentUser();
  Future<bool> isLoggedIn();
  Future<void> saveCurrentUser(User user);
  Future<void> deleteCurrentUser();
}

abstract class BaseUserDataProvider{
  Future<User> saveDetails(User user);
  Future<User> saveProfileDetails(String username, String profileImageUrl);
  Future<bool> isProfileComplete();
  Future<List<Contact>> getContacts();
  Future<void> addContact(String username);
  Future<User> getUser(String username);
  Future<String> getUidByUsername(String username);
}

abstract class BaseStorageProvider{
  Future<String> uploadImage(File file, String path);
} 