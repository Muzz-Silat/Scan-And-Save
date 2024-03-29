// import 'package:flutter/material.dart';
// import 'package:demo_flutter/components/components.dart';
// import 'package:demo_flutter/screens/login_screen.dart';
// import 'package:demo_flutter/screens/signup_screen.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
//   static String id = 'home_screen';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(25),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const TopScreenImage(screenImageName: 'home.jpg'),
//               Expanded(
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.only(right: 15.0, left: 15, bottom: 15),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       const ScreenTitle(title: 'Hello'),
//                       const Text(
//                         'Welcome to Scan & Save',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 20,
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 15,
//                       ),
//                       Hero(
//                         tag: 'login_btn',
//                         child: CustomButton(
//                           buttonText: 'Login',
//                           onPressed: () {
//                             Navigator.pushNamed(context, LoginScreen.id);
//                           },
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Hero(
//                         tag: 'signup_btn',
//                         child: CustomButton(
//                           buttonText: 'Sign Up',
//                           isOutlined: true,
//                           onPressed: () {
//                             Navigator.pushNamed(context, SignUpScreen.id);
//                           },
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 25,
//                       ),
//                       const Text(
//                         'Sign up using',
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 16,
//                         ),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           IconButton(
//                             onPressed: () {},
//                             icon: CircleAvatar(
//                               radius: 25,
//                               child: Image.asset(
//                                   'assets/images/icons/facebook.png'),
//                             ),
//                           ),
//                           IconButton(
//                             onPressed: () {},
//                             icon: CircleAvatar(
//                               radius: 25,
//                               backgroundColor: Colors.transparent,
//                               child:
//                                   Image.asset('assets/images/icons/google.png'),
//                             ),
//                           ),
//                           IconButton(
//                             onPressed: () {},
//                             icon: CircleAvatar(
//                               radius: 25,
//                               child: Image.asset(
//                                   'assets/images/icons/linkedin.png'),
//                             ),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:demo_flutter/screens/signup_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToSignUpScreen();
  }

  Future<void> _navigateToSignUpScreen() async {
    await Future.delayed(
        const Duration(seconds: 2)); // Adjust the delay as needed
    if (!mounted) return;
    Navigator.pushReplacementNamed(
        context,
        SignUpScreen
            .id); // Use pushReplacementNamed to prevent going back to the home screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E2E2E), // Changed background color to #2E2E2E
      body: SafeArea(
        child: Center(
          // Added Center widget to center everything on the screen
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center content vertically
            children: [
              SizedBox(
                width: double.infinity, // Take the full width
                child: Text(
                  'Scan & Save',
                  textAlign: TextAlign.center, // Center text horizontally
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontFamily: 'DotGothic16',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
