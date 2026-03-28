//importing necessary libraries and files
import 'dart:io';
import 'dart:math';
import 'User.dart';
import 'Event.dart';
import 'Session.dart';
import 'Registration.dart';
import 'mixins.dart';
import 'enums.dart';

//Defining lists to store events, users, sessions, and registrations
List<Event> events = [];
List<User> users = [];
List<Session> sessions = [];
Map<int, Registration> registrations = {};

void addEvent({
  required String title,
  String location = "Some-location",
  String? date,
  required int organizerId,
}) {

  //Generate event ID randomly
  int id = Random().nextInt(100000);

  events.add(Event(id,organizerId , title,
    date ?? "Not Set", // if date is null use default
    location
  ));

  print("Event added successfully!");
}

//Display a list of all events
void displayEvents() {
  //Check if there is no events
  if (events.isEmpty) {
    print("No events available.");
    return;
  }

  print("\n----- Events List -----");
  print("-----------------------------");
  for (var e in events) {
    print("ID: ${e.eventId} |Organizer ID: ${e.organizerId} |Title: ${e.title} |Lcation: ${e.location} |Date: ${e.date}");
  }
  print("-----------------------------");
}

void searchEvent() {
  stdout.write("Enter Event ID: ");
  int id = int.parse(stdin.readLineSync()!);

  //Search the event by ID
  for (var e in events) {
    if (e.eventId == id) {
      print("Found: ${e.title} at ${e.location}");
      return;
    }
  }
  //If not found display message
  print("Event not found.");
}

void deleteEvent() {
  stdout.write("Enter Event ID to delete: ");
  int id = int.parse(stdin.readLineSync()!);

  // Check if event exists
  if (!events.any((e) => e.eventId == id)) {
    print("Event with ID $id does not exist.");
    return;
  }

  //Is the User sure about deleting the event?
  stdout.write("Are you sure? (y/n): ");
  if (stdin.readLineSync()!.toLowerCase() == 'y') {
    events.removeWhere((e) => e.eventId == id); // remove the event
    print("Deleted successfully.");
  } else {
    print("Deletion cancelled.");
  }
}


void addSession() {
  //Check if any events exist
  if (events.isEmpty) {
    print("No events available. Please add an event first.");
    return;
  }

  //Show available events
  print("Available events:");
  for (var e in events) {
    print("${e.eventId}: ${e.title}");
  }

  //Ask user to choose an event
  stdout.write("Enter Event ID for this session: ");
  int eventId = int.parse(stdin.readLineSync()!);

  //Check if event ID exists
  if (!events.any((e) => e.eventId == eventId)) {
    print("Event ID not found.");
    return;
  }

  //Ask for speaker ID
  stdout.write("Enter Speaker ID: ");
  int speakerId = int.parse(stdin.readLineSync()!);

  //Ask for session details
  stdout.write("Enter session name: ");
  String name = stdin.readLineSync()!;

  stdout.write("Enter session time: ");
  String time = stdin.readLineSync()!;

  stdout.write("Enter session capacity: ");
  int capacity = int.parse(stdin.readLineSync()!);

  //Generate session ID randomly
  int sessionId = Random().nextInt(100000);

  //Add the session
  sessions.add(Session(sessionId, eventId, speakerId, name, time, capacity));

  print("Session '$name' added successfully for Event ID $eventId.");
}

void registerUser() {
  if (sessions.isEmpty) {
    print("No sessions available.");
    return;
  }

  //Ask for user ID
  stdout.write("Enter User ID: ");
  int userId = int.parse(stdin.readLineSync()!);

  //Show sessions
  print("Available sessions:");
  for (var s in sessions) {
    print("${s.sessionId}: ${s.title}");
  }

  //Choose session
  stdout.write("Enter Session ID: ");
  int sessionId = int.parse(stdin.readLineSync()!);

  //Find session
  if (!sessions.any((s) => s.sessionId == sessionId)) {
  print("Session not found.");
  return;
}

  var session = sessions.firstWhere((s) => s.sessionId == sessionId);

  int registeredCount = registrations.length;

  if (session.hasAvailableSeats(session.capacity, registeredCount)) {
    int id = Random().nextInt(100000);

    registrations[id] =
        Registration(id, userId, sessionId, RegistrationStatus.confirmed);

    print("Registration successful.");
  } else {
    print("Session is full.");
  }
}

void showMenu() {
  //Show the menu until user chooses to exit
  while (true) {
    print("\n===== Event Management System =====");
    print("1. Add Event");
    print("2. Display Events");
    print("3. Search Event");
    print("4. Delete Event");
    print("5. Add Session");
    print("6. Register User");
    print("7. Exit");

    try {
      stdout.write("Enter your choice[1-7]: ");
      int choice = int.parse(stdin.readLineSync()!);

      switch (choice) {
        case 1:
          stdout.write("Enter title: ");
          String title = stdin.readLineSync()!;

          stdout.write("Enter event date: ");
          String date = stdin.readLineSync()!;

          stdout.write("Enter event location: ");
          String location = stdin.readLineSync()!;

          stdout.write("Enter organizer ID: ");
          int organizerId = int.parse(stdin.readLineSync()!);

          addEvent(title: title, location: location, date: date , organizerId: organizerId);
          break;

        case 2:
          displayEvents();
          break;

        case 3:
          searchEvent();
          break;

        case 4:
          deleteEvent();
          break;

        case 5:
          addSession();
          break;

        case 6:
          registerUser();
          break;

        case 7:
          print(" Goodbye!");
          return;

        default:
          print(" Invalid choice.");
      }
    } catch (e) {
      print(" Invalid input. Please enter a number.");
    }
  }
}

void main() {
  showMenu();
}
