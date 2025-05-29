import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _currentIndex = 0; // Tracks the current tab

  final List<Widget> _tabs = [
    ManageUsersScreen(),
    ManagePropertiesScreen(),
    ManageBookingsScreen(),
    MonitorPaymentsScreen(),
    ManageSafetyScreen(),
  ];

  final List<String> _tabTitles = [
    "Manage Users",
    "Manage Properties",
    "Manage Bookings",
    "Monitor Payments",
    "Manage Safety",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _tabTitles[_currentIndex],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade900,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Users"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Properties"),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: "Bookings"),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: "Payments"),
          BottomNavigationBarItem(icon: Icon(Icons.shield), label: "Safety"),
        ],
        backgroundColor: Colors.blue.shade900,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey.shade300,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

// --- Manage Users Screen ---
class ManageUsersScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _deleteAccount(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
      print("Account deleted successfully");
    } catch (e) {
      print("Error deleting account: $e");
    }
  }

  void _suspendAccount(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({'isSuspended': true});
      print("Account suspended successfully");
    } catch (e) {
      print("Error suspending account: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              "No users found.",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        final users = snapshot.data!.docs;

        return ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index].data() as Map<String, dynamic>;
            final userId = users[index].id;

            // Skip admin users
            if (user['isAdmin'] == true) return SizedBox();

            return Card(
              margin: EdgeInsets.only(bottom: 16.0),
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16.0),
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: Icon(Icons.person, color: Colors.blue.shade900),
                ),
                title: Text(
                  "${user['firstName']} ${user['lastName']}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Email: ${user['email']}"),
                trailing: PopupMenuButton<String>(
                  onSelected: (action) {
                    if (action == 'delete') {
                      _deleteAccount(userId);
                    } else if (action == 'suspend') {
                      _suspendAccount(userId);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'delete',
                      child: Text("Delete Account"),
                    ),
                    PopupMenuItem(
                      value: 'suspend',
                      child: Text("Suspend Account"),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// --- Manage Properties Screen ---
class ManagePropertiesScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _approveProperty(String propertyId) async {
    try {
      await _firestore.collection('couchsurfing_spaces').doc(propertyId).update({'verified': true});
      print("Property approved successfully");
    } catch (e) {
      print("Error approving property: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('couchsurfing_spaces').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              "No properties found.",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        final properties = snapshot.data!.docs;

        return ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: properties.length,
          itemBuilder: (context, index) {
            final property = properties[index].data() as Map<String, dynamic>;
            final propertyId = properties[index].id;

            return Card(
              margin: EdgeInsets.only(bottom: 16.0),
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16.0),
                title: Text(
                  property['spaceName'],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Host: ${property['hostName']}"),
                trailing: property['verified'] == true
                    ? Icon(Icons.verified, color: Colors.green)
                    : ElevatedButton(
                        onPressed: () => _approveProperty(propertyId),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade900,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Approve",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Property Details"),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Name: ${property['spaceName']}"),
                          Text("Host: ${property['hostName']}"),
                          Text("Verified: ${property['verified'] == true ? 'Yes' : 'No'}"),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Close"),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

// --- Manage Bookings Screen ---
class ManageBookingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Manage Bookings Screen",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[600]),
      ),
    );
  }
}

// --- Monitor Payments Screen ---
class MonitorPaymentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Monitor Payments Screen",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[600]),
      ),
    );
  }
}

// --- Manage Safety Mechanisms Screen ---
class ManageSafetyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Manage Safety Mechanisms Screen",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[600]),
      ),
    );
  }
}
