class Urls {
  static const String port = '5000';

  // In AVD, 10.0.2.2 is mapped to 127.0.0.1 of the host
  static const String address = "http://10.0.2.2" + ":" + port + '/';

  // Get requests
  static const String getUsers = address + "users";

  // Post requests
  static const String register = address + "users/" + "register";
  static const String login = address + "users/" + "authenticate";
}