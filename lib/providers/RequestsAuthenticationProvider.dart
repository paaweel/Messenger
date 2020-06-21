import 'BaseProvider.dart';

import 'package:kopper/config/Urls.dart';
import 'package:requests/requests.dart';
import 'package:kopper/models/User.dart';

class RequestsAuthenticationProvider extends BaseAuthenticationProvider {

  @override
  Future<User> signIn(User user) async {
    final response = await Requests.post(Urls.register, body: user.toString());
    print (response.content());
    return user;
  }

  @override
  Future<User> logIn(String username, String password) async {
    final response = await Requests.post(Urls.login, body: {
      "username" : username,
      "password" : password
    },
    bodyEncoding: RequestBodyEncoding.JSON,
    );
    print (response.json());
    print(response.json()['id'] == null);
    print(User.fromJson(response.json()));
    return response.json()['id'] == null? null : User.fromJson(response.json());
  }

  @override
  Future<void> logOutUser() async {
    return Future.wait([]); // terminate the session
  }

  @override
  Future<User> getCurrentUser() async {
    return null; //retrieve the current user
  }

  @override
  Future<bool> isLoggedIn() async {
    final user = await Requests.get(Urls.getUsers);
    user.raiseForStatus();
    print(user.content());
    return true;
  }
}