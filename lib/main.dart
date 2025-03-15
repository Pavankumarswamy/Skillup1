import 'package:cetmock/General%20User%20Pages/certificates.dart';
import 'package:cetmock/General%20User%20Pages/logout.dart';
import 'package:cetmock/General%20User%20Pages/settings.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../General%20User%20Pages/userdash.dart';
import '../auth/login.dart';
import 'wrapper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase Core
import 'package:flutter/foundation.dart'; // For kIsWeb

const supabaseUrl = 'https://vduoxfcddksibwrpiuqd.supabase.co';
const supabaseKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZkdW94ZmNkZGtzaWJ3cnBpdXFkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzkxOTY4MjAsImV4cCI6MjA1NDc3MjgyMH0.GPLhjbM1JJ1_Hk6AqyRnvirFaW3bpkG91YMZ0qhGhpQ';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  // Initialize Firebase
  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          //firebase options
            
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
    debugPrint("Firebase initialized successfully!");
  } catch (e) {
    debugPrint("Error initializing Firebase: $e");
  }

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove debug banner
      title: 'Skill Up', // App name
      theme: ThemeData(
        primarySwatch: Colors.blue, // Default theme color
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/', // Initial route set to Wrapper
      routes: {
        '/': (context) => const Wrapper(), // Wrapper for authentication state
        '/login': (context) => const LoginPage(), // Login page
        '/home': (context) => UserDashboardPage(),
        '/settings': (context) => SettingsPage(),
        '/logout': (context) => LogoutPage(),
        '/wrapper': (context) => Wrapper(),
        'certificate': (context) => CertificatesPage(), // Home screen
      },
    );
  }
}
