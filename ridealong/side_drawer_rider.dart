// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class SideDrawer extends StatefulWidget {
//   final VoidCallback onLogout;
//
//   const SideDrawer({super.key, required this.onLogout});
//
//   @override
//   State<SideDrawer> createState() => _SideDrawerState();
// }
//
// class _SideDrawerState extends State<SideDrawer> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   Map<String, dynamic>? userData;
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchUserDetails();
//   }
//
//   /// Fetch the logged-in user’s details from Firestore
//   Future<void> _fetchUserDetails() async {
//     User? user = _auth.currentUser;
//     if (user == null) return;
//
//     try {
//       DocumentSnapshot userDoc = await _firestore.collection("users").doc(user.uid).get();
//       if (userDoc.exists) {
//         setState(() {
//           userData = userDoc.data() as Map<String, dynamic>;
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print("Error fetching user details: $e");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: isLoading
//           ? const Center(child: CircularProgressIndicator()) // Show loader while fetching data
//           : Column(
//         children: [
//           UserAccountsDrawerHeader(
//             decoration: const BoxDecoration(color: Color(0xFF0D47A1)),
//             accountName: Text(userData?['name'] ?? "Loading..."),
//             accountEmail: Text(userData?['email'] ?? "Loading..."),
//             currentAccountPicture: const CircleAvatar(
//               backgroundColor: Colors.white,
//               child: Icon(Icons.person, size: 50, color: Colors.black),
//             ),
//           ),
//           ListTile(
//             leading: const Icon(Icons.person),
//             title: const Text("My Account"),
//             onTap: () => _navigateToUserDetailsScreen(),
//           ),
//           ListTile(
//             leading: const Icon(Icons.logout, color: Colors.red),
//             title: const Text("Logout", style: TextStyle(color: Colors.red)),
//             onTap: widget.onLogout,
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// Navigate to My Account Page
//   void _navigateToUserDetailsScreen() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => UserDetailsScreen(userData: userData),
//       ),
//     );
//   }
// }
//
// /// **User Profile Screen - Supports Rider & Driver**
// class UserDetailsScreen extends StatelessWidget {
//   final Map<String, dynamic>? userData;
//
//   const UserDetailsScreen({super.key, required this.userData});
//
//   @override
//   Widget build(BuildContext context) {
//     bool isDriver = userData?['userType'] == "Driver";
//     bool isRider = userData?['userType'] == "Rider";
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF0D47A1),
//         title: const Text("My Account", style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Card(
//           elevation: 4,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const CircleAvatar(
//                   radius: 40,
//                   backgroundColor: Colors.blue,
//                   child: Icon(Icons.person, size: 50, color: Colors.white),
//                 ),
//                 const SizedBox(height: 12),
//                 const Divider(thickness: 1),
//                 _buildDetailTile(Icons.person, "Name", userData?['name']),
//                 _buildDetailTile(Icons.email, "Email", userData?['email']),
//                 _buildDetailTile(Icons.phone, "Phone", userData?['phone']),
//
//                 // Show only for Driver
//                 if (isDriver) _buildDetailTile(Icons.directions_car, "Vehicle Type", userData?['vehicleType']),
//                 if (isDriver) _buildDetailTile(Icons.directions_bus, "Vehicle Model", userData?['vehicleModel']),
//                 if (isDriver) _buildDetailTile(Icons.confirmation_number, "Vehicle Reg No", userData?['vehicleRegNo']),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// **Reusable Tile for User Details**
//   Widget _buildDetailTile(IconData icon, String title, String? value) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.blue),
//       title: Text(
//         title,
//         style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
//       ),
//       subtitle: Text(
//         value ?? "Not Available",
//         style: const TextStyle(fontSize: 16, color: Colors.grey),
//       ),
//     );
//   }
// }






import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SideDrawer extends StatefulWidget {
  final VoidCallback onLogout;

  const SideDrawer({super.key, required this.onLogout});

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    User? user = _auth.currentUser;
    if (user == null) return;

    try {
      DocumentSnapshot userDoc = await _firestore.collection("users").doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          userData = userDoc.data() as Map<String, dynamic>;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching user details: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(userData?['name'] ?? "Loading..."),
            accountEmail: Text(userData?['email'] ?? "Loading..."),
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text("Logout"),
            onTap: widget.onLogout,
          ),
        ],
      ),
    );
  }
}
