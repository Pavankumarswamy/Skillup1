// import 'dart:async';

// import 'package:cetmock/admin%20screens/course_content_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

// class UserDashboardWidget extends StatefulWidget {
//   const UserDashboardWidget({super.key});

//   @override
//   _UserDashboardWidgetState createState() => _UserDashboardWidgetState();
// }

// class _UserDashboardWidgetState extends State<UserDashboardWidget>
//     with SingleTickerProviderStateMixin {
//   final DatabaseReference _database = FirebaseDatabase.instance.ref("courses");
//   List<Map<String, dynamic>> _courses = [];
//   List<String> _categories = [];
//   int _currentPage = 0;
//   late AnimationController _loadingController;
//   bool _isLoading = true;
//   final Razorpay _razorpay = Razorpay();
//   final DatabaseReference _userRef = FirebaseDatabase.instance
//       .ref("users"); // Reference for storing data after purchase

//   late String courseId;
//   late double coursePrice;
//   final PageController _pageController = PageController();
//   final int _currentPage1 = 0;

//   @override
//   void initState() {
//     super.initState();
//     _loadingController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     )..repeat();
//     _fetchCourses();

//     Timer.periodic(Duration(seconds: 3), (Timer timer) {
//       if (_currentPage1 < 2) {
//         _pageController.animateToPage(
//           _currentPage1 + 1,
//           duration: Duration(milliseconds: 500),
//           curve: Curves.easeInOut,
//         );
//       } else {
//         _pageController.animateToPage(
//           0,
//           duration: Duration(milliseconds: 500),
//           curve: Curves.easeInOut,
//         );
//       }
//     });

//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//   }

//   @override
//   void dispose() {
//     _loadingController.dispose();
//     super.dispose();
//   }

//   void _handlePaymentSuccess(PaymentSuccessResponse response) {
//     var user = FirebaseAuth.instance.currentUser;
//     final userId =
//         user!.uid; // Replace with actual user ID or get it from Firebase auth
//     _userRef.child(userId).child("purchases").push().set({
//       courseId: "true",
//       "price": coursePrice,
//       "transactionId": response.paymentId,
//       "status": "success"
//     });

//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text("Payment Successful!")));
//   }

//   // Payment error handler
//   void _handlePaymentError(PaymentFailureResponse response) {
//     ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Payment Failed: ${response.message}")));
//   }

//   // External wallet handler (if any)
//   void _handleExternalWallet(ExternalWalletResponse response) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text("External Wallet Used: ${response.walletName}")));
//   }

//   Widget _buildShimmerEffect() {
//     return AnimatedBuilder(
//       animation: _loadingController,
//       builder: (context, child) {
//         return ShaderMask(
//           blendMode: BlendMode.srcATop,
//           shaderCallback: (rect) {
//             return LinearGradient(
//               colors: [Colors.grey[300]!, Colors.grey[100]!, Colors.grey[300]!],
//               stops: const [0.0, 0.5, 1.0],
//               begin: Alignment(-1.0 + (2 * _loadingController.value), 0.0),
//               end: const Alignment(1.0, 0.0),
//             ).createShader(rect);
//           },
//           child: child,
//         );
//       },
//       child: _buildSkeletonCard(),
//     );
//   }

//   Widget _buildSkeletonCard() {
//     return Card(
//       margin: const EdgeInsets.all(8),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               height: 120,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             const SizedBox(height: 12),
//             Container(
//               height: 16,
//               width: 200,
//               color: Colors.white,
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 Container(
//                   height: 12,
//                   width: 80,
//                   color: Colors.white,
//                 ),
//                 const Spacer(),
//                 Container(
//                   height: 12,
//                   width: 60,
//                   color: Colors.white,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             Container(
//               height: 40,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _startPayment(double price, String courseId) {
//     var options = {
//       'key': 'rzp_live_C4QRSwJt17HkUA', // Replace with your Razorpay key
//       'amount': (price * 100)
//           .toInt(), // Razorpay accepts amount in paise (1 INR = 100 paise)
//       'name': 'Course Payment',
//       'description': 'Payment for course $courseId',
//       'prefill': {
//         'contact': '9999999999',
//         'email':
//             FirebaseAuth.instance.currentUser?.email ?? 'support@Skillup.com',
//       },
//       'theme': {'color': '#F37254'},
//     };

//     _razorpay.open(options);
//   }

//   Widget _buildEnrollButton(String courseId, double price) {
//     var user = FirebaseAuth.instance.currentUser;
//     final userId = user!.uid;

//     // Use FutureBuilder to handle asynchronous data fetching from Firebase
//     return FutureBuilder<DatabaseEvent>(
//       future: _userRef.child(userId).once(), // Fetch data from Firebase
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//               child:
//                   CircularProgressIndicator()); // Loading indicator while fetching data
//         }

//         if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }

//         if (snapshot.hasData) {
//           var userData = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
//           String membershipPlan = userData['membershipPlan'] ?? 'none';

//           // If user has a membership plan, show "View Course" button
//           if (membershipPlan == "true") {
//             return SizedBox(
//               width: double.infinity,
//               child: FilledButton(
//                 onPressed: () {
//                   // Navigate to the course details page or show the course content
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) =>
//                             CourseContentPage(courseId: courseId)),
//                   );
//                 },
//                 style: FilledButton.styleFrom(
//                   backgroundColor: const Color.fromARGB(255, 10, 145, 255),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8)),
//                 ),
//                 child: const Text("View Course",
//                     style: TextStyle(color: Colors.white)),
//               ),
//             );
//           } else {
//             // If no membership, show the "Enroll Now" button
//             return SizedBox(
//               width: double.infinity,
//               child: FilledButton(
//                 onPressed: () {
//                   setState(() {
//                     this.courseId = courseId;
//                     coursePrice = price;
//                   });
//                   _startPayment(price, courseId); // Start Razorpay payment
//                 },
//                 style: FilledButton.styleFrom(
//                   backgroundColor: Colors.blue.shade900,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8)),
//                 ),
//                 child: const Text("Enroll Now",
//                     style: TextStyle(color: Colors.white)),
//               ),
//             );
//           }
//         }

//         // In case of any unexpected situation, return an empty container
//         return Container();
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.white, Colors.blue.shade100],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: CustomScrollView(
//           slivers: [
//             SliverPadding(
//               padding: const EdgeInsets.only(top: 19),
//               sliver: SliverList(
//                 delegate: SliverChildListDelegate([
//                   SizedBox(
//                     height: 180,
//                     child: Stack(alignment: Alignment.bottomCenter, children: [
//                       PageView(
//                         onPageChanged: (index) =>
//                             setState(() => _currentPage = index),
//                         children: List.generate(
//                           5, // You can change this number to add more images
//                           (index) {
//                             String imageUrl;
//                             if (index == 0) {
//                               imageUrl =
//                                   "https://cdn.prod.website-files.com/5f841209f4e71b2d70034471/60bb4a2e143f632da3e56aea_Flutter%20app%20development%20(2).png"; // First image
//                             } else if (index == 1) {
//                               imageUrl =
//                                   "https://res.cloudinary.com/upwork-cloud/image/upload/c_scale,w_1000/v1693202305/catalog/1696034845069537280/dhnpnmvv5qfyrj5k9zag.jpg"; // Second image (replace with actual URL)
//                             } else if (index == 2) {
//                               imageUrl =
//                                   "https://opencodestore.com/wp-content/uploads/2024/09/mastering-efficient-java-coding-1536x864.webp"; // Third image (replace with actual URL)
//                             } else if (index == 3) {
//                               imageUrl =
//                                   "https://api.reliasoftware.com/uploads/the_complete_guide_to_mobile_app_development_2021_ded2abd1b1.png"; // Fourth image (replace with actual URL)
//                             } else {
//                               imageUrl =
//                                   "https://cdn.prod.website-files.com/5f841209f4e71b2d70034471/60bb4a2e143f632da3e56aea_Flutter%20app%20development%20(2).png"; // Fifth image (replace with actual URL)
//                             }

//                             return Container(
//                               margin: const EdgeInsets.symmetric(horizontal: 8),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(12),
//                                 image: DecorationImage(
//                                   image: NetworkImage(imageUrl),
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                       Positioned(
//                         bottom: 10,
//                         child: Row(
//                           children: List.generate(
//                             5, // Update to match the number of images
//                             (index) => AnimatedContainer(
//                               duration: const Duration(milliseconds: 300),
//                               curve: Curves.easeInOut,
//                               width: 8,
//                               height: 8,
//                               margin: const EdgeInsets.symmetric(horizontal: 4),
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: _currentPage == index
//                                     ? Colors.blue.shade900
//                                     : Colors.grey.shade300,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ]),
//                   ),
//                   if (_categories.isNotEmpty)
//                     Padding(
//                       padding: const EdgeInsets.only(left: 15.0, top: 15),
//                       child: Wrap(
//                         spacing: 12, // Space between chips
//                         runSpacing: 12, // Space between rows
//                         children: _categories
//                             .map(
//                               (category) => SizedBox(
//                                 width: (_categories.length % 2 == 1 &&
//                                         _categories.indexOf(category) ==
//                                             _categories.length - 1)
//                                     ? double
//                                         .infinity // Occupy the whole row if it's the last category in an odd-length list
//                                     : (MediaQuery.of(context).size.width - 48) /
//                                         2, // 2 categories per row (subtracting the padding)
//                                 child: ActionChip(
//                                   avatar: Icon(
//                                     Icons.book,
//                                     size: 18,
//                                     color:
//                                         const Color.fromARGB(255, 15, 0, 232),
//                                   ),
//                                   label: Text(
//                                     category,
//                                     style: TextStyle(
//                                       color: const Color.fromARGB(255, 0, 0, 0),
//                                       fontSize: 16,
//                                       fontFamily: 'Georgia',
//                                     ),
//                                   ),
//                                   onPressed: () =>
//                                       _showCategoryCourses(context, category),
//                                   backgroundColor: Colors.deepPurple.shade50,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                 ),
//                               ),
//                             )
//                             .toList(),
//                       ),
//                     ),
//                 ]),
//               ),
//             ),
//             if (_isLoading)
//               SliverList(
//                 delegate: SliverChildBuilderDelegate(
//                   (context, index) => _buildShimmerEffect(),
//                   childCount: 3,
//                 ),
//               )
//             else if (_courses.isEmpty)
//               SliverFillRemaining(
//                 child: Center(
//                   child: Text(
//                     "No courses available",
//                     style: TextStyle(color: Colors.blue.shade900),
//                   ),
//                 ),
//               )
//             else
//               SliverList(
//                 delegate: SliverChildBuilderDelegate(
//                   (context, index) {
//                     final course = _courses[index];
//                     return Card(
//                       elevation: 4,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                       margin: const EdgeInsets.all(8),
//                       child: Padding(
//                         padding: const EdgeInsets.all(12),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(8),
//                               child: Image.network(
//                                 course["imageUrl"],
//                                 height: 120,
//                                 width: double.infinity,
//                                 fit: BoxFit.cover,
//                                 errorBuilder: (context, error, stackTrace) {
//                                   return Image.asset('assets/placeholder.png',
//                                       height: 120,
//                                       width: double.infinity,
//                                       fit: BoxFit.cover);
//                                 },
//                                 frameBuilder: (context, child, frame,
//                                     wasSynchronouslyLoaded) {
//                                   return AnimatedOpacity(
//                                     opacity: frame == null ? 0 : 1,
//                                     duration: const Duration(milliseconds: 500),
//                                     curve: Curves.easeOut,
//                                     child: child,
//                                   );
//                                 },
//                               ),
//                             ),
//                             const SizedBox(height: 12),
//                             Text(course["title"],
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .titleMedium
//                                     ?.copyWith(
//                                       color: Colors.blue.shade900,
//                                     )),
//                             const SizedBox(height: 8),
//                             Row(
//                               children: [
//                                 Icon(Icons.timer,
//                                     size: 16, color: Colors.blue.shade700),
//                                 Text(" ${course["duration"]} Days",
//                                     style:
//                                         TextStyle(color: Colors.blue.shade700)),
//                                 const Spacer(),
//                                 Text("₹${course["price"]}",
//                                     style: TextStyle(
//                                         color: Colors.green.shade700)),
//                               ],
//                             ),
//                             const SizedBox(height: 12),
//                             const SizedBox(height: 12),
//                             _buildEnrollButton(
//                                 course["courseId"], course["price"]),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                   childCount: _courses.length,
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _fetchCourses() {
//     setState(() => _isLoading = true);
//     _database.onValue.listen((event) {
//       if (event.snapshot.value != null) {
//         Map<dynamic, dynamic> values =
//             event.snapshot.value as Map<dynamic, dynamic>;
//         List<Map<String, dynamic>> tempCourses = [];
//         Set<String> categorySet = {};

//         values.forEach((key, value) {
//           if (value["status"] == "verified") {
//             tempCourses.add({
//               "courseId": key,
//               "title": value["title"] ?? "No Title",
//               "category": value["category"] ?? "Uncategorized",
//               "price": double.tryParse(value["price"].toString()) ?? 0.0,
//               "language": value["language"] ?? "Unknown",
//               "duration": value["duration"] ?? "0",
//               "imageUrl":
//                   value["imageUrl"] ?? "https://via.placeholder.com/400",
//             });
//             categorySet.add(value["category"] ?? "Uncategorized");
//           }
//         });

//         setState(() {
//           _courses = tempCourses;
//           _categories = categorySet.toList();
//           _isLoading = false;
//         });
//       }
//     });
//   }

//   void _showCategoryCourses(BuildContext context, String category) {
//     List<Map<String, dynamic>> filteredCourses = _courses.where((course) {
//       return course["category"] == category;
//     }).toList();

//     if (filteredCourses.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("No courses found for $category")),
//       );
//       return;
//     }

//     showDialog(
//       context: context,
//       builder: (context) {
//         return Dialog(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             height: 400,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Colors.white, Colors.blue.shade100],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(category,
//                     style: Theme.of(context)
//                         .textTheme
//                         .titleLarge
//                         ?.copyWith(color: Colors.blue.shade900)),
//                 const SizedBox(height: 12),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: filteredCourses.length,
//                     itemBuilder: (context, index) {
//                       final course = filteredCourses[index];
//                       return Card(
//                         elevation: 2,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8)),
//                         child: ListTile(
//                           leading: ClipRRect(
//                             borderRadius: BorderRadius.circular(8),
//                             child: Image.network(
//                               course["imageUrl"],
//                               width: 50,
//                               height: 50,
//                               fit: BoxFit.cover,
//                               errorBuilder: (context, error, stackTrace) {
//                                 return Image.asset('assets/placeholder.png',
//                                     width: 50, height: 50, fit: BoxFit.cover);
//                               },
//                             ),
//                           ),
//                           title: Text(course["title"],
//                               style: TextStyle(color: Colors.blue.shade900)),
//                           subtitle: Text("₹${course["price"]}",
//                               style: TextStyle(color: Colors.blue.shade700)),
//                           trailing: FilledButton(
//                             onPressed: () {},
//                             style: FilledButton.styleFrom(
//                               backgroundColor: Colors.blue.shade900,
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8)),
//                             ),
//                             child: const Text("Enroll",
//                                 style: TextStyle(color: Colors.white)),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
import 'package:cetmock/General%20User%20Pages/course.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class UserDashboardWidget extends StatefulWidget {
  const UserDashboardWidget({super.key});

  @override
  _UserDashboardWidgetState createState() => _UserDashboardWidgetState();
}

class _UserDashboardWidgetState extends State<UserDashboardWidget>
    with SingleTickerProviderStateMixin {
  final DatabaseReference _database = FirebaseDatabase.instance.ref("courses");
  List<Map<String, dynamic>> _courses = [];
  List<String> _categories = [];
  int _currentPage = 0;
  late AnimationController _loadingController;
  bool _isLoading = true;
  final Razorpay _razorpay = Razorpay();
  final DatabaseReference _userRef = FirebaseDatabase.instance.ref("users");
  String? _membershipPlan;
  bool _isUserDataLoading = true;
  String? _processingCourseId;
  late double coursePrice;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _fetchCourses();
    _fetchUserData();

    // Automatic slider

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _loadingController.dispose();
    _razorpay.clear();
    super.dispose();
  }

  void _fetchUserData() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => _isUserDataLoading = false);
      return;
    }

    try {
      DataSnapshot snapshot = await _userRef.child(user.uid).get();
      setState(() {
        _membershipPlan = snapshot.child('membershipPlan').value.toString();
        _isUserDataLoading = false;
      });
    } catch (e) {
      setState(() => _isUserDataLoading = false);
    }
  }

  void _fetchCourses() {
    setState(() => _isLoading = true);
    _database.onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> values =
            event.snapshot.value as Map<dynamic, dynamic>;
        List<Map<String, dynamic>> tempCourses = [];
        Set<String> categorySet = {};

        values.forEach((key, value) {
          if (value["status"] == "verified") {
            tempCourses.add({
              "courseId": key,
              "title": value["title"] ?? "No Title",
              "category": value["category"] ?? "Uncategorized",
              "price": double.tryParse(value["price"].toString()) ?? 0.0,
              "language": value["language"] ?? "Unknown",
              "duration": value["duration"] ?? "0",
              "imageUrl":
                  value["imageUrl"] ?? "https://via.placeholder.com/400",
            });
            categorySet.add(value["category"] ?? "Uncategorized");
          }
        });

        setState(() {
          _courses = tempCourses;
          _categories = categorySet.toList();
          _isLoading = false;
        });
      }
    });
  }

  void _startPayment(double price, String courseId) {
    var options = {
      'key': 'rzp_live_HJl9NwyBSY9rwV', // Replace with your Razorpay key
      'amount': (price * 100).toInt(), // Amount in paise
      'name': 'Course Payment',
      'description': 'Payment for course $courseId',
      'prefill': {
        'contact': '+91 8639122823',
        'email': FirebaseAuth.instance.currentUser?.email ?? 'live@ggu.edu.in',
      },
      'theme': {'color': '#F37254'},
    };

    _razorpay.open(options);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Capture values before clearing processing state
    final courseId = _processingCourseId;
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null || courseId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Error: User not logged in or course missing")),
      );
      return;
    }

    // Reset processing state
    setState(() => _processingCourseId = null);

    // Append the purchased course to the user's purchasedCourses map
    _userRef
        .child(userId)
        .child("purchasedCourses")
        .child(courseId) // Use the courseId as the key
        .set(true) // Set the value as boolean true
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Payment Successful! Course added to your account.")),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update purchased courses: $error")),
      );
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() => _processingCourseId = null);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment Failed: ${response.message}")));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    setState(() => _processingCourseId = null);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("External Wallet Used: ${response.walletName}")));
  }

  Widget _buildEnrollButton(String courseId, double price) {
    if (_isUserDataLoading) {
      return const SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: null,
          child: CircularProgressIndicator(),
        ),
      );
    }

    final bool isProcessing = courseId == _processingCourseId;

    return FutureBuilder<DataSnapshot>(
      future: _userRef
          .child(FirebaseAuth.instance.currentUser!.uid)
          .child("purchasedCourses")
          .child(courseId)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: null,
              child: CircularProgressIndicator(),
            ),
          );
        }

        bool isPurchased = snapshot.hasData && snapshot.data!.value == true;

        if (_membershipPlan == "true" || isPurchased) {
          return SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: isProcessing
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CourseContentPage(courseId: courseId),
                        ),
                      );
                    },
              style: FilledButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 10, 145, 255),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: isProcessing
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("View Course",
                      style: TextStyle(color: Colors.white)),
            ),
          );
        } else {
          return SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: isProcessing
                  ? null
                  : () {
                      setState(() => _processingCourseId = courseId);
                      _startPayment(price, courseId);
                    },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.blue.shade900,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: isProcessing
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Enroll Now",
                      style: TextStyle(color: Colors.white)),
            ),
          );
        }
      },
    );
  }

  Widget _buildShimmerEffect() {
    return AnimatedBuilder(
      animation: _loadingController,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (rect) {
            return LinearGradient(
              colors: [Colors.grey[300]!, Colors.grey[100]!, Colors.grey[300]!],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(-1.0 + (2 * _loadingController.value), 0.0),
              end: const Alignment(1.0, 0.0),
            ).createShader(rect);
          },
          child: child,
        );
      },
      child: _buildSkeletonCard(),
    );
  }

  Widget _buildSkeletonCard() {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 16,
              width: 200,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  height: 12,
                  width: 80,
                  color: Colors.white,
                ),
                const Spacer(),
                Container(
                  height: 12,
                  width: 60,
                  color: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(top: 19),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(
                    height: 180,
                    child: Stack(alignment: Alignment.bottomCenter, children: [
                      PageView(
                        controller: _pageController,
                        onPageChanged: (index) =>
                            setState(() => _currentPage = index),
                        children: List.generate(
                          5,
                          (index) {
                            String imageUrl;
                            switch (index) {
                              case 0:
                                imageUrl =
                                    "https://cdn.prod.website-files.com/5f841209f4e71b2d70034471/60bb4a2e143f632da3e56aea_Flutter%20app%20development%20(2).png";
                                break;
                              case 1:
                                imageUrl =
                                    "https://res.cloudinary.com/upwork-cloud/image/upload/c_scale,w_1000/v1693202305/catalog/1696034845069537280/dhnpnmvv5qfyrj5k9zag.jpg";
                                break;
                              case 2:
                                imageUrl =
                                    "https://opencodestore.com/wp-content/uploads/2024/09/mastering-efficient-java-coding-1536x864.webp";
                                break;
                              case 3:
                                imageUrl =
                                    "https://api.reliasoftware.com/uploads/the_complete_guide_to_mobile_app_development_2021_ded2abd1b1.png";
                                break;
                              default:
                                imageUrl =
                                    "https://cdn.prod.website-files.com/5f841209f4e71b2d70034471/60bb4a2e143f632da3e56aea_Flutter%20app%20development%20(2).png";
                            }

                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: NetworkImage(imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        child: Row(
                          children: List.generate(
                            5,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentPage == index
                                    ? Colors.blue.shade900
                                    : Colors.grey.shade300,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                  if (_categories.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, top: 15),
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: _categories
                            .map(
                              (category) => SizedBox(
                                width: (_categories.length % 2 == 1 &&
                                        _categories.indexOf(category) ==
                                            _categories.length - 1)
                                    ? double.infinity
                                    : (MediaQuery.of(context).size.width - 48) /
                                        2,
                                child: ActionChip(
                                  avatar: Icon(
                                    Icons.book,
                                    size: 18,
                                    color:
                                        const Color.fromARGB(255, 15, 0, 232),
                                  ),
                                  label: Text(
                                    category,
                                    style: TextStyle(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 16,
                                      fontFamily: 'Georgia',
                                    ),
                                  ),
                                  onPressed: () =>
                                      _showCategoryCourses(context, category),
                                  backgroundColor: Colors.deepPurple.shade50,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                ]),
              ),
            ),
            if (_isLoading)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildShimmerEffect(),
                  childCount: 3,
                ),
              )
            else if (_courses.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Text(
                    "No courses available",
                    style: TextStyle(color: Colors.blue.shade900),
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final course = _courses[index];
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.all(8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                course["imageUrl"],
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset('assets/placeholder.png',
                                      height: 120,
                                      width: double.infinity,
                                      fit: BoxFit.cover);
                                },
                                frameBuilder: (context, child, frame,
                                    wasSynchronouslyLoaded) {
                                  return AnimatedOpacity(
                                    opacity: frame == null ? 0 : 1,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeOut,
                                    child: child,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(course["title"],
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Colors.blue.shade900,
                                    )),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.timer,
                                    size: 16, color: Colors.blue.shade700),
                                Text(" ${course["duration"]} Days",
                                    style:
                                        TextStyle(color: Colors.blue.shade700)),
                                const Spacer(),
                                Text("₹${course["price"]}",
                                    style: TextStyle(
                                        color: Colors.green.shade700)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _buildEnrollButton(
                                course["courseId"], course["price"]),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: _courses.length,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showCategoryCourses(BuildContext context, String category) {
    final filteredCourses =
        _courses.where((c) => c["category"] == category).toList();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.blue.shade50],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Makes height dynamic
            children: [
              Text(
                category,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
              ),
              const SizedBox(height: 12),
              Flexible(
                // Ensures it doesn't overflow
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height *
                        0.7, // Max 70% of screen height
                  ),
                  child: ListView.builder(
                    shrinkWrap: true, // Adapts height to content
                    itemCount: filteredCourses.length,
                    itemBuilder: (context, index) {
                      final course = filteredCourses[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        shadowColor: Colors.blue.shade100,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  course["imageUrl"],
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset('assets/placeholder.png',
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover);
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      course["title"],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue.shade900,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "₹${course["price"]}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.blue.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              FilledButton(
                                onPressed: () {
                                  _startPayment(
                                      course["price"], course["courseId"]);
                                },
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.blue.shade900,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                ),
                                child: const Text(
                                  "Enroll",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
