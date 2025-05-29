import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        backgroundColor: Colors.lightBlue,
      ),
      body: Center(
        child: Text("Notifications Screen"),
      ),
    );
  }
}
