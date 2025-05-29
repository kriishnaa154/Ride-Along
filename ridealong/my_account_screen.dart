import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyAccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Account", style:TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.blue.shade900,
      ),
      body: FutureBuilder<Map<String, String>>(
        future: _fetchUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Text(
                "Error loading user details.",
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            );
          } else {
            final userDetails = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.blue.shade900,
                          child: Icon(Icons.person, size: 60, color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildDetailRow("Name", userDetails['name'] ?? "N/A"),
                      Divider(),
                      _buildDetailRow("Email", userDetails['email'] ?? "N/A"),
                      Divider(),
                      _buildDetailRow("Phone", userDetails['phone'] ?? "N/A"),
                      Divider(),
                      _buildDetailRow("Gender", userDetails['gender'] ?? "N/A"),
                      Divider(),
                      _buildDetailRow("Birthday", userDetails['birthday'] ?? "N/A"),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label:",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue.shade900),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Future<Map<String, String>> _fetchUserDetails() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception("No user is logged in.");
      }

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (!userDoc.exists) {
        throw Exception("User document does not exist.");
      }

      // Extracting details
      String firstName = userDoc['firstName'] ?? "First Name";
      String lastName = userDoc['lastName'] ?? "Last Name";
      String email = userDoc['email'] ?? "";
      String phone = userDoc['phone'] ?? "N/A";
      String gender = userDoc['gender'] ?? "N/A";
      String birthday = userDoc['birthday'] ?? "N/A";

      return {
        'name': "$firstName $lastName",
        'email': email,
        'phone': phone,
        'gender': gender,
        'birthday': birthday,
      };
    } catch (e) {
      print("Error fetching user details: $e");
      return {'name': "Guest", 'email': "N/A", 'phone': "N/A", 'gender': "N/A", 'birthday': "N/A"};
    }
  }
}
