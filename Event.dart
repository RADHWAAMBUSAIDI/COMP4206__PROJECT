class Event {
  int _eventId;
  int _organizerId;
  String _title;
  String _date;
  String _location;

  // Constructor
  Event(this._eventId, this._organizerId, this._title, this._date, this._location);

  // Getters
  int get eventId => _eventId;
  int get organizerId => _organizerId;
  String get title => _title;
  String get date => _date;
  String get location => _location;

  // Setters
  set title(String title) => _title = title;
  set date(String date) => _date = date;
  set location(String location) => _location = location;
}
