// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class RiderSummaryCard extends StatelessWidget {
//   final String rideRequestId;
//
//   const RiderSummaryCard({Key? key, required this.rideRequestId}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<DocumentSnapshot>(
//       stream: FirebaseFirestore.instance.collection('ride_requests').doc(rideRequestId).snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const SizedBox();
//         }
//
//         var rideData = snapshot.data!;
//         return Card(
//           margin: const EdgeInsets.all(16),
//           child: ListTile(
//             title: Text("Pickup: ${rideData['pickup']}"),
//             subtitle: Text("Drop: ${rideData['drop']}\nFare: ${rideData['fare']}"),
//             trailing: Text(rideData['status']),
//           ),
//         );
//       },
//     );
//   }
// }




//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class RiderSummaryCard extends StatelessWidget {
//   final String rideRequestId;
//
//   const RiderSummaryCard({Key? key, required this.rideRequestId}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<DocumentSnapshot>(
//       stream: FirebaseFirestore.instance.collection('ride_requests').doc(rideRequestId).snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const SizedBox();
//         }
//
//         var rideData = snapshot.data!;
//         return Card(
//           margin: const EdgeInsets.all(16),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           elevation: 4,
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "Ride Summary",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
//                 ),
//                 const Divider(),
//                 Text(
//                   "Pickup Location: ${rideData['pickup']}",
//                   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   "Drop Location: ${rideData['drop']}",
//                   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   "Fare: ${rideData['fare']}",
//                   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.green),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   "Status: ${rideData['status']}",
//                   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
//                 ),
//               ],
//             ),
//           ),
//         );
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
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class RiderSummaryCard extends StatefulWidget {
//   final String rideRequestId;
//
//   const RiderSummaryCard({Key? key, required this.rideRequestId}) : super(key: key);
//
//   @override
//   State<RiderSummaryCard> createState() => _RiderSummaryCardState();
// }
//
// class _RiderSummaryCardState extends State<RiderSummaryCard> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<Offset> _animation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//
//     _animation = Tween<Offset>(
//       begin: const Offset(0, 1),
//       end: const Offset(0, 0),
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeOut,
//     ));
//   }
//
//   void _triggerAnimation() {
//     _controller.forward();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   Color _getStatusColor(String status) {
//     switch (status) {
//       case "Pending":
//         return Colors.orange;
//       case "Matched":
//         return Colors.blue;
//       case "Completed":
//         return Colors.green;
//       case "Cancelled":
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<DocumentSnapshot>(
//       stream: FirebaseFirestore.instance.collection('ride_requests').doc(widget.rideRequestId).snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const SizedBox();
//         }
//
//         var rideData = snapshot.data!;
//         _triggerAnimation();
//
//         return SlideTransition(
//           position: _animation,
//           child: Card(
//             margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//             elevation: 6,
//             shadowColor: Colors.black26,
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildTitleRow(),
//                   const Divider(thickness: 1, color: Colors.grey),
//                   _buildInfoRow(Icons.my_location, "Pickup Location", rideData['pickup'], Colors.blue),
//                   const SizedBox(height: 8),
//                   _buildInfoRow(Icons.location_on, "Drop Location", rideData['drop'], Colors.red),
//                   const SizedBox(height: 8),
//                   _buildInfoRow(Icons.attach_money, "Fare", rideData['fare'], Colors.green),
//                   const SizedBox(height: 8),
//                   _buildStatusIndicator(rideData['status']),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildTitleRow() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         const Text(
//           "🚗 Ride Summary",
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
//         ),
//         Icon(Icons.directions_car, color: Colors.blue.shade700, size: 30),
//       ],
//     );
//   }
//
//   Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
//     return Row(
//       children: [
//         Icon(icon, color: color, size: 24),
//         const SizedBox(width: 10),
//         Expanded(
//           child: Text(
//             "$label: $value",
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildStatusIndicator(String status) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//       decoration: BoxDecoration(
//         color: _getStatusColor(status).withOpacity(0.2),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: [
//           Icon(Icons.info, color: _getStatusColor(status)),
//           const SizedBox(width: 8),
//           Text(
//             "Status: $status",
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: _getStatusColor(status),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//





// WORKING FINE
//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:async';
//
// class RiderSummaryCard extends StatefulWidget {
//   final String rideRequestId;
//
//   const RiderSummaryCard({Key? key, required this.rideRequestId}) : super(key: key);
//
//   @override
//   State<RiderSummaryCard> createState() => _RiderSummaryCardState();
// }
//
// class _RiderSummaryCardState extends State<RiderSummaryCard> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<Offset> _animation;
//   int dotCount = 1;
//
//   @override
//   void initState() {
//     super.initState();
//     _startDotLoadingAnimation();
//
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//
//     _animation = Tween<Offset>(
//       begin: const Offset(0, 1),
//       end: const Offset(0, 0),
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeOut,
//     ));
//   }
//
//   void _startDotLoadingAnimation() {
//     Timer.periodic(const Duration(milliseconds: 500), (timer) {
//       setState(() {
//         dotCount = (dotCount % 3) + 1;
//       });
//     });
//   }
//
//   void _triggerAnimation() {
//     _controller.forward();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   Color _getStatusColor(String status) {
//     switch (status) {
//       case "Pending":
//         return Colors.orange;
//       case "Matched":
//         return Colors.blue;
//       case "Completed":
//         return Colors.green;
//       case "Cancelled":
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<DocumentSnapshot>(
//       stream: FirebaseFirestore.instance.collection('ride_requests').doc(widget.rideRequestId).snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const SizedBox();
//         }
//
//         var rideData = snapshot.data!;
//         _triggerAnimation();
//
//         return SlideTransition(
//           position: _animation,
//           child: Card(
//             margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//             elevation: 6,
//             shadowColor: Colors.black26,
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildTitleRow(),
//                   const Divider(thickness: 1, color: Colors.grey),
//                   _buildInfoRow(Icons.my_location, "Pickup", rideData['pickup'], Colors.blue),
//                   const SizedBox(height: 8),
//                   _buildInfoRow(Icons.location_on, "Drop", rideData['drop'], Colors.red),
//                   const SizedBox(height: 8),
//                   _buildInfoRow(Icons.attach_money, "Fare", rideData['fare'], Colors.green),
//                   const SizedBox(height: 8),
//                   _buildStatusIndicator(rideData['status']),
//                   if (rideData['status'] == "Pending") _buildWaitingForDriverAnimation(),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildTitleRow() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         const Text(
//           "🚗 Ride Summary",
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
//         ),
//         Icon(Icons.directions_car, color: Colors.blue.shade700, size: 30),
//       ],
//     );
//   }
//
//   Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
//     return Row(
//       children: [
//         Icon(icon, color: color, size: 24),
//         const SizedBox(width: 10),
//         Expanded(
//           child: Text(
//             "$label: $value",
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildStatusIndicator(String status) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//       decoration: BoxDecoration(
//         color: _getStatusColor(status).withOpacity(0.2),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: [
//           Icon(Icons.info, color: _getStatusColor(status)),
//           const SizedBox(width: 8),
//           Text(
//             "Status: $status",
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: _getStatusColor(status),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildWaitingForDriverAnimation() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 12),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Text(
//             "Waiting for driver to accept",
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
//           ),
//           const SizedBox(width: 5),
//           _buildLoadingDots(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLoadingDots() {
//     String dots = ".." * dotCount;
//     return Text(
//       dots,
//       style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
//     );
//   }
// }









//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:async';
//
// class RiderSummaryCard extends StatefulWidget {
//   final String rideRequestId;
//
//   const RiderSummaryCard({Key? key, required this.rideRequestId}) : super(key: key);
//
//   @override
//   State<RiderSummaryCard> createState() => _RiderSummaryCardState();
// }
//
// class _RiderSummaryCardState extends State<RiderSummaryCard> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<Offset> _animation;
//   int dotCount = 1;
//   bool isCancelled = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _startDotLoadingAnimation();
//
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//
//     _animation = Tween<Offset>(
//       begin: const Offset(0, 1),
//       end: const Offset(0, 0),
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeOut,
//     ));
//   }
//
//   void _startDotLoadingAnimation() {
//     Timer.periodic(const Duration(milliseconds: 500), (timer) {
//       if (!mounted) {
//         timer.cancel();
//         return;
//       }
//       setState(() {
//         dotCount = (dotCount % 3) + 1;
//       });
//     });
//   }
//
//   void _triggerAnimation() {
//     _controller.forward();
//   }
//
//   Future<void> _cancelRide() async {
//     await FirebaseFirestore.instance.collection('ride_requests').doc(widget.rideRequestId).update({
//       'status': 'Cancelled',
//     });
//     setState(() {
//       isCancelled = true;
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   Color _getStatusColor(String status) {
//     switch (status) {
//       case "Pending":
//         return Colors.orange;
//       case "Matched":
//         return Colors.blue;
//       case "Completed":
//         return Colors.green;
//       case "Cancelled":
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (isCancelled) return const SizedBox();
//
//     return StreamBuilder<DocumentSnapshot>(
//       stream: FirebaseFirestore.instance.collection('ride_requests').doc(widget.rideRequestId).snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData || snapshot.data?.data() == null) {
//           return const SizedBox();
//         }
//
//         var rideData = snapshot.data!;
//         if (rideData['status'] == 'Cancelled') {
//           return const SizedBox();
//         }
//
//         _triggerAnimation();
//
//         return SlideTransition(
//           position: _animation,
//           child: Card(
//             margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//             elevation: 6,
//             shadowColor: Colors.black26,
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildTitleRow(),
//                   const Divider(thickness: 1, color: Colors.grey),
//                   _buildInfoRow(Icons.my_location, "Pickup", rideData['pickup'], Colors.blue),
//                   const SizedBox(height: 8),
//                   _buildInfoRow(Icons.location_on, "Drop", rideData['drop'], Colors.red),
//                   const SizedBox(height: 8),
//                   _buildInfoRow(Icons.attach_money, "Fare", rideData['fare'], Colors.green),
//                   const SizedBox(height: 8),
//                   _buildStatusIndicator(rideData['status']),
//                   if (rideData['status'] == "Pending") _buildWaitingForDriverAnimation(),
//                   const SizedBox(height: 12),
//                   if (rideData['status'] == "Pending") _buildCancelButton(),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildTitleRow() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         const Text(
//           "🚗 Ride Summary",
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
//         ),
//         Icon(Icons.directions_car, color: Colors.blue.shade700, size: 30),
//       ],
//     );
//   }
//
//   Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
//     return Row(
//       children: [
//         Icon(icon, color: color, size: 24),
//         const SizedBox(width: 10),
//         Expanded(
//           child: Text(
//             "$label: $value",
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildStatusIndicator(String status) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//       decoration: BoxDecoration(
//         color: _getStatusColor(status).withOpacity(0.2),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: [
//           Icon(Icons.info, color: _getStatusColor(status)),
//           const SizedBox(width: 8),
//           Text(
//             "Status: $status",
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: _getStatusColor(status),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildWaitingForDriverAnimation() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 12),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Text(
//             "Waiting for driver to accept",
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
//           ),
//           const SizedBox(width: 5),
//           _buildLoadingDots(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLoadingDots() {
//     String dots = ".." * dotCount;
//     return Text(
//       dots,
//       style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
//     );
//   }
//
//   Widget _buildCancelButton() {
//     return Center(
//       child: ElevatedButton(
//         onPressed: _cancelRide,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.red,
//           foregroundColor: Colors.white,
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//         child: const Text(
//           "Cancel Ride",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }
//
//








// Here is the complete updated rider_summary_card.dart file with
// all the necessary fixes to ensure the RiderSummaryCard disappears when a ride
// is canceled and reappears correctly when a new ride request is made.
// 1
//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:async';
//
// class RiderSummaryCard extends StatefulWidget {
//   final String rideRequestId;
//
//   const RiderSummaryCard({Key? key, required this.rideRequestId}) : super(key: key);
//
//   @override
//   State<RiderSummaryCard> createState() => _RiderSummaryCardState();
// }
//
// class _RiderSummaryCardState extends State<RiderSummaryCard> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<Offset> _animation;
//   int dotCount = 1;
//   bool isCancelled = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _startDotLoadingAnimation();
//     _initializeAnimation();
//   }
//
//   void _initializeAnimation() {
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//
//     _animation = Tween<Offset>(
//       begin: const Offset(0, 1),
//       end: const Offset(0, 0),
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeOut,
//     ));
//
//     _controller.forward();
//   }
//
//   void _startDotLoadingAnimation() {
//     Timer.periodic(const Duration(milliseconds: 500), (timer) {
//       if (!mounted) {
//         timer.cancel();
//         return;
//       }
//       setState(() {
//         dotCount = (dotCount % 3) + 1;
//       });
//     });
//   }
//
//   Future<void> _cancelRide() async {
//     await FirebaseFirestore.instance.collection('ride_requests').doc(widget.rideRequestId).update({
//       'status': 'Cancelled',
//     });
//
//     setState(() {
//       isCancelled = true;
//     });
//   }
//
//   @override
//   void didUpdateWidget(covariant RiderSummaryCard oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.rideRequestId != oldWidget.rideRequestId) {
//       setState(() {
//         isCancelled = false; // Reset the cancel state when a new ride request is made
//       });
//       _initializeAnimation(); // Re-trigger animation for new request
//     }
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   Color _getStatusColor(String status) {
//     switch (status) {
//       case "Pending":
//         return Colors.orange;
//       case "Matched":
//         return Colors.blue;
//       case "Completed":
//         return Colors.green;
//       case "Cancelled":
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (isCancelled) return const SizedBox(); // Hide if ride is cancelled
//
//     return StreamBuilder<DocumentSnapshot>(
//       stream: FirebaseFirestore.instance.collection('ride_requests').doc(widget.rideRequestId).snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData || snapshot.data?.data() == null) {
//           return const SizedBox();
//         }
//
//         var rideData = snapshot.data!;
//         if (rideData['status'] == 'Cancelled') {
//           return const SizedBox();
//         }
//
//         return SlideTransition(
//           position: _animation,
//           child: Card(
//             margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//             elevation: 6,
//             shadowColor: Colors.black26,
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildTitleRow(),
//                   const Divider(thickness: 1, color: Colors.grey),
//                   _buildInfoRow(Icons.my_location, "Pickup", rideData['pickup'], Colors.blue),
//                   const SizedBox(height: 8),
//                   _buildInfoRow(Icons.location_on, "Drop", rideData['drop'], Colors.red),
//                   const SizedBox(height: 8),
//                   _buildInfoRow(Icons.attach_money, "Fare", rideData['fare'], Colors.green),
//                   const SizedBox(height: 8),
//                   _buildStatusIndicator(rideData['status']),
//                   if (rideData['status'] == "Pending") _buildWaitingForDriverAnimation(),
//                   const SizedBox(height: 12),
//                   if (rideData['status'] == "Pending") _buildCancelButton(),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildTitleRow() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         const Text(
//           "🚗 Ride Summary",
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
//         ),
//         Icon(Icons.directions_car, color: Colors.blue.shade700, size: 30),
//       ],
//     );
//   }
//
//   Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
//     return Row(
//       children: [
//         Icon(icon, color: color, size: 24),
//         const SizedBox(width: 10),
//         Expanded(
//           child: Text(
//             "$label: $value",
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildStatusIndicator(String status) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//       decoration: BoxDecoration(
//         color: _getStatusColor(status).withOpacity(0.2),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: [
//           Icon(Icons.info, color: _getStatusColor(status)),
//           const SizedBox(width: 8),
//           Text(
//             "Status: $status",
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: _getStatusColor(status),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildWaitingForDriverAnimation() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 12),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Text(
//             "Waiting for driver to accept",
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
//           ),
//           const SizedBox(width: 5),
//           _buildLoadingDots(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLoadingDots() {
//     String dots = ".." * dotCount;
//     return Text(
//       dots,
//       style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
//     );
//   }
//
//   Widget _buildCancelButton() {
//     return Center(
//       child: ElevatedButton(
//         onPressed: _cancelRide,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.red,
//           foregroundColor: Colors.white,
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//         child: const Text(
//           "Cancel Ride",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }












// Enhancements:
// ✅ Smoother Slide Animation
// ✅ Better Typography & Spacing
// ✅ Gradient Background for Status Indicator
// ✅ Shimmer Effect for Loading Dots
// ✅ More Interactive Cancel Button with Confirmation Dialog
// ✅ Rounded, Elevated, and Better Styled Card



//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:async';
//
// class RiderSummaryCard extends StatefulWidget {
//   final String rideRequestId;
//
//   const RiderSummaryCard({Key? key, required this.rideRequestId}) : super(key: key);
//
//   @override
//   State<RiderSummaryCard> createState() => _RiderSummaryCardState();
// }
//
// class _RiderSummaryCardState extends State<RiderSummaryCard> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<Offset> _animation;
//   int dotCount = 1;
//   bool isCancelled = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _startDotLoadingAnimation();
//     _initializeAnimation();
//   }
//
//   void _initializeAnimation() {
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//
//     _animation = Tween<Offset>(
//       begin: const Offset(0, 1),
//       end: const Offset(0, 0),
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeOut,
//     ));
//
//     _controller.forward();
//   }
//
//   void _startDotLoadingAnimation() {
//     Timer.periodic(const Duration(milliseconds: 500), (timer) {
//       if (!mounted) {
//         timer.cancel();
//         return;
//       }
//       setState(() {
//         dotCount = (dotCount % 3) + 1;
//       });
//     });
//   }
//
//   Future<void> _cancelRide() async {
//     bool confirmCancel = await _showCancelConfirmationDialog();
//     if (!confirmCancel) return;
//
//     await FirebaseFirestore.instance.collection('ride_requests').doc(widget.rideRequestId).update({
//       'status': 'Cancelled',
//     });
//
//     setState(() {
//       isCancelled = true;
//     });
//   }
//
//   Future<bool> _showCancelConfirmationDialog() async {
//     return await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Cancel Ride"),
//         content: const Text("Are you sure you want to cancel this ride?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(false),
//             child: const Text("No"),
//           ),
//           ElevatedButton(
//             onPressed: () => Navigator.of(context).pop(true),
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: const Text("Yes"),
//           ),
//         ],
//       ),
//     ) ??
//         false;
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   Color _getStatusColor(String status) {
//     switch (status) {
//       case "Pending":
//         return Colors.orange;
//       case "Matched":
//         return Colors.blue;
//       case "Completed":
//         return Colors.green;
//       case "Cancelled":
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (isCancelled) return const SizedBox(); // Hide card if ride is cancelled
//
//     return StreamBuilder<DocumentSnapshot>(
//       stream: FirebaseFirestore.instance.collection('ride_requests').doc(widget.rideRequestId).snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData || snapshot.data?.data() == null) {
//           return const SizedBox();
//         }
//
//         var rideData = snapshot.data!;
//         if (rideData['status'] == 'Cancelled') {
//           return const SizedBox();
//         }
//
//         return SlideTransition(
//           position: _animation,
//           child: Card(
//             margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//             elevation: 8,
//             shadowColor: Colors.black26,
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildTitleRow(),
//                   const Divider(thickness: 1, color: Colors.grey),
//                   _buildInfoRow(Icons.my_location, "Pickup", rideData['pickup'], Colors.blue),
//                   const SizedBox(height: 8),
//                   _buildInfoRow(Icons.location_on, "Drop", rideData['drop'], Colors.red),
//                   const SizedBox(height: 8),
//                   _buildInfoRow(Icons.currency_rupee, "Fare", rideData['fare'], Colors.green),
//                   const SizedBox(height: 8),
//                   _buildStatusIndicator(rideData['status']),
//                   if (rideData['status'] == "Pending") _buildWaitingForDriverAnimation(),
//                   const SizedBox(height: 12),
//                   if (rideData['status'] == "Pending") _buildCancelButton(),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildTitleRow() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         const Text(
//           "🚗 Ride Summary",
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
//         ),
//         Icon(Icons.directions_car, color: Colors.blue.shade700, size: 30),
//       ],
//     );
//   }
//
//   Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
//     return Row(
//       children: [
//         Icon(icon, color: color, size: 24),
//         const SizedBox(width: 10),
//         Expanded(
//           child: Text(
//             "$label: $value",
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildStatusIndicator(String status) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [_getStatusColor(status).withOpacity(0.5), _getStatusColor(status)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: [
//           Icon(Icons.info, color: Colors.white),
//           const SizedBox(width: 8),
//           Text(
//             "Status: $status",
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildWaitingForDriverAnimation() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 12),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Text(
//             "Waiting for driver to accept",
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
//           ),
//           const SizedBox(width: 5),
//           _buildLoadingDots(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLoadingDots() {
//     String dots = "●" * dotCount;
//     return Text(
//       dots,
//       style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
//     );
//   }
//
//   Widget _buildCancelButton() {
//     return Center(
//       child: ElevatedButton(
//         onPressed: _cancelRide,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.red,
//           foregroundColor: Colors.white,
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//         child: const Text(
//           "Cancel Ride",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }








// Full Address Visibility:
// Used wrap with Expanded for the pickup and drop location fields so that the full address is always visible.
// Set maxLines: 2 to allow wrapping of text.
// Replaced Car Emoji with Bike Emoji:
// Changed "🚗" to "🏍️" to reflect the focus on bike ride-sharing



//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:async';
//
// class RiderSummaryCard extends StatefulWidget {
//   final String rideRequestId;
//
//   const RiderSummaryCard({Key? key, required this.rideRequestId}) : super(key: key);
//
//   @override
//   State<RiderSummaryCard> createState() => _RiderSummaryCardState();
// }
//
// class _RiderSummaryCardState extends State<RiderSummaryCard> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<Offset> _animation;
//   int dotCount = 1;
//   bool isCancelled = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _startDotLoadingAnimation();
//     _initializeAnimation();
//   }
//
//   void _initializeAnimation() {
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//
//     _animation = Tween<Offset>(
//       begin: const Offset(0, 1),
//       end: const Offset(0, 0),
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeOut,
//     ));
//
//     _controller.forward();
//   }
//
//   void _startDotLoadingAnimation() {
//     Timer.periodic(const Duration(milliseconds: 500), (timer) {
//       if (!mounted) {
//         timer.cancel();
//         return;
//       }
//       setState(() {
//         dotCount = (dotCount % 3) + 1;
//       });
//     });
//   }
//
//   Future<void> _cancelRide() async {
//     bool confirmCancel = await _showCancelConfirmationDialog();
//     if (!confirmCancel) return;
//
//     await FirebaseFirestore.instance.collection('ride_requests').doc(widget.rideRequestId).update({
//       'status': 'Cancelled',
//     });
//
//     setState(() {
//       isCancelled = true;
//     });
//   }
//
//   Future<bool> _showCancelConfirmationDialog() async {
//     return await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Cancel Ride"),
//         content: const Text("Are you sure you want to cancel this ride?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(false),
//             child: const Text("No"),
//           ),
//           ElevatedButton(
//             onPressed: () => Navigator.of(context).pop(true),
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: const Text("Yes"),
//           ),
//         ],
//       ),
//     ) ??
//         false;
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   Color _getStatusColor(String status) {
//     switch (status) {
//       case "Pending":
//         return Colors.orange;
//       case "Matched":
//         return Colors.blue;
//       case "Completed":
//         return Colors.green;
//       case "Cancelled":
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (isCancelled) return const SizedBox(); // Hide card if ride is cancelled
//
//     return StreamBuilder<DocumentSnapshot>(
//       stream: FirebaseFirestore.instance.collection('ride_requests').doc(widget.rideRequestId).snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData || snapshot.data?.data() == null) {
//           return const SizedBox();
//         }
//
//         var rideData = snapshot.data!;
//         if (rideData['status'] == 'Cancelled') {
//           return const SizedBox();
//         }
//
//         return SlideTransition(
//           position: _animation,
//           child: Card(
//             margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//             elevation: 8,
//             shadowColor: Colors.black26,
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildTitleRow(),
//                   const Divider(thickness: 1, color: Colors.grey),
//                   _buildInfoRow(Icons.my_location, "Pickup", rideData['pickup'], Colors.blue),
//                   const SizedBox(height: 8),
//                   _buildInfoRow(Icons.location_on, "Drop", rideData['drop'], Colors.red),
//                   const SizedBox(height: 8),
//                   _buildInfoRow(Icons.currency_rupee, "Amount", rideData['fare'], Colors.green),
//                   const SizedBox(height: 8),
//                   _buildStatusIndicator(rideData['status']),
//                   if (rideData['status'] == "Pending") _buildWaitingForDriverAnimation(),
//                   const SizedBox(height: 12),
//                   if (rideData['status'] == "Pending") _buildCancelButton(),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildTitleRow() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         const Text(
//           "🏍️ Ride Summary", // Changed from 🚗 to 🏍️ for bike ride
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
//         ),
//         Icon(Icons.pedal_bike, color: Colors.blue.shade700, size: 30),
//       ],
//     );
//   }
//
//   Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Icon(icon, color: color, size: 24),
//         const SizedBox(width: 10),
//         Expanded(
//           child: Text(
//             "$label: $value",
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
//             maxLines: 2, // Allows text wrapping
//             overflow: TextOverflow.visible, // Ensures full visibility
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildStatusIndicator(String status) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [_getStatusColor(status).withOpacity(0.5), _getStatusColor(status)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: [
//           Icon(Icons.info, color: Colors.white),
//           const SizedBox(width: 8),
//           Text(
//             "Status: $status",
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildWaitingForDriverAnimation() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 12),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Text(
//             "Waiting for driver to accept",
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
//           ),
//           const SizedBox(width: 5),
//           _buildLoadingDots(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLoadingDots() {
//     String dots = "●" * dotCount;
//     return Text(
//       dots,
//       style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
//     );
//   }
//
//   Widget _buildCancelButton() {
//     return Center(
//       child: ElevatedButton(
//         onPressed: _cancelRide,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.red,
//           foregroundColor: Colors.white,
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//         child: const Text(
//           "Cancel Ride",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }




















// 19-04-2025 WORKING FINE
//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:async';
// import 'PaymentPage.dart'; // <-- Import the new page
//
// class RiderSummaryCard extends StatefulWidget {
//   final String rideRequestId;
//
//   const RiderSummaryCard({Key? key, required this.rideRequestId}) : super(key: key);
//
//   @override
//   State<RiderSummaryCard> createState() => _RiderSummaryCardState();
// }
//
// class _RiderSummaryCardState extends State<RiderSummaryCard> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<Offset> _animation;
//   int dotCount = 1;
//   bool isCancelled = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _startDotLoadingAnimation();
//     _initializeAnimation();
//   }
//
//   void _initializeAnimation() {
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//
//     _animation = Tween<Offset>(
//       begin: const Offset(0, 1),
//       end: const Offset(0, 0),
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeOut,
//     ));
//
//     _controller.forward();
//   }
//
//   void _startDotLoadingAnimation() {
//     Timer.periodic(const Duration(milliseconds: 500), (timer) {
//       if (!mounted) {
//         timer.cancel();
//         return;
//       }
//       setState(() {
//         dotCount = (dotCount % 3) + 1;
//       });
//     });
//   }
//
//   Future<void> _cancelRide() async {
//     bool confirmCancel = await _showCancelConfirmationDialog();
//     if (!confirmCancel) return;
//
//     await FirebaseFirestore.instance.collection('ride_requests').doc(widget.rideRequestId).update({
//       'status': 'Cancelled',
//     });
//
//     setState(() {
//       isCancelled = true;
//     });
//   }
//
//   Future<bool> _showCancelConfirmationDialog() async {
//     return await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Cancel Ride"),
//         content: const Text("Are you sure you want to cancel this ride?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(false),
//             child: const Text("No"),
//           ),
//           ElevatedButton(
//             onPressed: () => Navigator.of(context).pop(true),
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: const Text("Yes"),
//           ),
//         ],
//       ),
//     ) ?? false;
//   }
//
//   void _goToPaymentPage(String fare) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => PaymentPage(
//           rideId: widget.rideRequestId,
//           amount: fare,
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   Color _getStatusColor(String status) {
//     switch (status) {
//       case "Pending":
//         return Colors.orange;
//       case "Matched":
//         return Colors.blue;
//       case "Completed":
//         return Colors.green;
//       case "Cancelled":
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (isCancelled) return const SizedBox();
//
//     return StreamBuilder<DocumentSnapshot>(
//       stream: FirebaseFirestore.instance.collection('ride_requests').doc(widget.rideRequestId).snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData || snapshot.data?.data() == null) {
//           return const SizedBox();
//         }
//
//         var rideData = snapshot.data!;
//         if (rideData['status'] == 'Cancelled') {
//           return const SizedBox();
//         }
//
//         return SlideTransition(
//           position: _animation,
//           child: Card(
//             margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//             elevation: 8,
//             shadowColor: Colors.black26,
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildTitleRow(),
//                   const Divider(thickness: 1, color: Colors.grey),
//                   _buildInfoRow(Icons.my_location, "Pickup", rideData['pickup'], Colors.blue),
//                   const SizedBox(height: 8),
//                   _buildInfoRow(Icons.location_on, "Drop", rideData['drop'], Colors.red),
//                   const SizedBox(height: 8),
//                   _buildInfoRow(Icons.currency_rupee, "Amount", rideData['fare'], Colors.green),
//                   const SizedBox(height: 8),
//                   _buildStatusIndicator(rideData['status']),
//                   if (rideData['status'] == "Pending") _buildWaitingForDriverAnimation(),
//                   const SizedBox(height: 12),
//                   if (rideData['status'] == "Pending") _buildCancelButton(),
//                   if (rideData['status'] == "Completed") _buildMakePaymentButton(rideData['fare']),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildTitleRow() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         const Text(
//           "🏍️ Ride Summary",
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
//         ),
//         Icon(Icons.pedal_bike, color: Colors.blue.shade700, size: 30),
//       ],
//     );
//   }
//
//   Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Icon(icon, color: color, size: 24),
//         const SizedBox(width: 10),
//         Expanded(
//           child: Text(
//             "$label: $value",
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
//             maxLines: 2,
//             overflow: TextOverflow.visible,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildStatusIndicator(String status) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [_getStatusColor(status).withOpacity(0.5), _getStatusColor(status)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: [
//           const Icon(Icons.info, color: Colors.white),
//           const SizedBox(width: 8),
//           Text(
//             "Status: $status",
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildWaitingForDriverAnimation() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 12),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Text(
//             "Waiting for driver to accept",
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
//           ),
//           const SizedBox(width: 5),
//           _buildLoadingDots(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLoadingDots() {
//     String dots = "●" * dotCount;
//     return Text(
//       dots,
//       style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
//     );
//   }
//
//   Widget _buildCancelButton() {
//     return Center(
//       child: ElevatedButton(
//         onPressed: _cancelRide,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.red,
//           foregroundColor: Colors.white,
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//         child: const Text(
//           "Cancel Ride",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMakePaymentButton(String fare) {
//     return Center(
//       child: ElevatedButton(
//         onPressed: () => _goToPaymentPage(fare),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.green.shade600,
//           foregroundColor: Colors.white,
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//         child: const Text(
//           "Make Payment",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }
//
//







//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:async';
// import 'PaymentPage.dart'; // <-- Import the PaymentPage
//
// class RiderSummaryCard extends StatefulWidget {
//   final String rideRequestId;
//
//   const RiderSummaryCard({Key? key, required this.rideRequestId}) : super(key: key);
//
//   @override
//   State<RiderSummaryCard> createState() => _RiderSummaryCardState();
// }
//
// class _RiderSummaryCardState extends State<RiderSummaryCard> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<Offset> _animation;
//   int dotCount = 1;
//   bool isCancelled = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _startDotLoadingAnimation();
//     _initializeAnimation();
//   }
//
//   void _initializeAnimation() {
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//
//     _animation = Tween<Offset>(
//       begin: const Offset(0, 1),
//       end: const Offset(0, 0),
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeOut,
//     ));
//
//     _controller.forward();
//   }
//
//   void _startDotLoadingAnimation() {
//     Timer.periodic(const Duration(milliseconds: 500), (timer) {
//       if (!mounted) {
//         timer.cancel();
//         return;
//       }
//       setState(() {
//         dotCount = (dotCount % 3) + 1;
//       });
//     });
//   }
//
//   Future<void> _cancelRide() async {
//     bool confirmCancel = await _showCancelConfirmationDialog();
//     if (!confirmCancel) return;
//
//     await FirebaseFirestore.instance.collection('ride_requests').doc(widget.rideRequestId).update({
//       'status': 'Cancelled',
//     });
//
//     setState(() {
//       isCancelled = true;
//     });
//   }
//
//   Future<bool> _showCancelConfirmationDialog() async {
//     return await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Cancel Ride"),
//         content: const Text("Are you sure you want to cancel this ride?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(false),
//             child: const Text("No"),
//           ),
//           ElevatedButton(
//             onPressed: () => Navigator.of(context).pop(true),
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: const Text("Yes"),
//           ),
//         ],
//       ),
//     ) ?? false;
//   }
//
//   void _goToPaymentPage(String fare) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => PaymentPage(
//           rideId: widget.rideRequestId,
//           amount: fare,
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   Color _getStatusColor(String status) {
//     switch (status) {
//       case "Pending":
//         return Colors.orange;
//       case "Matched":
//         return Colors.blue;
//       case "Completed":
//         return Colors.green;
//       case "Done":
//         return Colors.green;
//       case "Cancelled":
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (isCancelled) return const SizedBox();
//
//     return StreamBuilder<DocumentSnapshot>(
//       stream: FirebaseFirestore.instance.collection('ride_requests').doc(widget.rideRequestId).snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData || snapshot.data?.data() == null) {
//           return const SizedBox();
//         }
//
//         var rideData = snapshot.data!;
//         if (rideData['status'] == 'Cancelled') {
//           return const SizedBox();
//         }
//
//         return SlideTransition(
//           position: _animation,
//           child: Card(
//             margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//             elevation: 8,
//             shadowColor: Colors.black26,
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildTitleRow(),
//                   const Divider(thickness: 1, color: Colors.grey),
//                   _buildInfoRow(Icons.my_location, "Pickup", rideData['pickup'], Colors.blue),
//                   const SizedBox(height: 8),
//                   _buildInfoRow(Icons.location_on, "Drop", rideData['drop'], Colors.red),
//                   const SizedBox(height: 8),
//                   _buildInfoRow(Icons.currency_rupee, "Amount", rideData['fare'], Colors.green),
//                   const SizedBox(height: 8),
//                   _buildStatusIndicator(rideData['status']),
//                   if (rideData['status'] == "Pending")
//                     _buildWaitingForDriverAnimation(),
//                   const SizedBox(height: 12),
//                   if (rideData['status'] == "Pending")
//                     _buildCancelButton(),
//                   if (rideData['status'] == "Completed")
//                     _buildMakePaymentButton(rideData['fare']),
//                   if (rideData['status'] == "Done")
//                     _buildPaymentDoneMessage(),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildTitleRow() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         const Text(
//           "🏍️ Ride Summary",
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
//         ),
//         Icon(Icons.pedal_bike, color: Colors.blue.shade700, size: 30),
//       ],
//     );
//   }
//
//   Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Icon(icon, color: color, size: 24),
//         const SizedBox(width: 10),
//         Expanded(
//           child: Text(
//             "$label: $value",
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
//             maxLines: 2,
//             overflow: TextOverflow.visible,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildStatusIndicator(String status) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [_getStatusColor(status).withOpacity(0.5), _getStatusColor(status)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: [
//           const Icon(Icons.info, color: Colors.white),
//           const SizedBox(width: 8),
//           Text(
//             "Status: $status",
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildWaitingForDriverAnimation() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 12),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Text(
//             "Waiting for driver to accept",
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
//           ),
//           const SizedBox(width: 5),
//           _buildLoadingDots(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLoadingDots() {
//     String dots = "●" * dotCount;
//     return Text(
//       dots,
//       style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
//     );
//   }
//
//   Widget _buildCancelButton() {
//     return Center(
//       child: ElevatedButton(
//         onPressed: _cancelRide,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.red,
//           foregroundColor: Colors.white,
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//         child: const Text(
//           "Cancel Ride",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMakePaymentButton(String fare) {
//     return Center(
//       child: ElevatedButton(
//         onPressed: () => _goToPaymentPage(fare),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.green.shade600,
//           foregroundColor: Colors.white,
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//         child: const Text(
//           "Make Payment",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPaymentDoneMessage() {
//     return Center(
//       child: Text(
//         "Payment Done, Ride Completed",
//         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green.shade700),
//       ),
//     );
//   }
// }










// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:async';
// import 'PaymentPage.dart';

// class RiderSummaryCard extends StatefulWidget {
//   final String rideRequestId;

//   const RiderSummaryCard({Key? key, required this.rideRequestId}) : super(key: key);

//   @override
//   State<RiderSummaryCard> createState() => _RiderSummaryCardState();
// }

// class _RiderSummaryCardState extends State<RiderSummaryCard> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<Offset> _animation;
//   int dotCount = 1;
//   bool isCancelled = false;

//   @override
//   void initState() {
//     super.initState();
//     _startDotLoadingAnimation();
//     _initializeAnimation();
//   }

//   void _initializeAnimation() {
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );

//     _animation = Tween<Offset>(
//       begin: const Offset(0, 1),
//       end: const Offset(0, 0),
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeOut,
//     ));

//     _controller.forward();
//   }

//   void _startDotLoadingAnimation() {
//     Timer.periodic(const Duration(milliseconds: 500), (timer) {
//       if (!mounted) {
//         timer.cancel();
//         return;
//       }
//       setState(() {
//         dotCount = (dotCount % 3) + 1;
//       });
//     });
//   }

//   Future<void> _cancelRide() async {
//     bool confirmCancel = await _showCancelConfirmationDialog();
//     if (!confirmCancel) return;

//     await FirebaseFirestore.instance.collection('ride_requests').doc(widget.rideRequestId).update({
//       'status': 'Cancelled',
//     });

//     setState(() {
//       isCancelled = true;
//     });
//   }

//   Future<bool> _showCancelConfirmationDialog() async {
//     return await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Cancel Ride"),
//         content: const Text("Are you sure you want to cancel this ride?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(false),
//             child: const Text("No"),
//           ),
//           ElevatedButton(
//             onPressed: () => Navigator.of(context).pop(true),
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: const Text("Yes"),
//           ),
//         ],
//       ),
//     ) ?? false;
//   }

//   void _goToPaymentPage(String fare) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => PaymentPage(
//           rideId: widget.rideRequestId,
//           amount: fare,
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   Color _getStatusColor(String status) {
//     switch (status) {
//       case "Pending":
//         return Colors.orange;
//       case "Matched":
//         return Colors.blue;
//       case "Completed":
//         return Colors.green;
//       case "Done":
//         return Colors.green;
//       case "Cancelled":
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isCancelled) return const SizedBox();

//     return StreamBuilder<DocumentSnapshot>(
//       stream: FirebaseFirestore.instance.collection('ride_requests').doc(widget.rideRequestId).snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData || snapshot.data?.data() == null) {
//           return const SizedBox();
//         }

//         var rideData = snapshot.data!;
//         if (rideData['status'] == 'Cancelled') {
//           return const SizedBox();
//         }

//         return SlideTransition(
//           position: _animation,
//           child: Card(
//             margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//             elevation: 8,
//             shadowColor: Colors.black26,
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildTitleRow(),
//                   const Divider(thickness: 1, color: Colors.grey),
//                   _buildInfoRow(Icons.my_location, "Pickup", rideData['pickup'], Colors.blue),
//                   const SizedBox(height: 8),
//                   _buildInfoRow(Icons.location_on, "Drop", rideData['drop'], Colors.red),
//                   const SizedBox(height: 8),
//                   _buildInfoRow(Icons.currency_rupee, "Amount", rideData['fare'], Colors.green),
//                   const SizedBox(height: 8),
//                   _buildStatusIndicator(rideData['status']),
//                   if (rideData['status'] == "Pending") _buildWaitingForDriverAnimation(),
//                   const SizedBox(height: 12),
//                   if (rideData['status'] == "Pending") _buildCancelButton(),
//                   if (rideData['status'] == "Completed") _buildMakePaymentButton(rideData['fare']),
//                   if (rideData['status'] == "Done") _buildPaymentDoneMessage(),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildTitleRow() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         const Text(
//           "🏍️ Ride Summary",
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
//         ),
//         IconButton(
//           icon: const Icon(Icons.close, color: Colors.red),
//           onPressed: () {
//             setState(() {
//               isCancelled = true;
//             });
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Icon(icon, color: color, size: 24),
//         const SizedBox(width: 10),
//         Expanded(
//           child: Text(
//             "$label: $value",
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
//             maxLines: 2,
//             overflow: TextOverflow.visible,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildStatusIndicator(String status) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [_getStatusColor(status).withOpacity(0.5), _getStatusColor(status)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: [
//           const Icon(Icons.info, color: Colors.white),
//           const SizedBox(width: 8),
//           Text(
//             "Status: $status",
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildWaitingForDriverAnimation() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 12),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Text(
//             "Waiting for driver to accept",
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
//           ),
//           const SizedBox(width: 5),
//           _buildLoadingDots(),
//         ],
//       ),
//     );
//   }

//   Widget _buildLoadingDots() {
//     String dots = "●" * dotCount;
//     return Text(
//       dots,
//       style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
//     );
//   }

//   Widget _buildCancelButton() {
//     return Center(
//       child: ElevatedButton(
//         onPressed: _cancelRide,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.red,
//           foregroundColor: Colors.white,
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//         child: const Text(
//           "Cancel Ride",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }

//   Widget _buildMakePaymentButton(String fare) {
//     return Center(
//       child: ElevatedButton(
//         onPressed: () => _goToPaymentPage(fare),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.green.shade600,
//           foregroundColor: Colors.white,
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//         child: const Text(
//           "Make Payment",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }

//   Widget _buildPaymentDoneMessage() {
//     return Center(
//       child: Text(
//         "Payment Done, Ride Completed",
//         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green.shade700),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'PaymentPage.dart';

class RiderSummaryCard extends StatefulWidget {
  final String rideRequestId;

  const RiderSummaryCard({Key? key, required this.rideRequestId}) : super(key: key);

  @override
  State<RiderSummaryCard> createState() => _RiderSummaryCardState();
}

class _RiderSummaryCardState extends State<RiderSummaryCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  int dotCount = 1;
  bool isCancelled = false;
  DocumentSnapshot? driverData; // NEW: Driver data fetched separately

  @override
  void initState() {
    super.initState();
    _startDotLoadingAnimation();
    _initializeAnimation();
  }

  void _initializeAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  void _startDotLoadingAnimation() {
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        dotCount = (dotCount % 3) + 1;
      });
    });
  }

  Future<void> _cancelRide() async {
    bool confirmCancel = await _showCancelConfirmationDialog();
    if (!confirmCancel) return;

    await FirebaseFirestore.instance.collection('ride_requests').doc(widget.rideRequestId).update({
      'status': 'Cancelled',
    });

    setState(() {
      isCancelled = true;
    });
  }

  Future<bool> _showCancelConfirmationDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cancel Ride"),
        content: const Text("Are you sure you want to cancel this ride?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("No"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Yes"),
          ),
        ],
      ),
    ) ?? false;
  }

  void _goToPaymentPage(String fare) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(
          rideId: widget.rideRequestId,
          amount: fare,
        ),
      ),
    );
  }

  Future<void> _fetchDriverDetails(String driverId) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: driverId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          driverData = querySnapshot.docs.first;
        });
      }
    } catch (e) {
      debugPrint("Error fetching driver data: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Pending":
        return Colors.orange;
      case "Matched":
        return Colors.blue;
      case "Completed":
      case "Done":
        return Colors.green;
      case "Cancelled":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isCancelled) return const SizedBox();

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('ride_requests').doc(widget.rideRequestId).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data?.data() == null) {
          return const SizedBox();
        }

        var rideData = snapshot.data!;
        if (rideData['status'] == 'Cancelled') {
          return const SizedBox();
        }

        // If driverId exists and driverData not yet fetched
        if (rideData['driverId'] != null && driverData == null) {
          _fetchDriverDetails(rideData['driverId']);
        }

        return SlideTransition(
          position: _animation,
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 8,
            shadowColor: Colors.black26,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleRow(),
                  const Divider(thickness: 1, color: Colors.grey),
                  _buildInfoRow(Icons.my_location, "Pickup", rideData['pickup'], Colors.blue),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.location_on, "Drop", rideData['drop'], Colors.red),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.currency_rupee, "Amount", rideData['fare'], Colors.green),
                  const SizedBox(height: 8),
                  _buildStatusIndicator(rideData['status']),
                  const SizedBox(height: 8),
                  if (driverData != null) _buildDriverDetails(),
                  if (rideData['status'] == "Pending") _buildWaitingForDriverAnimation(),
                  const SizedBox(height: 12),
                  if (rideData['status'] == "Pending") _buildCancelButton(),
                  if (rideData['status'] == "Completed") _buildMakePaymentButton(rideData['fare']),
                  if (rideData['status'] == "Done") _buildPaymentDoneMessage(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "🏍️ Ride Summary",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        IconButton(
          icon: const Icon(Icons.close, color: Colors.red),
          onPressed: () {
            setState(() {
              isCancelled = true;
            });
          },
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            "$label: $value",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
            maxLines: 2,
            overflow: TextOverflow.visible,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusIndicator(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_getStatusColor(status).withOpacity(0.5), _getStatusColor(status)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.info, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            "Status: $status",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildWaitingForDriverAnimation() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Waiting for driver to accept",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
          ),
          const SizedBox(width: 5),
          _buildLoadingDots(),
        ],
      ),
    );
  }

  Widget _buildLoadingDots() {
    String dots = "●" * dotCount;
    return Text(
      dots,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
    );
  }

  Widget _buildCancelButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _cancelRide,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          "Cancel Ride",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildMakePaymentButton(String fare) {
    return Center(
      child: ElevatedButton(
        onPressed: () => _goToPaymentPage(fare),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade600,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          "Make Payment",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildPaymentDoneMessage() {
    return Center(
      child: Text(
        "Payment Done, Ride Completed",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green.shade700),
      ),
    );
  }

  Widget _buildDriverDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Text(
          "👨‍✈️ Driver Details",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 8),
        _buildInfoRow(Icons.person, "Name", driverData?['name'] ?? "Not available", Colors.black),
        const SizedBox(height: 8),
        _buildInfoRow(Icons.phone, "Phone", driverData?['phone'] ?? "Not available", Colors.black),
      ],
    );
  }
}



