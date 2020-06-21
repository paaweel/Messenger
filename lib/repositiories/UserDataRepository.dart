import 'package:firebase_auth/firebase_auth.dart';
import 'package:kopper/models/User.dart';
import 'package:kopper/providers/BaseProvider.dart';
import 'package:kopper/providers/UserDataProvider.dart';

// Interacts with database, saves user data
class UserDataRepository {
  BaseUserDataProvider userDataProvider = UserDataProvider();

  Future<User> saveDetailsFromGoogleAuth(User user) =>
      userDataProvider.saveDetailsFromGoogleAuth(user);

  Future<User> saveProfileDetails(String username, String profileImageUrl) =>
      userDataProvider.saveProfileDetails(username, profileImageUrl);

  Future<bool> isProfileComplete(String uid) =>
      userDataProvider.isProfileComplete(uid);
}