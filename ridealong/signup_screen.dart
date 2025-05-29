// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class SignUpScreen extends StatefulWidget {
//   @override
//   _SignUpScreenState createState() => _SignUpScreenState();
// }
//
// class _SignUpScreenState extends State<SignUpScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   bool _isPasswordVisible = false;
//   bool _isConfirmPasswordVisible = false;
//   String _selectedUserType = "Rider";
//   String _selectedVehicleType = "Car";
//
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController vehicleRegController = TextEditingController();
//   final TextEditingController vehicleModelController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController = TextEditingController();
//
//   void _signUp() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//           email: emailController.text.trim(),
//           password: passwordController.text.trim(),
//         );
//
//         Map<String, dynamic> userData = {
//           "name": nameController.text.trim(),
//           "email": emailController.text.trim(),
//           "phone": phoneController.text.trim(),
//           "userType": _selectedUserType,
//           "uid": userCredential.user!.uid,
//         };
//
//         if (_selectedUserType == "Driver") {
//           userData.addAll({
//             "vehicleType": _selectedVehicleType,
//             "vehicleRegNo": vehicleRegController.text.trim(),
//             "vehicleModel": vehicleModelController.text.trim(),
//           });
//         }
//
//         await _firestore.collection("users").doc(userCredential.user!.uid).set(userData);
//
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Signup Successful!")));
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xFFB71C1C),
//         title: Text("Sign Up"),
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Color(0xFFB71C1C),
//               Color(0xFFD32F2F),
//             ],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               elevation: 4,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       Text(
//                         "Create Your Account",
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFFB71C1C),
//                         ),
//                       ),
//                       SizedBox(height: 20),
//
//                       // Name Field
//                       _buildTextField(
//                         controller: nameController,
//                         labelText: "Name",
//                         validator: (value) => value!.isEmpty ? "Enter your name" : null,
//                       ),
//                       SizedBox(height: 10),
//
//                       // Email Field
//                       _buildTextField(
//                         controller: emailController,
//                         labelText: "Email",
//                         keyboardType: TextInputType.emailAddress,
//                         validator: (value) => !RegExp(r'\S+@\S+\.\S+').hasMatch(value!) ? "Enter a valid email" : null,
//                       ),
//                       SizedBox(height: 10),
//
//                       // Phone Field
//                       _buildTextField(
//                         controller: phoneController,
//                         labelText: "Phone",
//                         keyboardType: TextInputType.phone,
//                         validator: (value) => value!.length < 10 ? "Enter a valid phone number" : null,
//                       ),
//                       SizedBox(height: 10),
//
//                       // User Type Dropdown
//                       DropdownButtonFormField<String>(
//                         value: _selectedUserType,
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                           filled: true,
//                           fillColor: Colors.white,
//                         ),
//                         items: ["Rider", "Driver"].map((type) {
//                           return DropdownMenuItem(value: type, child: Text(type));
//                         }).toList(),
//                         onChanged: (value) {
//                           setState(() => _selectedUserType = value!);
//                         },
//                       ),
//                       SizedBox(height: 10),
//
//                       // Vehicle Fields (Shown if Driver)
//                       if (_selectedUserType == "Driver") ...[
//                         DropdownButtonFormField<String>(
//                           value: _selectedVehicleType,
//                           decoration: InputDecoration(
//                             border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                             filled: true,
//                             fillColor: Colors.white,
//                           ),
//                           items: ["Car", "Bike"].map((type) {
//                             return DropdownMenuItem(value: type, child: Text(type));
//                           }).toList(),
//                           onChanged: (value) {
//                             setState(() => _selectedVehicleType = value!);
//                           },
//                         ),
//                         SizedBox(height: 10),
//
//                         _buildTextField(
//                           controller: vehicleRegController,
//                           labelText: "Vehicle Reg No.",
//                           validator: (value) => value!.isEmpty ? "Enter vehicle reg no." : null,
//                         ),
//                         SizedBox(height: 10),
//
//                         _buildTextField(
//                           controller: vehicleModelController,
//                           labelText: "Vehicle Model Name",
//                           validator: (value) => value!.isEmpty ? "Enter vehicle model name" : null,
//                         ),
//                         SizedBox(height: 10),
//                       ],
//
//                       // Password Field
//                       _buildTextField(
//                         controller: passwordController,
//                         labelText: "Password",
//                         obscureText: !_isPasswordVisible,
//                         suffixIcon: IconButton(
//                           icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
//                           onPressed: () {
//                             setState(() => _isPasswordVisible = !_isPasswordVisible);
//                           },
//                         ),
//                         validator: (value) => value!.length < 6 ? "Password must be 6+ characters" : null,
//                       ),
//                       SizedBox(height: 10),
//
//                       // Confirm Password Field
//                       _buildTextField(
//                         controller: confirmPasswordController,
//                         labelText: "Confirm Password",
//                         obscureText: !_isConfirmPasswordVisible,
//                         suffixIcon: IconButton(
//                           icon: Icon(_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off),
//                           onPressed: () {
//                             setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
//                           },
//                         ),
//                         validator: (value) => value != passwordController.text ? "Passwords do not match" : null,
//                       ),
//                       SizedBox(height: 20),
//
//                       // Signup Button
//                       ElevatedButton(
//                         onPressed: _signUp,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.white,
//                           padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//                         ),
//                         child: Text(
//                           "Sign Up",
//                           style: TextStyle(
//                             color: Color(0xFFB71C1C),
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String labelText,
//     TextInputType keyboardType = TextInputType.text,
//     bool obscureText = false,
//     Widget? suffixIcon,
//     String? Function(String?)? validator,
//   }) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: keyboardType,
//       obscureText: obscureText,
//       decoration: InputDecoration(
//         labelText: labelText,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         filled: true,
//         fillColor: Colors.white,
//         suffixIcon: suffixIcon,
//       ),
//       validator: validator,
//     );
//   }
// }








//NAVIGATE TO LOGIN SCREEN
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart'; // Ensure you import your login screen

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String _selectedUserType = "Rider";
  String _selectedVehicleType = "Car";

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController vehicleRegController = TextEditingController();
  final TextEditingController vehicleModelController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        Map<String, dynamic> userData = {
          "name": nameController.text.trim(),
          "email": emailController.text.trim(),
          "phone": phoneController.text.trim(),
          "userType": _selectedUserType,
          "uid": userCredential.user!.uid,
        };

        if (_selectedUserType == "Driver") {
          userData.addAll({
            "vehicleType": _selectedVehicleType,
            "vehicleRegNo": vehicleRegController.text.trim(),
            "vehicleModel": vehicleModelController.text.trim(),
          });
        }

        await _firestore.collection("users").doc(userCredential.user!.uid).set(userData);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Signup Successful!")));

        // Navigate to LoginScreen after signup
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFB71C1C),
        title: Text("Sign Up"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFB71C1C),
              Color(0xFFD32F2F),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        "Create Your Account",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFB71C1C),
                        ),
                      ),
                      SizedBox(height: 20),

                      _buildTextField(
                        controller: nameController,
                        labelText: "Name",
                        validator: (value) => value!.isEmpty ? "Enter your name" : null,
                      ),
                      SizedBox(height: 10),

                      _buildTextField(
                        controller: emailController,
                        labelText: "Email",
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => !RegExp(r'\S+@\S+\.\S+').hasMatch(value!) ? "Enter a valid email" : null,
                      ),
                      SizedBox(height: 10),

                      _buildTextField(
                        controller: phoneController,
                        labelText: "Phone",
                        keyboardType: TextInputType.phone,
                        validator: (value) => value!.length < 10 ? "Enter a valid phone number" : null,
                      ),
                      SizedBox(height: 10),

                      DropdownButtonFormField<String>(
                        value: _selectedUserType,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        items: ["Rider", "Driver"].map((type) {
                          return DropdownMenuItem(value: type, child: Text(type));
                        }).toList(),
                        onChanged: (value) {
                          setState(() => _selectedUserType = value!);
                        },
                      ),
                      SizedBox(height: 10),

                      if (_selectedUserType == "Driver") ...[
                        DropdownButtonFormField<String>(
                          value: _selectedVehicleType,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          items: ["Car", "Bike"].map((type) {
                            return DropdownMenuItem(value: type, child: Text(type));
                          }).toList(),
                          onChanged: (value) {
                            setState(() => _selectedVehicleType = value!);
                          },
                        ),
                        SizedBox(height: 10),

                        _buildTextField(
                          controller: vehicleRegController,
                          labelText: "Vehicle Reg No.",
                          validator: (value) => value!.isEmpty ? "Enter vehicle reg no." : null,
                        ),
                        SizedBox(height: 10),

                        _buildTextField(
                          controller: vehicleModelController,
                          labelText: "Vehicle Model Name",
                          validator: (value) => value!.isEmpty ? "Enter vehicle model name" : null,
                        ),
                        SizedBox(height: 10),
                      ],

                      _buildTextField(
                        controller: passwordController,
                        labelText: "Password",
                        obscureText: !_isPasswordVisible,
                        suffixIcon: IconButton(
                          icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                          onPressed: () {
                            setState(() => _isPasswordVisible = !_isPasswordVisible);
                          },
                        ),
                        validator: (value) => value!.length < 6 ? "Password must be 6+ characters" : null,
                      ),
                      SizedBox(height: 10),

                      _buildTextField(
                        controller: confirmPasswordController,
                        labelText: "Confirm Password",
                        obscureText: !_isConfirmPasswordVisible,
                        suffixIcon: IconButton(
                          icon: Icon(_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off),
                          onPressed: () {
                            setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
                          },
                        ),
                        validator: (value) => value != passwordController.text ? "Passwords do not match" : null,
                      ),
                      SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: _signUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Color(0xFFB71C1C),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: suffixIcon,
      ),
      validator: validator,
    );
  }
}
