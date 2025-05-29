// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class SideDrawer extends StatelessWidget {
//   final VoidCallback onLogout;
//
//   const SideDrawer({super.key, required this.onLogout});
//
//   @override
//   Widget build(BuildContext context) {
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
//             onTap: onLogout,
//           ),
//         ],
//       ),
//     );
//   }
// }















//
//
//
//
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
//   Map<String, dynamic>? driverData; // ✅ Store driver details
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchDriverDetails(); // ✅ Fetch driver details on drawer open
//   }
//
//   /// ✅ Fetch the logged-in driver's details from Firestore
//   Future<void> _fetchDriverDetails() async {
//     User? user = _auth.currentUser;
//     if (user == null) return;
//
//     try {
//       DocumentSnapshot userDoc = await _firestore.collection("users").doc(user.uid).get();
//       if (userDoc.exists) {
//         setState(() {
//           driverData = userDoc.data() as Map<String, dynamic>;
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print("Error fetching driver details: $e");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: Column(
//         children: [
//           UserAccountsDrawerHeader(
//             decoration: const BoxDecoration(color: Color(0xFFB71C1C)),
//             accountName: Text(driverData?['name'] ?? "Loading..."),
//             accountEmail: Text(driverData?['email'] ?? "Loading..."),
//             currentAccountPicture: const CircleAvatar(
//               backgroundColor: Colors.white,
//               child: Icon(Icons.person, size: 50, color: Colors.black),
//             ),
//           ),
//           ListTile(
//             leading: const Icon(Icons.person),
//             title: const Text("My Details"),
//             onTap: () => _showDriverDetailsDialog(),
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
//   /// ✅ Show Driver Details Dialog
//   void _showDriverDetailsDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("My Details"),
//           content: isLoading
//               ? const CircularProgressIndicator()
//               : Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildDetailRow("Name", driverData?['name']),
//               _buildDetailRow("Email", driverData?['email']),
//               _buildDetailRow("Phone", driverData?['phone']),
//               if (driverData?['userType'] == "Driver") ...[
//                 _buildDetailRow("Vehicle Type", driverData?['vehicleType']),
//                 _buildDetailRow("Vehicle Model", driverData?['vehicleModel']),
//                 _buildDetailRow("Vehicle Reg No", driverData?['vehicleRegNo']),
//               ],
//             ],
//           ),
//           actions: [
//             TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close")),
//           ],
//         );
//       },
//     );
//   }
//
//   Widget _buildDetailRow(String title, String? value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 6),
//       child: Text("$title: ${value ?? 'Not Available'}", style: const TextStyle(fontSize: 16)),
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

  Map<String, dynamic>? driverData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDriverDetails();
  }

  /// Fetch the logged-in driver's details from Firestore
  Future<void> _fetchDriverDetails() async {
    User? user = _auth.currentUser;
    if (user == null) return;

    try {
      DocumentSnapshot userDoc = await _firestore.collection("users").doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          driverData = userDoc.data() as Map<String, dynamic>;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching driver details: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF0D47A1)),
            accountName: Text(driverData?['name'] ?? "Loading..."),
            accountEmail: Text(driverData?['email'] ?? "Loading..."),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 50, color: Colors.black),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("My Account"),
            onTap: () => _navigateToUserDetailsScreen(),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: widget.onLogout,
          ),
        ],
      ),
    );
  }

  /// Navigate to My Account Page
  void _navigateToUserDetailsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailsScreen(userData: driverData),
      ),
    );
  }
}

/// **Improved My Account Screen UI**
class UserDetailsScreen extends StatelessWidget {
  final Map<String, dynamic>? userData;

  const UserDetailsScreen({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    bool isDriver = userData?['userType'] == "Driver";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        title: const Text("My Account", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 12),
                const Divider(thickness: 1),
                _buildDetailTile(Icons.person, "Name", userData?['name']),
                _buildDetailTile(Icons.email, "Email", userData?['email']),
                _buildDetailTile(Icons.phone, "Phone", userData?['phone']),
                if (isDriver) _buildDetailTile(Icons.directions_car, "Vehicle Type", userData?['vehicleType']),
                if (isDriver) _buildDetailTile(Icons.directions_bus, "Vehicle Model", userData?['vehicleModel']),
                if (isDriver) _buildDetailTile(Icons.confirmation_number, "Vehicle Reg No", userData?['vehicleRegNo']),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// **Reusable UI for User Details**
  Widget _buildDetailTile(IconData icon, String title, String? value) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
      ),
      subtitle: Text(
        value ?? "Not Available",
        style: const TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
}
