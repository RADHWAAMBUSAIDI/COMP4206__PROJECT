class User {
  int _userId;
  String _name;
  String _email;
  String _role;
  String _location;

  //Constructor
  User(this._userId, this._name, this._email, this._role, this._location);

  //Getters
  int get userId => _userId;
  String get name => _name;
  String get email => _email;
  String get role => _role;
  String get location => _location;

  //Setters
  set name(String name) => _name = name;
  set email(String email) => _email = email;
  set role(String role) => _role = role;
  set location(String location) => _location = location;
}
