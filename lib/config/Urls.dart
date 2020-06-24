class Urls {
  static const String port = '5000';

  // In AVD, 10.0.2.2 is mapped to 127.0.0.1 of the host
  static const String address = "http://10.0.2.2" + ":" + port + '/';

  // Get requests
  static const String getUsers = address + "users";
  static String getContacts(int userId) {
    return address + "users/" + userId.toString() + "/" + "contacts";
  }

  // Post requests
  static const String register = address + "users/" + "register";
  static const String login = address + "users/" + "authenticate";
  static String postContacts(int userId) {
    return address + "users/" + userId.toString() + "/" + "contacts";
  }

  // authorization
  static const authenticationPrefix = "Bearer ";
  static String token = "";
  static String getToken() => authenticationPrefix + token;
}