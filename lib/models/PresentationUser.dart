import 'Contact.dart';

class PresentationUser {
  String firstName;
  String lastName;
  String username;
  String photoUrl;

  PresentationUser(
      {this.firstName, this.lastName, this.username, this.photoUrl = ""});

  factory PresentationUser.fromContact(Contact contact) {
    return PresentationUser(
        firstName: contact.firstName,
        lastName: contact.lastName,
        username: contact.username);
  }

  String name() {
    return firstName + " " + lastName;
  }

  @override
  String toString() {
    return '{ firstName: $firstName, lastName: $lastName, username: $username }';
  }
}
