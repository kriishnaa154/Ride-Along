// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_places_flutter/google_places_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class RiderHomePage extends StatefulWidget {
//   const RiderHomePage({super.key});
//
//   @override
//   State<RiderHomePage> createState() => _RiderHomePageState();
// }
//
// class _RiderHomePageState extends State<RiderHomePage> {
//   TextEditingController pickupController = TextEditingController();
//   TextEditingController dropController = TextEditingController();
//   bool isRequesting = false;
//   String? estimatedFare;
//   String? rideRequestId; // Store the ride request ID for real-time updates
//   String rideStatus = "No ride requested yet.";
//   String? assignedDriverId;
//
//   final String googleAPIKey = "AIzaSyDkHTHE8ll2oNXD0_j66gkmrpMW3n1o9hA"; // Replace with actual API Key
//   String pickupLatLng = "";
//   String dropLatLng = "";
//
//   @override
//   void initState() {
//     super.initState();
//     _listenForRideUpdates(); // Listen for ride status changes
//   }
//
//   void _listenForRideUpdates() {
//     FirebaseFirestore.instance
//         .collection('ride_requests')
//         .where('status', whereIn: ['Pending', 'Matched'])
//         .snapshots()
//         .listen((QuerySnapshot snapshot) {
//       if (snapshot.docs.isNotEmpty) {
//         var rideData = snapshot.docs.first;
//         setState(() {
//           rideRequestId = rideData.id;
//           rideStatus = rideData['status'];
//           assignedDriverId = rideData['driverId'];
//         });
//
//         if (rideStatus == "Matched") {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("A driver has been assigned!")),
//           );
//         }
//       }
//     });
//   }
//
//   void _calculateFare() async {
//     if (pickupLatLng.isEmpty || dropLatLng.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please select valid locations!")),
//       );
//       return;
//     }
//
//     final url =
//         "https://maps.googleapis.com/maps/api/distancematrix/json?origins=$pickupLatLng&destinations=$dropLatLng&key=$googleAPIKey";
//
//     final response = await http.get(Uri.parse(url));
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       if (data["rows"][0]["elements"][0]["status"] == "OK") {
//         int distanceInMeters = data["rows"][0]["elements"][0]["distance"]["value"];
//         double distanceInKm = distanceInMeters / 1000.0;
//
//         // Student fare logic (lower than standard rates)
//         double baseFare = 10.0; // Fixed base fare
//         double perKmRate = 5.0; // Student-friendly rate per km
//         double fare = baseFare + (distanceInKm * perKmRate);
//
//         setState(() {
//           estimatedFare = "₹${fare.toStringAsFixed(2)}";
//         });
//       } else {
//         setState(() {
//           estimatedFare = "Error calculating fare";
//         });
//       }
//     } else {
//       setState(() {
//         estimatedFare = "API Error";
//       });
//     }
//   }
//
//   Future<void> _requestRide() async {
//     if (pickupController.text.isEmpty ||
//         dropController.text.isEmpty ||
//         estimatedFare == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter valid details!")),
//       );
//       return;
//     }
//
//     setState(() {
//       isRequesting = true;
//     });
//
//     DocumentReference rideRef =
//         await FirebaseFirestore.instance.collection('ride_requests').add({
//       'pickup': pickupController.text,
//       'drop': dropController.text,
//       'fare': estimatedFare,
//       'status': 'Pending',
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//
//     setState(() {
//       rideRequestId = rideRef.id;
//       rideStatus = "Pending";
//       isRequesting = false;
//       pickupController.clear();
//       dropController.clear();
//       estimatedFare = null;
//     });
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Ride request sent!")),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF1565C0),
//         title: const Text("Rider Home", style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//         leading: const Icon(Icons.person, color: Colors.white, size: 30),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             _buildGooglePlacesTextField(pickupController, "Pickup Location", true),
//             const SizedBox(height: 12),
//             _buildGooglePlacesTextField(dropController, "Drop Location", false),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _calculateFare,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//                 padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 50),
//               ),
//               child: const Text(
//                 "Calculate Fare",
//                 style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(height: 12),
//             if (estimatedFare != null)
//               Text(
//                 "Estimated Fare: $estimatedFare",
//                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
//               ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: isRequesting ? null : _requestRide,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 50),
//               ),
//               child: isRequesting
//                   ? const CircularProgressIndicator(color: Colors.white)
//                   : const Text(
//                       "Request Ride",
//                       style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//             ),
//             const SizedBox(height: 20),
//             _buildRideStatusWidget(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildRideStatusWidget() {
//     return Column(
//       children: [
//         Text(
//           "Ride Status: $rideStatus",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
//         ),
//         if (assignedDriverId != null)
//           Text(
//             "Driver ID: $assignedDriverId",
//             style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green),
//           ),
//       ],
//     );
//   }
//
//   Widget _buildGooglePlacesTextField(TextEditingController controller, String hint, bool isPickup) {
//     return GooglePlaceAutoCompleteTextField(
//       textEditingController: controller,
//       googleAPIKey: googleAPIKey,
//       inputDecoration: InputDecoration(
//         labelText: hint,
//         prefixIcon: const Icon(Icons.location_on, color: Color(0xFF1565C0)),
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
//       ),
//       debounceTime: 800,
//       isLatLngRequired: true,
//       getPlaceDetailWithLatLng: (prediction) {
//         if (isPickup) {
//           pickupLatLng = "${prediction.lat},${prediction.lng}";
//         } else {
//           dropLatLng = "${prediction.lat},${prediction.lng}";
//         }
//       },
//       itemClick: (prediction) {
//         controller.text = prediction.description!;
//         FocusScope.of(context).unfocus();
//       },
//     );
//   }
// }


//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//




//USER ID STORED IN DB
//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_places_flutter/google_places_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class RiderHomePage extends StatefulWidget {
//   const RiderHomePage({super.key});
//
//   @override
//   State<RiderHomePage> createState() => _RiderHomePageState();
// }
//
// class _RiderHomePageState extends State<RiderHomePage> {
//   TextEditingController pickupController = TextEditingController();
//   TextEditingController dropController = TextEditingController();
//   bool isRequesting = false;
//   String? estimatedFare;
//   String? rideRequestId;
//   String rideStatus = "No ride requested yet.";
//   String? assignedDriverId;
//   String? userId;
//
//   final String googleAPIKey = "AIzaSyDkHTHE8ll2oNXD0_j66gkmrpMW3n1o9hA"; // Replace with actual API Key
//   String pickupLatLng = "";
//   String dropLatLng = "";
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentUser();
//     _listenForRideUpdates();
//   }
//
//   void _getCurrentUser() {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       setState(() {
//         userId = user.uid; // Fetch the currently logged-in user's ID
//       });
//     }
//   }
//
//   void _listenForRideUpdates() {
//     FirebaseFirestore.instance
//         .collection('ride_requests')
//         .where('status', whereIn: ['Pending', 'Matched'])
//         .snapshots()
//         .listen((QuerySnapshot snapshot) {
//       if (snapshot.docs.isNotEmpty) {
//         var rideData = snapshot.docs.first;
//         setState(() {
//           rideRequestId = rideData.id;
//           rideStatus = rideData['status'];
//           assignedDriverId = rideData['driverId'];
//         });
//
//         if (rideStatus == "Matched") {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("A driver has been assigned!")),
//           );
//         }
//       }
//     });
//   }
//
//   void _calculateFare() async {
//     if (pickupLatLng.isEmpty || dropLatLng.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please select valid locations!")),
//       );
//       return;
//     }
//
//     final url =
//         "https://maps.googleapis.com/maps/api/distancematrix/json?origins=$pickupLatLng&destinations=$dropLatLng&key=$googleAPIKey";
//
//     final response = await http.get(Uri.parse(url));
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       if (data["rows"][0]["elements"][0]["status"] == "OK") {
//         int distanceInMeters = data["rows"][0]["elements"][0]["distance"]["value"];
//         double distanceInKm = distanceInMeters / 1000.0;
//
//         double baseFare = 10.0;
//         double perKmRate = 5.0;
//         double fare = baseFare + (distanceInKm * perKmRate);
//
//         setState(() {
//           estimatedFare = "₹${fare.toStringAsFixed(2)}";
//         });
//       } else {
//         setState(() {
//           estimatedFare = "Error calculating fare";
//         });
//       }
//     } else {
//       setState(() {
//         estimatedFare = "API Error";
//       });
//     }
//   }
//
//   Future<void> _requestRide() async {
//     if (pickupController.text.isEmpty ||
//         dropController.text.isEmpty ||
//         estimatedFare == null ||
//         userId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter valid details!")),
//       );
//       return;
//     }
//
//     setState(() {
//       isRequesting = true;
//     });
//
//     DocumentReference rideRef =
//     await FirebaseFirestore.instance.collection('ride_requests').add({
//       'userId': userId, // Store the user ID of the requester
//       'pickup': pickupController.text,
//       'drop': dropController.text,
//       'fare': estimatedFare,
//       'status': 'Pending',
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//
//     setState(() {
//       rideRequestId = rideRef.id;
//       rideStatus = "Pending";
//       isRequesting = false;
//       pickupController.clear();
//       dropController.clear();
//       estimatedFare = null;
//     });
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Ride request sent!")),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF1565C0),
//         title: const Text("Rider Home", style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//         leading: const Icon(Icons.person, color: Colors.white, size: 30),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             _buildGooglePlacesTextField(pickupController, "Pickup Location", true),
//             const SizedBox(height: 12),
//             _buildGooglePlacesTextField(dropController, "Drop Location", false),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _calculateFare,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//                 padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 50),
//               ),
//               child: const Text(
//                 "Calculate Fare",
//                 style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(height: 12),
//             if (estimatedFare != null)
//               Text(
//                 "Estimated Fare: $estimatedFare",
//                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
//               ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: isRequesting ? null : _requestRide,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 50),
//               ),
//               child: isRequesting
//                   ? const CircularProgressIndicator(color: Colors.white)
//                   : const Text(
//                 "Request Ride",
//                 style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(height: 20),
//             _buildRideStatusWidget(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildRideStatusWidget() {
//     return Column(
//       children: [
//         Text(
//           "Ride Status: $rideStatus",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
//         ),
//         if (assignedDriverId != null)
//           Text(
//             "Driver ID: $assignedDriverId",
//             style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green),
//           ),
//       ],
//     );
//   }
//
//   Widget _buildGooglePlacesTextField(TextEditingController controller, String hint, bool isPickup) {
//     return GooglePlaceAutoCompleteTextField(
//       textEditingController: controller,
//       googleAPIKey: googleAPIKey,
//       inputDecoration: InputDecoration(
//         labelText: hint,
//         prefixIcon: const Icon(Icons.location_on, color: Color(0xFF1565C0)),
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
//       ),
//       debounceTime: 800,
//       isLatLngRequired: true,
//       getPlaceDetailWithLatLng: (prediction) {
//         if (isPickup) {
//           pickupLatLng = "${prediction.lat},${prediction.lng}";
//         } else {
//           dropLatLng = "${prediction.lat},${prediction.lng}";
//         }
//       },
//       itemClick: (prediction) {
//         controller.text = prediction.description!;
//         FocusScope.of(context).unfocus();
//       },
//     );
//   }
// }










//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_places_flutter/google_places_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'rider_summary_card.dart'; // Import the RiderSummaryCard file
//
// class RiderHomePage extends StatefulWidget {
//   const RiderHomePage({super.key});
//
//   @override
//   State<RiderHomePage> createState() => _RiderHomePageState();
// }
//
// class _RiderHomePageState extends State<RiderHomePage> {
//   TextEditingController pickupController = TextEditingController();
//   TextEditingController dropController = TextEditingController();
//   bool isRequesting = false;
//   String? estimatedFare;
//   String? rideRequestId;
//   String rideStatus = "No ride requested yet.";
//   String? assignedDriverId;
//   String? userId;
//
//   final String googleAPIKey = "AIzaSyDkHTHE8ll2oNXD0_j66gkmrpMW3n1o9hA"; // Replace with actual API Key
//   String pickupLatLng = "";
//   String dropLatLng = "";
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentUser();
//     _listenForRideUpdates();
//   }
//
//   void _getCurrentUser() {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       setState(() {
//         userId = user.uid;
//       });
//     }
//   }
//
//   void _listenForRideUpdates() {
//     if (userId == null) return;
//     FirebaseFirestore.instance
//         .collection('ride_requests')
//         .where('userId', isEqualTo: userId)
//         .orderBy('timestamp', descending: true)
//         .snapshots()
//         .listen((QuerySnapshot snapshot) {
//       if (snapshot.docs.isNotEmpty) {
//         var rideData = snapshot.docs.first;
//         setState(() {
//           rideRequestId = rideData.id;
//           rideStatus = rideData['status'];
//           assignedDriverId = rideData['driverId'];
//         });
//       }
//     });
//   }
//
//   void _calculateFare() async {
//     if (pickupLatLng.isEmpty || dropLatLng.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please select valid locations!")),
//       );
//       return;
//     }
//
//     final url =
//         "https://maps.googleapis.com/maps/api/distancematrix/json?origins=$pickupLatLng&destinations=$dropLatLng&key=$googleAPIKey";
//
//     final response = await http.get(Uri.parse(url));
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       if (data["rows"][0]["elements"][0]["status"] == "OK") {
//         int distanceInMeters = data["rows"][0]["elements"][0]["distance"]["value"];
//         double distanceInKm = distanceInMeters / 1000.0;
//
//         double baseFare = 10.0;
//         double perKmRate = 5.0;
//         double fare = baseFare + (distanceInKm * perKmRate);
//
//         setState(() {
//           estimatedFare = "₹${fare.toStringAsFixed(2)}";
//         });
//       } else {
//         setState(() {
//           estimatedFare = "Error calculating fare";
//         });
//       }
//     } else {
//       setState(() {
//         estimatedFare = "API Error";
//       });
//     }
//   }
//
//   Future<void> _requestRide() async {
//     if (pickupController.text.isEmpty ||
//         dropController.text.isEmpty ||
//         estimatedFare == null ||
//         userId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter valid details!")),
//       );
//       return;
//     }
//
//     setState(() {
//       isRequesting = true;
//     });
//
//     DocumentReference rideRef =
//     await FirebaseFirestore.instance.collection('ride_requests').add({
//       'userId': userId,
//       'pickup': pickupController.text,
//       'drop': dropController.text,
//       'fare': estimatedFare,
//       'status': 'Pending',
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//
//     setState(() {
//       rideRequestId = rideRef.id;
//       rideStatus = "Pending";
//       isRequesting = false;
//       pickupController.clear();
//       dropController.clear();
//       estimatedFare = null;
//     });
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Ride request sent!")),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF1565C0),
//         title: const Text("Rider Home", style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//         leading: const Icon(Icons.person, color: Colors.white, size: 30),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   _buildGooglePlacesTextField(pickupController, "Pickup Location", true),
//                   const SizedBox(height: 12),
//                   _buildGooglePlacesTextField(dropController, "Drop Location", false),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: _calculateFare,
//                     style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                     child: const Text("Calculate Fare"),
//                   ),
//                   const SizedBox(height: 12),
//                   if (estimatedFare != null)
//                     Text(
//                       "Estimated Fare: $estimatedFare",
//                       style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: isRequesting ? null : _requestRide,
//                     style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//                     child: isRequesting
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : const Text("Request Ride"),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           if (rideRequestId != null)
//             RiderSummaryCard(rideRequestId: rideRequestId!), // Show RiderSummaryCard
//         ],
//       ),
//     );
//   }
//
//   Widget _buildGooglePlacesTextField(TextEditingController controller, String hint, bool isPickup) {
//     return GooglePlaceAutoCompleteTextField(
//       textEditingController: controller,
//       googleAPIKey: googleAPIKey,
//       inputDecoration: InputDecoration(
//         labelText: hint,
//         prefixIcon: const Icon(Icons.location_on, color: Color(0xFF1565C0)),
//         filled: true,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
//       ),
//       debounceTime: 800,
//       isLatLngRequired: true,
//       getPlaceDetailWithLatLng: (prediction) {
//         if (isPickup) {
//           pickupLatLng = "${prediction.lat},${prediction.lng}";
//         } else {
//           dropLatLng = "${prediction.lat},${prediction.lng}";
//         }
//       },
//       itemClick: (prediction) {
//         controller.text = prediction.description!;
//         FocusScope.of(context).unfocus();
//       },
//     );
//   }
// }
//







//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_places_flutter/google_places_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'rider_summary_card.dart';
//
// class RiderHomePage extends StatefulWidget {
//   const RiderHomePage({super.key});
//
//   @override
//   State<RiderHomePage> createState() => _RiderHomePageState();
// }
//
// class _RiderHomePageState extends State<RiderHomePage> {
//   TextEditingController pickupController = TextEditingController();
//   TextEditingController dropController = TextEditingController();
//   bool isRequesting = false;
//   String? estimatedFare;
//   String? rideRequestId;
//   String rideStatus = "No ride requested yet.";
//   String? assignedDriverId;
//   String? userId;
//
//   final String googleAPIKey = "AIzaSyDkHTHE8ll2oNXD0_j66gkmrpMW3n1o9hA"; // Replace with actual API Key
//   String pickupLatLng = "";
//   String dropLatLng = "";
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentUser();
//   }
//
//   void _getCurrentUser() {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       setState(() {
//         userId = user.uid;
//       });
//       _listenForRideUpdates(); // Start listening after fetching userId
//     }
//   }
//
//   void _listenForRideUpdates() {
//     if (userId == null) return;
//
//     FirebaseFirestore.instance
//         .collection('ride_requests')
//         .where('userId', isEqualTo: userId)
//         .orderBy('timestamp', descending: true)
//         .limit(1) // Fetch only the latest ride request
//         .snapshots()
//         .listen((QuerySnapshot snapshot) {
//       if (snapshot.docs.isNotEmpty) {
//         var rideData = snapshot.docs.first;
//         setState(() {
//           rideRequestId = rideData.id;
//           rideStatus = rideData['status'];
//           assignedDriverId = rideData['driverId'];
//         });
//       } else {
//         setState(() {
//           rideRequestId = null; // No active ride request
//         });
//       }
//     });
//   }
//
//   void _calculateFare() async {
//     if (pickupLatLng.isEmpty || dropLatLng.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please select valid locations!")),
//       );
//       return;
//     }
//
//     final url =
//         "https://maps.googleapis.com/maps/api/distancematrix/json?origins=$pickupLatLng&destinations=$dropLatLng&key=$googleAPIKey";
//
//     final response = await http.get(Uri.parse(url));
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       if (data["rows"][0]["elements"][0]["status"] == "OK") {
//         int distanceInMeters = data["rows"][0]["elements"][0]["distance"]["value"];
//         double distanceInKm = distanceInMeters / 1000.0;
//
//         double baseFare = 10.0;
//         double perKmRate = 5.0;
//         double fare = baseFare + (distanceInKm * perKmRate);
//
//         setState(() {
//           estimatedFare = "₹${fare.toStringAsFixed(2)}";
//         });
//       } else {
//         setState(() {
//           estimatedFare = "Error calculating fare";
//         });
//       }
//     } else {
//       setState(() {
//         estimatedFare = "API Error";
//       });
//     }
//   }
//
//   Future<void> _requestRide() async {
//     if (pickupController.text.isEmpty ||
//         dropController.text.isEmpty ||
//         estimatedFare == null ||
//         userId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter valid details!")),
//       );
//       return;
//     }
//
//     setState(() {
//       isRequesting = true;
//     });
//
//     DocumentReference rideRef =
//     await FirebaseFirestore.instance.collection('ride_requests').add({
//       'userId': userId,
//       'pickup': pickupController.text,
//       'drop': dropController.text,
//       'fare': estimatedFare,
//       'status': 'Pending',
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//
//     setState(() {
//       rideRequestId = rideRef.id; // Set the new rideRequestId
//       rideStatus = "Pending";
//       isRequesting = false;
//       pickupController.clear();
//       dropController.clear();
//       estimatedFare = null;
//     });
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Ride request sent!")),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF1565C0),
//         title: const Text("Rider Home", style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//         leading: const Icon(Icons.person, color: Colors.white, size: 30),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   _buildGooglePlacesTextField(pickupController, "Pickup Location", true),
//                   const SizedBox(height: 12),
//                   _buildGooglePlacesTextField(dropController, "Drop Location", false),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: _calculateFare,
//                     style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                     child: const Text("Calculate Fare"),
//                   ),
//                   const SizedBox(height: 12),
//                   if (estimatedFare != null)
//                     Text(
//                       "Estimated Fare: $estimatedFare",
//                       style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: isRequesting ? null : _requestRide,
//                     style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//                     child: isRequesting
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : const Text("Request Ride"),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           if (rideRequestId != null) RiderSummaryCard(rideRequestId: rideRequestId!), // Show RiderSummaryCard
//         ],
//       ),
//     );
//   }
//
//   Widget _buildGooglePlacesTextField(TextEditingController controller, String hint, bool isPickup) {
//     return GooglePlaceAutoCompleteTextField(
//       textEditingController: controller,
//       googleAPIKey: googleAPIKey,
//       inputDecoration: InputDecoration(
//         labelText: hint,
//         prefixIcon: const Icon(Icons.location_on, color: Color(0xFF1565C0)),
//         filled: true,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
//       ),
//       debounceTime: 800,
//       isLatLngRequired: true,
//       getPlaceDetailWithLatLng: (prediction) {
//         if (isPickup) {
//           pickupLatLng = "${prediction.lat},${prediction.lng}";
//         } else {
//           dropLatLng = "${prediction.lat},${prediction.lng}";
//         }
//       },
//       itemClick: (prediction) {
//         controller.text = prediction.description!;
//         FocusScope.of(context).unfocus();
//       },
//     );
//   }
// }
//










// WORKING FINE 1

//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_places_flutter/google_places_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'rider_summary_card.dart';
//
// class RiderHomePage extends StatefulWidget {
//   const RiderHomePage({super.key});
//
//   @override
//   State<RiderHomePage> createState() => _RiderHomePageState();
// }
//
// class _RiderHomePageState extends State<RiderHomePage> {
//   TextEditingController pickupController = TextEditingController();
//   TextEditingController dropController = TextEditingController();
//   bool isRequesting = false;
//   String? estimatedFare;
//   String? rideRequestId;
//   String rideStatus = "No ride requested yet.";
//   String? assignedDriverId;
//   String? userId;
//
//   final String googleAPIKey = "AIzaSyDkHTHE8ll2oNXD0_j66gkmrpMW3n1o9hA"; // Replace with actual API Key
//   String pickupLatLng = "";
//   String dropLatLng = "";
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentUser();
//   }
//
//   void _getCurrentUser() {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       setState(() {
//         userId = user.uid;
//       });
//       _listenForRideUpdates();
//     }
//   }
//
//   void _listenForRideUpdates() {
//     if (userId == null) return;
//
//     FirebaseFirestore.instance
//         .collection('ride_requests')
//         .where('userId', isEqualTo: userId)
//         .orderBy('timestamp', descending: true)
//         .limit(1)
//         .snapshots()
//         .listen((QuerySnapshot snapshot) {
//       if (snapshot.docs.isNotEmpty) {
//         var rideData = snapshot.docs.first;
//         setState(() {
//           rideRequestId = rideData.id;
//           rideStatus = rideData['status'];
//           assignedDriverId = rideData['driverId'];
//         });
//       } else {
//         setState(() {
//           rideRequestId = null;
//         });
//       }
//     });
//   }
//
//   void _calculateFare() async {
//     if (pickupLatLng.isEmpty || dropLatLng.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please select valid locations!")),
//       );
//       return;
//     }
//
//     final url =
//         "https://maps.googleapis.com/maps/api/distancematrix/json?origins=$pickupLatLng&destinations=$dropLatLng&key=$googleAPIKey";
//
//     final response = await http.get(Uri.parse(url));
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       if (data["rows"][0]["elements"][0]["status"] == "OK") {
//         int distanceInMeters = data["rows"][0]["elements"][0]["distance"]["value"];
//         double distanceInKm = distanceInMeters / 1000.0;
//
//         double baseFare = 10.0;
//         double perKmRate = 5.0;
//         double fare = baseFare + (distanceInKm * perKmRate);
//
//         setState(() {
//           estimatedFare = "₹${fare.toStringAsFixed(2)}";
//         });
//       } else {
//         setState(() {
//           estimatedFare = "Error calculating fare";
//         });
//       }
//     } else {
//       setState(() {
//         estimatedFare = "API Error";
//       });
//     }
//   }
//
//   Future<void> _requestRide() async {
//     if (pickupController.text.isEmpty ||
//         dropController.text.isEmpty ||
//         estimatedFare == null ||
//         userId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter valid details!")),
//       );
//       return;
//     }
//
//     setState(() {
//       isRequesting = true;
//       rideRequestId = null;
//     });
//
//     DocumentReference rideRef =
//     await FirebaseFirestore.instance.collection('ride_requests').add({
//       'userId': userId,
//       'pickup': pickupController.text,
//       'drop': dropController.text,
//       'fare': estimatedFare,
//       'status': 'Pending',
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//
//     setState(() {
//       rideRequestId = rideRef.id;
//       rideStatus = "Pending";
//       isRequesting = false;
//       pickupController.clear();
//       dropController.clear();
//       estimatedFare = null;
//     });
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Ride request sent!")),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF1565C0),
//         title: const Text("Rider Home", style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//         leading: const Icon(Icons.person, color: Colors.white, size: 30),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   _buildGooglePlacesTextField(pickupController, "Pickup Location", true),
//                   const SizedBox(height: 12),
//                   _buildGooglePlacesTextField(dropController, "Drop Location", false),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: _calculateFare,
//                     style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                     child: const Text("Calculate Fare"),
//                   ),
//                   const SizedBox(height: 12),
//                   if (estimatedFare != null)
//                     Text(
//                       "Estimated Fare: $estimatedFare",
//                       style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: isRequesting ? null : _requestRide,
//                     style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//                     child: isRequesting
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : const Text("Request Ride"),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           if (rideRequestId != null && rideStatus != 'Cancelled')
//             RiderSummaryCard(rideRequestId: rideRequestId!),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildGooglePlacesTextField(TextEditingController controller, String hint, bool isPickup) {
//     return GooglePlaceAutoCompleteTextField(
//       textEditingController: controller,
//       googleAPIKey: googleAPIKey,
//       inputDecoration: InputDecoration(
//         labelText: hint,
//         prefixIcon: const Icon(Icons.location_on, color: Color(0xFF1565C0)),
//         filled: true,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
//       ),
//       debounceTime: 800,
//       isLatLngRequired: true,
//       getPlaceDetailWithLatLng: (prediction) {
//         if (isPickup) {
//           pickupLatLng = "${prediction.lat},${prediction.lng}";
//         } else {
//           dropLatLng = "${prediction.lat},${prediction.lng}";
//         }
//       },
//       itemClick: (prediction) {
//         controller.text = prediction.description!;
//         FocusScope.of(context).unfocus();
//       },
//     );
//   }
// }
//
//



// bottom overflow solved working fine
//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_places_flutter/google_places_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'rider_summary_card.dart';
//
// class RiderHomePage extends StatefulWidget {
//   const RiderHomePage({super.key});
//
//   @override
//   State<RiderHomePage> createState() => _RiderHomePageState();
// }
//
// class _RiderHomePageState extends State<RiderHomePage> {
//   TextEditingController pickupController = TextEditingController();
//   TextEditingController dropController = TextEditingController();
//   bool isRequesting = false;
//   String? estimatedFare;
//   String? rideRequestId;
//   String rideStatus = "No ride requested yet.";
//   String? assignedDriverId;
//   String? userId;
//
//   final String googleAPIKey = "AIzaSyDkHTHE8ll2oNXD0_j66gkmrpMW3n1o9hA"; // Replace with actual API Key
//   String pickupLatLng = "";
//   String dropLatLng = "";
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentUser();
//   }
//
//   void _getCurrentUser() {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       setState(() {
//         userId = user.uid;
//       });
//       _listenForRideUpdates();
//     }
//   }
//
//   void _listenForRideUpdates() {
//     if (userId == null) return;
//
//     FirebaseFirestore.instance
//         .collection('ride_requests')
//         .where('userId', isEqualTo: userId)
//         .orderBy('timestamp', descending: true)
//         .limit(1)
//         .snapshots()
//         .listen((QuerySnapshot snapshot) {
//       if (snapshot.docs.isNotEmpty) {
//         var rideData = snapshot.docs.first;
//         setState(() {
//           rideRequestId = rideData.id;
//           rideStatus = rideData['status'];
//           assignedDriverId = rideData['driverId'];
//         });
//       } else {
//         setState(() {
//           rideRequestId = null;
//         });
//       }
//     });
//   }
//
//   void _calculateFare() async {
//     if (pickupLatLng.isEmpty || dropLatLng.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please select valid locations!")),
//       );
//       return;
//     }
//
//     final url =
//         "https://maps.googleapis.com/maps/api/distancematrix/json?origins=$pickupLatLng&destinations=$dropLatLng&key=$googleAPIKey";
//
//     final response = await http.get(Uri.parse(url));
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       if (data["rows"][0]["elements"][0]["status"] == "OK") {
//         int distanceInMeters = data["rows"][0]["elements"][0]["distance"]["value"];
//         double distanceInKm = distanceInMeters / 1000.0;
//
//         double baseFare = 10.0;
//         double perKmRate = 5.0;
//         double fare = baseFare + (distanceInKm * perKmRate);
//
//         setState(() {
//           estimatedFare = "₹${fare.toStringAsFixed(2)}";
//         });
//       } else {
//         setState(() {
//           estimatedFare = "Error calculating fare";
//         });
//       }
//     } else {
//       setState(() {
//         estimatedFare = "API Error";
//       });
//     }
//   }
//
//   Future<void> _requestRide() async {
//     if (pickupController.text.isEmpty ||
//         dropController.text.isEmpty ||
//         estimatedFare == null ||
//         userId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter valid details!")),
//       );
//       return;
//     }
//
//     setState(() {
//       isRequesting = true;
//       rideRequestId = null;
//     });
//
//     DocumentReference rideRef =
//     await FirebaseFirestore.instance.collection('ride_requests').add({
//       'userId': userId,
//       'pickup': pickupController.text,
//       'drop': dropController.text,
//       'fare': estimatedFare,
//       'status': 'Pending',
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//
//     setState(() {
//       rideRequestId = rideRef.id;
//       rideStatus = "Pending";
//       isRequesting = false;
//       pickupController.clear();
//       dropController.clear();
//       estimatedFare = null;
//     });
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Ride request sent!")),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF1565C0),
//         title: const Text("Rider Home", style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//         leading: const Icon(Icons.person, color: Colors.white, size: 30),
//       ),
//       body: SingleChildScrollView( // Added to prevent overflow
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   _buildGooglePlacesTextField(pickupController, "Pickup Location", true),
//                   const SizedBox(height: 12),
//                   _buildGooglePlacesTextField(dropController, "Drop Location", false),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: _calculateFare,
//                     style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                     child: const Text("Calculate Fare"),
//                   ),
//                   const SizedBox(height: 12),
//                   if (estimatedFare != null)
//                     Text(
//                       "Estimated Fare: $estimatedFare",
//                       style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: isRequesting ? null : _requestRide,
//                     style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//                     child: isRequesting
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : const Text("Request Ride"),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 50), // to move card top and bottom
//             if (rideRequestId != null && rideStatus != 'Cancelled')
//               RiderSummaryCard(rideRequestId: rideRequestId!),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildGooglePlacesTextField(TextEditingController controller, String hint, bool isPickup) {
//     return GooglePlaceAutoCompleteTextField(
//       textEditingController: controller,
//       googleAPIKey: googleAPIKey,
//       inputDecoration: InputDecoration(
//         labelText: hint,
//         prefixIcon: const Icon(Icons.location_on, color: Color(0xFF1565C0)),
//         filled: true,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
//       ),
//       debounceTime: 800,
//       isLatLngRequired: true,
//       getPlaceDetailWithLatLng: (prediction) {
//         if (isPickup) {
//           pickupLatLng = "${prediction.lat},${prediction.lng}";
//         } else {
//           dropLatLng = "${prediction.lat},${prediction.lng}";
//         }
//       },
//       itemClick: (prediction) {
//         controller.text = prediction.description!;
//         FocusScope.of(context).unfocus();
//       },
//     );
//   }
// }













// working fine


//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_places_flutter/google_places_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'rider_summary_card.dart';
// import 'rider_history.dart'; // Import My Rides page
//
// class RiderHomePage extends StatefulWidget {
//   const RiderHomePage({super.key});
//
//   @override
//   State<RiderHomePage> createState() => _RiderHomePageState();
// }
//
// class _RiderHomePageState extends State<RiderHomePage> {
//   TextEditingController pickupController = TextEditingController();
//   TextEditingController dropController = TextEditingController();
//   bool isRequesting = false;
//   String? estimatedFare;
//   String? rideRequestId;
//   String rideStatus = "No ride requested yet.";
//   String? assignedDriverId;
//   String? userId;
//
//   final String googleAPIKey = "AIzaSyDkHTHE8ll2oNXD0_j66gkmrpMW3n1o9hA"; // Replace with actual API Key
//   String pickupLatLng = "";
//   String dropLatLng = "";
//
//   int _selectedIndex = 0; // Bottom Navigation index
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentUser();
//   }
//
//   void _getCurrentUser() {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       setState(() {
//         userId = user.uid;
//       });
//       _listenForRideUpdates();
//     }
//   }
//
//   void _listenForRideUpdates() {
//     if (userId == null) return;
//
//     FirebaseFirestore.instance
//         .collection('ride_requests')
//         .where('userId', isEqualTo: userId)
//         .orderBy('timestamp', descending: true)
//         .limit(1)
//         .snapshots()
//         .listen((QuerySnapshot snapshot) {
//       if (snapshot.docs.isNotEmpty) {
//         var rideData = snapshot.docs.first;
//         setState(() {
//           rideRequestId = rideData.id;
//           rideStatus = rideData['status'];
//           assignedDriverId = rideData['driverId'];
//         });
//       } else {
//         setState(() {
//           rideRequestId = null;
//         });
//       }
//     });
//   }
//
//   void _calculateFare() async {
//     if (pickupLatLng.isEmpty || dropLatLng.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please select valid locations!")),
//       );
//       return;
//     }
//
//     final url =
//         "https://maps.googleapis.com/maps/api/distancematrix/json?origins=$pickupLatLng&destinations=$dropLatLng&key=$googleAPIKey";
//
//     final response = await http.get(Uri.parse(url));
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       if (data["rows"][0]["elements"][0]["status"] == "OK") {
//         int distanceInMeters = data["rows"][0]["elements"][0]["distance"]["value"];
//         double distanceInKm = distanceInMeters / 1000.0;
//
//         double baseFare = 10.0;
//         double perKmRate = 5.0;
//         double fare = baseFare + (distanceInKm * perKmRate);
//
//         setState(() {
//           estimatedFare = "₹${fare.toStringAsFixed(2)}";
//         });
//       } else {
//         setState(() {
//           estimatedFare = "Error calculating fare";
//         });
//       }
//     } else {
//       setState(() {
//         estimatedFare = "API Error";
//       });
//     }
//   }
//
//   Future<void> _requestRide() async {
//     if (pickupController.text.isEmpty ||
//         dropController.text.isEmpty ||
//         estimatedFare == null ||
//         userId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter valid details!")),
//       );
//       return;
//     }
//
//     setState(() {
//       isRequesting = true;
//       rideRequestId = null;
//     });
//
//     DocumentReference rideRef =
//     await FirebaseFirestore.instance.collection('ride_requests').add({
//       'userId': userId,
//       'pickup': pickupController.text,
//       'drop': dropController.text,
//       'fare': estimatedFare,
//       'status': 'Pending',
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//
//     setState(() {
//       rideRequestId = rideRef.id;
//       rideStatus = "Pending";
//       isRequesting = false;
//       pickupController.clear();
//       dropController.clear();
//       estimatedFare = null;
//     });
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Ride request sent!")),
//     );
//   }
//
//   void _onNavItemTapped(int index) {
//     if (index == 1) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const RiderHistoryPage()),
//       );
//     } else {
//       setState(() {
//         _selectedIndex = index;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF1565C0),
//         title: const Text("Rider Home", style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//         leading: const Icon(Icons.person, color: Colors.white, size: 30),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   _buildGooglePlacesTextField(pickupController, "Pickup Location", true),
//                   const SizedBox(height: 12),
//                   _buildGooglePlacesTextField(dropController, "Drop Location", false),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: _calculateFare,
//                     style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                     child: const Text("Calculate Fare"),
//                   ),
//                   const SizedBox(height: 12),
//                   if (estimatedFare != null)
//                     Text(
//                       "Estimated Fare: $estimatedFare",
//                       style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: isRequesting ? null : _requestRide,
//                     style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//                     child: isRequesting
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : const Text("Request Ride"),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 50),
//             if (rideRequestId != null && rideStatus != 'Cancelled')
//               RiderSummaryCard(rideRequestId: rideRequestId!),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onNavItemTapped,
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: Colors.grey,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: "Home",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.history),
//             label: "My Rides",
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildGooglePlacesTextField(TextEditingController controller, String hint, bool isPickup) {
//     return GooglePlaceAutoCompleteTextField(
//       textEditingController: controller,
//       googleAPIKey: googleAPIKey,
//       inputDecoration: InputDecoration(
//         labelText: hint,
//         prefixIcon: const Icon(Icons.location_on, color: Color(0xFF1565C0)),
//         filled: true,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
//       ),
//       debounceTime: 800,
//       isLatLngRequired: true,
//       getPlaceDetailWithLatLng: (prediction) {
//         if (isPickup) {
//           pickupLatLng = "${prediction.lat},${prediction.lng}";
//         } else {
//           dropLatLng = "${prediction.lat},${prediction.lng}";
//         }
//       },
//       itemClick: (prediction) {
//         controller.text = prediction.description!;
//         FocusScope.of(context).unfocus();
//       },
//     );
//   }
// }
//
//








// Added a Logout Button in the AppBar
// Implemented _logout() method
// Signs out the user using FirebaseAuth.instance.signOut()
// Navigates to LoginScreen
// Ensured Professional UI Design

// 24-03-2025


//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_places_flutter/google_places_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'rider_summary_card.dart';
// import 'rider_history.dart';
// import 'login_screen.dart'; // Import Login Screen
//
// class RiderHomePage extends StatefulWidget {
//   const RiderHomePage({super.key});
//
//   @override
//   State<RiderHomePage> createState() => _RiderHomePageState();
// }
//
// class _RiderHomePageState extends State<RiderHomePage> {
//   TextEditingController pickupController = TextEditingController();
//   TextEditingController dropController = TextEditingController();
//   bool isRequesting = false;
//   String? estimatedFare;
//   String? rideRequestId;
//   String rideStatus = "No ride requested yet.";
//   String? assignedDriverId;
//   String? userId;
//
//   final String googleAPIKey = "AIzaSyDkHTHE8ll2oNXD0_j66gkmrpMW3n1o9hA"; // Replace with actual API Key
//   String pickupLatLng = "";
//   String dropLatLng = "";
//
//   int _selectedIndex = 0; // Bottom Navigation index
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentUser();
//   }
//
//   void _getCurrentUser() {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       setState(() {
//         userId = user.uid;
//       });
//       _listenForRideUpdates();
//     }
//   }
//
//   void _listenForRideUpdates() {
//     if (userId == null) return;
//
//     FirebaseFirestore.instance
//         .collection('ride_requests')
//         .where('userId', isEqualTo: userId)
//         .orderBy('timestamp', descending: true)
//         .limit(1)
//         .snapshots()
//         .listen((QuerySnapshot snapshot) {
//       if (snapshot.docs.isNotEmpty) {
//         var rideData = snapshot.docs.first;
//         setState(() {
//           rideRequestId = rideData.id;
//           rideStatus = rideData['status'];
//           assignedDriverId = rideData['driverId'];
//         });
//       } else {
//         setState(() {
//           rideRequestId = null;
//         });
//       }
//     });
//   }
//
//   void _calculateFare() async {
//     if (pickupLatLng.isEmpty || dropLatLng.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please select valid locations!")),
//       );
//       return;
//     }
//
//     final url =
//         "https://maps.googleapis.com/maps/api/distancematrix/json?origins=$pickupLatLng&destinations=$dropLatLng&key=$googleAPIKey";
//
//     final response = await http.get(Uri.parse(url));
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       if (data["rows"][0]["elements"][0]["status"] == "OK") {
//         int distanceInMeters = data["rows"][0]["elements"][0]["distance"]["value"];
//         double distanceInKm = distanceInMeters / 1000.0;
//
//         double baseFare = 10.0;
//         double perKmRate = 5.0;
//         double fare = baseFare + (distanceInKm * perKmRate);
//
//         setState(() {
//           estimatedFare = "₹${fare.toStringAsFixed(2)}";
//         });
//       } else {
//         setState(() {
//           estimatedFare = "Error calculating fare";
//         });
//       }
//     } else {
//       setState(() {
//         estimatedFare = "API Error";
//       });
//     }
//   }
//
//   Future<void> _requestRide() async {
//     if (pickupController.text.isEmpty ||
//         dropController.text.isEmpty ||
//         estimatedFare == null ||
//         userId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter valid details!")),
//       );
//       return;
//     }
//
//     setState(() {
//       isRequesting = true;
//       rideRequestId = null;
//     });
//
//     DocumentReference rideRef =
//     await FirebaseFirestore.instance.collection('ride_requests').add({
//       'userId': userId,
//       'pickup': pickupController.text,
//       'drop': dropController.text,
//       'fare': estimatedFare,
//       'status': 'Pending',
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//
//     setState(() {
//       rideRequestId = rideRef.id;
//       rideStatus = "Pending";
//       isRequesting = false;
//       pickupController.clear();
//       dropController.clear();
//       estimatedFare = null;
//     });
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Ride request sent!")),
//     );
//   }
//
//   void _logout() async {
//     await FirebaseAuth.instance.signOut();
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => LoginScreen()),
//     );
//   }
//
//   void _onNavItemTapped(int index) {
//     if (index == 1) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const RiderHistoryPage()),
//       );
//     } else {
//       setState(() {
//         _selectedIndex = index;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF1565C0),
//         title: const Text("Rider Home", style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//         leading: const Icon(Icons.person, color: Colors.white, size: 30),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout, color: Colors.white),
//             onPressed: _logout,
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   _buildGooglePlacesTextField(pickupController, "Pickup Location", true),
//                   const SizedBox(height: 12),
//                   _buildGooglePlacesTextField(dropController, "Drop Location", false),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: _calculateFare,
//                     style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                     child: const Text("Calculate Fare"),
//                   ),
//                   const SizedBox(height: 12),
//                   if (estimatedFare != null)
//                     Text(
//                       "Estimated Fare: $estimatedFare",
//                       style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: isRequesting ? null : _requestRide,
//                     style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//                     child: isRequesting
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : const Text("Request Ride"),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 50),
//             if (rideRequestId != null && rideStatus != 'Cancelled')
//               RiderSummaryCard(rideRequestId: rideRequestId!),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onNavItemTapped,
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: Colors.grey,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(icon: Icon(Icons.history), label: "My Rides"),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildGooglePlacesTextField(TextEditingController controller, String hint, bool isPickup) {
//     return GooglePlaceAutoCompleteTextField(
//       textEditingController: controller,
//       googleAPIKey: googleAPIKey,
//       inputDecoration: InputDecoration(
//         labelText: hint,
//         prefixIcon: const Icon(Icons.location_on, color: Color(0xFF1565C0)),
//         filled: true,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
//       ),
//       debounceTime: 800,
//       isLatLngRequired: true,
//       getPlaceDetailWithLatLng: (prediction) {
//         if (isPickup) {
//           pickupLatLng = "${prediction.lat},${prediction.lng}";
//         } else {
//           dropLatLng = "${prediction.lat},${prediction.lng}";
//         }
//       },
//       itemClick: (prediction) {
//         controller.text = prediction.description!;
//         FocusScope.of(context).unfocus();
//       },
//     );
//   }
// }
//








// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_places_flutter/google_places_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'rider_summary_card.dart';
// import 'rider_history.dart';
// import 'login_screen.dart';

// class RiderHomePage extends StatefulWidget {
//   const RiderHomePage({super.key});

//   @override
//   State<RiderHomePage> createState() => _RiderHomePageState();
// }

// class _RiderHomePageState extends State<RiderHomePage> {
//   TextEditingController pickupController = TextEditingController();
//   TextEditingController dropController = TextEditingController();
//   bool isRequesting = false;
//   String? estimatedFare;
//   String? rideRequestId;
//   String rideStatus = "No ride requested yet.";
//   String? assignedDriverId;
//   String? userId;
//   bool showSummaryCard = false;
//   String? userName;
//   String? userEmail;

//   final String googleAPIKey = "AIzaSyDkHTHE8ll2oNXD0_j66gkmrpMW3n1o9hA"; // Update your key
//   String pickupLatLng = "";
//   String dropLatLng = "";

//   int _selectedIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentUser();
//   }

//   void _getCurrentUser() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       setState(() {
//         userId = user.uid;
//         userEmail = user.email;
//       });

//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(user.uid)
//           .get();

//       if (userDoc.exists) {
//         setState(() {
//           userName = userDoc.get('name') ?? "User";
//         });
//       }

//       _listenForRideUpdates();
//     }
//   }

//   void _listenForRideUpdates() {
//     if (userId == null) return;

//     FirebaseFirestore.instance
//         .collection('ride_requests')
//         .where('userId', isEqualTo: userId)
//         .orderBy('timestamp', descending: true)
//         .limit(1)
//         .snapshots()
//         .listen((QuerySnapshot snapshot) {
//       if (snapshot.docs.isNotEmpty) {
//         var rideData = snapshot.docs.first;
//         setState(() {
//           rideRequestId = rideData.id;
//           rideStatus = rideData['status'];
//           assignedDriverId = rideData['driverId'];
//         });
//       } else {
//         setState(() {
//           rideRequestId = null;
//         });
//       }
//     });
//   }

//   void _calculateFare() async {
//     if (pickupLatLng.isEmpty || dropLatLng.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please select valid locations!")),
//       );
//       return;
//     }

//     final url =
//         "https://maps.googleapis.com/maps/api/distancematrix/json?origins=$pickupLatLng&destinations=$dropLatLng&key=$googleAPIKey";

//     final response = await http.get(Uri.parse(url));

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       if (data["rows"][0]["elements"][0]["status"] == "OK") {
//         int distanceInMeters = data["rows"][0]["elements"][0]["distance"]["value"];
//         double distanceInKm = distanceInMeters / 1000.0;

//         double baseFare = 10.0;
//         double perKmRate = 5.0;
//         double fare = baseFare + (distanceInKm * perKmRate);

//         setState(() {
//           estimatedFare = "₹${fare.toStringAsFixed(2)}";
//         });
//       } else {
//         setState(() {
//           estimatedFare = "Error calculating fare";
//         });
//       }
//     } else {
//       setState(() {
//         estimatedFare = "API Error";
//       });
//     }
//   }

//   Future<void> _requestRide() async {
//     if (pickupController.text.isEmpty ||
//         dropController.text.isEmpty ||
//         estimatedFare == null ||
//         userId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter valid details!")),
//       );
//       return;
//     }

//     setState(() {
//       isRequesting = true;
//       rideRequestId = null;
//     });

//     DocumentReference rideRef =
//     await FirebaseFirestore.instance.collection('ride_requests').add({
//       'userId': userId,
//       'pickup': pickupController.text,
//       'drop': dropController.text,
//       'fare': estimatedFare,
//       'status': 'Pending',
//       'timestamp': FieldValue.serverTimestamp(),
//     });

//     setState(() {
//       rideRequestId = rideRef.id;
//       rideStatus = "Pending";
//       isRequesting = false;
//       pickupController.clear();
//       dropController.clear();
//       estimatedFare = null;
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Ride request sent!")),
//     );
//   }

//   void _logout() async {
//     await FirebaseAuth.instance.signOut();
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => LoginScreen()),
//     );
//   }

//   void _openProfileDetails() {
//     showModalBottomSheet(
//       context: context,
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const CircleAvatar(
//                 radius: 40,
//                 backgroundColor: Colors.blue,
//                 child: Icon(Icons.person, size: 50, color: Colors.white),
//               ),
//               const SizedBox(height: 12),
//               Text(userName ?? "Name", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 4),
//               Text(userEmail ?? "Email", style: const TextStyle(color: Colors.grey)),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _logout,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.red,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 ),
//                 child: const Text("Logout", style: TextStyle(color: Colors.white)),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _onNavItemTapped(int index) {
//     if (index == 1) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const RiderHistoryPage()),
//       );
//     } else {
//       setState(() {
//         _selectedIndex = index;
//       });
//     }
//   }

//   void _handleSwipe(DragEndDetails details) {
//     if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
//       setState(() {
//         showSummaryCard = true;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFB71C1C),
//         title: const Text(" Rider Home",
//             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.person, color: Colors.white, size: 28),
//           onPressed: _openProfileDetails,
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout, color: Colors.white),
//             onPressed: _logout,
//           ),
//         ],
//         elevation: 4,
//       ),
//       body: GestureDetector(
//         onVerticalDragEnd: _handleSwipe,
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildGooglePlacesTextField(pickupController, "Pickup Location", true),
//                 const SizedBox(height: 16),
//                 _buildGooglePlacesTextField(dropController, "Drop Location", false),
//                 const SizedBox(height: 20),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: _calculateFare,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFFB71C1C),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                     ),
//                     child: const Text("Calculate Fare",
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 if (estimatedFare != null)
//                   Card(
//                     elevation: 5,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20)),
//                     margin: const EdgeInsets.symmetric(vertical: 10),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
//                       child: Text(
//                         "💰 Estimated Fare: $estimatedFare",
//                         style: const TextStyle(
//                             fontSize: 20, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                 const SizedBox(height: 20),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: isRequesting ? null : _requestRide,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                     ),
//                     child: isRequesting
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : const Text("Request Ride",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold, fontSize: 18)),
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 if (rideRequestId != null && rideStatus != 'Cancelled' && showSummaryCard)
//                   RiderSummaryCard(rideRequestId: rideRequestId!),
//               ],
//             ),
//           ),
//         ),
//       ),
//       bottomNavigationBar: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           GestureDetector(
//             onTap: () {
//               setState(() {
//                 showSummaryCard = true;
//               });
//             },
//             child: Container(
//               height: 40,
//               child: const Center(
//                 child: Icon(Icons.keyboard_arrow_up, size: 30, color: Colors.grey),
//               ),
//             ),
//           ),
//           BottomNavigationBar(
//             currentIndex: _selectedIndex,
//             onTap: _onNavItemTapped,
//             selectedItemColor: const Color(0xFFB71C1C),
//             unselectedItemColor: Colors.grey,
//             items: const [
//               BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//               BottomNavigationBarItem(icon: Icon(Icons.history), label: "My Rides"),
//             ],
//             elevation: 8,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildGooglePlacesTextField(
//       TextEditingController controller, String hint, bool isPickup) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
//       ),
//       child: GooglePlaceAutoCompleteTextField(
//         textEditingController: controller,
//         googleAPIKey: googleAPIKey,
//         inputDecoration: InputDecoration(
//           labelText: hint,
//           prefixIcon: const Icon(Icons.location_on, color: Color(0xFFB71C1C)),
//           filled: true,
//           fillColor: Colors.white,
//           contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(20),
//             borderSide: BorderSide.none,
//           ),
//         ),
//         debounceTime: 800,
//         isLatLngRequired: true,
//         getPlaceDetailWithLatLng: (prediction) {
//           if (isPickup) {
//             pickupLatLng = "${prediction.lat},${prediction.lng}";
//           } else {
//             dropLatLng = "${prediction.lat},${prediction.lng}";
//           }
//         },
//         itemClick: (prediction) {
//           controller.text = prediction.description!;
//           FocusScope.of(context).unfocus();
//         },
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_places_flutter/google_places_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';

// import 'rider_summary_card.dart';
// import 'rider_history.dart';
// import 'login_screen.dart';

// class RiderHomePage extends StatefulWidget {
//   const RiderHomePage({super.key});

//   @override
//   State<RiderHomePage> createState() => _RiderHomePageState();
// }

// class _RiderHomePageState extends State<RiderHomePage> {
//   TextEditingController pickupController = TextEditingController();
//   TextEditingController dropController = TextEditingController();

//   final String googleAPIKey = "AIzaSyDkHTHE8ll2oNXD0_j66gkmrpMW3n1o9hA";
//   String? userId, userName, userEmail;
//   String? estimatedFare;
//   String? rideRequestId;
//   String rideStatus = "No ride requested yet.";
//   bool isRequesting = false;
//   bool showSummaryCard = false;

//   LatLng? pickupLatLng;
//   LatLng? dropLatLng;

//   GoogleMapController? mapController;
//   Set<Marker> markers = {};
//   Set<Polyline> polylines = {};

//   int _selectedIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentUser();
//   }

//   void _getCurrentUser() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       userId = user.uid;
//       userEmail = user.email;

//       final userDoc =
//           await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

//       if (userDoc.exists) {
//         setState(() => userName = userDoc.get('name') ?? "User");
//       }

//       _listenForRideUpdates();
//     }
//   }

//   void _listenForRideUpdates() {
//     if (userId == null) return;
//     FirebaseFirestore.instance
//         .collection('ride_requests')
//         .where('userId', isEqualTo: userId)
//         .orderBy('timestamp', descending: true)
//         .limit(1)
//         .snapshots()
//         .listen((snapshot) {
//       if (snapshot.docs.isNotEmpty) {
//         var rideData = snapshot.docs.first;
//         setState(() {
//           rideRequestId = rideData.id;
//           rideStatus = rideData['status'];
//         });
//       }
//     });
//   }

//   Future<void> _calculateFare() async {
//     if (pickupLatLng == null || dropLatLng == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please select valid locations!")),
//       );
//       return;
//     }

//     final url =
//         "https://maps.googleapis.com/maps/api/distancematrix/json?origins=${pickupLatLng!.latitude},${pickupLatLng!.longitude}&destinations=${dropLatLng!.latitude},${dropLatLng!.longitude}&key=$googleAPIKey";

//     final response = await http.get(Uri.parse(url));
//     final data = json.decode(response.body);

//     if (data["rows"][0]["elements"][0]["status"] == "OK") {
//       int distanceInMeters = data["rows"][0]["elements"][0]["distance"]["value"];
//       double distanceInKm = distanceInMeters / 1000.0;
//       double fare = 10 + distanceInKm * 5;

//       setState(() {
//         estimatedFare = "₹${fare.toStringAsFixed(2)}";
//       });

//       _showRouteOnMap();
//     } else {
//       setState(() {
//         estimatedFare = "Error calculating fare";
//       });
//     }
//   }

//   Future<void> _showRouteOnMap() async {
//     if (pickupLatLng == null || dropLatLng == null) return;

//     markers.clear();
//     polylines.clear();

//     markers.add(Marker(markerId: MarkerId("pickup"), position: pickupLatLng!));
//     markers.add(Marker(markerId: MarkerId("drop"), position: dropLatLng!));

//     final polylinePoints = PolylinePoints();
//     final result = await polylinePoints.getRouteBetweenCoordinates(
//       googleAPIKey,
//       PointLatLng(pickupLatLng!.latitude, pickupLatLng!.longitude),
//       PointLatLng(dropLatLng!.latitude, dropLatLng!.longitude),
//     );

//     if (result.points.isNotEmpty) {
//       polylines.add(
//         Polyline(
//           polylineId: PolylineId("route"),
//           points: result.points.map((e) => LatLng(e.latitude, e.longitude)).toList(),
//           color: Colors.red,
//           width: 4,
//         ),
//       );
//     }

//     mapController?.animateCamera(CameraUpdate.newLatLngBounds(
//       LatLngBounds(
//         southwest: LatLng(
//           pickupLatLng!.latitude <= dropLatLng!.latitude
//               ? pickupLatLng!.latitude
//               : dropLatLng!.latitude,
//           pickupLatLng!.longitude <= dropLatLng!.longitude
//               ? pickupLatLng!.longitude
//               : dropLatLng!.longitude,
//         ),
//         northeast: LatLng(
//           pickupLatLng!.latitude >= dropLatLng!.latitude
//               ? pickupLatLng!.latitude
//               : dropLatLng!.latitude,
//           pickupLatLng!.longitude >= dropLatLng!.longitude
//               ? pickupLatLng!.longitude
//               : dropLatLng!.longitude,
//         ),
//       ),
//       80,
//     ));

//     setState(() {});
//   }

//   Future<void> _requestRide() async {
//     if (pickupController.text.isEmpty ||
//         dropController.text.isEmpty ||
//         estimatedFare == null ||
//         userId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter valid details!")),
//       );
//       return;
//     }

//     setState(() => isRequesting = true);

//     final rideRef = await FirebaseFirestore.instance.collection('ride_requests').add({
//       'userId': userId,
//       'pickup': pickupController.text,
//       'drop': dropController.text,
//       'fare': estimatedFare,
//       'status': 'Pending',
//       'timestamp': FieldValue.serverTimestamp(),
//     });

//     setState(() {
//       rideRequestId = rideRef.id;
//       rideStatus = "Pending";
//       isRequesting = false;
//       pickupController.clear();
//       dropController.clear();
//       estimatedFare = null;
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Ride request sent!")),
//     );
//   }

//   void _logout() async {
//     await FirebaseAuth.instance.signOut();
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => LoginScreen()),
//     );
//   }

//   void _onNavItemTapped(int index) {
//     if (index == 1) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const RiderHistoryPage()),
//       );
//     } else {
//       setState(() => _selectedIndex = index);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFB71C1C),
//         title: const Text(" Rider Home",
//             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//         centerTitle: true,
//         actions: [
//           IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: GoogleMap(
//               initialCameraPosition: const CameraPosition(
//                 target: LatLng(12.9716, 77.5946), // Default to Bangalore
//                 zoom: 12,
//               ),
//               markers: markers,
//               polylines: polylines,
//               onMapCreated: (controller) => mapController = controller,
//               myLocationButtonEnabled: true,
//               myLocationEnabled: true,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 _buildGooglePlacesTextField(pickupController, "Pickup", true),
//                 const SizedBox(height: 12),
//                 _buildGooglePlacesTextField(dropController, "Drop", false),
//                 const SizedBox(height: 12),
//                 if (estimatedFare != null)
//                   Text("Estimated Fare: $estimatedFare",
//                       style: const TextStyle(
//                           fontSize: 18, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 12),
//                 ElevatedButton(
//                   onPressed: isRequesting ? null : _calculateFare,
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                   child: const Text("Calculate Fare"),
//                 ),
//                 const SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: isRequesting ? null : _requestRide,
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//                   child: const Text("Request Ride"),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onNavItemTapped,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(icon: Icon(Icons.history), label: "My Rides"),
//         ],
//       ),
//     );
//   }

//   Widget _buildGooglePlacesTextField(
//       TextEditingController controller, String hint, bool isPickup) {
//     return GooglePlaceAutoCompleteTextField(
//       textEditingController: controller,
//       googleAPIKey: googleAPIKey,
//       inputDecoration: InputDecoration(
//         labelText: hint,
//         prefixIcon: const Icon(Icons.location_on),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//       ),
//       debounceTime: 800,
//       isLatLngRequired: true,
//       getPlaceDetailWithLatLng: (prediction) {
//         LatLng coords = LatLng(
//   double.parse(prediction.lat!),
//   double.parse(prediction.lng!),
// );

//         if (isPickup) {
//           pickupLatLng = coords;
//         } else {
//           dropLatLng = coords;
//         }
//       },
//       itemClick: (prediction) {
//         controller.text = prediction.description!;
//         FocusScope.of(context).unfocus();
//       },
//     );
//   }
// }









// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_places_flutter/google_places_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'rider_summary_card.dart';
// import 'rider_history.dart';
// import 'login_screen.dart';

// class RiderHomePage extends StatefulWidget {
//   const RiderHomePage({super.key});

//   @override
//   State<RiderHomePage> createState() => _RiderHomePageState();
// }

// class _RiderHomePageState extends State<RiderHomePage> {
//   TextEditingController pickupController = TextEditingController();
//   TextEditingController dropController = TextEditingController();
//   bool isRequesting = false;
//   String? estimatedFare;
//   String? rideRequestId;
//   String rideStatus = "No ride requested yet.";
//   String? assignedDriverId;
//   String? userId;
//   bool showSummaryCard = false;

//   final String googleAPIKey = "AIzaSyDkHTHE8ll2oNXD0_j66gkmrpMW3n1o9hA"; // Replace with your actual API key
//   String pickupLatLng = "";
//   String dropLatLng = "";

//   int _selectedIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentUser();
//   }

//   void _getCurrentUser() {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       setState(() {
//         userId = user.uid;
//       });
//       _listenForRideUpdates();
//     }
//   }

//   void _listenForRideUpdates() {
//     if (userId == null) return;

//     FirebaseFirestore.instance
//         .collection('ride_requests')
//         .where('userId', isEqualTo: userId)
//         .orderBy('timestamp', descending: true)
//         .limit(1)
//         .snapshots()
//         .listen((QuerySnapshot snapshot) {
//       if (snapshot.docs.isNotEmpty) {
//         var rideData = snapshot.docs.first;
//         setState(() {
//           rideRequestId = rideData.id;
//           rideStatus = rideData['status'];
//           assignedDriverId = rideData['driverId'];
//         });
//       } else {
//         setState(() {
//           rideRequestId = null;
//         });
//       }
//     });
//   }

//   void _calculateFare() async {
//     if (pickupLatLng.isEmpty || dropLatLng.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please select valid locations!")),
//       );
//       return;
//     }

//     final url =
//         "https://maps.googleapis.com/maps/api/distancematrix/json?origins=$pickupLatLng&destinations=$dropLatLng&key=$googleAPIKey";

//     final response = await http.get(Uri.parse(url));

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       if (data["rows"][0]["elements"][0]["status"] == "OK") {
//         int distanceInMeters = data["rows"][0]["elements"][0]["distance"]["value"];
//         double distanceInKm = distanceInMeters / 1000.0;

//         double baseFare = 10.0;
//         double perKmRate = 5.0;
//         double fare = baseFare + (distanceInKm * perKmRate);

//         setState(() {
//           estimatedFare = "₹${fare.toStringAsFixed(2)}";
//         });
//       } else {
//         setState(() {
//           estimatedFare = "Error calculating fare";
//         });
//       }
//     } else {
//       setState(() {
//         estimatedFare = "API Error";
//       });
//     }
//   }

//   Future<void> _requestRide() async {
//     if (pickupController.text.isEmpty ||
//         dropController.text.isEmpty ||
//         estimatedFare == null ||
//         userId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter valid details!")),
//       );
//       return;
//     }

//     setState(() {
//       isRequesting = true;
//       rideRequestId = null;
//     });

//     DocumentReference rideRef =
//     await FirebaseFirestore.instance.collection('ride_requests').add({
//       'userId': userId,
//       'pickup': pickupController.text,
//       'drop': dropController.text,
//       'fare': estimatedFare,
//       'status': 'Pending',
//       'timestamp': FieldValue.serverTimestamp(),
//     });

//     setState(() {
//       rideRequestId = rideRef.id;
//       rideStatus = "Pending";
//       isRequesting = false;
//       pickupController.clear();
//       dropController.clear();
//       estimatedFare = null;
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Ride request sent!")),
//     );
//   }

//   void _logout() async {
//     await FirebaseAuth.instance.signOut();
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => LoginScreen()),
//     );
//   }

//   void _onNavItemTapped(int index) {
//     if (index == 1) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const RiderHistoryPage()),
//       );
//     } else {
//       setState(() {
//         _selectedIndex = index;
//       });
//     }
//   }

//   void _handleSwipe(DragEndDetails details) {
//     if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
//       // Swiped up
//       setState(() {
//         showSummaryCard = true;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF1565C0),
//         title: const Text("Rider Home", style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//         leading: const Icon(Icons.person, color: Colors.white, size: 30),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout, color: Colors.white),
//             onPressed: _logout,
//           ),
//         ],
//       ),
//       body: GestureDetector(
//         onVerticalDragEnd: _handleSwipe,
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   children: [
//                     _buildGooglePlacesTextField(pickupController, "Pickup Location", true),
//                     const SizedBox(height: 12),
//                     _buildGooglePlacesTextField(dropController, "Drop Location", false),
//                     const SizedBox(height: 16),
//                     ElevatedButton(
//                       onPressed: _calculateFare,
//                       style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                       child: const Text("Calculate Fare"),
//                     ),
//                     const SizedBox(height: 12),
//                     if (estimatedFare != null)
//                       Text(
//                         "Estimated Fare: $estimatedFare",
//                         style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                     const SizedBox(height: 16),
//                     ElevatedButton(
//                       onPressed: isRequesting ? null : _requestRide,
//                       style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//                       child: isRequesting
//                           ? const CircularProgressIndicator(color: Colors.white)
//                           : const Text("Request Ride"),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               if (rideRequestId != null && rideStatus != 'Cancelled' && showSummaryCard)
//                 RiderSummaryCard(rideRequestId: rideRequestId!),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           GestureDetector(
//             onTap: () {
//               setState(() {
//                 showSummaryCard = true;
//               });
//             },
//             child: const Icon(Icons.keyboard_arrow_up, size: 30, color: Colors.grey),
//           ),
//           BottomNavigationBar(
//             currentIndex: _selectedIndex,
//             onTap: _onNavItemTapped,
//             selectedItemColor: Colors.blue,
//             unselectedItemColor: Colors.grey,
//             items: const [
//               BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//               BottomNavigationBarItem(icon: Icon(Icons.history), label: "My Rides"),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildGooglePlacesTextField(TextEditingController controller, String hint, bool isPickup) {
//     return GooglePlaceAutoCompleteTextField(
//       textEditingController: controller,
//       googleAPIKey: googleAPIKey,
//       inputDecoration: InputDecoration(
//         labelText: hint,
//         prefixIcon: const Icon(Icons.location_on, color: Color(0xFF1565C0)),
//         filled: true,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
//       ),
//       debounceTime: 800,
//       isLatLngRequired: true,
//       getPlaceDetailWithLatLng: (prediction) {
//         if (isPickup) {
//           pickupLatLng = "${prediction.lat},${prediction.lng}";
//         } else {
//           dropLatLng = "${prediction.lat},${prediction.lng}";
//         }
//       },
//       itemClick: (prediction) {
//         controller.text = prediction.description!;
//         FocusScope.of(context).unfocus();
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'rider_summary_card.dart';
import 'rider_history.dart';
import 'login_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // NEW

class RiderHomePage extends StatefulWidget {
  const RiderHomePage({super.key});

  @override
  State<RiderHomePage> createState() => _RiderHomePageState();
}

class _RiderHomePageState extends State<RiderHomePage> {
  TextEditingController pickupController = TextEditingController();
  TextEditingController dropController = TextEditingController();
  bool isRequesting = false;
  String? estimatedFare;
  String? rideRequestId;
  String rideStatus = "No ride requested yet.";
  String? assignedDriverId;
  String? userId;
  bool showSummaryCard = false;

  final String googleAPIKey = "AIzaSyDkHTHE8ll2oNXD0_j66gkmrpMW3n1o9hA"; // Replace with your actual API key
  String pickupLatLng = "";
  String dropLatLng = "";

  int _selectedIndex = 0;

  GoogleMapController? mapController; // NEW
  LatLng? pickupLatLngObj; // NEW
  LatLng? dropLatLngObj; // NEW
  Set<Polyline> _polylines = {}; // NEW
  Set<Marker> _markers = {}; // NEW

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
      _listenForRideUpdates();
    }
  }

  void _listenForRideUpdates() {
    if (userId == null) return;

    FirebaseFirestore.instance
        .collection('ride_requests')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      if (snapshot.docs.isNotEmpty) {
        var rideData = snapshot.docs.first;
        setState(() {
          rideRequestId = rideData.id;
          rideStatus = rideData['status'];
          assignedDriverId = rideData['driverId'];
        });
      } else {
        setState(() {
          rideRequestId = null;
        });
      }
    });
  }

  void _calculateFare() async {
    if (pickupLatLng.isEmpty || dropLatLng.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select valid locations!")),
      );
      return;
    }

    final url =
        "https://maps.googleapis.com/maps/api/distancematrix/json?origins=$pickupLatLng&destinations=$dropLatLng&key=$googleAPIKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["rows"][0]["elements"][0]["status"] == "OK") {
        int distanceInMeters = data["rows"][0]["elements"][0]["distance"]["value"];
        double distanceInKm = distanceInMeters / 1000.0;

        double baseFare = 10.0;
        double perKmRate = 5.0;
        double fare = baseFare + (distanceInKm * perKmRate);

        setState(() {
          estimatedFare = "₹${fare.toStringAsFixed(2)}";
        });

        _drawRoute(); // NEW
      } else {
        setState(() {
          estimatedFare = "Error calculating fare";
        });
      }
    } else {
      setState(() {
        estimatedFare = "API Error";
      });
    }
  }

  Future<void> _requestRide() async {
    if (pickupController.text.isEmpty ||
        dropController.text.isEmpty ||
        estimatedFare == null ||
        userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter valid details!")),
      );
      return;
    }

    setState(() {
      isRequesting = true;
      rideRequestId = null;
    });

    DocumentReference rideRef =
    await FirebaseFirestore.instance.collection('ride_requests').add({
      'userId': userId,
      'pickup': pickupController.text,
      'drop': dropController.text,
      'fare': estimatedFare,
      'status': 'Pending',
      'timestamp': FieldValue.serverTimestamp(),
    });

    setState(() {
      rideRequestId = rideRef.id;
      rideStatus = "Pending";
      isRequesting = false;
      pickupController.clear();
      dropController.clear();
      estimatedFare = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Ride request sent!")),
    );
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void _onNavItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RiderHistoryPage()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _handleSwipe(DragEndDetails details) {
    if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
      setState(() {
        showSummaryCard = true;
      });
    }
  }

  void _drawRoute() async {
    if (pickupLatLng.isEmpty || dropLatLng.isEmpty) return;

    final pickupCoords = pickupLatLng.split(',');
    final dropCoords = dropLatLng.split(',');

    pickupLatLngObj = LatLng(double.parse(pickupCoords[0]), double.parse(pickupCoords[1]));
    dropLatLngObj = LatLng(double.parse(dropCoords[0]), double.parse(dropCoords[1]));

    setState(() {
      _markers.clear();
      _markers.add(Marker(
        markerId: const MarkerId('pickup'),
        position: pickupLatLngObj!,
        infoWindow: const InfoWindow(title: 'Pickup'),
      ));
      _markers.add(Marker(
        markerId: const MarkerId('drop'),
        position: dropLatLngObj!,
        infoWindow: const InfoWindow(title: 'Drop'),
      ));

      _polylines.clear();
      _polylines.add(Polyline(
        polylineId: const PolylineId('route'),
        points: [pickupLatLngObj!, dropLatLngObj!],
        color: Colors.blue,
        width: 5,
      ));
    });

    if (mapController != null) {
      mapController!.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(
            (pickupLatLngObj!.latitude <= dropLatLngObj!.latitude)
                ? pickupLatLngObj!.latitude
                : dropLatLngObj!.latitude,
            (pickupLatLngObj!.longitude <= dropLatLngObj!.longitude)
                ? pickupLatLngObj!.longitude
                : dropLatLngObj!.longitude,
          ),
          northeast: LatLng(
            (pickupLatLngObj!.latitude > dropLatLngObj!.latitude)
                ? pickupLatLngObj!.latitude
                : dropLatLngObj!.latitude,
            (pickupLatLngObj!.longitude > dropLatLngObj!.longitude)
                ? pickupLatLngObj!.longitude
                : dropLatLngObj!.longitude,
          ),
        ),
        100,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        title: const Text("Rider Home", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: const Icon(Icons.person, color: Colors.white, size: 30),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
      body: GestureDetector(
        onVerticalDragEnd: _handleSwipe,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildGooglePlacesTextField(pickupController, "Pickup Location", true),
                    const SizedBox(height: 12),
                    _buildGooglePlacesTextField(dropController, "Drop Location", false),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _calculateFare,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      child: const Text("Calculate Fare"),
                    ),
                    const SizedBox(height: 12),
                    if (estimatedFare != null)
                      Text(
                        "Estimated Fare: $estimatedFare",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: isRequesting ? null : _requestRide,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: isRequesting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Request Ride"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (pickupLatLngObj != null && dropLatLngObj != null)
                SizedBox(
                  height: 300,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: pickupLatLngObj!,
                      zoom: 12,
                    ),
                    markers: _markers,
                    polylines: _polylines,
                    onMapCreated: (GoogleMapController controller) {
                      mapController = controller;
                    },
                  ),
                ),
              const SizedBox(height: 20),
              if (rideRequestId != null && rideStatus != 'Cancelled' && showSummaryCard)
                RiderSummaryCard(rideRequestId: rideRequestId!),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                showSummaryCard = true;
              });
            },
            child: const Icon(Icons.keyboard_arrow_up, size: 30, color: Colors.grey),
          ),
          BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onNavItemTapped,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.history), label: "My Rides"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGooglePlacesTextField(TextEditingController controller, String hint, bool isPickup) {
    return GooglePlaceAutoCompleteTextField(
      textEditingController: controller,
      googleAPIKey: googleAPIKey,
      inputDecoration: InputDecoration(
        labelText: hint,
        prefixIcon: const Icon(Icons.location_on, color: Color(0xFF1565C0)),
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
      debounceTime: 800,
      isLatLngRequired: true,
      getPlaceDetailWithLatLng: (prediction) {
        if (isPickup) {
          pickupLatLng = "${prediction.lat},${prediction.lng}";
        } else {
          dropLatLng = "${prediction.lat},${prediction.lng}";
        }
      },
      itemClick: (prediction) {
        controller.text = prediction.description!;
        FocusScope.of(context).unfocus();
      },
    );
  }
}
