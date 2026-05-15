import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/event.dart';
import '../pages/CreatEventPage.dart';
import '../pages/EventPage.dart';
import '../pages/profile_page.dart';
import '../pages/schedule_page.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DatabaseReference database = FirebaseDatabase.instance.ref();
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      drawer: _buildDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Event Manager",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Discover & Manage Events",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: database.child("events").onValue,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: CircularProgressIndicator());
          }

          Map<dynamic, dynamic> data = snapshot.data!.snapshot.value as Map;
          List<MapEntry<dynamic, dynamic>> items = data.entries.toList();

          List<Event> events = items.map((item) {
            return Event.fromMap(item.key, item.value);
          }).toList();

          int totalEvents = events.length;
          int totalAttendees = events.fold(0, (sum, e) => sum + e.attendees);
          int totalCapacity = events.fold(0, (sum, e) => sum + e.capacity);
          int activeEvents = events.where((e) => e.progress < 1.0).length;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: const LinearGradient(
                        colors: [Color(0xff3D5AFE), Color(0xff304FFE)],
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Organizer Dashboard",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Manage your events",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _buildStatCard(Icons.calendar_month, totalEvents.toString(), "Events"),
                      const SizedBox(width: 12),
                      _buildStatCard(Icons.people, totalAttendees.toString(), "Attendees"),
                      const SizedBox(width: 12),
                      _buildStatCard(Icons.trending_up, activeEvents.toString(), "Active"),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "My Events",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 16),
                  events.isEmpty
                      ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text("No events created yet"),
                    ),
                  )
                      : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.location_on, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(event.location, style: const TextStyle(fontSize: 12)),
                                  const SizedBox(width: 16),
                                  Icon(Icons.access_time, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(event.time, style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Capacity"),
                                  Text("${event.attendees} / ${event.capacity}"),
                                ],
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: event.progress.clamp(0.0, 1.0),
                                color: event.progress >= 0.9 ? Colors.red : Colors.orange,
                                backgroundColor: Colors.grey.shade300,
                                minHeight: 8,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  // Edit button - Update operation
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => CreateEventPage(
                                              eventId: event.id,
                                              eventData: {
                                                'title': event.title,
                                                'date': event.date,
                                                'time': event.time,
                                                'location': event.location,
                                                'capacity': event.capacity,
                                                'attendees': event.attendees,
                                                'image': event.image,
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.edit, size: 18),
                                      label: const Text("Edit"),
                                      style: OutlinedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Delete button - Delete operation
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () => _confirmDelete(event),
                                      icon: const Icon(Icons.delete, size: 18),
                                      label: const Text("Delete"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff3D5AFE), Color(0xff304FFE)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Event Manager",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Organizer Dashboard",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Color(0xff3D5AFE)),
            title: const Text("Events"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const EventPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month, color: Color(0xff3D5AFE)),
            title: const Text("Schedule"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ScheduleScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.dashboard, color: Color(0xff3D5AFE)),
            title: const Text("Dashboard"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Color(0xff3D5AFE)),
            title: const Text("Profile"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      selectedItemColor: const Color(0xff3D5AFE),
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const EventPage()),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ScheduleScreen()),
            );
            break;
          case 2:
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            );
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Events"),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: "Schedule"),
        BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: "Dashboard"),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
      ],
    );
  }

  Widget _buildStatCard(IconData icon, String number, String title) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xff3D5AFE), size: 28),
            const SizedBox(height: 8),
            Text(
              number,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(Event event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Event"),
        content: Text("Are you sure you want to delete '${event.title}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              await database.child("events").child(event.id).remove();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("${event.title} deleted"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}