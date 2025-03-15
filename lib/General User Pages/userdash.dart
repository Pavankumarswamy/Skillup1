// import 'package:cetmock/General%20User%20Pages/side.dart';
// import 'package:flutter/material.dart';
// import 'package:cetmock/General%20User%20Pages/dashwidget.dart';

// class UserDashboardPage extends StatefulWidget {
//   const UserDashboardPage({super.key});

//   @override
//   State<UserDashboardPage> createState() => _UserDashboardPageState();
// }

// class _UserDashboardPageState extends State<UserDashboardPage>
//     with SingleTickerProviderStateMixin {
//   bool isMenuOpen = false;
//   late AnimationController _animationController;
//   late Animation<double> _rotateAnimation;
//   late Animation<double> _borderRadiusAnimation;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _translateAnimation;
//   Widget _selectedWidget = const UserDashboardWidget();

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );

//     _rotateAnimation = Tween<double>(begin: 0, end: 0.5).animate(
//       CurvedAnimation(
//           parent: _animationController, curve: Curves.easeInOutQuad),
//     );

//     _borderRadiusAnimation = Tween<double>(begin: 0, end: 40).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );

//     _scaleAnimation = Tween<double>(begin: 1, end: 0.70).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );

//     _translateAnimation = Tween<double>(begin: 0, end: 190).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//   }

//   void _toggleMenu() {
//     if (isMenuOpen) {
//       _animationController.reverse().then((_) {
//         setState(() => isMenuOpen = false);
//       });
//     } else {
//       setState(() => isMenuOpen = true);
//       _animationController.forward();
//     }
//   }

//   void _selectMenuItem(Widget widget) {
//     setState(() {
//       _selectedWidget = widget;
//       _toggleMenu();
//     });
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         MenuWidget(onItemSelected: _selectMenuItem),
//         AnimatedBuilder(
//           animation: _animationController,
//           builder: (context, child) {
//             return Transform(
//               alignment: Alignment.centerLeft,
//               transform: Matrix4.identity()
//                 ..setEntry(3, 2, 0.002)
//                 ..rotateY(_rotateAnimation.value)
//                 ..translate(_translateAnimation.value)
//                 ..scale(_scaleAnimation.value),
//               child: ClipRRect(
//                 borderRadius:
//                     BorderRadius.circular(_borderRadiusAnimation.value),
//                 child: Scaffold(
//                   appBar: AppBar(
//                     leading: IconButton(
//                       icon: const Icon(Icons.menu),
//                       onPressed: _toggleMenu,
//                     ),
//                     title: Text('Skill UP'),
//                     backgroundColor: Colors.blue,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.vertical(
//                         bottom: Radius.circular(
//                             25), // Rounded corners at the bottom of the AppBar  QuizPage
//                       ),
//                     ),
//                     flexibleSpace: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.vertical(
//                           bottom:
//                               Radius.circular(25), // Match the rounded corners
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors
//                                 .blue.shade900, // Darker shadow for 3D effect
//                             offset: Offset(
//                                 0, 5), // Shadow position (below the AppBar)
//                             blurRadius: 5, // Soften the shadow
//                             spreadRadius: 1.5, // Extend the shadow
//                           ),
//                         ],
//                         gradient: LinearGradient(
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                           colors: [
//                             Colors.blue.shade400, // Lighter blue at the top
//                             Colors.blue.shade800, // Darker blue at the bottom
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),

//                   // appBar: AppBar(
//                   //   leading: IconButton(
//                   //     icon: const Icon(Icons.menu),
//                   //     onPressed: _toggleMenu,
//                   //   ),
//                   //   title: const Text('User Dashboard'),
//                   // ),
//                   body: _selectedWidget,
//                 ),
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }
import 'package:cetmock/General%20User%20Pages/certificateupload.dart';
import 'package:cetmock/General%20User%20Pages/delete.dart';
import 'package:cetmock/General%20User%20Pages/uploadimage.dart';
import 'package:cetmock/admin%20screens/dashboard%20admin.dart';

import '../General%20User%20Pages/side.dart';
import '../admin%20screens/admin.dart';
import 'package:flutter/material.dart';
import '../General%20User%20Pages/dashwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDashboardPage extends StatefulWidget {
  const UserDashboardPage({super.key});

  @override
  State<UserDashboardPage> createState() => _UserDashboardPageState();
}

class _UserDashboardPageState extends State<UserDashboardPage>
    with SingleTickerProviderStateMixin {
  bool isMenuOpen = false;
  late AnimationController _animationController;
  late Animation<double> _rotateAnimation;
  late Animation<double> _borderRadiusAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _translateAnimation;
  Widget _selectedWidget = const UserDashboardWidget();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _rotateAnimation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(
          parent: _animationController, curve: Curves.easeInOutQuad),
    );

    _borderRadiusAnimation = Tween<double>(begin: 0, end: 40).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 1, end: 0.70).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _translateAnimation = Tween<double>(begin: 0, end: 190).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  void _toggleMenu() {
    if (isMenuOpen) {
      _animationController.reverse().then((_) {
        setState(() => isMenuOpen = false);
      });
    } else {
      setState(() => isMenuOpen = true);
      _animationController.forward();
    }
  }

  void _selectMenuItem(Widget widget) {
    setState(() {
      _selectedWidget = widget;
      _toggleMenu();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MenuWidget(onItemSelected: _selectMenuItem),
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform(
              alignment: Alignment.centerLeft,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.002)
                ..rotateY(_rotateAnimation.value)
                ..translate(_translateAnimation.value)
                ..scale(_scaleAnimation.value),
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(_borderRadiusAnimation.value),
                child: Scaffold(
                  appBar: AppBar(
                    leading: IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: _toggleMenu,
                    ),
                    title: const Text('Skill UP'),
                    backgroundColor: Colors.blue,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(25)),
                    ),
                    flexibleSpace: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(25),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.shade900,
                            offset: const Offset(0, 5),
                            blurRadius: 5,
                            spreadRadius: 1.5,
                          ),
                        ],
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.blue.shade400,
                            Colors.blue.shade800,
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      if (FirebaseAuth.instance.currentUser?.email ==
                          "shesettipavankumarswamy@gmail.com") ...[
                        IconButton(
                          icon: const Icon(Icons.admin_panel_settings,
                              color: Colors.black),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminDashboard(),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_to_home_screen_outlined,
                              color: Colors.black),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminCoursesPage(),
                              ),
                            );
                          },
                        ), //DeleteSessionsPage
                        IconButton(
                          icon: const Icon(Icons.image, color: Colors.black),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UploadImagePage(),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.celebration,
                              color: Colors.black),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchAndUploadPage(),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.black),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DeleteSessionsPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                  body: _selectedWidget,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
