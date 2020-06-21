import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kopper/models/User.dart';

abstract class BaseAuthenticationProvider{
  Future<User> signIn(User user);
  Future<User> logIn(String username, String password);
  Future<void> logOutUser();
  Future<User> getCurrentUser();
  Future<bool> isLoggedIn();
}

abstract class BaseUserDataProvider{
  Future<User> saveDetailsFromGoogleAuth(User user);
  Future<User> saveProfileDetails(String username, String profileImageUrl);
  Future<bool> isProfileComplete(String uid);
}

abstract class BaseStorageProvider{
  Future<String> uploadImage(File file, String path);
} 