import 'mixins.dart';

class Session with CapacityMixin  {
  int _sessionId;
  int _eventId;
  int _speakerId;
  String _title;
  String _time;
  int _capacity;

  //Constructor
  Session(this._sessionId, this._eventId, this._speakerId,
      this._title, this._time, this._capacity);

  //Getters
  int get sessionId => _sessionId;
  int get eventId => _eventId;
  int get speakerId => _speakerId;
  String get title => _title;
  String get time => _time;
  int get capacity => _capacity;

  //Setters
  set title(String title) => _title = title;
  set time(String time) => _time = time;
  set capacity(int capacity) => _capacity = capacity;
}
