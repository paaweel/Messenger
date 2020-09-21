class User {
  String token;
  int id;
  String firstName;
  String lastName;
  String username;
  String password;
  String photoUrl;

  User(
      {this.token = "",
      this.id,
      this.firstName,
      this.lastName,
      this.username,
      this.password,
      this.photoUrl = ""});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'] as int,
        token: json['token'] as String,
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        username: json['username'] as String,
        password: json['password'] as String);
  }

  @override
  String toString() {
    return '{ firstName: $firstName, lastName: $lastName, username: $username }';
  }

  String registrationString() {
    return '{username: $username, password: $password, FirstName: $firstName, LastName: $lastName}';
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();

    map['Username'] = username;
    map['Password'] = password;
    map['FirstName'] = firstName;
    map['LastName'] = lastName;
    return map;
  }
}
