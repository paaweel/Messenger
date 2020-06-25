
part of "ContactsBloc.dart";

@immutable
abstract class ContactsEvent extends Equatable {
  ContactsEvent([List props = const <dynamic>[]]) : super(props);
}

class FetchContactsEvent extends ContactsEvent{
  @override
  String toString() => 'FetchContactsEvent';
}

class AddContactEvent extends ContactsEvent {
  final String username;
  AddContactEvent({@required this.username});
  @override
  String toString() => 'AddContactEvent';
}

class ClickedContactEvent extends ContactsEvent {
  final Contact contact;
  ClickedContactEvent(this.contact): super([contact]);
  @override
  String toString() => 'ClickedContactEvent';
}