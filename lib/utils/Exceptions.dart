
abstract class KopperException implements Exception{
  String errorMessage();
}

class UserNotFoundException extends KopperException{
  @override
  String errorMessage() => 'No user found for provided uid/username';
}

class UsernameMappingUndefinedException extends KopperException{
  @override
  String errorMessage() =>'User not found';
}

class ContactAlreadyExistsException extends KopperException{
  @override
  String errorMessage() => 'Contact already exists!';
}

class ContactUnableToAddCurrent extends KopperException{
  @override
  String errorMessage() => 'Unable to add current user as contact!';
}
