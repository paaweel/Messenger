import 'package:kopper/models/User.dart';
import 'package:kopper/providers/RequestsAuthenticationProvider.dart';
import 'package:kopper/providers/BaseProvider.dart';

// Responsible for creating users and retrieving their information
class AuthenticationRepository {
  BaseAuthenticationProvider authenticationProvider = RequestsAuthenticationProvider();

  Future<User> signIn(User user) =>
      authenticationProvider.signIn(user);

  Future<User> logIn(String username, String password) =>
      authenticationProvider.logIn(username, password);

  Future<void> signOutUser() => authenticationProvider.logOutUser();

  Future<User> getCurrentUser() =>
      authenticationProvider.getCurrentUser();

  Future<bool> isLoggedIn() => authenticationProvider.isLoggedIn();
}