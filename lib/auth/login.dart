// import 'package:cetmock/admin%20screens/dashboard%20admin.dart';
// import 'package:cetmock/customloader.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import '../auth/auth.dart';
// import '../auth/signup.dart';
// import '../auth/forgot.dart';
// import '../Mentor%20Pages/dashboard.dart';
// import '../General%20User%20Pages/userdash.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final AuthService _authService = AuthService();
//   bool _isLoading = false;
//   bool _isPasswordVisible = false;
//   void _login() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       String email = _emailController.text.trim();
//       String password = _passwordController.text.trim();

//       // Authenticate user
//       User? user = await _authService.login(email, password);

//       if (user != null) {
//         String uid = user.uid;

//         // Check if the user is already logged in on another device
//         DatabaseReference sessionRef =
//             FirebaseDatabase.instance.ref("users/$uid/session");
//         final sessionSnapshot = await sessionRef.get();

//         if (sessionSnapshot.exists) {
//           _showSnackbar("You are already logged in on another device.");
//           setState(() {
//             _isLoading = false;
//           });
//           return;
//         }

//         // Store session (new login)
//         await sessionRef
//             .set({"active": true, "timestamp": ServerValue.timestamp});

//         // Fetch user role
//         String? role = await _getUserRole(uid);

//         if (role != null) {
//           if (mounted) {
//             switch (role) {
//               case "mentor":
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const MentorDashboard()),
//                 );
//                 break;
//               case "admin":
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => AdminCoursesPage()),
//                 );
//                 break;
//               case "user":
//               default:
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => UserDashboardPage()),
//                 );
//                 break;
//             }
//           }
//         } else {
//           _showSnackbar("Failed to fetch user role. Try again.");
//         }
//       }
//     } on FirebaseAuthException catch (e) {
//       String errorMessage = "Login failed";
//       if (e.code == 'user-not-found') {
//         errorMessage = "No user found with this email.";
//       } else if (e.code == 'wrong-password') {
//         errorMessage = "Incorrect password. Please try again.";
//       }
//       _showSnackbar(errorMessage);
//     } catch (e) {
//       _showSnackbar("An unexpected error occurred: ${e.toString()}");
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Future<String?> _getUserRole(String uid) async {
//     try {
//       DatabaseReference userRef =
//           FirebaseDatabase.instance.ref("users/$uid/role");
//       final snapshot = await userRef.get();
//       if (snapshot.exists) {
//         return snapshot.value as String?;
//       }
//     } catch (e) {
//       debugPrint("Error fetching role: $e");
//     }
//     return null;
//   }

//   void _showSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromRGBO(28, 156, 231, 1),
//       body: Center(
//         child: Container(
//           width: 300,
//           padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
//           decoration: BoxDecoration(
//             color: const Color(0xFFE3E3E3),
//             borderRadius: BorderRadius.circular(8),
//             boxShadow: const [
//               BoxShadow(
//                 color: Color.fromRGBO(45, 48, 49, 0.493),
//                 offset: Offset(16, 16),
//                 blurRadius: 32,
//               ),
//               BoxShadow(
//                 color: Color.fromRGBO(33, 37, 39, 0),
//                 offset: Offset(-16, -16),
//                 blurRadius: 32,
//               ),
//             ],
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text(
//                 'Log in',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   letterSpacing: 2,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               _buildInputField(controller: _emailController, label: 'E-mail'),
//               const SizedBox(height: 20),
//               _buildInputField(
//                 controller: _passwordController,
//                 label: 'Password',
//                 obscureText: true,
//                 isPasswordField: true,
//               ),
//               const SizedBox(height: 10),
//               TextButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const ForgotPasswordPage()),
//                   );
//                 },
//                 child: const Text(
//                   "Forgot Password?",
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 12,
//                     decoration: TextDecoration.underline,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.transparent,
//                   foregroundColor: Colors.black,
//                   shadowColor: Colors.transparent,
//                   side: const BorderSide(color: Colors.black, width: 2),
//                   textStyle: const TextStyle(
//                     fontSize: 10,
//                     letterSpacing: 2,
//                   ),
//                 ),
//                 onPressed: _isLoading ? null : _login,
//                 child: _isLoading
//                     ? Center(child: CustomSpinner())
//                     : const Text('Enter'),
//               ),
//               const SizedBox(height: 10),
//               TextButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const SignupPage()),
//                   );
//                 },
//                 child: const Text(
//                   "Don't have an account? Create now",
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 12,
//                     decoration: TextDecoration.underline,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInputField({
//     required TextEditingController controller,
//     required String label,
//     bool obscureText = false,
//     bool isPasswordField = false,
//   }) {
//     return SizedBox(
//       width: 250,
//       child: TextField(
//         controller: controller,
//         obscureText: isPasswordField ? !_isPasswordVisible : obscureText,
//         style: const TextStyle(color: Colors.black, fontSize: 16),
//         cursorColor: Colors.black,
//         decoration: InputDecoration(
//           labelText: label,
//           labelStyle: const TextStyle(color: Colors.black, fontSize: 14),
//           contentPadding: const EdgeInsets.all(10),
//           focusedBorder: const OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.black, width: 2),
//           ),
//           enabledBorder: const OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.black, width: 2),
//           ),
//           suffixIcon: isPasswordField
//               ? IconButton(
//                   icon: Icon(
//                     _isPasswordVisible
//                         ? Icons.visibility
//                         : Icons.visibility_off,
//                     color: Colors.black,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       _isPasswordVisible = !_isPasswordVisible;
//                     });
//                   },
//                 )
//               : null,
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cetmock/admin%20screens/dashboard%20admin.dart';
import 'package:cetmock/customloader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../auth/auth.dart';
import '../auth/signup.dart';
import '../auth/forgot.dart';
import '../Mentor%20Pages/dashboard.dart';
import '../General%20User%20Pages/userdash.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      // Authenticate user
      User? user = await _authService.login(email, password);

      if (user != null) {
        String uid = user.uid;

        // Check if the user is already logged in on another device
        DatabaseReference sessionRef =
            FirebaseDatabase.instance.ref("users/$uid/session");
        final sessionSnapshot = await sessionRef.get();

        if (sessionSnapshot.exists) {
          _showSnackbar("You are already logged in on another device.");
          setState(() {
            _isLoading = false;
          });
          return;
        }

        // Store session (new login)
        await sessionRef
            .set({"active": true, "timestamp": ServerValue.timestamp});

        // Fetch user role
        String? role = await _getUserRole(uid);

        if (role != null) {
          if (mounted) {
            switch (role) {
              case "mentor":
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MentorDashboard()),
                );
                break;
              case "admin":
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AdminCoursesPage()),
                );
                break;
              case "user":
              default:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => UserDashboardPage()),
                );
                break;
            }
          }
        } else {
          _showSnackbar("Failed to fetch user role. Try again.");
        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Login failed";
      if (e.code == 'user-not-found') {
        errorMessage = "No user found with this email.";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Incorrect password. Please try again.";
      }
      _showSnackbar(errorMessage);
    } catch (e) {
      _showSnackbar("An unexpected error occurred ");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String?> _getUserRole(String uid) async {
    try {
      DatabaseReference userRef =
          FirebaseDatabase.instance.ref("users/$uid/role");
      final snapshot = await userRef.get();
      if (snapshot.exists) {
        return snapshot.value as String?;
      }
    } catch (e) {
      debugPrint("Error fetching role: $e");
    }
    return null;
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 3, 100, 255),
              Color.fromARGB(255, 104, 215, 240),
              Color.fromARGB(255, 5, 109, 255)
            ],
          ),
        ),
        child: Center(
          child: ScaleTransition(
            scale: _animation,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Login to continue',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildInputField(
                      controller: _emailController,
                      label: 'Email',
                      icon: Icons.email,
                    ),
                    const SizedBox(height: 20),
                    _buildInputField(
                      controller: _passwordController,
                      label: 'Password',
                      icon: Icons.lock,
                      obscureText: true,
                      isPasswordField: true,
                    ),
                    const SizedBox(height: 15),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordPage()),
                          );
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Color(0xFF2C3E50),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 0, 119, 255),
                              Color.fromARGB(255, 116, 176, 255)
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: _isLoading ? null : _login,
                          child: _isLoading
                              ? const CustomSpinner()
                              : const Text(
                                  'LOGIN',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(color: Colors.grey),
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignupPage()),
                              );
                            },
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Color(0xFF2C3E50),
                                fontWeight: FontWeight.bold,
                              ),
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
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    bool isPasswordField = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.blue.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPasswordField ? !_isPasswordVisible : obscureText,
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          prefixIcon: Icon(icon, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
          suffixIcon: isPasswordField
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
