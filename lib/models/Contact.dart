class Contact {
  String username;
  String name;
  int conversationId;
  String lastName;

  Contact({this.username, this.name, this.conversationId});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
        name: json['firstName'] as String,
        conversationId: json['conversationID'] as int,
        username: json['username'] as String);
  }

  @override
  String toString() {
    return '{ name: $name, username: $username}';
  }

  String getFirstName() => name;

  String getLastName() => "";
}
