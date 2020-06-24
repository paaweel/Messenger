import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  String username;
  String name;

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


  String getFirstName() => name.split(' ')[0];

  String getLastName(){
    List names = name.split(' ');
    return names.length>1?names[1]:'';
  }
}