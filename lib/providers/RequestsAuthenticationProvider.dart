import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'BaseProvider.dart';

import 'package:kopper/config/Urls.dart';
import 'package:requests/requests.dart';
import 'package:kopper/models/User.dart';

class RequestsAuthenticationProvider extends BaseAuthenticationProvider {
  final secureStorage = FlutterSecureStorage();

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
    print(response.json()['id'] == null);
    print(User.fromJson(response.json()));
    return response.json()['id'] == null
        ? null
        : User.fromJson(response.json());
  }

  @override
  Future<void> logOutUser() async {
    return Future.wait([]); // terminate the session
  }

  @override
  Future<bool> isLoggedIn() async {
    final user = await Requests.get(Urls.getUsers);
    user.raiseForStatus();
    print(user.content());
    return true;
  }

  @override
  Future<User> getCurrentUser() async {
    var user = User();
    user.username = await secureStorage.read(key: "username");
    user.password = await secureStorage.read(key: "password");
    return user;
  }

  @override
  Future<void> saveCurrentUser(User user) async {
    await secureStorage.write(key: "username", value: user.username);
    await secureStorage.write(key: "password", value: user.password);
  }

  @override
  Future<void> deleteCurrentUser() async {
    await secureStorage.delete(key: "username");
    await secureStorage.delete(key: "password");
  }
}
