class User {
  String id;
  String name;
  String email;
  String role;
  int age;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.age,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "role": role,
      "age": age,
    };
  }

  factory User.fromMap(String id, Map<dynamic, dynamic> map) {
    return User(
      id: id,
      name: map["name"] ?? "",
      email: map["email"] ?? "",
      role: map["role"] ?? "Attendee",
      age: map["age"] ?? 18,
    );
  }
}