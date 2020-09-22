class Urls {
  static const String port = '5000';
  // In AVD, 10.0.2.2 is mapped to 127.0.0.1 of the host
  static const String host = "http://10.0.2.2";
  static const String address = host + ":" + port;

  static const String userPrefix = "/users";
  // Contacts
  static const String getUsers = address + userPrefix;
  static String getContacts(int userId) =>
      address + userPrefix + "/" + userId.toString() + "/contacts";

  static String getMessages(int userId, String username) =>
      address + userPrefix + "/" + userId.toString() + "/contacts/" + username;

  // Login/Sign-in
  static const String register = address + userPrefix + "/register";
  static const String login = address + userPrefix + "/authenticate";
  static String postContacts(int userId) =>
      address + userPrefix + "/" + userId.toString() + "/contacts";

  // Authorization
  static const authenticationPrefix = "Bearer ";
  static String token = "";
  static String getToken() => authenticationPrefix + token;
}
