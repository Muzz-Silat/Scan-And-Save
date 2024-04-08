import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _name = '';
  String _preferredCurrency = 'USD';
  double _monthlyIncome = 0.0;
  double _savings = 0.0;
  String? _profilePicUrl;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _monthlyIncomeController =
      TextEditingController();
  final TextEditingController _savingsController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userProfile = await _firestore
          .collection('Users')
          .doc(user.uid)
          .collection('Profile')
          .doc('personal')
          .get();
      if (userProfile.exists) {
        Map<String, dynamic> userData =
            userProfile.data() as Map<String, dynamic>;
        setState(() {
          _name = userData['Name'] ?? '';
          _preferredCurrency = userData['preferredCurrency'] ?? 'USD';
          _monthlyIncome = userData['MonthlyIncome']?.toDouble() ?? 0.0;
          _savings = userData['Savings']?.toDouble() ?? 0.0;
          _profilePicUrl = userData['ProfilePicture'];
          _nameController.text = _name;
          _monthlyIncomeController.text = _monthlyIncome.toString();
          _savingsController.text = _savings.toString();
        });
      }
    }
  }

  Future<void> _pickAndUploadImage() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) return; // User canceled the picker

    File file = File(image.path);

    try {
      // Generate a unique file name for the image
      String filePath =
          'profilePictures/${_auth.currentUser!.uid}/${DateTime.now().millisecondsSinceEpoch}.png';
      final ref = FirebaseStorage.instance.ref().child(filePath);
      await ref.putFile(file);

      // After upload, get the URL
      final String downloadUrl = await ref.getDownloadURL();

      // Save the URL to Firestore
      final User? user = _auth.currentUser;
      if (user != null) {
        await _firestore
            .collection('Users')
            .doc(user.uid)
            .collection('Profile')
            .doc('personal')
            .set({
          'ProfilePicture': downloadUrl,
        }, SetOptions(merge: true));

        setState(() {
          _profilePicUrl =
              downloadUrl; // Update local state to show new picture
        });
      }
    } catch (e) {
      print("Error uploading image: $e");
      // Handle errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Settings',
            style: TextStyle(
              fontFamily: "CourierPrime",
              fontSize: 24,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 30), // Increase gap
                CircleAvatar(
                  radius: 60, // Increase size
                  backgroundImage: _profilePicUrl != null
                      ? NetworkImage(_profilePicUrl!)
                      : AssetImage('assets/profileImage.webp') as ImageProvider,
                  backgroundColor: Colors.transparent,
                ),
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: _pickAndUploadImage,
                ),
                SizedBox(
                  height: 30,
                ),
                _buildTextField(
                  labelText: 'Name',
                  prefixIcon: Icons.person,
                  controller: _nameController,
                  onChanged: (value) => _name = value,
                ),
                SizedBox(
                  height: 30,
                ),
                _buildTextField(
                  labelText: 'Monthly Income',
                  prefixIcon: Icons.attach_money,
                  controller: _monthlyIncomeController,
                  onChanged: (value) =>
                      _monthlyIncome = double.tryParse(value) ?? 0.0,
                ),
                SizedBox(
                  height: 30,
                ),
                _buildTextField(
                  labelText: 'Savings',
                  prefixIcon: Icons.savings,
                  controller: _savingsController,
                  onChanged: (value) =>
                      _savings = double.tryParse(value) ?? 0.0,
                ),
                SizedBox(
                  height: 30,
                ),
                _buildDropdown(),
                SizedBox(
                  height: 40,
                ),
                _buildSaveButton(),
              ],
            ),
          ),
        ));
  }

  Widget _buildDropdown() {
    return Container(
      width: 308, // Match width of text fields
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Color(0xFF131313),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        // Remove underline
        child: DropdownButton<String>(
          value: _preferredCurrency,
          icon: Icon(Icons.arrow_drop_down,
              color: Colors.grey), // Match icon color
          dropdownColor: Color(0xFF131313), // Match dropdown background color
          style: TextStyle(
            fontFamily: "CourierPrime",
            fontSize: 18,
            color: Colors.white,
          ),
          items: <String>['USD', 'EUR', 'GBP'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _preferredCurrency = value!;
            });
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String labelText,
    required IconData prefixIcon,
    TextEditingController? controller,
    required Function(String) onChanged,
  }) {
    return Container(
      width: 308,
      height: 66,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Color(0xFF131313),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          style: const TextStyle(
            fontFamily: "CourierPrime",
            fontSize: 18,
            color: Colors.white,
          ),
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(color: Colors.grey),
            prefixIcon: Icon(prefixIcon, color: Colors.grey),
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: () async {
        final User? user = _auth.currentUser;
        if (user != null) {
          await _firestore
              .collection('Users')
              .doc(user.uid)
              .collection('Profile')
              .doc('personal')
              .set({
            'Name': _name,
            'preferredCurrency': _preferredCurrency,
            'MonthlyIncome': _monthlyIncome,
            'Savings': _savings,
            'ProfilePicture': _profilePicUrl, // Assuming you're updating this
          }, SetOptions(merge: true));

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Settings updated successfully')),
          );
        }
      },
      child: Container(
        width: 120,
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 11),
        decoration: ShapeDecoration(
          color: Colors.black,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 3, color: Color(0xFF67F0AD)),
            borderRadius: BorderRadius.circular(23),
          ),
          shadows: [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: const Text(
          'Save',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'CourierPrime',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _monthlyIncomeController.dispose();
    _savingsController.dispose();
    super.dispose();
  }
}
