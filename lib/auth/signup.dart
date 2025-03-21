// import 'package:cetmock/customloader.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';

// class SignupPage extends StatefulWidget {
//   const SignupPage({super.key});

//   @override
//   _SignupPageState createState() => _SignupPageState();
// }

// class _SignupPageState extends State<SignupPage> {
//   final _emailController = TextEditingController();
//   final _mobilenoController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _isLoading = false;
//   bool _obscurePassword = true;
//   final _formKey = GlobalKey<FormState>();

//   final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("users");

//   String? _validateEmail(String? value) {
//     if (value == null || value.isEmpty) return 'Email is required';
//     if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
//       return 'Enter a valid email address';
//     }
//     return null;
//   }

//   String? _validateMobile(String? value) {
//     if (value == null || value.isEmpty) return 'Mobile number is required';
//     if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
//       return 'Enter a valid 10-digit mobile number';
//     }
//     return null;
//   }

//   String? _validatePassword(String? value) {
//     if (value == null || value.isEmpty) return 'Password is required';
//     if (value.length < 8) return 'Password must be at least 8 characters';
//     if (!value.contains(RegExp(r'[A-Z]'))) {
//       return 'Include at least one uppercase letter';
//     }
//     if (!value.contains(RegExp(r'[0-9]'))) return 'Include at least one number';
//     return null;
//   }

//   void _signup() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isLoading = true);

//     try {
//       final userCredential =
//           await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );

//       if (userCredential.user != null) {
//         // Save additional details to the Realtime Database
//         await _dbRef.child(userCredential.user!.uid).set({
//           "email": _emailController.text.trim(),
//           "mobile": _mobilenoController.text.trim(),
//           "createdAt": ServerValue.timestamp,
//           "role": "user", // Default role
//           "membershipPlan": "none",
//           "membershipExpiry": "none",
//           "purchasedCourses": "none",
//         });

//         await userCredential.user!.sendEmailVerification();

//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Verification email sent! Please check your inbox.'),
//             duration: Duration(seconds: 5),
//           ),
//         );

//         Navigator.pop(context);
//       }
//     } on FirebaseAuthException catch (e) {
//       String message = 'Signup failed';
//       if (e.code == 'email-already-in-use') {
//         message = 'Email already registered';
//       } else if (e.code == 'weak-password') {
//         message = 'Password is too weak';
//       }
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(message)),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('An unexpected error occurred')),
//       );
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromRGBO(28, 156, 231, 1),
//       body: Center(
//         child: SingleChildScrollView(
//           child: Container(
//             width: 300,
//             padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
//             decoration: BoxDecoration(
//               color: const Color(0xFFE3E3E3),
//               borderRadius: BorderRadius.circular(8),
//               boxShadow: const [
//                 BoxShadow(
//                   color: Color.fromRGBO(45, 48, 49, 0.493),
//                   offset: Offset(16, 16),
//                   blurRadius: 32,
//                 ),
//                 BoxShadow(
//                   color: Color.fromRGBO(33, 37, 39, 0),
//                   offset: Offset(-16, -16),
//                   blurRadius: 32,
//                 ),
//               ],
//             ),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Text(
//                     'Sign Up',
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 1.5,
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   _buildInputField(
//                     controller: _emailController,
//                     label: 'Email',
//                     validator: _validateEmail,
//                     keyboardType: TextInputType.emailAddress,
//                   ),
//                   const SizedBox(height: 20),
//                   _buildInputField(
//                     controller: _mobilenoController,
//                     label: 'Mobile No',
//                     validator: _validateMobile,
//                     keyboardType: TextInputType.phone,
//                   ),
//                   const SizedBox(height: 20),
//                   _buildPasswordField(),
//                   const SizedBox(height: 30),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 15),
//                         backgroundColor: Colors.black,
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       onPressed: _isLoading ? null : _signup,
//                       child: _isLoading
//                           ? SizedBox(
//                               height: 20,
//                               width: 20,
//                               child: Center(child: CustomSpinner()))
//                           : const Text(
//                               'CREATE ACCOUNT',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                     ),
//                   ),
//                   const SizedBox(height: 15),
//                   TextButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: const Text.rich(
//                       TextSpan(
//                         text: 'Already have an account? ',
//                         style: TextStyle(color: Colors.black54),
//                         children: [
//                           TextSpan(
//                             text: 'Log in',
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontWeight: FontWeight.w600,
//                               decoration: TextDecoration.underline,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInputField({
//     required TextEditingController controller,
//     required String label,
//     required String? Function(String?) validator,
//     TextInputType? keyboardType,
//   }) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: keyboardType,
//       style: const TextStyle(fontSize: 16),
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: const TextStyle(color: Colors.black54),
//         contentPadding:
//             const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: const BorderSide(color: Colors.black54),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: const BorderSide(color: Colors.black, width: 1.5),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: const BorderSide(color: Colors.red),
//         ),
//       ),
//       validator: validator,
//       textInputAction: TextInputAction.next,
//     );
//   }

//   Widget _buildPasswordField() {
//     return TextFormField(
//       controller: _passwordController,
//       obscureText: _obscurePassword,
//       style: const TextStyle(fontSize: 16),
//       decoration: InputDecoration(
//         labelText: 'Password',
//         labelStyle: const TextStyle(color: Colors.black54),
//         contentPadding:
//             const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: const BorderSide(color: Colors.black54),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: const BorderSide(color: Colors.black, width: 1.5),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: const BorderSide(color: Colors.red),
//         ),
//         suffixIcon: IconButton(
//           icon: Icon(
//             _obscurePassword ? Icons.visibility : Icons.visibility_off,
//             color: Colors.black54,
//           ),
//           onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
//         ),
//       ),
//       validator: _validatePassword,
//       textInputAction: TextInputAction.done,
//     );
//   }
// }
import 'package:cetmock/customloader.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailController = TextEditingController();
  final _mobilenoController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("users");

  void _signup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        await _dbRef.child(userCredential.user!.uid).set({
          "email": _emailController.text.trim(),
          "mobile": _mobilenoController.text.trim(),
          "createdAt": ServerValue.timestamp,
          "role": "user",
          "membershipPlan": "false",
          "membershipExpiry": "none",
        });

        await userCredential.user!.sendEmailVerification();

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification email sent! Please check your inbox.'),
            duration: Duration(seconds: 5),
          ),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signup failed! Try again.')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 118, 175, 232),
              Color.fromARGB(255, 85, 179, 255),
              Color.fromARGB(255, 0, 111, 201)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 320,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildInputField(
                      controller: _emailController,
                      label: 'Email',
                      icon: Icons.email,
                    ),
                    const SizedBox(height: 15),
                    _buildInputField(
                      controller: _mobilenoController,
                      label: 'Mobile Number',
                      icon: Icons.phone,
                    ),
                    const SizedBox(height: 15),
                    _buildPasswordField(),
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
                          onPressed: _isLoading ? null : _signup,
                          child: _isLoading
                              ? const CustomSpinner()
                              : const Text(
                                  'SIGNUP',
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
                    const SizedBox(height: 15),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Already have an account? Log in',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: label == 'Mobile Number'
          ? TextInputType.phone
          : TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black54),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return '$label is required';
        if (label == 'Email' &&
            !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Enter a valid email address';
        }
        if (label == 'Mobile Number' &&
            !RegExp(r'^[0-9]{10}$').hasMatch(value)) {
          return 'Enter a valid 10-digit mobile number';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock, color: Colors.blueAccent),
        labelText: 'Password',
        labelStyle: const TextStyle(color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black54),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility : Icons.visibility_off,
            color: Colors.black54,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Password is required';
        if (value.length < 8) return 'Password must be at least 8 characters';
        if (!value.contains(RegExp(r'[A-Z]'))) {
          return 'Include at least one uppercase letter';
        }
        if (!value.contains(RegExp(r'[0-9]'))) {
          return 'Include at least one number';
        }
        return null;
      },
    );
  }
}
