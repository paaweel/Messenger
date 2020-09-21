import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:kopper/repositories/AuthenticationRepository.dart';
import 'package:kopper/repositories/UserDataRepository.dart';
import 'package:kopper/repositories/StorageRepository.dart';
import 'package:kopper/config/Paths.dart';
import 'package:kopper/models/User.dart';

part 'AuthenticationEvent.dart';
part 'AuthenticationState.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository authenticationRepository;
  final UserDataRepository userDataRepository;
  final StorageRepository storageRepository;

  AuthenticationBloc(
      {this.authenticationRepository,
      this.userDataRepository,
      this.storageRepository})
      : assert(authenticationRepository != null),
        assert(userDataRepository != null),
        assert(storageRepository != null);

  @override
  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    print(event);
    if (event is AppLaunched) {
      yield* mapAppLaunchedToState();
    } else if (event is ClickedRegister) {
      yield* mapClickedRegisterToState(event.user);
    } else if (event is ClickedLogin) {
      print(event.username + event.password);
      yield* mapClickedLoginToState(event.username, event.password);
    } else if (event is LoggedIn) {
      yield* mapLoggedInToState(event.user);
    } else if (event is PickedProfilePicture) {
      yield ReceivedProfilePicture(event.file);
    } else if (event is SaveProfile) {
      yield* mapSaveProfileToState(
          event.profileImage, event.age, event.username);
    } else if (event is ClickedLogout) {
      yield* mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> mapAppLaunchedToState() async* {
    try {
      yield AuthInProgress(); //show the progress bar
      final isSignedIn = await authenticationRepository
          .isLoggedIn(); // check if user is signed in
      if (isSignedIn) {
        final user = await authenticationRepository.getCurrentUser();
        yield Authenticated(
            user); // else yield the authenticated state and redirect to profile page to complete profile.
        add(LoggedIn(
            user)); // also disptach a login event so that the data from gauth can be prefilled
      } else {
        yield UnAuthenticated(); // is not signed in then show the home page
      }
    } catch (_, stacktrace) {
      print(stacktrace);
      yield UnAuthenticated();
    }
  }

  Stream<AuthenticationState> mapClickedRegisterToState(User user) async* {
    yield AuthInProgress(); //show progress bar
    try {
      User registeredUser = await authenticationRepository.signIn(user);
      if (registeredUser == null) {
        yield UnAuthenticated();
      } else {
        User authenticatedUser =
            await authenticationRepository.logIn(user.username, user.password);

        if (authenticatedUser == null) {
          yield UnAuthenticated();
        } else {
          yield Authenticated(
              registeredUser); // else yield the authenticated state and redirect to profile page to complete profile.
          add(LoggedIn(
              registeredUser)); // also dispatch a login event so that the data from gauth can be prefilled
        }
      }
    } catch (_, stacktrace) {
      print(stacktrace);
      yield UnAuthenticated(); // in case of error go back to first registration page
    }
  }

  Stream<AuthenticationState> mapClickedLoginToState(
      String username, String password) async* {
    yield AuthInProgress(); //show progress bar
    try {
      User authenticatedUser =
          await authenticationRepository.logIn(username, password);
      if (authenticatedUser == null)
        yield UnAuthenticated();
      else {
        yield Authenticated(authenticatedUser);
        yield ProfileUpdated();
        add(LoggedIn(authenticatedUser));
      }
    } catch (_, stacktrace) {
      print(stacktrace);
      yield UnAuthenticated(); // in case of error go back to first registration page
    }
  }

  Stream<AuthenticationState> mapLoggedInToState(User user) async* {
    yield ProfileUpdated(); // shows progress bar
  }

  Stream<AuthenticationState> mapSaveProfileToState(
      File profileImage, int age, String username) async* {
    yield ProfileUpdateInProgress(); // shows progress bar
    String profilePictureUrl = await storageRepository.uploadImage(profileImage,
        Paths.profilePicturePath); // upload image to firebase storage
    User user = await authenticationRepository
        .getCurrentUser(); // retrieve user from firebase
    await userDataRepository.saveProfileDetails(
        user.username, user.photoUrl); // save profile details to firestore
    yield ProfileUpdated(); //redirect to home page
  }

  Stream<AuthenticationState> mapLoggedOutToState() async* {
    yield UnAuthenticated(); // redirect to login page
    authenticationRepository.signOutUser(); // terminate session
  }
}
