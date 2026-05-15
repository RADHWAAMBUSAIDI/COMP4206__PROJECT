import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key, this.eventId, this.eventData});
  final String? eventId;
  final Map<dynamic, dynamic>? eventData;

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseReference database = FirebaseDatabase.instance.ref();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    if (widget.eventId != null && widget.eventData != null) {
      _isEditMode = true;
      titleController.text = widget.eventData!['title'] ?? '';
      dateController.text = widget.eventData!['date'] ?? '';
      timeController.text = widget.eventData!['time'] ?? '';
      locationController.text = widget.eventData!['location'] ?? '';
      capacityController.text = widget.eventData!['capacity']?.toString() ?? '';
      imageController.text = widget.eventData!['image'] ?? 'assets/images/logo.png';
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    dateController.dispose();
    timeController.dispose();
    locationController.dispose();
    capacityController.dispose();
    imageController.dispose();
    super.dispose();
  }

  void _saveEvent() async {
    if (_formKey.currentState!.validate()) {
      int capacity = int.tryParse(capacityController.text) ?? 0;

      Map<String, dynamic> eventData = {
        "title": titleController.text,
        "date": dateController.text,
        "time": timeController.text,
        "location": locationController.text,
        "attendees": _isEditMode ? (widget.eventData!['attendees'] ?? 0) : 0,
        "capacity": capacity,
        "image": imageController.text.isNotEmpty ? imageController.text : 'assets/images/logo.png',
      };

      if (_isEditMode) {
        await database.child("events").child(widget.eventId!).update(eventData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Event Updated Successfully")),
        );
      } else {
        await database.child("events").push().set(eventData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Event Created Successfully")),
        );
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          _isEditMode ? "Edit Event" : "Create Event",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Event Details",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _buildTextField(
                        label: "Event Title",
                        hint: "Tech Summit 2026",
                        controller: titleController,
                        icon: Icons.event,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: "Date",
                        hint: "Apr 15, 2026",
                        controller: dateController,
                        icon: Icons.calendar_today,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: "Time",
                        hint: "15:30",
                        controller: timeController,
                        icon: Icons.access_time,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: "Location",
                        hint: "SQU, Muscat",
                        controller: locationController,
                        icon: Icons.location_on,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: "Capacity",
                        hint: "300",
                        controller: capacityController,
                        icon: Icons.groups,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: "Image Path",
                        hint: "assets/images/logo.png",
                        controller: imageController,
                        icon: Icons.image,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: const BorderSide(color: Colors.red),
                        ),
                        child: const Text("Cancel", style: TextStyle(color: Colors.red)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _saveEvent,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff3D5AFE),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _isEditMode ? "Update Event" : "Create Event",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xff3D5AFE)),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return "Required field";
            if (label == "Capacity") {
              if (int.tryParse(value) == null) return "Enter a valid number";
            }
            return null;
          },
        ),
      ],
    );
  }
}