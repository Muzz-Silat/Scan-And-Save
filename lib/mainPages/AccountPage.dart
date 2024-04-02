// ignore_for_file: prefer_const_constructors, file_names

import 'package:demo_flutter/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_flutter/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:demo_flutter/preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:demo_flutter/theme_bloc.dart';
import 'package:demo_flutter/theme_event.dart';
import 'package:demo_flutter/theme_state.dart';
import 'package:demo_flutter/screens/login_screen.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.all(25),
            child: Text(
              "My Account",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 15),
            child: CircleAvatar(
              radius: 100,
              backgroundImage: AssetImage('assets/profileImage.webp'),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 15),
              child: Text(
                "Hey Alisha!",
                style: TextStyle(
                    color: Colors.grey[500],
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              )),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 25, 15, 0),
            child: Column(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                ListTile(
                  leading: Icon(
                    Icons.person,
                    size: 22,
                    color: Colors.greenAccent,
                  ),
                  title: Text("My Account"),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.payment_outlined,
                    size: 22,
                    color: Colors.greenAccent,
                  ),
                  title: Text("My Banking Details"),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.loyalty,
                    size: 22,
                    color: Colors.greenAccent,
                  ),
                  title: Text("My Subscription"),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.group,
                    size: 22,
                    color: Colors.greenAccent,
                  ),
                  title: Text("Referrer Program"),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.question_answer,
                    size: 22,
                    color: Colors.greenAccent,
                  ),
                  title: Text("FAQs"),
                  trailing: Icon(Icons.question_mark),
                ),
                Divider(),
                // DropdownButton<String>(
                //   value: _selectedCurrency,
                //   onChanged: (String? newValue) {
                //     setState(() {
                //       _selectedCurrency = newValue!;
                //     });
                //   },
                //   items:
                //       <String>['USD', 'EUR', 'GBP', 'JPY'] // Example currencies
                //           .map<DropdownMenuItem<String>>((String value) {
                //     return DropdownMenuItem<String>(
                //       value: value,
                //       child: Text(value),
                //     );
                //   }).toList(),
                // ),
                // ElevatedButton(
                //   onPressed: () {
                //     saveUserPreferences();
                //   },
                //   child: Text('Save Preferences'),
                // )
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.redAccent)),
              onPressed: _logout,
              child: Text(
                "Log Out",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        )
      ],
    ));
  }

  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, HomeScreen.id);
  }

  // void saveUserPreferences() async {
  //   final User? user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     await FirebaseFirestore.instance
  //         .collection('Users')
  //         .doc(user.uid)
  //         .collection('Preferences')
  //         .doc('Settings')
  //         .set({
  //           'PreferredCurrency': _selectedCurrency,
  //           // Add other preferences as needed
  //         }, SetOptions(merge: true))
  //         .then((_) => print('Preferences saved successfully'))
  //         .catchError((error) => print('Failed to save preferences: $error'));
  //   }
  // }
}
