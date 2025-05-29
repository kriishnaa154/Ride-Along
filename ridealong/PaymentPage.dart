//
// import 'package:flutter/material.dart';
//
// class PaymentPage extends StatefulWidget {
//   final String rideId;
//   final String amount;
//
//   const PaymentPage({Key? key, required this.rideId, required this.amount}) : super(key: key);
//
//   @override
//   State<PaymentPage> createState() => _PaymentPageState();
// }
//
// class _PaymentPageState extends State<PaymentPage> {
//   String _selectedPayment = 'UPI';
//
//   final List<Map<String, dynamic>> _paymentMethods = [
//     {'label': 'UPI', 'icon': Icons.account_balance_wallet},
//     {'label': 'Credit/Debit Card', 'icon': Icons.credit_card},
//     {'label': 'Wallet', 'icon': Icons.account_balance},
//     {'label': 'Cash', 'icon': Icons.money},
//   ];
//
//   void _handlePayment() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Processing payment via $_selectedPayment...")),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Payment"),
//         backgroundColor: Colors.green.shade600,
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 16),
//             const Text(
//               "Ride Summary",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 8),
//             Card(
//               elevation: 3,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               child: ListTile(
//                 leading: const Icon(Icons.local_taxi, size: 36, color: Colors.green),
//                 title: Text("Ride ID: ${widget.rideId}"),
//                 subtitle: const Text("Payment Pending"),
//                 trailing: Text(
//                   "${widget.amount}",
//                   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               "Select Payment Method",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 12),
//             ..._paymentMethods.map((method) {
//               return RadioListTile<String>(
//                 value: method['label'],
//                 groupValue: _selectedPayment,
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedPayment = value!;
//                   });
//                 },
//                 title: Text(method['label']),
//                 secondary: Icon(method['icon'], color: Colors.green),
//               );
//             }).toList(),
//             const Spacer(),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: _handlePayment,
//                 icon: const Icon(Icons.check_circle_outline),
//                 label: const Text("Confirm and Pay"),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green.shade600,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
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
//
// class PaymentPage extends StatefulWidget {
//   final String rideId;
//   final String amount;
//
//   const PaymentPage({Key? key, required this.rideId, required this.amount}) : super(key: key);
//
//   @override
//   State<PaymentPage> createState() => _PaymentPageState();
// }
//
// class _PaymentPageState extends State<PaymentPage> {
//   String _selectedPayment = 'UPI';
//   String? _selectedUPIApp;
//
//   final List<Map<String, dynamic>> _paymentMethods = [
//     {'label': 'UPI', 'icon': Icons.account_balance_wallet},
//     {'label': 'Credit/Debit Card', 'icon': Icons.credit_card},
//     {'label': 'Wallet', 'icon': Icons.account_balance},
//     {'label': 'Cash', 'icon': Icons.money},
//   ];
//
//   final List<Map<String, dynamic>> _upiApps = [
//     {'label': 'PhonePe', 'icon': Icons.phone_android},
//     {'label': 'Google Pay', 'icon': Icons.android},
//     {'label': 'Paytm', 'icon': Icons.payment},
//   ];
//
//   void _handlePayment() {
//     String message = "Processing payment via $_selectedPayment";
//     if (_selectedPayment == 'UPI' && _selectedUPIApp != null) {
//       message += " ($_selectedUPIApp)";
//     }
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("$message...")),
//     );
//   }
//
//   Widget _buildUPIOptions() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 16),
//       child: Column(
//         children: _upiApps.map((app) {
//           return RadioListTile<String>(
//             value: app['label'],
//             groupValue: _selectedUPIApp,
//             onChanged: (value) {
//               setState(() {
//                 _selectedUPIApp = value!;
//               });
//             },
//             title: Text(app['label']),
//             secondary: Icon(app['icon'], color: Colors.deepPurple),
//           );
//         }).toList(),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Payment"),
//         backgroundColor: Colors.green.shade600,
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 16),
//             const Text(
//               "Ride Summary",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 8),
//             Card(
//               elevation: 3,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               child: ListTile(
//                 leading: const Icon(Icons.local_taxi, size: 36, color: Colors.green),
//                 title: Text("Ride ID: ${widget.rideId}"),
//                 subtitle: const Text("Payment Pending"),
//                 trailing: Text(
//                   "₹${widget.amount}",
//                   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               "Select Payment Method",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 12),
//             ..._paymentMethods.map((method) {
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   RadioListTile<String>(
//                     value: method['label'],
//                     groupValue: _selectedPayment,
//                     onChanged: (value) {
//                       setState(() {
//                         _selectedPayment = value!;
//                         if (_selectedPayment != 'UPI') {
//                           _selectedUPIApp = null;
//                         }
//                       });
//                     },
//                     title: Text(method['label']),
//                     secondary: Icon(method['icon'], color: Colors.green),
//                   ),
//                   if (_selectedPayment == 'UPI' && method['label'] == 'UPI') _buildUPIOptions(),
//                 ],
//               );
//             }).toList(),
//             const Spacer(),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: _handlePayment,
//                 icon: const Icon(Icons.check_circle_outline),
//                 label: const Text("Confirm and Pay"),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green.shade600,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }





// actual redict to apps
//
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class PaymentPage extends StatefulWidget {
//   final String rideId;
//   final String amount;
//
//   const PaymentPage({Key? key, required this.rideId, required this.amount}) : super(key: key);
//
//   @override
//   State<PaymentPage> createState() => _PaymentPageState();
// }
//
// class _PaymentPageState extends State<PaymentPage> {
//   String _selectedPayment = 'UPI';
//   String? _selectedUPIApp;
//
//   final List<Map<String, dynamic>> _paymentMethods = [
//     {'label': 'UPI', 'icon': Icons.account_balance_wallet},
//     {'label': 'Credit/Debit Card', 'icon': Icons.credit_card},
//     {'label': 'Wallet', 'icon': Icons.account_balance},
//     {'label': 'Cash', 'icon': Icons.money},
//   ];
//
//   final List<Map<String, dynamic>> _upiApps = [
//     {'label': 'PhonePe', 'icon': Icons.phone_android},
//     {'label': 'Google Pay', 'icon': Icons.android},
//     {'label': 'Paytm', 'icon': Icons.payment},
//   ];
//
//   Future<void> _handlePayment() async {
//     if (_selectedPayment == 'UPI' && _selectedUPIApp != null) {
//       final uri = Uri.parse(
//         'upi://pay?pa=test@upi&pn=RideApp&am=${widget.amount}&cu=INR&tn=Ride Payment',
//       );
//
//       if (await canLaunchUrl(uri)) {
//         await launchUrl(uri, mode: LaunchMode.externalApplication);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("No UPI app found to handle the transaction.")),
//         );
//       }
//       return;
//     }
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Processing $_selectedPayment...")),
//     );
//   }
//
//   Widget _buildUPIOptions() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 16),
//       child: Column(
//         children: _upiApps.map((app) {
//           return RadioListTile<String>(
//             value: app['label'],
//             groupValue: _selectedUPIApp,
//             onChanged: (value) {
//               setState(() {
//                 _selectedUPIApp = value!;
//               });
//             },
//             title: Text(app['label']),
//             secondary: Icon(app['icon'], color: Colors.deepPurple),
//           );
//         }).toList(),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Payment"),
//         backgroundColor: Colors.green.shade600,
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 16),
//             const Text(
//               "Ride Summary",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 8),
//             Card(
//               elevation: 3,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               child: ListTile(
//                 leading: const Icon(Icons.local_taxi, size: 36, color: Colors.green),
//                 title: Text("Ride ID: ${widget.rideId}"),
//                 subtitle: const Text("Payment Pending"),
//                 trailing: Text(
//                   "${widget.amount}",
//                   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               "Select Payment Method",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 12),
//             ..._paymentMethods.map((method) {
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   RadioListTile<String>(
//                     value: method['label'],
//                     groupValue: _selectedPayment,
//                     onChanged: (value) {
//                       setState(() {
//                         _selectedPayment = value!;
//                         if (_selectedPayment != 'UPI') {
//                           _selectedUPIApp = null;
//                         }
//                       });
//                     },
//                     title: Text(method['label']),
//                     secondary: Icon(method['icon'], color: Colors.green),
//                   ),
//                   if (_selectedPayment == 'UPI' && method['label'] == 'UPI') _buildUPIOptions(),
//                 ],
//               );
//             }).toList(),
//             const Spacer(),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: _handlePayment,
//                 icon: const Icon(Icons.check_circle_outline),
//                 label: const Text("Confirm and Pay"),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green.shade600,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }








// 19-04-2025
//

// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class PaymentPage extends StatefulWidget {
//   final String rideId;
//   final String amount;
//
//   const PaymentPage({Key? key, required this.rideId, required this.amount}) : super(key: key);
//
//   @override
//   State<PaymentPage> createState() => _PaymentPageState();
// }
//
// class _PaymentPageState extends State<PaymentPage> {
//   String _selectedPayment = 'UPI';
//   String? _selectedUPIApp;
//
//   final List<Map<String, dynamic>> _paymentMethods = [
//     {'label': 'UPI', 'icon': Icons.account_balance_wallet},
//     {'label': 'Cash', 'icon': Icons.money},
//   ];
//
//   final List<Map<String, dynamic>> _upiApps = [
//     {'label': 'PhonePe', 'icon': Icons.phone_android},
//     {'label': 'Google Pay', 'icon': Icons.android},
//     {'label': 'Paytm', 'icon': Icons.payment},
//   ];
//
//   Future<void> _handlePayment() async {
//     if (_selectedPayment == 'UPI' && _selectedUPIApp != null) {
//       final uri = Uri.parse(
//         'upi://pay?pa=test@upi&pn=RideApp&am=${widget.amount}&cu=INR&tn=Ride Payment',
//       );
//
//       if (await canLaunchUrl(uri)) {
//         await launchUrl(uri, mode: LaunchMode.externalApplication);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("No UPI app found to handle the transaction.")),
//         );
//       }
//       return;
//     }
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Processing $_selectedPayment...")),
//     );
//   }
//
//   Widget _buildUPIOptions() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 16),
//       child: Column(
//         children: _upiApps.map((app) {
//           return RadioListTile<String>(
//             value: app['label'],
//             groupValue: _selectedUPIApp,
//             onChanged: (value) {
//               setState(() {
//                 _selectedUPIApp = value!;
//               });
//             },
//             title: Text(app['label']),
//             secondary: Icon(app['icon'], color: Colors.deepPurple),
//           );
//         }).toList(),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Payment"),
//         backgroundColor: Colors.green.shade600,
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 16),
//             const Text(
//               "Ride Summary",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 8),
//             Card(
//               elevation: 3,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               child: ListTile(
//                 leading: const Icon(Icons.local_taxi, size: 36, color: Colors.green),
//                 title: Text("Ride ID: ${widget.rideId}"),
//                 subtitle: const Text("Payment Pending"),
//                 trailing: Text(
//                   "${widget.amount}",
//                   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               "Select Payment Method",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 12),
//             ..._paymentMethods.map((method) {
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   RadioListTile<String>(
//                     value: method['label'],
//                     groupValue: _selectedPayment,
//                     onChanged: (value) {
//                       setState(() {
//                         _selectedPayment = value!;
//                         if (_selectedPayment != 'UPI') {
//                           _selectedUPIApp = null;
//                         }
//                       });
//                     },
//                     title: Text(method['label']),
//                     secondary: Icon(method['icon'], color: Colors.green),
//                   ),
//                   if (_selectedPayment == 'UPI' && method['label'] == 'UPI') _buildUPIOptions(),
//                 ],
//               );
//             }).toList(),
//             const Spacer(),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: _handlePayment,
//                 icon: const Icon(Icons.check_circle_outline),
//                 label: const Text("Confirm and Pay"),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green.shade600,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }




//
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'riderhome.dart'; // Make sure this file exists and the widget is implemented
//
// class PaymentPage extends StatefulWidget {
//   final String rideId;
//   final String amount;
//
//   const PaymentPage({Key? key, required this.rideId, required this.amount}) : super(key: key);
//
//   @override
//   State<PaymentPage> createState() => _PaymentPageState();
// }
//
// class _PaymentPageState extends State<PaymentPage> {
//   String _selectedPayment = 'UPI';
//   String? _selectedUPIApp;
//   bool _isPaymentDone = false;
//
//   final List<Map<String, dynamic>> _paymentMethods = [
//     {'label': 'UPI', 'icon': Icons.account_balance_wallet},
//     {'label': 'Cash', 'icon': Icons.money},
//   ];
//
//   final List<Map<String, dynamic>> _upiApps = [
//     {'label': 'PhonePe', 'icon': Icons.phone_android},
//     {'label': 'Google Pay', 'icon': Icons.android},
//     {'label': 'Paytm', 'icon': Icons.payment},
//   ];
//
//   Future<void> _handlePayment() async {
//     if (_isPaymentDone) return;
//
//     if (_selectedPayment == 'UPI' && _selectedUPIApp != null) {
//       final uri = Uri.parse(
//         'upi://pay?pa=test@upi&pn=RideApp&am=${widget.amount}&cu=INR&tn=Ride Payment',
//       );
//
//       if (await canLaunchUrl(uri)) {
//         await launchUrl(uri, mode: LaunchMode.externalApplication);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("No UPI app found to handle the transaction.")),
//         );
//       }
//       return;
//     }
//
//     if (_selectedPayment == 'Cash') {
//       setState(() {
//         _isPaymentDone = true;
//       });
//     }
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Processing $_selectedPayment...")),
//     );
//   }
//
//   Widget _buildUPIOptions() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 16),
//       child: Column(
//         children: _upiApps.map((app) {
//           return RadioListTile<String>(
//             value: app['label'],
//             groupValue: _selectedUPIApp,
//             onChanged: _isPaymentDone ? null : (value) {
//               setState(() {
//                 _selectedUPIApp = value!;
//               });
//             },
//             title: Text(app['label']),
//             secondary: Icon(app['icon'], color: Colors.deepPurple),
//           );
//         }).toList(),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Payment"),
//         backgroundColor: Colors.green.shade600,
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 16),
//             const Text(
//               "Ride Summary",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 8),
//             Card(
//               elevation: 3,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               child: ListTile(
//                 leading: const Icon(Icons.local_taxi, size: 36, color: Colors.green),
//                 title: Text("Ride ID: ${widget.rideId}"),
//                 subtitle: Text(_isPaymentDone ? "Payment Done" : "Payment Pending"),
//                 trailing: Text(
//                   "${widget.amount}",
//                   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               "Select Payment Method",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 12),
//             ..._paymentMethods.map((method) {
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   RadioListTile<String>(
//                     value: method['label'],
//                     groupValue: _selectedPayment,
//                     onChanged: _isPaymentDone ? null : (value) {
//                       setState(() {
//                         _selectedPayment = value!;
//                         if (_selectedPayment != 'UPI') {
//                           _selectedUPIApp = null;
//                         }
//                       });
//                     },
//                     title: Text(method['label']),
//                     secondary: Icon(method['icon'], color: Colors.green),
//                   ),
//                   if (_selectedPayment == 'UPI' && method['label'] == 'UPI') _buildUPIOptions(),
//                 ],
//               );
//             }).toList(),
//             const Spacer(),
//             if (!_isPaymentDone)
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton.icon(
//                   onPressed: _handlePayment,
//                   icon: const Icon(Icons.check_circle_outline),
//                   label: const Text("Confirm and Pay"),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green.shade600,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                   ),
//                 ),
//               ),
//             if (_isPaymentDone)
//               Column(
//                 children: [
//                   const Text(
//                     "Payment Done",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.green),
//                   ),
//                   const SizedBox(height: 12),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton.icon(
//                       onPressed: () {
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(builder: (context) => const RiderHomePage()),
//                         );
//                       },
//                       icon: const Icon(Icons.home),
//                       label: const Text("Go to Home Page"),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }






import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'riderhome.dart';

class PaymentPage extends StatefulWidget {
  final String rideId;
  final String amount;

  const PaymentPage({Key? key, required this.rideId, required this.amount}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedPayment = 'UPI';
  String? _selectedUPIApp;
  bool _isPaymentDone = false;

  final List<Map<String, dynamic>> _paymentMethods = [
    {'label': 'UPI', 'icon': Icons.account_balance_wallet},
    {'label': 'Cash', 'icon': Icons.money},
  ];

  final List<Map<String, dynamic>> _upiApps = [
    {'label': 'PhonePe', 'icon': Icons.phone_android},
    {'label': 'Google Pay', 'icon': Icons.android},
    {'label': 'Paytm', 'icon': Icons.payment},
  ];

  Future<void> _handlePayment() async {
    if (_isPaymentDone) return;

    if (_selectedPayment == 'UPI' && _selectedUPIApp != null) {
      final uri = Uri.parse(
        'upi://pay?pa=test@upi&pn=RideApp&am=${widget.amount}&cu=INR&tn=Ride Payment',
      );

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No UPI app found to handle the transaction.")),
        );
      }
      return;
    }

    if (_selectedPayment == 'Cash') {
      try {
        await FirebaseFirestore.instance.collection('ride_requests').doc(widget.rideId).update({
          'status': 'Done',
        });
        setState(() {
          _isPaymentDone = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Payment Done")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating payment status: $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Processing $_selectedPayment...")),
      );
    }
  }

  Widget _buildUPIOptions() {
    return Column(
      children: _upiApps.map((app) {
        return RadioListTile<String>(
          value: app['label'],
          groupValue: _selectedUPIApp,
          onChanged: _isPaymentDone ? null : (value) {
            setState(() {
              _selectedUPIApp = value!;
            });
          },
          title: Text(app['label'], style: const TextStyle(fontWeight: FontWeight.w500)),
          secondary: Icon(app['icon'], color: const Color(0xFFB71C1C)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          dense: true,
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xFFB71C1C),
        title: const Text("💳 Payment",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              margin: const EdgeInsets.only(bottom: 20),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: const Icon(Icons.local_taxi, size: 40, color: Color(0xFFB71C1C)),
                title: Text("Ride ID: ${widget.rideId}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(_isPaymentDone ? "✅ Payment Done" : "Pending Payment",
                    style: TextStyle(color: _isPaymentDone ? Colors.green : Colors.orange)),
                trailing: Text(
                  "₹${widget.amount}",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const Text(
              "Select Payment Method",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ..._paymentMethods.map((method) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RadioListTile<String>(
                    value: method['label'],
                    groupValue: _selectedPayment,
                    onChanged: _isPaymentDone ? null : (value) {
                      setState(() {
                        _selectedPayment = value!;
                        if (_selectedPayment != 'UPI') {
                          _selectedUPIApp = null;
                        }
                      });
                    },
                    title: Text(method['label'], style: const TextStyle(fontWeight: FontWeight.w500)),
                    secondary: Icon(method['icon'], color: const Color(0xFFB71C1C)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  if (_selectedPayment == 'UPI' && method['label'] == 'UPI')
                    _buildUPIOptions(),
                ],
              );
            }).toList(),
            const Spacer(),
            if (!_isPaymentDone)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _handlePayment,
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text("Confirm & Pay"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB71C1C),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 6,
                  ),
                ),
              ),
            if (_isPaymentDone)
              Column(
                children: [
                  const Text(
                    "✅ Payment Successful!",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const RiderHomePage()),
                        );
                      },
                      icon: const Icon(Icons.home),
                      label: const Text("Back to Home"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 6,
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
