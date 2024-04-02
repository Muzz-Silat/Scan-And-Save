import 'package:flutter/material.dart';
import 'package:demo_flutter/components/components.dart';
import 'package:demo_flutter/constants.dart';
import 'package:demo_flutter/screens/signup_screen.dart';
import 'package:demo_flutter/mainPages/home_navigation_page.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:demo_flutter/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String id = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  late String _email;
  late String _password;
  bool _saving = false;
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popAndPushNamed(context, HomeScreen.id);
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 46, 46, 46),
        body: LoadingOverlay(
          isLoading: _saving,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 60),
                        SizedBox(
                          width: double.infinity, // Take the full width
                          child: Text(
                            'Scan & Save',
                            textAlign:
                                TextAlign.center, // Center text horizontally
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontFamily: 'DotGothic16',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                        Container(
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
                              onChanged: (value) {
                                setState(() {
                                  _email = value;
                                });
                              },
                              style: const TextStyle(
                                fontFamily: "CourierPrime",
                                fontSize: 18,
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Email Address',
                                labelStyle: TextStyle(color: Colors.grey),
                                prefixIcon:
                                    Icon(Icons.email, color: Colors.grey),
                                hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.6)),
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        _buildPasswordInputField('Password', _passwordVisible,
                            (value) {
                          setState(() {
                            _password = value;
                          });
                        }, () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        }),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color(0xFF67F0AD), // Background color
                              foregroundColor: Colors.black, // Text color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(33),
                              ),
                              shadowColor: Color(0x3F000000),
                              elevation: 4,
                              fixedSize: Size(308, 43), // Button size
                            ),
                            onPressed: () async {
                              // Attempt to log in the user
                              FocusManager.instance.primaryFocus?.unfocus();
                              setState(() {
                                _saving = true;
                              });
                              try {
                                await _auth.signInWithEmailAndPassword(
                                  email: _email,
                                  password: _password,
                                );

                                if (context.mounted) {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    HomeNavigationPage.routeName,
                                  );
                                }
                              } catch (e) {
                                // Handle login error
                                showAlert(
                                  context: context,
                                  title: 'Login Error',
                                  desc: 'Invalid email or password.',
                                  onPressed: () => Navigator.pop(context),
                                ).show();
                              } finally {
                                if (context.mounted) {
                                  setState(() {
                                    _saving = false;
                                  });
                                }
                              }
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontFamily: 'CourierPrime',
                                fontSize: 24,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 308, // Match the width to the buttons above
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, SignUpScreen.id);
                                },
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "CourierPrime",
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  // Forgot password functionality
                                  await FirebaseAuth.instance
                                      .sendPasswordResetEmail(email: _email);
                                  // Show confirmation dialog/alert
                                  showAlert(
                                    context: context,
                                    title: 'Reset Email Sent',
                                    desc:
                                        'Check your email to reset your password.',
                                    onPressed: () => Navigator.pop(context),
                                  ).show();
                                },
                                child: Text(
                                  "Forgot password?",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "CourierPrime",
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordInputField(String label, bool visible,
      Function(String) onChanged, VoidCallback toggleVisibility) {
    return Container(
      width: 308,
      height: 66,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.symmetric(vertical: 8),
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
          onChanged: onChanged,
          obscureText: !visible,
          style: const TextStyle(
            fontFamily: "CourierPrime",
            fontSize: 18,
            color: Colors.white,
          ),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.grey),
            prefixIcon: Icon(Icons.lock, color: Colors.grey),
            suffixIcon: IconButton(
              icon: Icon(
                // Choose the icon depending on the state
                visible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: toggleVisibility,
            ),
            hintText: '••••••••',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
