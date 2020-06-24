import 'dart:async';
import 'package:kopper/models/Contact.dart';
import 'package:kopper/repositories/UserDataRepository.dart';
import 'package:kopper/utils/Exceptions.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'ContactsEvents.dart';
part 'ContactsStates.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  UserDataRepository userDataRepository;

  ContactsBloc({this.userDataRepository}) : assert(userDataRepository != null);

  @override
  ContactsState get initialState => InitialContactsState();

  @override
  Stream<ContactsState> mapEventToState(
      ContactsEvent event,
      ) async* {
    if (event is FetchContactsEvent) {
      yield* mapFetchContactsEventToState();
    } else if (event is AddContactEvent) {
      yield* mapAddContactEventToState(event.username);
    } else if (event is ClickedContactEvent) {
      yield* mapClickedContactEventToState();
    }

  }

  Stream<ContactsState> mapFetchContactsEventToState() async* {
    try {
      yield FetchingContactsState();
      List<Contact> contacts = await userDataRepository.getContacts();
      yield FetchedContactsState(contacts);
    } on KopperException catch(exception){
      print(exception.errorMessage());
      yield ErrorState(exception);
    }
  }

  Stream<ContactsState> mapAddContactEventToState(String username) async* {
    try {
      yield AddContactProgressState();
      await userDataRepository.addContact(username);
      add(FetchContactsEvent());
      yield AddContactSuccessState();
    } on KopperException catch(exception){
      print(exception.errorMessage());
      yield AddContactFailedState(exception);
    }
  }

  Stream<ContactsState> mapClickedContactEventToState() async* {
    //TODO: Redirect to chat screen
  }
}