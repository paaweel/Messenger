import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'BaseProvider.dart';

import 'package:kopper/config/Urls.dart';
import 'package:requests/requests.dart';
import 'package:kopper/models/User.dart';

class RequestsAuthenticationProvider extends BaseAuthenticationProvider {
  final secureStorage = FlutterSecureStorage();
  User currentUser;

  @override
  Future<User> signIn(User user) async {
    final response = await Requests.post(Urls.register, body: user.toString());
    print(response.content());
    return user;
  }

  @override
  Future<User> logIn(String username, String password) async {
    final response = await Requests.post(
      Urls.login,
      body: {"username": username, "password": password},
      bodyEncoding: RequestBodyEncoding.JSON,
    );
    print(response.json());
    dynamic json = response.json();
    Urls.token = response.success ? json['token'] : "";
    return !response.success ? null : currentUser = User.fromJson(json);
  }

  @override
  Future<void> logOutUser() async {
    return deleteCurrentUser();
  }

  @override
  Future<bool> isLoggedIn() async {
    if (getCurrentUser() == null) {
      return false;
    } else if (Urls.token == "") {
      currentUser = currentUser.token == ""
          ? await logIn(currentUser.username, currentUser.password)
          : currentUser.token;
      Urls.token = currentUser.token;
    }
    return true;
  }

  @override
  Future<User> getCurrentUser() async {
    return currentUser != null
        ? currentUser
        : await secureStorage.read(key: "username") != null
            ? currentUser = await readCurrentUser()
            : null;
  }

  Future<User> readCurrentUser() async {
    return User(
        firstName: await secureStorage.read(key: "firstname"),
        lastName: await secureStorage.read(key: "lastname"),
        username: await secureStorage.read(key: "username"),
        password: await secureStorage.read(key: "password"));
  }

  @override
  Future<void> saveCurrentUser(User user) async {
    await secureStorage.write(key: "username", value: user.username);
    await secureStorage.write(key: "password", value: user.password);
    await secureStorage.write(key: "username", value: user.firstName);
    await secureStorage.write(key: "password", value: user.lastName);
  }

  @override
  Future<void> deleteCurrentUser() async {
    await secureStorage.delete(key: "username");
    await secureStorage.delete(key: "password");
    await secureStorage.delete(key: "firstname");
    await secureStorage.delete(key: "lastname");
  }
}
