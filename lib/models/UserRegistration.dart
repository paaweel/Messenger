class UserRegistration{
  String firstName;
  String lastName;
  String username;
  String password;
  String photoUrl;

  UserRegistration({this.firstName, this.lastName, this.username, this.password, this.photoUrl});

  factory UserRegistration.fromJson(Map<String, dynamic> json) {
    return UserRegistration(
        firstName: json['FirstName'] as String,
        lastName: json['LastName'] as String,
        username: json['Username'] as String,
        password: json['Password'] as String
    );
  }

  @override
  String toString() {
    return '{ FirstName: $firstName, LastName: $lastName, Username: $username }';
  }
}