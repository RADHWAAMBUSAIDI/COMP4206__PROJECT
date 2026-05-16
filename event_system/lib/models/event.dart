class Event {
  final String id;
  final String title;
  final String date;
  final String time;
  final String location;
  final int attendees;
  final int capacity;
  final String image;

  Event({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.attendees,
    required this.capacity,
    required this.image,
  });

  double get progress {
    if (capacity == 0) return 0;
    return attendees / capacity;
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "date": date,
      "time": time,
      "location": location,
      "attendees": attendees,
      "capacity": capacity,
      "image": image,
    };
  }

  factory Event.fromMap(String id, Map<dynamic, dynamic> data) {
    return Event(
      id: id,
      title: data["title"] ?? "",
      date: data["date"] ?? "",
      time: data["time"] ?? "",
      location: data["location"] ?? "",
      attendees: data["attendees"] is int ? data["attendees"] : (data["attendees"] ?? 0),
      capacity: data["capacity"] is int ? data["capacity"] : (data["capacity"] ?? 0),
      image: data["image"] ?? "assets/images/logo.png",
    );
  }
}