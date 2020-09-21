import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kopper/utils/SharedObjects.dart';

import 'BaseProvider.dart';

import 'package:kopper/config/Urls.dart';
import 'package:requests/requests.dart';
import 'package:kopper/models/User.dart';
import 'dart:convert';

class RequestsAuthenticationProvider extends BaseAuthenticationProvider {
  User _currentUser;
  final _storage = FlutterSecureStorage();

  @override
  Future<User> signIn(User user) async {
    print(Urls.register);
    final response = await Requests.post(Urls.register,
        body: {
          "username": user.username,
          "password": user.password,
          "LastName": user.lastName,
          "FirstName": user.firstName
        },
        bodyEncoding: RequestBodyEncoding.JSON);
    print(response.content());

    if (response.hasError) {
      return null;
    }

    return user;
  }

  @override
  Future<User> logIn(String username, String password) async {
    _currentUser = null;

    final response = await Requests.post(
      Urls.login,
      body: {"username": username, "password": password},
      bodyEncoding: RequestBodyEncoding.JSON,
    );
    print(response.json());
    dynamic json = response.json();

    if (response.success) {
      Urls.token = json['token'];
      SharedObjects.userId = json['id'];
      SharedObjects.username = username;
      _currentUser = User.fromJson(json);
      _currentUser.password = password;
      saveCurrentUser(_currentUser);
    }

    return _currentUser;
  }

  @override
  Future<void> logOutUser() async {
    return deleteCurrentUser();
  }

  @override
  Future<bool> isLoggedIn() async {
    if (_currentUser == null) {
      //check storage
      User user = await readCurrentUser();
      if (user != null && user.id != null) {
        //authenticate
        _currentUser = await logIn(user.username, user.password);
      }
      return _currentUser != null && _currentUser.token != null;
    } else {
      return true;
    }
  }

  @override
  Future<User> getCurrentUser() async {
    return _currentUser;
  }

  Future<User> readCurrentUser() async {
    var idString = await _storage.read(key: "id");
    if (idString == null) {
      return null;
    } else
      return User(
          id: int.parse(idString),
          firstName: await _storage.read(key: "firstname"),
          lastName: await _storage.read(key: "lastname"),
          username: await _storage.read(key: "username"),
          password: await _storage.read(key: "password"));
  }

  @override
  Future<void> saveCurrentUser(User user) async {
    await _storage.write(key: "id", value: user.id.toString());
    await _storage.write(key: "username", value: user.username);
    await _storage.write(key: "password", value: user.password);
    await _storage.write(key: "firstname", value: user.firstName);
    await _storage.write(key: "lastname", value: user.lastName);
  }

  @override
  Future<void> deleteCurrentUser() async {
    await _storage.delete(key: "id");
    await _storage.delete(key: "username");
    await _storage.delete(key: "password");
    await _storage.delete(key: "firstname");
    await _storage.delete(key: "lastname");
  }
}
