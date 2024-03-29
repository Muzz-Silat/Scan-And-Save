import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:demo_flutter/components/components.dart';
import 'package:demo_flutter/screens/home_screen.dart';
import 'package:demo_flutter/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:demo_flutter/constants.dart';
import 'package:loading_overlay/loading_overlay.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static String id = 'signup_screen';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth = FirebaseAuth.instance;
  String? _email;
  String? _password;
  String? _confirmPass;
  bool _saving = false;
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popAndPushNamed(context, HomeScreen.id);
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 46, 46, 46),
        body: LoadingOverlay(
          isLoading: _saving,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // const TopScreenImage(screenImageName: 'signup.png'),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
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
                          SizedBox(height: 20),
                          _buildPasswordInputField(
                              'Confirm Password', _passwordVisible, (value) {
                            setState(() {
                              _confirmPass = value;
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
                                if (_email?.isEmpty ?? true) {
                                  // Checks if _email is null or empty
                                  // Show an error message about the email
                                  showAlert(
                                    context: context,
                                    title: 'Email Required',
                                    desc: 'Please enter your email address.',
                                    onPressed: () => Navigator.pop(context),
                                  ).show();
                                  return;
                                }

                                if (_password?.isEmpty ?? true) {
                                  // Checks if _password is null or empty
                                  // Show an error message about the password
                                  showAlert(
                                    context: context,
                                    title: 'Password Required',
                                    desc: 'Please enter your password.',
                                    onPressed: () => Navigator.pop(context),
                                  ).show();
                                  return;
                                }

                                if (_confirmPass?.isEmpty ?? true) {
                                  // Checks if _confirmPass is null or empty
                                  // Show an error message about the confirm password
                                  showAlert(
                                    context: context,
                                    title: 'Confirm Password Required',
                                    desc: 'Please confirm your password.',
                                    onPressed: () => Navigator.pop(context),
                                  ).show();
                                  return;
                                }

                                if (_password != _confirmPass) {
                                  // Show an error message if passwords don't match
                                  showAlert(
                                    context: context,
                                    title: 'Passwords Do Not Match',
                                    desc:
                                        'Make sure that you write the same password twice.',
                                    onPressed: () => Navigator.pop(context),
                                  ).show();
                                  return;
                                }

                                // If all checks passed, proceed with Firebase sign-up
                                setState(() {
                                  _saving = true;
                                });

                                try {
                                  await _auth.createUserWithEmailAndPassword(
                                    email: _email!,
                                    password: _password!,
                                  );

                                  // Navigate to the login screen after successful sign-up
                                  Navigator.popAndPushNamed(
                                      context, LoginScreen.id);
                                } on FirebaseAuthException catch (e) {
                                  setState(() {
                                    _saving = false;
                                  });

                                  String errorMessage =
                                      'An error occurred. Please try again.';
                                  if (e.code == 'weak-password') {
                                    errorMessage = 'The password is too weak.';
                                  } else if (e.code == 'email-already-in-use') {
                                    errorMessage =
                                        'An account already exists for that email.';
                                  } else if (e.code == 'invalid-email') {
                                    errorMessage =
                                        'The email address is not valid.';
                                  }

                                  showAlert(
                                    context: context,
                                    title: 'Sign Up Error',
                                    desc: errorMessage,
                                    onPressed: () => Navigator.pop(context),
                                  ).show();
                                } catch (e) {
                                  setState(() {
                                    _saving = false;
                                  });

                                  // Show a generic error message
                                  showAlert(
                                    context: context,
                                    title: 'Error',
                                    desc:
                                        'An unexpected error occurred. Please try again later.',
                                    onPressed: () => Navigator.pop(context),
                                  ).show();
                                }
                              },
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontFamily: 'CourierPrime',
                                  fontSize: 24,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            "Already have an account?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontFamily: "CourierPrime",
                            ),
                          ),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, LoginScreen.id);
                            },
                            child: Text(
                              "Login",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: "CourierPrime",
                                color: Color.fromARGB(255, 103, 240, 173),
                              ),
                            ),
                          ),
                        ],
                      ),
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
