// import 'package:cetmock/General%20User%20Pages/Membership%20Page.dart';
// import 'package:cetmock/General%20User%20Pages/mycourses.dart';
// import 'package:cetmock/General%20User%20Pages/dashwidget.dart';
// import 'package:cetmock/General%20User%20Pages/search.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'dart:math' as math;

// class MenuWidget extends StatelessWidget {
//   final Function(Widget) onItemSelected;
//   const MenuWidget({required this.onItemSelected, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Positioned.fill(
//           child: Opacity(
//             opacity: 0.8, // Adjust opacity as needed
//             child: Image.asset(
//               "assets/bg.gif", // Make sure to place the GIF in assets
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),

//         // Sidebar Menu
//         Positioned(
//           left: 0,
//           top: 0,
//           bottom: 0,
//           width: 450,
//           child: Container(
//             // ignore: deprecated_member_use
//             color: Colors.black.withOpacity(0.7), // Semi-transparent black
//             padding: const EdgeInsets.only(top: 65, left: 35),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildAnimatedTile(
//                   icon: Icons.home,
//                   title: 'Home',
//                   onTap: () => onItemSelected(const UserDashboardWidget()),
//                 ),
//                 const SizedBox(height: 20),
//                 _buildAnimatedTile(
//                   icon: Icons.search,
//                   title: 'Courses',
//                   onTap: () => onItemSelected(SearchCoursesPage()),
//                 ),
//                 const SizedBox(height: 20),
//                 _buildAnimatedTile(
//                   icon: Icons.card_membership,
//                   title: 'Membership',
//                   onTap: () => onItemSelected(MembershipPage()),
//                 ),
//                 const SizedBox(height: 20),
//                 _buildAnimatedTile(
//                   icon: Icons.my_library_books_outlined,
//                   title: 'My course',
//                   onTap: () => onItemSelected(MyCoursesPage()),
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),

//         // Logout Button at Bottom
//         Positioned(
//           left: 20,
//           bottom: 20,
//           child: FloatingActionButton(
//             onPressed: () async {
//               User? user = FirebaseAuth.instance.currentUser;
//               if (user != null) {
//                 // Remove session entry from Firebase Realtime Database
//                 await FirebaseDatabase.instance
//                     .ref("users/${user.uid}/session")
//                     .remove();
//               }

//               // Sign out from Firebase
//               await FirebaseAuth.instance.signOut();

//               // Redirect to login screen, removing all previous routes
//               if (context.mounted) {
//                 Navigator.pushNamedAndRemoveUntil(
//                     context, "/", (route) => false);
//               }
//             },
//             backgroundColor: Colors.red,
//             child: Transform(
//               alignment: Alignment.center,
//               transform: Matrix4.rotationY(math.pi),
//               child: const Icon(Icons.logout, color: Colors.white),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildAnimatedTile({
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           color: Colors.blue,
//         ),
//         child: Row(
//           children: [
//             Icon(icon, color: Colors.white, size: 28),
//             const SizedBox(width: 15),
//             Text(
//               title,
//               style: const TextStyle(color: Colors.white, fontSize: 18),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:cetmock/General%20User%20Pages/Membership%20Page.dart';
import 'package:cetmock/General%20User%20Pages/certificates.dart';
import 'package:cetmock/General%20User%20Pages/mycourses.dart';
import 'package:cetmock/General%20User%20Pages/dashwidget.dart';
import 'package:cetmock/General%20User%20Pages/search.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math' as math;

class MenuWidget extends StatelessWidget {
  final Function(Widget) onItemSelected;
  const MenuWidget({required this.onItemSelected, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Opacity(
            opacity: 1.0, // Adjust opacity as needed
            child: Image.asset(
              "assets/bg.gif", // Make sure to place the GIF in assets
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Sidebar Menu
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          width: 450,
          child: Container(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.3), // Semi-transparent black
            padding: const EdgeInsets.only(top: 80, left: 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAnimatedTile(
                  icon: Icons.home,
                  title: 'Home',
                  onTap: () => onItemSelected(const UserDashboardWidget()),
                ),
                const SizedBox(height: 20),
                _buildAnimatedTile(
                  icon: Icons.search,
                  title: 'Courses',
                  onTap: () => onItemSelected(SearchCoursesPage()),
                ),
                const SizedBox(height: 20),
                _buildAnimatedTile(
                  icon: Icons.card_membership,
                  title: 'Membership',
                  onTap: () => onItemSelected(MembershipPage()),
                ),
                const SizedBox(height: 20),
                _buildAnimatedTile(
                  icon: Icons.my_library_books_outlined,
                  title: 'My course',
                  onTap: () => onItemSelected(MyCoursesPage()),
                ),
                const SizedBox(height: 20),
                _buildAnimatedTile(
                  icon: Icons.card_giftcard,
                  title: 'certificates',
                  onTap: () => onItemSelected(CertificatesPage()),
                ),
                // const SizedBox(height: 20),
                // _buildAnimatedTile(
                //   icon: Icons.create_new_folder_outlined,
                //   title: 'Create',
                //   onTap: () => onItemSelected(CreateCoursePage()),
                // ),
                // const SizedBox(height: 20),
                // _buildAnimatedTile(
                //   icon: Icons.manage_search,
                //   title: 'Manage',
                //   onTap: () => onItemSelected(ManageCoursesPage()),
                // ),
                // const SizedBox(height: 20),
                // _buildAnimatedTile(
                //   icon: Icons.volunteer_activism_rounded,
                //   title: 'Active',
                //   onTap: () => onItemSelected(ActiveCoursesPage()),
                // ),
              ],
            ),
          ),
        ),

        // Logout Button at Bottom
        Positioned(
          left: 20,
          bottom: 20,
          child: FloatingActionButton(
            onPressed: () async {
              User? user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                await FirebaseDatabase.instance
                    .ref("users/${user.uid}/session")
                    .remove();
              }

              await FirebaseAuth.instance.signOut();

              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                    context, "/", (route) => false);
              }
            },
            backgroundColor: Colors.red,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(math.pi),
              child: const Icon(Icons.logout, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent, // No solid background color
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.blue.withOpacity(0.3), // Light ripple effect
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(width: 15),
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
