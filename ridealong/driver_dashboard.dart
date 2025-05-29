// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// class DriverDash extends StatefulWidget {
//   final String driverId; // Dynamic driver ID
//   const DriverDash({super.key, required this.driverId});
//
//   @override
//   State<DriverDash> createState() => _DriverDashState();
// }
//
// class _DriverDashState extends State<DriverDash> {
//   String? driverStartLocation;
//   String? driverEndLocation;
//   List<Map<String, dynamic>> matchedRides = [];
//   final String googleAPIKey = "AIzaSyDkHTHE8ll2oNXD0_j66gkmrpMW3n1o9hA"; // Replace with actual key
//
//   @override
//   void initState() {
//     super.initState();
//     fetchDriverRoute();
//   }
//
//   // Fetch driver route dynamically from Firestore
//   Future<void> fetchDriverRoute() async {
//     try {
//       DocumentSnapshot driverDoc = await FirebaseFirestore.instance
//           .collection('rides')
//           .doc(widget.driverId) // Driver’s ride document
//           .get();
//
//       if (driverDoc.exists) {
//         var driverData = driverDoc.data() as Map<String, dynamic>;
//         setState(() {
//           driverStartLocation = driverData['start_location'];
//           driverEndLocation = driverData['end_location'];
//         });
//
//         print("Driver Start Location: $driverStartLocation");
//         print("Driver End Location: $driverEndLocation");
//
//         fetchMatchingRideRequests();
//       } else {
//         print("Driver document does not exist.");
//       }
//     } catch (e) {
//       print("Error fetching driver route: $e");
//     }
//   }
//
//   // Fetch pending ride requests and match with driver route
//   Future<void> fetchMatchingRideRequests() async {
//     try {
//       QuerySnapshot requestSnapshot = await FirebaseFirestore.instance
//           .collection('ride_requests')
//           .where('status', isEqualTo: 'Pending')
//           .get();
//
//       print("Total pending ride requests found: ${requestSnapshot.docs.length}");
//
//       List<Map<String, dynamic>> filteredRequests = [];
//
//       for (var requestDoc in requestSnapshot.docs) {
//         var requestData = requestDoc.data() as Map<String, dynamic>;
//         print("Checking ride request: Pickup: ${requestData['pickup']}, Drop: ${requestData['drop']}");
//
//         bool isMatching = await checkRouteMatch(
//           requestData['pickup'],
//           requestData['drop'],
//         );
//
//         if (isMatching) {
//           filteredRequests.add({...requestData, 'id': requestDoc.id});
//         }
//       }
//
//       setState(() {
//         matchedRides = filteredRequests;
//         print("Matched Rides Count: ${matchedRides.length}");
//       });
//     } catch (e) {
//       print("Error fetching ride requests: $e");
//     }
//   }
//
//   // Use Google Maps Distance Matrix API for location-based filtering
//   Future<bool> checkRouteMatch(String pickup, String drop) async {
//     if (driverStartLocation == null || driverEndLocation == null) return false;
//
//     try {
//       String pickupUrl =
//           "https://maps.googleapis.com/maps/api/distancematrix/json?origins=$driverStartLocation&destinations=$pickup&key=$googleAPIKey";
//
//       final responsePickup = await http.get(Uri.parse(pickupUrl));
//       final dataPickup = json.decode(responsePickup.body);
//       print("Pickup API Response: $dataPickup");
//
//       String dropUrl =
//           "https://maps.googleapis.com/maps/api/distancematrix/json?origins=$driverEndLocation&destinations=$drop&key=$googleAPIKey";
//
//       final responseDrop = await http.get(Uri.parse(dropUrl));
//       final dataDrop = json.decode(responseDrop.body);
//       print("Drop API Response: $dataDrop");
//
//       if (responsePickup.statusCode == 200 &&
//           responseDrop.statusCode == 200 &&
//           dataPickup["rows"][0]["elements"][0]["status"] == "OK" &&
//           dataDrop["rows"][0]["elements"][0]["status"] == "OK") {
//         int pickupDistance = dataPickup["rows"][0]["elements"][0]["distance"]["value"];
//         int dropDistance = dataDrop["rows"][0]["elements"][0]["distance"]["value"];
//
//         print("Pickup Distance: $pickupDistance meters");
//         print("Drop Distance: $dropDistance meters");
//
//         // Set a higher threshold (e.g., 10km) for better route matching
//         return pickupDistance <= 10000 && dropDistance <= 10000;
//       }
//     } catch (e) {
//       print("Error checking route match: $e");
//     }
//
//     return false;
//   }
//
//   // Accept ride and update Firestore
//   Future<void> acceptRide(String requestId) async {
//     try {
//       await FirebaseFirestore.instance.collection('ride_requests').doc(requestId).update({
//         'status': 'Accepted',
//         'driverId': widget.driverId,
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Ride Accepted!")),
//       );
//
//       fetchMatchingRideRequests(); // Refresh list after acceptance
//     } catch (e) {
//       print("Error accepting ride: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Driver Dashboard"),
//         backgroundColor: Colors.red,
//       ),
//       body: matchedRides.isEmpty
//           ? const Center(child: Text("No matching ride requests"))
//           : ListView.builder(
//               itemCount: matchedRides.length,
//               itemBuilder: (context, index) {
//                 final ride = matchedRides[index];
//
//                 return Card(
//                   margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                   child: ListTile(
//                     leading: const Icon(Icons.directions_car, color: Colors.red),
//                     title: Text("Pickup: ${ride['pickup']}"),
//                     subtitle: Text("Drop: ${ride['drop']}"),
//                     trailing: ElevatedButton(
//                       onPressed: () => acceptRide(ride['id']),
//                       style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//                       child: const Text("Accept", style: TextStyle(color: Colors.white)),
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
//
//
//







//
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// class DriverDashboard extends StatefulWidget {
//   const DriverDashboard({super.key});
//
//   @override
//   State<DriverDashboard> createState() => _DriverDashboardState();
// }
//
// class _DriverDashboardState extends State<DriverDashboard> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   List<DocumentSnapshot> rideRequests = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchPendingRides();
//   }
//
//   void _fetchPendingRides() {
//     _firestore
//         .collection('ride_requests')
//         .where('status', isEqualTo: 'Pending')
//         .orderBy('timestamp', descending: true)
//         .snapshots(includeMetadataChanges: true)
//         .listen((snapshot) {
//       if (mounted) {
//         setState(() {
//           rideRequests = snapshot.docs;
//         });
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Driver Dashboard"),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: rideRequests.isEmpty
//           ? const Center(child: Text("No pending ride requests."))
//           : ListView.builder(
//         itemCount: rideRequests.length,
//         itemBuilder: (context, index) {
//           var ride = rideRequests[index];
//           var data = ride.data() as Map<String, dynamic>;
//
//           return RideRequestCard(
//             pickup: data['pickup'] ?? 'Unknown',
//             drop: data['drop'] ?? 'Unknown',
//             fare: data['fare']?.toString() ?? 'N/A',
//             timestamp: data['timestamp'] as Timestamp?,
//           );
//         },
//       ),
//     );
//   }
// }
//
// class RideRequestCard extends StatelessWidget {
//   final String pickup;
//   final String drop;
//   final String fare;
//   final Timestamp? timestamp;
//
//   const RideRequestCard({
//     super.key,
//     required this.pickup,
//     required this.drop,
//     required this.fare,
//     this.timestamp,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     String formattedTime = "Unknown time";
//     if (timestamp != null) {
//       DateTime dateTime =
//       DateTime.fromMillisecondsSinceEpoch(timestamp!.seconds * 1000);
//       formattedTime = DateFormat('MMM d, yyyy - h:mm a').format(dateTime);
//     }
//
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Pickup: $pickup",
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 5),
//             Text("Drop: $drop", style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 5),
//             Text("Fare: \$ $fare", style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 10),
//             Text("Requested at: $formattedTime",
//                 style: const TextStyle(color: Colors.grey)),
//           ],
//         ),
//       ),
//     );
//   }
// }










// 18-04-2025

// Here is your updated code with the "Accept Ride" button added at the bottom of each ride request card:1
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// class DriverDashboard extends StatefulWidget {
//   const DriverDashboard({super.key});
//
//   @override
//   State<DriverDashboard> createState() => _DriverDashboardState();
// }
//
// class _DriverDashboardState extends State<DriverDashboard> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   List<DocumentSnapshot> rideRequests = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchPendingRides();
//   }
//
//   void _fetchPendingRides() {
//     _firestore
//         .collection('ride_requests')
//         .where('status', isEqualTo: 'Pending')
//         .orderBy('timestamp', descending: true)
//         .snapshots(includeMetadataChanges: true)
//         .listen((snapshot) {
//       if (mounted) {
//         setState(() {
//           rideRequests = snapshot.docs;
//         });
//       }
//     });
//   }
//
//   /// ✅ Handles accepting a ride request
//   Future<void> _acceptRide(String rideId) async {
//     try {
//       await _firestore.collection('ride_requests').doc(rideId).update({
//         'status': 'Accepted',
//       });
//
//       // Refresh ride list after accepting
//       _fetchPendingRides();
//     } catch (e) {
//       print("Error accepting ride request: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Driver Dashboard"),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: rideRequests.isEmpty
//           ? const Center(child: Text("No pending ride requests."))
//           : ListView.builder(
//         itemCount: rideRequests.length,
//         itemBuilder: (context, index) {
//           var ride = rideRequests[index];
//           var data = ride.data() as Map<String, dynamic>;
//
//           return RideRequestCard(
//             rideId: ride.id,
//             pickup: data['pickup'] ?? 'Unknown',
//             drop: data['drop'] ?? 'Unknown',
//             fare: data['fare']?.toString() ?? 'N/A',
//             timestamp: data['timestamp'] as Timestamp?,
//             onAccept: () => _acceptRide(ride.id),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class RideRequestCard extends StatelessWidget {
//   final String rideId;
//   final String pickup;
//   final String drop;
//   final String fare;
//   final Timestamp? timestamp;
//   final VoidCallback onAccept;
//
//   const RideRequestCard({
//     super.key,
//     required this.rideId,
//     required this.pickup,
//     required this.drop,
//     required this.fare,
//     this.timestamp,
//     required this.onAccept,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     String formattedTime = "Unknown time";
//     if (timestamp != null) {
//       DateTime dateTime =
//       DateTime.fromMillisecondsSinceEpoch(timestamp!.seconds * 1000);
//       formattedTime = DateFormat('MMM d, yyyy - h:mm a').format(dateTime);
//     }
//
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Pickup: $pickup",
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 5),
//             Text("Drop: $drop", style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 5),
//             Text("Fare: $fare", style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 10),
//             Text("Requested at: $formattedTime",
//                 style: const TextStyle(color: Colors.grey)),
//             const SizedBox(height: 15),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: onAccept,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8)),
//                 ),
//                 child: const Text("Accept Ride"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//




// accept ride working
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// class DriverDashboard extends StatefulWidget {
//   const DriverDashboard({super.key});
//
//   @override
//   State<DriverDashboard> createState() => _DriverDashboardState();
// }
//
// class _DriverDashboardState extends State<DriverDashboard> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   List<DocumentSnapshot> rideRequests = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchPendingRides();
//   }
//
//   void _fetchPendingRides() {
//     _firestore
//         .collection('ride_requests')
//         .where('status', isEqualTo: 'Pending')
//         .orderBy('timestamp', descending: true)
//         .snapshots(includeMetadataChanges: true)
//         .listen((snapshot) {
//       if (mounted) {
//         setState(() {
//           rideRequests = snapshot.docs;
//         });
//       }
//     });
//   }
//
//   /// ✅ Handles accepting a ride request
//   Future<void> _acceptRide(String rideId) async {
//     try {
//       final currentUser = FirebaseAuth.instance.currentUser;
//
//       if (currentUser == null) {
//         print("No user is logged in.");
//         return;
//       }
//
//       await _firestore.collection('ride_requests').doc(rideId).update({
//         'status': 'Accepted',
//         'driverId': currentUser.uid, // Assign to driver
//       });
//
//       print("Ride accepted and assigned to driver.");
//       _fetchPendingRides();
//     } catch (e) {
//       print("Error accepting ride request: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Driver Dashboard"),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: rideRequests.isEmpty
//           ? const Center(child: Text("No pending ride requests."))
//           : ListView.builder(
//         itemCount: rideRequests.length,
//         itemBuilder: (context, index) {
//           var ride = rideRequests[index];
//           var data = ride.data() as Map<String, dynamic>;
//
//           return RideRequestCard(
//             rideId: ride.id,
//             pickup: data['pickup'] ?? 'Unknown',
//             drop: data['drop'] ?? 'Unknown',
//             fare: data['fare']?.toString() ?? 'N/A',
//             timestamp: data['timestamp'] as Timestamp?,
//             onAccept: () => _acceptRide(ride.id),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class RideRequestCard extends StatelessWidget {
//   final String rideId;
//   final String pickup;
//   final String drop;
//   final String fare;
//   final Timestamp? timestamp;
//   final VoidCallback onAccept;
//
//   const RideRequestCard({
//     super.key,
//     required this.rideId,
//     required this.pickup,
//     required this.drop,
//     required this.fare,
//     this.timestamp,
//     required this.onAccept,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     String formattedTime = "Unknown time";
//     if (timestamp != null) {
//       DateTime dateTime =
//       DateTime.fromMillisecondsSinceEpoch(timestamp!.seconds * 1000);
//       formattedTime = DateFormat('MMM d, yyyy - h:mm a').format(dateTime);
//     }
//
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Pickup: $pickup",
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 5),
//             Text("Drop: $drop", style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 5),
//             Text("Fare: $fare", style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 10),
//             Text("Requested at: $formattedTime",
//                 style: const TextStyle(color: Colors.grey)),
//             const SizedBox(height: 15),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: onAccept,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8)),
//                 ),
//                 child: const Text("Accept Ride"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }





// When no ride is accepted, the driver sees all pending ride requests.
//
// Once the driver accepts one ride, all others disappear and the accepted ride summary is shown.
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// class DriverDashboard extends StatefulWidget {
//   const DriverDashboard({super.key});
//
//   @override
//   State<DriverDashboard> createState() => _DriverDashboardState();
// }
//
// class _DriverDashboardState extends State<DriverDashboard> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   List<DocumentSnapshot> rideRequests = [];
//   DocumentSnapshot? acceptedRide;
//   final currentUser = FirebaseAuth.instance.currentUser;
//
//   @override
//   void initState() {
//     super.initState();
//     _listenToAcceptedRide();
//     _fetchPendingRides();
//   }
//
//   void _fetchPendingRides() {
//     _firestore
//         .collection('ride_requests')
//         .where('status', isEqualTo: 'Pending')
//         .orderBy('timestamp', descending: true)
//         .snapshots(includeMetadataChanges: true)
//         .listen((snapshot) {
//       if (mounted && acceptedRide == null) {
//         setState(() {
//           rideRequests = snapshot.docs;
//         });
//       }
//     });
//   }
//
//   void _listenToAcceptedRide() {
//     if (currentUser == null) return;
//
//     _firestore
//         .collection('ride_requests')
//         .where('status', isEqualTo: 'Accepted')
//         .where('driverId', isEqualTo: currentUser!.uid)
//         .limit(1)
//         .snapshots()
//         .listen((snapshot) {
//       if (mounted) {
//         if (snapshot.docs.isNotEmpty) {
//           setState(() {
//             acceptedRide = snapshot.docs.first;
//             rideRequests.clear();
//           });
//         } else {
//           setState(() {
//             acceptedRide = null;
//           });
//         }
//       }
//     });
//   }
//
//   Future<void> _acceptRide(String rideId) async {
//     try {
//       if (currentUser == null) {
//         print("No user is logged in.");
//         return;
//       }
//
//       await _firestore.collection('ride_requests').doc(rideId).update({
//         'status': 'Accepted',
//         'driverId': currentUser!.uid,
//       });
//
//       print("Ride accepted and assigned to driver.");
//     } catch (e) {
//       print("Error accepting ride request: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Driver Dashboard"),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: acceptedRide != null
//           ? AcceptedRideCard(data: acceptedRide!.data() as Map<String, dynamic>)
//           : rideRequests.isEmpty
//           ? const Center(child: Text("No pending ride requests."))
//           : ListView.builder(
//         itemCount: rideRequests.length,
//         itemBuilder: (context, index) {
//           var ride = rideRequests[index];
//           var data = ride.data() as Map<String, dynamic>;
//
//           return RideRequestCard(
//             rideId: ride.id,
//             pickup: data['pickup'] ?? 'Unknown',
//             drop: data['drop'] ?? 'Unknown',
//             fare: data['fare']?.toString() ?? 'N/A',
//             timestamp: data['timestamp'] as Timestamp?,
//             onAccept: () => _acceptRide(ride.id),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class RideRequestCard extends StatelessWidget {
//   final String rideId;
//   final String pickup;
//   final String drop;
//   final String fare;
//   final Timestamp? timestamp;
//   final VoidCallback onAccept;
//
//   const RideRequestCard({
//     super.key,
//     required this.rideId,
//     required this.pickup,
//     required this.drop,
//     required this.fare,
//     this.timestamp,
//     required this.onAccept,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     String formattedTime = "Unknown time";
//     if (timestamp != null) {
//       DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp!.seconds * 1000);
//       formattedTime = DateFormat('MMM d, yyyy - h:mm a').format(dateTime);
//     }
//
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Pickup: $pickup", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 5),
//             Text("Drop: $drop", style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 5),
//             Text("Fare: ₹$fare", style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 10),
//             Text("Requested at: $formattedTime", style: const TextStyle(color: Colors.grey)),
//             const SizedBox(height: 15),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: onAccept,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                 ),
//                 child: const Text("Accept Ride"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class AcceptedRideCard extends StatelessWidget {
//   final Map<String, dynamic> data;
//
//   const AcceptedRideCard({super.key, required this.data});
//
//   @override
//   Widget build(BuildContext context) {
//     final pickup = data['pickup'] ?? 'Unknown';
//     final drop = data['drop'] ?? 'Unknown';
//     final fare = data['fare']?.toString() ?? 'N/A';
//     final timestamp = data['timestamp'] as Timestamp?;
//     String formattedTime = "Unknown time";
//
//     if (timestamp != null) {
//       DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
//       formattedTime = DateFormat('MMM d, yyyy - h:mm a').format(dateTime);
//     }
//
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Card(
//         elevation: 5,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text("🚗 Ride Assigned", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//               const Divider(height: 20, thickness: 1.5),
//               Text("Pickup: $pickup", style: const TextStyle(fontSize: 16)),
//               const SizedBox(height: 5),
//               Text("Drop: $drop", style: const TextStyle(fontSize: 16)),
//               const SizedBox(height: 5),
//               Text("Fare: $fare", style: const TextStyle(fontSize: 16)),
//               const SizedBox(height: 10),
//               Text("Accepted at: $formattedTime", style: const TextStyle(color: Colors.grey)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }




//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// class DriverDashboard extends StatefulWidget {
//   const DriverDashboard({super.key});
//
//   @override
//   State<DriverDashboard> createState() => _DriverDashboardState();
// }
//
// class _DriverDashboardState extends State<DriverDashboard> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   List<DocumentSnapshot> rideRequests = [];
//   DocumentSnapshot? acceptedRide;
//   final currentUser = FirebaseAuth.instance.currentUser;
//
//   @override
//   void initState() {
//     super.initState();
//     _listenToAcceptedRide();
//     _fetchPendingRides();
//   }
//
//   void _fetchPendingRides() {
//     _firestore
//         .collection('ride_requests')
//         .where('status', isEqualTo: 'Pending')
//         .orderBy('timestamp', descending: true)
//         .snapshots(includeMetadataChanges: true)
//         .listen((snapshot) {
//       if (mounted && acceptedRide == null) {
//         setState(() {
//           rideRequests = snapshot.docs;
//         });
//       }
//     });
//   }
//
//   void _listenToAcceptedRide() {
//     if (currentUser == null) return;
//
//     _firestore
//         .collection('ride_requests')
//         .where('status', isEqualTo: 'Accepted')
//         .where('driverId', isEqualTo: currentUser!.uid)
//         .limit(1)
//         .snapshots()
//         .listen((snapshot) {
//       if (mounted) {
//         if (snapshot.docs.isNotEmpty) {
//           setState(() {
//             acceptedRide = snapshot.docs.first;
//             rideRequests.clear();
//           });
//         } else {
//           setState(() {
//             acceptedRide = null;
//           });
//         }
//       }
//     });
//   }
//
//   Future<void> _acceptRide(String rideId) async {
//     try {
//       if (currentUser == null) return;
//
//       await _firestore.collection('ride_requests').doc(rideId).update({
//         'status': 'Accepted',
//         'driverId': currentUser!.uid,
//       });
//     } catch (e) {
//       print("Error accepting ride request: $e");
//     }
//   }
//
//   Future<void> _updateRideStatus(String rideId, String newStatus) async {
//     try {
//       await _firestore.collection('ride_requests').doc(rideId).update({
//         'status': newStatus,
//       });
//
//       setState(() {
//         acceptedRide = null;
//       });
//
//       _fetchPendingRides();
//     } catch (e) {
//       print("Error updating ride status: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Driver Dashboard"),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: acceptedRide != null
//           ? AcceptedRideCard(
//         data: acceptedRide!.data() as Map<String, dynamic>,
//         rideId: acceptedRide!.id,
//         onEndRide: () => _updateRideStatus(acceptedRide!.id, 'Completed'),
//         onCancelRide: () => _updateRideStatus(acceptedRide!.id, 'Cancelled'),
//       )
//           : rideRequests.isEmpty
//           ? const Center(child: Text("No pending ride requests."))
//           : ListView.builder(
//         itemCount: rideRequests.length,
//         itemBuilder: (context, index) {
//           var ride = rideRequests[index];
//           var data = ride.data() as Map<String, dynamic>;
//
//           return RideRequestCard(
//             rideId: ride.id,
//             pickup: data['pickup'] ?? 'Unknown',
//             drop: data['drop'] ?? 'Unknown',
//             fare: data['fare']?.toString() ?? 'N/A',
//             timestamp: data['timestamp'] as Timestamp?,
//             onAccept: () => _acceptRide(ride.id),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class RideRequestCard extends StatelessWidget {
//   final String rideId;
//   final String pickup;
//   final String drop;
//   final String fare;
//   final Timestamp? timestamp;
//   final VoidCallback onAccept;
//
//   const RideRequestCard({
//     super.key,
//     required this.rideId,
//     required this.pickup,
//     required this.drop,
//     required this.fare,
//     this.timestamp,
//     required this.onAccept,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     String formattedTime = "Unknown time";
//     if (timestamp != null) {
//       DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp!.seconds * 1000);
//       formattedTime = DateFormat('MMM d, yyyy - h:mm a').format(dateTime);
//     }
//
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Pickup: $pickup", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 5),
//             Text("Drop: $drop", style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 5),
//             Text("Fare: $fare", style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 10),
//             Text("Requested at: $formattedTime", style: const TextStyle(color: Colors.grey)),
//             const SizedBox(height: 15),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: onAccept,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                 ),
//                 child: const Text("Accept Ride"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class AcceptedRideCard extends StatelessWidget {
//   final Map<String, dynamic> data;
//   final String rideId;
//   final VoidCallback onEndRide;
//   final VoidCallback onCancelRide;
//
//   const AcceptedRideCard({
//     super.key,
//     required this.data,
//     required this.rideId,
//     required this.onEndRide,
//     required this.onCancelRide,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final pickup = data['pickup'] ?? 'Unknown';
//     final drop = data['drop'] ?? 'Unknown';
//     final fare = data['fare']?.toString() ?? 'N/A';
//     final timestamp = data['timestamp'] as Timestamp?;
//     String formattedTime = "Unknown time";
//
//     if (timestamp != null) {
//       DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
//       formattedTime = DateFormat('MMM d, yyyy - h:mm a').format(dateTime);
//     }
//
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Card(
//         elevation: 5,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text("🚗 Ride Assigned", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//               const Divider(height: 20, thickness: 1.5),
//               Text("Pickup: $pickup", style: const TextStyle(fontSize: 16)),
//               const SizedBox(height: 5),
//               Text("Drop: $drop", style: const TextStyle(fontSize: 16)),
//               const SizedBox(height: 5),
//               Text("Fare: $fare", style: const TextStyle(fontSize: 16)),
//               const SizedBox(height: 10),
//               Text("Accepted at: $formattedTime", style: const TextStyle(color: Colors.grey)),
//               const SizedBox(height: 20),
//               Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: onEndRide,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         foregroundColor: Colors.white,
//                       ),
//                       child: const Text("End Ride"),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: onCancelRide,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                         foregroundColor: Colors.white,
//                       ),
//                       child: const Text("Cancel Ride"),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//




//
// With these changes, once the driver clicks
// "Accept Ride," the ride's details will be shown '
// 'immediately, replacing the pending ride requests. '
// 'Let me know if you need further adjustments!

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverDashboard extends StatefulWidget {
  const DriverDashboard({super.key});

  @override
  State<DriverDashboard> createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> rideRequests = [];
  DocumentSnapshot? acceptedRide;
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _listenToAcceptedRide();
    _fetchPendingRides();
  }

  void _fetchPendingRides() {
    _firestore
        .collection('ride_requests')
        .where('status', isEqualTo: 'Pending')
        .orderBy('timestamp', descending: true)
        .snapshots(includeMetadataChanges: true)
        .listen((snapshot) {
      if (mounted && acceptedRide == null) {
        setState(() {
          rideRequests = snapshot.docs;
        });
      }
    });
  }

  void _listenToAcceptedRide() {
    if (currentUser == null) return;

    _firestore
        .collection('ride_requests')
        .where('status', isEqualTo: 'Accepted')
        .where('driverId', isEqualTo: currentUser!.uid)
        .limit(1)
        .snapshots()
        .listen((snapshot) {
      if (mounted) {
        if (snapshot.docs.isNotEmpty) {
          setState(() {
            acceptedRide = snapshot.docs.first;
            rideRequests.clear();
          });
        } else {
          setState(() {
            acceptedRide = null;
          });
        }
      }
    });
  }

  Future<void> _acceptRide(String rideId) async {
    try {
      if (currentUser == null) return;

      await _firestore.collection('ride_requests').doc(rideId).update({
        'status': 'Accepted',
        'driverId': currentUser!.uid,
      });

      DocumentSnapshot ride = await _firestore.collection('ride_requests').doc(rideId).get();
      setState(() {
        acceptedRide = ride;
        rideRequests.clear();
      });
    } catch (e) {
      print("Error accepting ride request: $e");
    }
  }

  Future<void> _updateRideStatus(String rideId, String newStatus) async {
    try {
      await _firestore.collection('ride_requests').doc(rideId).update({
        'status': newStatus,
      });

      setState(() {
        acceptedRide = null;
      });

      _fetchPendingRides();
    } catch (e) {
      print("Error updating ride status: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Driver Dashboard", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFB71C1C),
        centerTitle: true,
        elevation: 4,
      ),
      body: acceptedRide != null
          ? AcceptedRideCard(
              data: acceptedRide!.data() as Map<String, dynamic>,
              rideId: acceptedRide!.id,
              onEndRide: () => _updateRideStatus(acceptedRide!.id, 'Completed'),
              onCancelRide: () => _updateRideStatus(acceptedRide!.id, 'Cancelled'),
            )
          : rideRequests.isEmpty
              ? const Center(child: Text("No pending ride requests.", style: TextStyle(fontSize: 16)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: rideRequests.length,
                  itemBuilder: (context, index) {
                    var ride = rideRequests[index];
                    var data = ride.data() as Map<String, dynamic>;

                    return RideRequestCard(
                      rideId: ride.id,
                      pickup: data['pickup'] ?? 'Unknown',
                      drop: data['drop'] ?? 'Unknown',
                      fare: data['fare']?.toString() ?? 'N/A',
                      timestamp: data['timestamp'] as Timestamp?,
                      onAccept: () => _acceptRide(ride.id),
                    );
                  },
                ),
    );
  }
}

class RideRequestCard extends StatelessWidget {
  final String rideId;
  final String pickup;
  final String drop;
  final String fare;
  final Timestamp? timestamp;
  final VoidCallback onAccept;

  const RideRequestCard({
    super.key,
    required this.rideId,
    required this.pickup,
    required this.drop,
    required this.fare,
    this.timestamp,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    String formattedTime = "Unknown time";
    if (timestamp != null) {
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp!.seconds * 1000);
      formattedTime = DateFormat('MMM d, yyyy - h:mm a').format(dateTime);
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pickup: $pickup", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Drop: $drop", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text("Fare: ₹$fare", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text("Requested: $formattedTime", style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onAccept,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB71C1C),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Accept Ride", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AcceptedRideCard extends StatefulWidget {
  final Map<String, dynamic> data;
  final String rideId;
  final VoidCallback onEndRide;
  final VoidCallback onCancelRide;

  const AcceptedRideCard({
    super.key,
    required this.data,
    required this.rideId,
    required this.onEndRide,
    required this.onCancelRide,
  });

  @override
  State<AcceptedRideCard> createState() => _AcceptedRideCardState();
}

class _AcceptedRideCardState extends State<AcceptedRideCard> {
  LatLng? pickupLatLng;
  LatLng? dropLatLng;
  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    _resolveLocations();
  }

  Future<void> _resolveLocations() async {
    try {
      List<Location> pickupLocations = await locationFromAddress(widget.data['pickup']);
      List<Location> dropLocations = await locationFromAddress(widget.data['drop']);

      setState(() {
        pickupLatLng = LatLng(pickupLocations.first.latitude, pickupLocations.first.longitude);
        dropLatLng = LatLng(dropLocations.first.latitude, dropLocations.first.longitude);
      });
    } catch (e) {
      print("Error resolving locations: $e");
    }
  }

  void _launchGoogleMapsNavigation() {
    if (pickupLatLng != null && dropLatLng != null) {
      final url = Uri.parse(
          'https://www.google.com/maps/dir/?api=1&origin=${pickupLatLng!.latitude},${pickupLatLng!.longitude}&destination=${dropLatLng!.latitude},${dropLatLng!.longitude}&travelmode=driving');
      launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pickup = widget.data['pickup'] ?? 'Unknown';
    final drop = widget.data['drop'] ?? 'Unknown';
    final fare = widget.data['fare']?.toString() ?? 'N/A';
    final timestamp = widget.data['timestamp'] as Timestamp?;
    String formattedTime = "Unknown time";

    if (timestamp != null) {
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
      formattedTime = DateFormat('MMM d, yyyy - h:mm a').format(dateTime);
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("🚕 Assigned Ride", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const Divider(height: 20, thickness: 1.5),
                  Text("Pickup: $pickup", style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text("Drop: $drop", style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text("Fare: ₹$fare", style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text("Accepted at: $formattedTime", style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: widget.onEndRide,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text("End Ride", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: widget.onCancelRide,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text("Cancel Ride", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (pickupLatLng != null && dropLatLng != null)
                    ElevatedButton.icon(
                      onPressed: _launchGoogleMapsNavigation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.navigation),
                      label: const Text("Navigate in Google Maps"),
                    ),
                ],
              ),
            ),
            if (pickupLatLng != null && dropLatLng != null)
              SizedBox(
                height: 200,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(target: pickupLatLng!, zoom: 13),
                  onMapCreated: (controller) => mapController = controller,
                  markers: {
                    Marker(markerId: const MarkerId('pickup'), position: pickupLatLng!),
                    Marker(markerId: const MarkerId('drop'), position: dropLatLng!),
                  },
                  polylines: {
                    Polyline(
                      polylineId: const PolylineId('route'),
                      color: Colors.red,
                      width: 5,
                      points: [pickupLatLng!, dropLatLng!],
                    ),
                  },
                ),
              )
            else
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text("Loading map...", style: TextStyle(color: Colors.grey)),
              ),
          ],
        ),
      ),
    );
  }
}
























//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// class DriverDashboard extends StatefulWidget {
//   const DriverDashboard({super.key});
//
//   @override
//   State<DriverDashboard> createState() => _DriverDashboardState();
// }
//
// class _DriverDashboardState extends State<DriverDashboard> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   List<DocumentSnapshot> rideRequests = [];
//   bool isLoading = true; // ✅ Loading state
//
//   @override
//   void initState() {
//     super.initState();
//     _clearFirestoreCache();
//     _fetchPendingRides();
//   }
//
//   /// ✅ Clears Firestore Cache to Prevent Stale Data Issues
//   Future<void> _clearFirestoreCache() async {
//     await _firestore.clearPersistence();
//   }
//
//   /// ✅ Fetches Pending Rides WITHOUT Real-time Listeners (Fixes Disappearing Data Issue)
//   Future<void> _fetchPendingRides() async {
//     try {
//       var snapshot = await _firestore
//           .collection('ride_requests')
//           .where('status', isEqualTo: 'Pending')
//           .orderBy('timestamp', descending: true)
//           .get();
//
//       if (mounted) {
//         setState(() {
//           rideRequests = snapshot.docs;
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print("Error fetching ride requests: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Driver Dashboard"),
//         backgroundColor: Colors.blueAccent,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: _fetchPendingRides, // ✅ Manual refresh button
//           ),
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator()) // ✅ Show loading indicator
//           : rideRequests.isEmpty
//           ? const Center(child: Text("No pending ride requests."))
//           : ListView.builder(
//         itemCount: rideRequests.length,
//         itemBuilder: (context, index) {
//           var ride = rideRequests[index];
//           var data = ride.data() as Map<String, dynamic>;
//
//           return RideRequestCard(
//             pickup: data['pickup'] ?? 'Unknown',
//             drop: data['drop'] ?? 'Unknown',
//             fare: data['fare']?.toString() ?? 'N/A',
//             timestamp: data['timestamp'] as Timestamp?,
//           );
//         },
//       ),
//     );
//   }
// }
//
// class RideRequestCard extends StatelessWidget {
//   final String pickup;
//   final String drop;
//   final String fare;
//   final Timestamp? timestamp;
//
//   const RideRequestCard({
//     super.key,
//     required this.pickup,
//     required this.drop,
//     required this.fare,
//     this.timestamp,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     String formattedTime = "Unknown time";
//     if (timestamp != null) {
//       DateTime dateTime =
//       DateTime.fromMillisecondsSinceEpoch(timestamp!.seconds * 1000);
//       formattedTime = DateFormat('MMM d, yyyy - h:mm a').format(dateTime);
//     }
//
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Pickup: $pickup",
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 5),
//             Text("Drop: $drop", style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 5),
//             Text("Fare: \$ $fare", style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 10),
//             Text("Requested at: $formattedTime",
//                 style: const TextStyle(color: Colors.grey)),
//           ],
//         ),
//       ),
//     );
//   }
// }
//




// Here is the updated code with an "Accept Ride" button added to each request card:
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// class DriverDashboard extends StatefulWidget {
//   const DriverDashboard({super.key});
//
//   @override
//   State<DriverDashboard> createState() => _DriverDashboardState();
// }
//
// class _DriverDashboardState extends State<DriverDashboard> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   List<DocumentSnapshot> rideRequests = [];
//   bool isLoading = true; // ✅ Loading state
//
//   @override
//   void initState() {
//     super.initState();
//     _clearFirestoreCache();
//     _fetchPendingRides();
//   }
//
//   /// ✅ Clears Firestore Cache to Prevent Stale Data Issues
//   Future<void> _clearFirestoreCache() async {
//     await _firestore.clearPersistence();
//   }
//
//   /// ✅ Fetches Pending Rides WITHOUT Real-time Listeners (Fixes Disappearing Data Issue)
//   Future<void> _fetchPendingRides() async {
//     try {
//       var snapshot = await _firestore
//           .collection('ride_requests')
//           .where('status', isEqualTo: 'Pending')
//           .orderBy('timestamp', descending: true)
//           .get();
//
//       if (mounted) {
//         setState(() {
//           rideRequests = snapshot.docs;
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print("Error fetching ride requests: $e");
//     }
//   }
//
//   /// ✅ Handles accepting a ride request
//   Future<void> _acceptRide(String rideId) async {
//     try {
//       await _firestore.collection('ride_requests').doc(rideId).update({
//         'status': 'Accepted',
//       });
//
//       // Refresh ride list after accepting
//       _fetchPendingRides();
//     } catch (e) {
//       print("Error accepting ride request: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Driver Dashboard"),
//         backgroundColor: Colors.blueAccent,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: _fetchPendingRides, // ✅ Manual refresh button
//           ),
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator()) // ✅ Show loading indicator
//           : rideRequests.isEmpty
//           ? const Center(child: Text("No pending ride requests."))
//           : ListView.builder(
//         itemCount: rideRequests.length,
//         itemBuilder: (context, index) {
//           var ride = rideRequests[index];
//           var data = ride.data() as Map<String, dynamic>;
//
//           return RideRequestCard(
//             rideId: ride.id,
//             pickup: data['pickup'] ?? 'Unknown',
//             drop: data['drop'] ?? 'Unknown',
//             fare: data['fare']?.toString() ?? 'N/A',
//             timestamp: data['timestamp'] as Timestamp?,
//             onAccept: () => _acceptRide(ride.id),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class RideRequestCard extends StatelessWidget {
//   final String rideId;
//   final String pickup;
//   final String drop;
//   final String fare;
//   final Timestamp? timestamp;
//   final VoidCallback onAccept;
//
//   const RideRequestCard({
//     super.key,
//     required this.rideId,
//     required this.pickup,
//     required this.drop,
//     required this.fare,
//     this.timestamp,
//     required this.onAccept,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     String formattedTime = "Unknown time";
//     if (timestamp != null) {
//       DateTime dateTime =
//       DateTime.fromMillisecondsSinceEpoch(timestamp!.seconds * 1000);
//       formattedTime = DateFormat('MMM d, yyyy - h:mm a').format(dateTime);
//     }
//
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Pickup: $pickup",
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 5),
//             Text("Drop: $drop", style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 5),
//             Text("Fare: \$ $fare", style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 10),
//             Text("Requested at: $formattedTime",
//                 style: const TextStyle(color: Colors.grey)),
//             const SizedBox(height: 15),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: onAccept,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8)),
//                 ),
//                 child: const Text("Accept Ride"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
