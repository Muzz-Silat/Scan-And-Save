import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReceiptsPage extends StatefulWidget {
  const ReceiptsPage({Key? key}) : super(key: key);

  @override
  State<ReceiptsPage> createState() => _ReceiptsPageState();
}

class _ReceiptsPageState extends State<ReceiptsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Receipts'),
      ),
      body: user != null
          ? StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(user.uid)
                  .collection('Profile')
                  .doc('personal')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.error != null) {
                  // Handle errors appropriately in your app.
                  return const Center(child: Text("An error occurred"));
                }

                Map<String, dynamic>? data =
                    snapshot.data?.data() as Map<String, dynamic>?;
                if (data == null ||
                    !data.containsKey('receipts') ||
                    data['receipts'].isEmpty) {
                  // Provide UI feedback when no receipts are found
                  return const Center(child: Text("No receipts found."));
                }

                List<dynamic> receipts = data['receipts'];
                return ListView.builder(
                  itemCount: receipts.length,
                  itemBuilder: (context, index) => ListTile(
                    leading: const Icon(Icons.receipt),
                    title: Text("Receipt ${index + 1}"),
                    onTap: () {
                      // Adjust this to navigate to a detailed view or display the receipt image
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => Image.network(receipts[index])));
                    },
                  ),
                );
              },
            )
          : const Center(child: Text("Please login to view receipts")),
    );
  }
}
