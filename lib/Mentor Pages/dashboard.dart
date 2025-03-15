import 'package:cetmock/Mentor%20Pages/activecourses.dart';
import '../Mentor%20Pages/Create%20Course%20Page.dart';
import '../Mentor%20Pages/Manage%20Courses%20Page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import the CreateCoursePage

class MentorDashboard extends StatelessWidget {
  const MentorDashboard({super.key});

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login'); // Adjust route as needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          child: AppBar(
            title: Center(
              child: Text(
                "Mentor Dashboard",
                style: TextStyle(fontSize: 20), // Optional: Adjust text size
              ),
            ),
            backgroundColor: const Color.fromARGB(255, 43, 171, 251),
            elevation: 4.0,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: () => _logout(context),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: Colors.grey[50], // Soft light background color
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              const Text(
                'Welcome, Mentor!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal, // Consistent with the app bar
                ),
              ),
              const SizedBox(height: 40),
              _buildResponsiveButton(
                context,
                'Create Courses',
                Colors.teal.shade100,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateCoursePage()),
                  );
                },
              ),
              const SizedBox(height: 15),
              _buildResponsiveButton(
                context,
                'Manage Courses',
                Colors.blue.shade100,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ManageCoursesPage()),
                  );
                },
              ),
              const SizedBox(height: 15),
              _buildResponsiveButton(
                context,
                'Active Courses',
                Colors.pink.shade100,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ActiveCoursesPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to build buttons
  Widget _buildResponsiveButton(
    BuildContext context,
    String title,
    Color color,
    VoidCallback onPressed,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color, // Different color for each button
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0), // Rounded corners
          ),
          padding: EdgeInsets.symmetric(vertical: 14),
          minimumSize: Size(
            MediaQuery.of(context).size.width * 0.8, // 80% width of screen
            50, // Fixed height
          ),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
