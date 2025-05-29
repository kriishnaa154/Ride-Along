import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flightAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    // Define the flight animation
    _flightAnimation = Tween<double>(begin: 0, end: -40).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Start the animation with continuous back and forth motion
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade900, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          "Explore Solo",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            _buildDrawerHeader(),
            Expanded(
              child: ListView(
                children: [
                  _buildDrawerItem(
                    "My Account",
                    Icons.person,
                    Colors.lightBlue,
                    onTap: () => Navigator.pushNamed(context, '/my-account'),
                  ),
                  _buildDrawerItem(
                    "My Trips",
                    Icons.directions_bus,
                    Colors.orange,
                    onTap: () => Navigator.pushNamed(context, '/my-trips'),
                  ),
                  _buildDrawerItem(
                    "Settings",
                    Icons.settings,
                    Colors.green,
                    onTap: () => Navigator.pushNamed(context, '/settings'),
                  ),
                  Divider(),
                  _buildDrawerItem(
                    "Logout",
                    Icons.logout,
                    Colors.red,
                    onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAnimatedBanner(),
            SizedBox(height: 20),
            Text(
              "Explore Features",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue.shade900),
            ),
            SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _buildFeatureCard(
                  "Pre-Trip Planning",
                  Icons.travel_explore_rounded,
                  [Colors.lightBlue.shade600, Colors.blue.shade900],
                  onTap: () => Navigator.pushNamed(context, '/pre-trip-options'),
                ),
                _buildFeatureCard(
                  "Couchsurfing",
                  Icons.bed,
                  [Colors.orange.shade700, Colors.deepOrange],
                  onTap: () => Navigator.pushNamed(context, '/couchsurfing'),
                ),
                _buildFeatureCard(
                  "Destination Discovery",
                  Icons.map,
                  [Colors.green.shade500, Colors.green.shade800],
                  onTap: () => Navigator.pushNamed(context, '/destination-discovery'),
                ),
                _buildFeatureCard(
                  "Emergency Options",
                  Icons.emergency_outlined,
                  [Colors.red.shade600, Colors.red.shade800],
                  onTap: () => Navigator.pushNamed(context, '/safety-center'),
                ),
                _buildFeatureCard(
                  "My Preferences",
                  Icons.settings_suggest,
                  [Colors.purple.shade400, Colors.deepPurple.shade700],
                  onTap: () {},
                ),
                _buildFeatureCard(
                  "Ratings & Reviews",
                  Icons.star_rate_rounded,
                  [Colors.teal.shade400, Colors.teal.shade800],
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return FutureBuilder<Map<String, String>>(
      future: _fetchUserDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 180,
            color: Colors.blue.shade900,
            child: Center(child: CircularProgressIndicator(color: Colors.white)),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Container(
            height: 180,
            color: Colors.blue.shade900,
            child: Center(
              child: Text(
                "Error loading user info",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          );
        }

        final data = snapshot.data!;
        return Container(
          height: 180,
          padding: EdgeInsets.all(16.0),
          color: Colors.blue.shade900,
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 50, color: Colors.lightBlue),
              ),
              SizedBox(height: 10),
              Text(
                data['name'] ?? "Traveler",
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                data['email'] ?? "",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDrawerItem(String title, IconData icon, Color color, {required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildAnimatedBanner() {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade900, Colors.blueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _flightAnimation,
            builder: (context, child) {
              return Positioned(
                top: 40 + _flightAnimation.value,
                left: 45,
                child: child!,
              );
            },
            child: Icon(
              Icons.airplanemode_active,
              color: Colors.white.withOpacity(0.8),
              size: 60,
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Your Journey",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  "Starts Here",
                  style: TextStyle(fontSize: 20, color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(String title, IconData icon, List<Color> gradientColors,
      {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradientColors.last.withOpacity(0.4),
              blurRadius: 8,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 50, color: Colors.white),
              SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Map<String, String>> _fetchUserDetails() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) throw Exception("No user logged in.");
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
      if (!userDoc.exists) throw Exception("User document does not exist.");
      return {
        'name': "${userDoc['firstName'] ?? ''} ${userDoc['lastName'] ?? ''}",
        'email': userDoc['email'] ?? '',
      };
    } catch (e) {
      print("Error fetching user details: $e");
      return {'name': "Guest", 'email': ""};
    }
  }
}
