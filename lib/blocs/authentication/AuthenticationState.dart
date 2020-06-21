part of 'AuthenticationBloc.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  AuthenticationState([List props = const <dynamic>[]]) : super(props);
}

class Uninitialized extends AuthenticationState{
  @override
  String toString() => 'Uninitialized';
}

class AuthInProgress extends AuthenticationState{
  @override
  String toString() => 'AuthInProgress';
}

class Authenticated extends AuthenticationState{
  final User user;
  Authenticated(this.user);
  @override
  String toString() => 'Authenticated';
}

class UnAuthenticated extends AuthenticationState{
  @override
  String toString() => 'UnAuthenticated';
}

class ReceivedProfilePicture extends AuthenticationState{
  final File file;
  ReceivedProfilePicture(this.file);
  @override toString() => 'ReceivedProfilePicture';
}

class ProfileUpdateInProgress extends AuthenticationState{
  @override
  String toString() => 'ProfileUpdateInProgress';
}

class ProfileUpdated extends AuthenticationState{
  @override
  String toString() => 'ProfileComplete';
}