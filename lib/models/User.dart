class User{
  String firstName;
  String lastName;
  String username;
  String password;
  String photoUrl;

  User({this.firstName, this.lastName, this.username, this.password, this.photoUrl});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        username: json['username'] as String,
        password: json['password'] as String
    );
  }
  
  @override
  String toString() {
   return '{ firstName: $firstName, lastName: $lastName, username: $username }';
  }
} 