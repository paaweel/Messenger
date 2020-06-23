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
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        username: json['username'] as String,
        password: json['password'] as String);
  }

  @override
  String toString() {
    return '{ firstName: $firstName, lastName: $lastName, username: $username }';
  }
}
