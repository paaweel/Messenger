class Contact {
  String username;
  String name;
  String lastName;

  Contact({this.username, this.name});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
        name: json['firstName'] as String,
        username: json['username'] as String);
  }

  @override
  String toString() {
    return '{ name: $name, username: $username}';
  }

  String getFirstName() => name;

  String getLastName() => "Wykopek";
}
