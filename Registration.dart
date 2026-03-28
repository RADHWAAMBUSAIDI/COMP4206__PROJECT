//Importing enumeration file to be used in the registration class 
import 'enums.dart';

class Registration {
  int _registrationId;
  int _userId;
  int _sessionId;
  RegistrationStatus _status; 

  //Constructor
  Registration(this._registrationId, this._userId, this._sessionId, this._status);

  //Getters
  int get registrationId => _registrationId;
  int get userId => _userId;
  int get sessionId => _sessionId;
  RegistrationStatus get status => _status; 

  //Setters
  set userId(int userId) => _userId = userId;
  set sessionId(int sessionId) => _sessionId = sessionId;
  set status(RegistrationStatus status) => _status = status;
}
