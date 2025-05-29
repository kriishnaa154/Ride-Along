// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_places_flutter/google_places_flutter.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'driver_dashboard.dart'; // Import the driver dashboard page
//
// class DriverHomePage extends StatefulWidget {
//   const DriverHomePage({super.key});
//
//   @override
//   State<DriverHomePage> createState() => _DriverHomePageState();
// }
//
// class _DriverHomePageState extends State<DriverHomePage> {
//   TextEditingController startController = TextEditingController();
//   TextEditingController endController = TextEditingController();
//   TimeOfDay? selectedTime;
//   bool isOnline = false;
//   bool showGreetingCard = false;
//
//   final String googleAPIKey = "AIzaSyDkHTHE8ll2oNXD0_j66gkmrpMW3n1o9hA"; // Replace with your API key
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   void _selectTime(BuildContext context) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (picked != null) {
//       setState(() {
//         selectedTime = picked;
//       });
//     }
//   }
//
//   Future<void> _startRide() async {
//     if (startController.text.isEmpty || endController.text.isEmpty || selectedTime == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please select Start Location, End Location, and Time!")),
//       );
//       return;
//     }
//
//     User? user = _auth.currentUser;
//     if (user == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("User not logged in!")),
//       );
//       return;
//     }
//
//     await FirebaseFirestore.instance.collection('rides').add({
//       'start_location': startController.text,
//       'end_location': endController.text,
//       'time': "${selectedTime!.hour}:${selectedTime!.minute}",
//       'status': 'Available',
//       'timestamp': FieldValue.serverTimestamp(),
//       'driverId': user.uid, // Added driver ID
//     });
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Ride started successfully!")),
//     );
//
//     setState(() {
//       startController.clear();
//       endController.clear();
//       selectedTime = null;
//     });
//   }
//
//   void _onNavTapped(int index) {
//     User? user = _auth.currentUser;
//     if (index == 1 && user != null) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => DriverDash(driverId: user.uid), // ✅ Pass driverId to DriverDash
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFB71C1C),
//         title: const Text("Driver Home", style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//         leading: const Icon(Icons.account_circle, color: Colors.white, size: 30),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             _buildStatusCard(),
//             if (showGreetingCard) _buildGreetingCard(),
//             const SizedBox(height: 16),
//             _buildGooglePlacesTextField(startController, "Start Location"),
//             const SizedBox(height: 12),
//             _buildGooglePlacesTextField(endController, "End Location"),
//             const SizedBox(height: 12),
//             _buildTimePicker(),
//             const SizedBox(height: 16),
//           ],
//         ),
//       ),
//       bottomNavigationBar: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           if (showGreetingCard) _buildStartRideCard(),
//           BottomNavigationBar(
//             currentIndex: 0,
//             selectedItemColor: const Color(0xFFB71C1C),
//             unselectedItemColor: Colors.grey,
//             onTap: _onNavTapped,
//             items: const [
//               BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//               BottomNavigationBarItem(icon: Icon(Icons.request_page), label: "Requests"),
//               BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatusCard() {
//     return Card(
//       elevation: 6,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       color: Colors.white.withOpacity(0.95),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//         child: Row(
//           children: [
//             Icon(
//               isOnline ? Icons.wifi : Icons.wifi_off,
//               color: isOnline ? const Color(0xFFB71C1C) : Colors.grey,
//               size: 28,
//             ),
//             const SizedBox(width: 12),
//             Text(
//               isOnline ? "Online" : "Offline",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//                 color: isOnline ? const Color(0xFFB71C1C) : Colors.grey,
//               ),
//             ),
//             const Spacer(),
//             Switch(
//               value: isOnline,
//               onChanged: (value) {
//                 setState(() {
//                   isOnline = value;
//                   showGreetingCard = value;
//                   if (!isOnline) {
//                     startController.clear();
//                     endController.clear();
//                     selectedTime = null;
//                   }
//                 });
//               },
//               activeColor: const Color(0xFFB71C1C),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildGooglePlacesTextField(TextEditingController controller, String hint) {
//     return GooglePlaceAutoCompleteTextField(
//       textEditingController: controller,
//       googleAPIKey: googleAPIKey,
//       inputDecoration: InputDecoration(
//         labelText: hint,
//         prefixIcon: const Icon(Icons.location_on, color: Color(0xFFB71C1C)),
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
//       ),
//       debounceTime: 800,
//       isLatLngRequired: false,
//       getPlaceDetailWithLatLng: (prediction) {
//         print("Selected Location: ${prediction.description}");
//       },
//       itemClick: (prediction) {
//         controller.text = prediction.description!;
//         FocusScope.of(context).unfocus();
//       },
//     );
//   }
//
//   Widget _buildTimePicker() {
//     return GestureDetector(
//       onTap: () => _selectTime(context),
//       child: InputDecorator(
//         decoration: InputDecoration(
//           labelText: "Trip Start Time",
//           prefixIcon: const Icon(Icons.access_time, color: Color(0xFFB71C1C)),
//           filled: true,
//           fillColor: Colors.white,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
//         ),
//         child: Text(
//           selectedTime != null ? "${selectedTime!.hour}:${selectedTime!.minute}" : "Select Time",
//           style: const TextStyle(fontSize: 16),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildGreetingCard() {
//     return Card(
//       elevation: 4,
//       color: Colors.red.shade50,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       child: const Padding(
//         padding: EdgeInsets.all(14.0),
//         child: Text(
//           "Welcome, Driver! You are now Online.",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStartRideCard() {
//     return Padding(
//       padding: const EdgeInsets.all(12.0),
//       child: ElevatedButton(
//         onPressed: _startRide,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.white,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//           elevation: 4,
//           padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 50),
//         ),
//         child: const Text(
//           "Schedule Ride",
//           style: TextStyle(color: Color(0xFFB71C1C), fontWeight: FontWeight.bold, fontSize: 16),
//         ),
//       ),
//     );
//   }
// }











// ONLINE OFFLINE BUTTON

//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_places_flutter/google_places_flutter.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'driver_dashboard.dart'; // Import the driver dashboard page
//
// class DriverHomePage extends StatefulWidget {
//   const DriverHomePage({super.key});
//
//   @override
//   State<DriverHomePage> createState() => _DriverHomePageState();
// }
//
// class _DriverHomePageState extends State<DriverHomePage> {
//   TextEditingController startController = TextEditingController();
//   TextEditingController endController = TextEditingController();
//   bool isOnline = false;
//   bool showGreetingCard = false;
//
//   final String googleAPIKey = "AIzaSyDkHTHE8ll2oNXD0_j66gkmrpMW3n1o9hA"; // Replace with your API key
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   Future<void> _startRide() async {
//     if (startController.text.isEmpty || endController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please select Start Location and End Location!")),
//       );
//       return;
//     }
//
//     User? user = _auth.currentUser;
//     if (user == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("User not logged in!")),
//       );
//       return;
//     }
//
//     await FirebaseFirestore.instance.collection('rides').add({
//       'start_location': startController.text,
//       'end_location': endController.text,
//       'status': 'Available',
//       'timestamp': FieldValue.serverTimestamp(),
//       'driverId': user.uid, // Added driver ID
//     });
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Ride started successfully!")),
//     );
//
//     setState(() {
//       startController.clear();
//       endController.clear();
//     });
//   }
//
//   void _onNavTapped(int index) {
//     User? user = _auth.currentUser;
//     if (index == 1 && user != null) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => DriverDash(driverId: user.uid), // ✅ Pass driverId to DriverDash
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFB71C1C),
//         title: const Text("Driver Home", style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//         leading: const Icon(Icons.account_circle, color: Colors.white, size: 30),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             _buildStatusCard(),
//             if (showGreetingCard) _buildGreetingCard(),
//             const SizedBox(height: 16),
//             _buildGooglePlacesTextField(startController, "Start Location", isOnline),
//             const SizedBox(height: 12),
//             _buildGooglePlacesTextField(endController, "End Location", isOnline),
//             const SizedBox(height: 16),
//           ],
//         ),
//       ),
//       bottomNavigationBar: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           if (showGreetingCard) _buildStartRideCard(),
//           BottomNavigationBar(
//             currentIndex: 0,
//             selectedItemColor: const Color(0xFFB71C1C),
//             unselectedItemColor: Colors.grey,
//             onTap: _onNavTapped,
//             items: const [
//               BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//               BottomNavigationBarItem(icon: Icon(Icons.request_page), label: "Requests"),
//               BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatusCard() {
//     return Card(
//       elevation: 6,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       color: Colors.white.withOpacity(0.95),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//         child: Row(
//           children: [
//             Icon(
//               isOnline ? Icons.wifi : Icons.wifi_off,
//               color: isOnline ? const Color(0xFFB71C1C) : Colors.grey,
//               size: 28,
//             ),
//             const SizedBox(width: 12),
//             Text(
//               isOnline ? "Online" : "Offline",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//                 color: isOnline ? const Color(0xFFB71C1C) : Colors.grey,
//               ),
//             ),
//             const Spacer(),
//             Switch(
//               value: isOnline,
//               onChanged: (value) {
//                 setState(() {
//                   isOnline = value;
//                   showGreetingCard = value;
//                   if (!isOnline) {
//                     startController.clear();
//                     endController.clear();
//                   }
//                 });
//               },
//               activeColor: const Color(0xFFB71C1C),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildGooglePlacesTextField(TextEditingController controller, String hint, bool isEnabled) {
//     return AbsorbPointer(
//       absorbing: !isEnabled, // Disable interaction when offline
//       child: Opacity(
//         opacity: isEnabled ? 1.0 : 0.5, // Grey out when disabled
//         child: GooglePlaceAutoCompleteTextField(
//           textEditingController: controller,
//           googleAPIKey: googleAPIKey,
//           inputDecoration: InputDecoration(
//             labelText: hint,
//             prefixIcon: const Icon(Icons.location_on, color: Color(0xFFB71C1C)),
//             filled: true,
//             fillColor: Colors.white,
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
//           ),
//           debounceTime: 800,
//           isLatLngRequired: false,
//           getPlaceDetailWithLatLng: (prediction) {
//             print("Selected Location: ${prediction.description}");
//           },
//           itemClick: (prediction) {
//             controller.text = prediction.description!;
//             FocusScope.of(context).unfocus();
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildGreetingCard() {
//     return Card(
//       elevation: 4,
//       color: Colors.red.shade50,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       child: const Padding(
//         padding: EdgeInsets.all(14.0),
//         child: Text(
//           "Welcome, Driver! You are now Online.",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStartRideCard() {
//     return Padding(
//       padding: const EdgeInsets.all(12.0),
//       child: ElevatedButton(
//         onPressed: _startRide,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.white,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//           elevation: 4,
//           padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 50),
//         ),
//         child: const Text(
//           "Schedule Ride",
//           style: TextStyle(color: Color(0xFFB71C1C), fontWeight: FontWeight.bold, fontSize: 16),
//         ),
//       ),
//     );
//   }
// }
//






//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_places_flutter/google_places_flutter.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'driver_dashboard.dart'; // Import the driver dashboard page
//
// class DriverHomePage extends StatefulWidget {
//   const DriverHomePage({super.key});
//
//   @override
//   State<DriverHomePage> createState() => _DriverHomePageState();
// }
//
// class _DriverHomePageState extends State<DriverHomePage> {
//   TextEditingController startController = TextEditingController();
//   TextEditingController endController = TextEditingController();
//   bool isOnline = false;
//   bool showGreetingCard = false;
//
//   final String googleAPIKey = "AIzaSyDkHTHE8ll2oNXD0_j66gkmrpMW3n1o9hA"; // Replace with your API key
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   Future<void> _startRide() async {
//     if (startController.text.isEmpty || endController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please select Start Location and End Location!")),
//       );
//       return;
//     }
//
//     User? user = _auth.currentUser;
//     if (user == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("User not logged in!")),
//       );
//       return;
//     }
//
//     await FirebaseFirestore.instance.collection('rides').add({
//       'start_location': startController.text,
//       'end_location': endController.text,
//       'status': 'Available',
//       'timestamp': FieldValue.serverTimestamp(),
//       'driverId': user.uid, // Added driver ID
//     });
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Ride started successfully!")),
//     );
//
//     setState(() {
//       startController.clear();
//       endController.clear();
//     });
//   }
//
//   void _onNavTapped(int index) {
//     if (index == 1) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const DriverDashboard(), // ✅ Navigate to DriverDashboard
//         ),
//       );
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFB71C1C),
//         title: const Text("Driver Home", style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//         leading: const Icon(Icons.account_circle, color: Colors.white, size: 30),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             _buildStatusCard(),
//             if (showGreetingCard) _buildGreetingCard(),
//             const SizedBox(height: 16),
//             _buildGooglePlacesTextField(startController, "Start Location", isOnline),
//             const SizedBox(height: 12),
//             _buildGooglePlacesTextField(endController, "End Location", isOnline),
//             const SizedBox(height: 16),
//           ],
//         ),
//       ),
//       bottomNavigationBar: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           if (showGreetingCard) _buildStartRideCard(),
//           BottomNavigationBar(
//             currentIndex: 0,
//             selectedItemColor: const Color(0xFFB71C1C),
//             unselectedItemColor: Colors.grey,
//             onTap: _onNavTapped,
//             items: const [
//               BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//               BottomNavigationBarItem(icon: Icon(Icons.request_page), label: "Requests"),
//               BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatusCard() {
//     return Card(
//       elevation: 6,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       color: Colors.white.withOpacity(0.95),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//         child: Row(
//           children: [
//             Icon(
//               isOnline ? Icons.wifi : Icons.wifi_off,
//               color: isOnline ? const Color(0xFFB71C1C) : Colors.grey,
//               size: 28,
//             ),
//             const SizedBox(width: 12),
//             Text(
//               isOnline ? "Online" : "Offline",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//                 color: isOnline ? const Color(0xFFB71C1C) : Colors.grey,
//               ),
//             ),
//             const Spacer(),
//             Switch(
//               value: isOnline,
//               onChanged: (value) {
//                 setState(() {
//                   isOnline = value;
//                   showGreetingCard = value;
//                   if (!isOnline) {
//                     startController.clear();
//                     endController.clear();
//                   }
//                 });
//               },
//               activeColor: const Color(0xFFB71C1C),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildGooglePlacesTextField(TextEditingController controller, String hint, bool isEnabled) {
//     return AbsorbPointer(
//       absorbing: !isEnabled, // Disable interaction when offline
//       child: Opacity(
//         opacity: isEnabled ? 1.0 : 0.5, // Grey out when disabled
//         child: GooglePlaceAutoCompleteTextField(
//           textEditingController: controller,
//           googleAPIKey: googleAPIKey,
//           inputDecoration: InputDecoration(
//             labelText: hint,
//             prefixIcon: const Icon(Icons.location_on, color: Color(0xFFB71C1C)),
//             filled: true,
//             fillColor: Colors.white,
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
//           ),
//           debounceTime: 800,
//           isLatLngRequired: false,
//           getPlaceDetailWithLatLng: (prediction) {
//             print("Selected Location: ${prediction.description}");
//           },
//           itemClick: (prediction) {
//             controller.text = prediction.description!;
//             FocusScope.of(context).unfocus();
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildGreetingCard() {
//     return Card(
//       elevation: 4,
//       color: Colors.red.shade50,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       child: const Padding(
//         padding: EdgeInsets.all(14.0),
//         child: Text(
//           "Welcome, Driver! You are now Online.",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStartRideCard() {
//     return Padding(
//       padding: const EdgeInsets.all(12.0),
//       child: ElevatedButton(
//         onPressed: _startRide,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.white,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//           elevation: 4,
//           padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 50),
//         ),
//         child: const Text(
//           "Schedule Ride",
//           style: TextStyle(color: Color(0xFFB71C1C), fontWeight: FontWeight.bold, fontSize: 16),
//         ),
//       ),
//     );
//   }
// }













// working fine

//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_places_flutter/google_places_flutter.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'driver_dashboard.dart';
//
// class DriverHomePage extends StatefulWidget {
//   const DriverHomePage({super.key});
//
//   @override
//   State<DriverHomePage> createState() => _DriverHomePageState();
// }
//
// class _DriverHomePageState extends State<DriverHomePage> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // ✅ Added key
//   TextEditingController startController = TextEditingController();
//   TextEditingController endController = TextEditingController();
//   bool isOnline = false;
//   bool showGreetingCard = false;
//
//   final String googleAPIKey = "AIzaSyDkHTHE8ll2oNXD0_j66gkmrpMW3n1o9hA"; // Replace with actual key
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   Future<void> _startRide() async {
//     if (startController.text.isEmpty || endController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please select Start Location and End Location!")),
//       );
//       return;
//     }
//
//     User? user = _auth.currentUser;
//     if (user == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("User not logged in!")),
//       );
//       return;
//     }
//
//     await FirebaseFirestore.instance.collection('rides').add({
//       'start_location': startController.text,
//       'end_location': endController.text,
//       'status': 'Available',
//       'timestamp': FieldValue.serverTimestamp(),
//       'driverId': user.uid,
//     });
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Ride started successfully!")),
//     );
//
//     setState(() {
//       startController.clear();
//       endController.clear();
//     });
//   }
//
//   void _onNavTapped(int index) {
//     if (index == 1) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const DriverDashboard(),
//         ),
//       );
//     }
//   }
//
//   void _logout() async {
//     await _auth.signOut();
//     Navigator.pushReplacementNamed(context, '/login');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey, // ✅ Assign the key here
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFB71C1C),
//         title: const Text("Driver Home", style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.account_circle, color: Colors.white, size: 30),
//           onPressed: () => _scaffoldKey.currentState?.openDrawer(), // ✅ Correct way to open drawer
//         ),
//       ),
//       drawer: _buildDrawer(),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             _buildStatusCard(),
//             if (showGreetingCard) _buildGreetingCard(),
//             const SizedBox(height: 16),
//             _buildGooglePlacesTextField(startController, "Start Location", isOnline),
//             const SizedBox(height: 12),
//             _buildGooglePlacesTextField(endController, "End Location", isOnline),
//             const SizedBox(height: 16),
//           ],
//         ),
//       ),
//       bottomNavigationBar: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           if (showGreetingCard) _buildStartRideCard(),
//           BottomNavigationBar(
//             currentIndex: 0,
//             selectedItemColor: const Color(0xFFB71C1C),
//             unselectedItemColor: Colors.grey,
//             onTap: _onNavTapped,
//             items: const [
//               BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//               BottomNavigationBarItem(icon: Icon(Icons.request_page), label: "Requests"),
//               BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDrawer() {
//     return Drawer(
//       child: Column(
//         children: [
//           UserAccountsDrawerHeader(
//             decoration: const BoxDecoration(color: Color(0xFFB71C1C)),
//             accountName: const Text("Driver Name"),
//             accountEmail: const Text("driver@example.com"),
//             currentAccountPicture: const CircleAvatar(
//               backgroundColor: Colors.white,
//               child: Icon(Icons.person, size: 50, color: Colors.black),
//             ),
//           ),
//           ListTile(
//             leading: const Icon(Icons.person),
//             title: const Text("My Details"),
//             onTap: () {
//               Navigator.pop(context);
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.logout, color: Colors.red),
//             title: const Text("Logout", style: TextStyle(color: Colors.red)),
//             onTap: _logout,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatusCard() {
//     return Card(
//       elevation: 6,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       color: Colors.white.withOpacity(0.95),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//         child: Row(
//           children: [
//             Icon(
//               isOnline ? Icons.wifi : Icons.wifi_off,
//               color: isOnline ? const Color(0xFFB71C1C) : Colors.grey,
//               size: 28,
//             ),
//             const SizedBox(width: 12),
//             Text(
//               isOnline ? "Online" : "Offline",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//                 color: isOnline ? const Color(0xFFB71C1C) : Colors.grey,
//               ),
//             ),
//             const Spacer(),
//             Switch(
//               value: isOnline,
//               onChanged: (value) {
//                 setState(() {
//                   isOnline = value;
//                   showGreetingCard = value;
//                   if (!isOnline) {
//                     startController.clear();
//                     endController.clear();
//                   }
//                 });
//               },
//               activeColor: const Color(0xFFB71C1C),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildGooglePlacesTextField(TextEditingController controller, String hint, bool isEnabled) {
//     return AbsorbPointer(
//       absorbing: !isEnabled,
//       child: Opacity(
//         opacity: isEnabled ? 1.0 : 0.5,
//         child: GooglePlaceAutoCompleteTextField(
//           textEditingController: controller,
//           googleAPIKey: googleAPIKey,
//           inputDecoration: InputDecoration(
//             labelText: hint,
//             prefixIcon: const Icon(Icons.location_on, color: Color(0xFFB71C1C)),
//             filled: true,
//             fillColor: Colors.white,
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
//           ),
//           debounceTime: 800,
//           isLatLngRequired: false,
//           getPlaceDetailWithLatLng: (prediction) {
//             print("Selected Location: ${prediction.description}");
//           },
//           itemClick: (prediction) {
//             controller.text = prediction.description!;
//             FocusScope.of(context).unfocus();
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildGreetingCard() {
//     return Card(
//       elevation: 4,
//       color: Colors.red.shade50,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       child: const Padding(
//         padding: EdgeInsets.all(14.0),
//         child: Text(
//           "Welcome, Driver! You are now Online.",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStartRideCard() {
//     return Padding(
//       padding: const EdgeInsets.all(12.0),
//       child: ElevatedButton(
//         onPressed: _startRide,
//         style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
//         child: const Text("Schedule Ride", style: TextStyle(color: Color(0xFFB71C1C))),
//       ),
//     );
//   }
// }
//














































































// WORKING FINE  - 18-04-2025

//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_places_flutter/google_places_flutter.dart';
// import 'driver_dashboard.dart';
// import 'side_drawer.dart'; // ✅ Import the SideDrawer
//
// class DriverHomePage extends StatefulWidget {
//   const DriverHomePage({super.key});
//
//   @override
//   State<DriverHomePage> createState() => _DriverHomePageState();
// }
//
// class _DriverHomePageState extends State<DriverHomePage> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   TextEditingController startController = TextEditingController();
//   TextEditingController endController = TextEditingController();
//   bool isOnline = false;
//   bool showGreetingCard = false;
//
//   final String googleAPIKey = "AIzaSyDkHTHE8ll2oNXD0_j66gkmrpMW3n1o9hA"; // Replace with actual key
//
//   Future<void> _startRide() async {
//     if (startController.text.isEmpty || endController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please select Start Location and End Location!")),
//       );
//       return;
//     }
//
//     User? user = _auth.currentUser;
//     if (user == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("User not logged in!")),
//       );
//       return;
//     }
//
//     await FirebaseFirestore.instance.collection('rides').add({
//       'start_location': startController.text,
//       'end_location': endController.text,
//       'status': 'Available',
//       'timestamp': FieldValue.serverTimestamp(),
//       'driverId': user.uid,
//     });
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Ride started successfully!")),
//     );
//
//     setState(() {
//       startController.clear();
//       endController.clear();
//     });
//   }
//
//   void _onNavTapped(int index) {
//     if (index == 1) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const DriverDashboard(),
//         ),
//       );
//     }
//   }
//
//   void _logout() async {
//     await _auth.signOut();
//     Navigator.pushReplacementNamed(context, '/login');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFB71C1C),
//         title: const Text("Driver Home", style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.account_circle, color: Colors.white, size: 30),
//           onPressed: () => _scaffoldKey.currentState?.openDrawer(),
//         ),
//       ),
//       drawer: SideDrawer(onLogout: _logout), // ✅ Use SideDrawer here
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             _buildStatusCard(),
//             if (showGreetingCard) _buildGreetingCard(),
//             const SizedBox(height: 16),
//             _buildGooglePlacesTextField(startController, "Start Location", isOnline),
//             const SizedBox(height: 12),
//             _buildGooglePlacesTextField(endController, "End Location", isOnline),
//             const SizedBox(height: 16),
//           ],
//         ),
//       ),
//       bottomNavigationBar: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           if (showGreetingCard) _buildStartRideCard(),
//           BottomNavigationBar(
//             currentIndex: 0,
//             selectedItemColor: const Color(0xFFB71C1C),
//             unselectedItemColor: Colors.grey,
//             onTap: _onNavTapped,
//             items: const [
//               BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//               BottomNavigationBarItem(icon: Icon(Icons.request_page), label: "Requests"),
//               BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatusCard() {
//     return Card(
//       elevation: 6,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       color: Colors.white.withOpacity(0.95),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//         child: Row(
//           children: [
//             Icon(
//               isOnline ? Icons.wifi : Icons.wifi_off,
//               color: isOnline ? const Color(0xFFB71C1C) : Colors.grey,
//               size: 28,
//             ),
//             const SizedBox(width: 12),
//             Text(
//               isOnline ? "Online" : "Offline",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//                 color: isOnline ? const Color(0xFFB71C1C) : Colors.grey,
//               ),
//             ),
//             const Spacer(),
//             Switch(
//               value: isOnline,
//               onChanged: (value) {
//                 setState(() {
//                   isOnline = value;
//                   showGreetingCard = value;
//                   if (!isOnline) {
//                     startController.clear();
//                     endController.clear();
//                   }
//                 });
//               },
//               activeColor: const Color(0xFFB71C1C),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildGooglePlacesTextField(TextEditingController controller, String hint, bool isEnabled) {
//     return AbsorbPointer(
//       absorbing: !isEnabled,
//       child: Opacity(
//         opacity: isEnabled ? 1.0 : 0.5,
//         child: GooglePlaceAutoCompleteTextField(
//           textEditingController: controller,
//           googleAPIKey: googleAPIKey,
//           inputDecoration: InputDecoration(
//             labelText: hint,
//             prefixIcon: const Icon(Icons.location_on, color: Color(0xFFB71C1C)),
//             filled: true,
//             fillColor: Colors.white,
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
//           ),
//           debounceTime: 800,
//           isLatLngRequired: false,
//           getPlaceDetailWithLatLng: (prediction) {
//             print("Selected Location: ${prediction.description}");
//           },
//           itemClick: (prediction) {
//             controller.text = prediction.description!;
//             FocusScope.of(context).unfocus();
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildGreetingCard() {
//     return Card(
//       elevation: 4,
//       color: Colors.red.shade50,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       child: const Padding(
//         padding: EdgeInsets.all(14.0),
//         child: Text(
//           "Welcome, Driver! You are now Online.",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStartRideCard() {
//     return Padding(
//       padding: const EdgeInsets.all(12.0),
//       child: ElevatedButton(
//         onPressed: _startRide,
//         style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
//         child: const Text("Schedule Ride", style: TextStyle(color: Color(0xFFB71C1C))),
//       ),
//     );
//   }
// }












import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'driver_dashboard.dart';
import 'side_drawer.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();
  bool isOnline = false;
  bool showGreetingCard = false;

  final String googleAPIKey = "AIzaSyDkHTHE8ll2oNXD0_j66gkmrpMW3n1o9hA";

  Future<void> _startRide() async {
    if (startController.text.isEmpty || endController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select Start Location and End Location!")),
      );
      return;
    }

    User? user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in!")),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('rides').add({
      'start_location': startController.text,
      'end_location': endController.text,
      'status': 'Available',
      'timestamp': FieldValue.serverTimestamp(),
      'driverId': user.uid,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Ride started successfully!")),
    );

    setState(() {
      startController.clear();
      endController.clear();
    });
  }

  void _onNavTapped(int index) {
    if (index == 1) {
      if (!isOnline) {
        _showOfflineDialog();
        return;
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DriverDashboard(),
        ),
      );
    } else if (index == 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("History feature coming soon!")),
      );
    }
  }

  void _logout() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _showOfflineDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        title: Row(
          children: const [
            Icon(Icons.wifi_off, color: Color(0xFFB71C1C)),
            SizedBox(width: 10),
            Text("Offline Mode", style: TextStyle(color: Color(0xFFB71C1C))),
          ],
        ),
        content: const Text(
          "You're currently offline. Please go online to view ride requests.",
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK", style: TextStyle(color: Color(0xFFB71C1C))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xFFB71C1C),
        title: const Text("Driver Home", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.account_circle, color: Colors.white, size: 30),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      drawer: SideDrawer(onLogout: _logout),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildStatusCard(),
            if (showGreetingCard) _buildGreetingCard(),
            const SizedBox(height: 16),
            _buildGooglePlacesTextField(startController, "Start Location", isOnline),
            const SizedBox(height: 12),
            _buildGooglePlacesTextField(endController, "End Location", isOnline),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showGreetingCard) _buildStartRideCard(),
          BottomNavigationBar(
            currentIndex: 0,
            selectedItemColor: const Color(0xFFB71C1C),
            unselectedItemColor: Colors.grey,
            onTap: _onNavTapped,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.request_page), label: "Requests"),
              BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white.withOpacity(0.95),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Icon(
              isOnline ? Icons.wifi : Icons.wifi_off,
              color: isOnline ? const Color(0xFFB71C1C) : Colors.grey,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              isOnline ? "Online" : "Offline",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isOnline ? const Color(0xFFB71C1C) : Colors.grey,
              ),
            ),
            const Spacer(),
            Switch(
              value: isOnline,
              onChanged: (value) {
                setState(() {
                  isOnline = value;
                  showGreetingCard = value;
                  if (!isOnline) {
                    startController.clear();
                    endController.clear();
                  }
                });
              },
              activeColor: const Color(0xFFB71C1C),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGooglePlacesTextField(TextEditingController controller, String hint, bool isEnabled) {
    return AbsorbPointer(
      absorbing: !isEnabled,
      child: Opacity(
        opacity: isEnabled ? 1.0 : 0.5,
        child: GooglePlaceAutoCompleteTextField(
          textEditingController: controller,
          googleAPIKey: googleAPIKey,
          inputDecoration: InputDecoration(
            labelText: hint,
            prefixIcon: const Icon(Icons.location_on, color: Color(0xFFB71C1C)),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          ),
          debounceTime: 800,
          isLatLngRequired: false,
          getPlaceDetailWithLatLng: (prediction) {},
          itemClick: (prediction) {
            controller.text = prediction.description!;
            FocusScope.of(context).unfocus();
          },
        ),
      ),
    );
  }

  Widget _buildGreetingCard() {
    return Card(
      elevation: 4,
      color: Colors.red.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: const Padding(
        padding: EdgeInsets.all(14.0),
        child: Text(
          "Welcome, Driver! You are now Online.",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildStartRideCard() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ElevatedButton(
        onPressed: _startRide,
        style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
        child: const Text("Schedule Ride", style: TextStyle(color: Color(0xFFB71C1C))),
      ),
    );
  }
}
