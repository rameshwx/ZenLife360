import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenlife/controller/login_view_controller.dart';

import '../utils/utils.dart';
import 'home_page.dart';

class GoogleSignInUI extends StatefulWidget {
  const GoogleSignInUI({Key? key}) : super(key: key);

  @override
  State<GoogleSignInUI> createState() => _GoogleSignInScreenState();
}

class _GoogleSignInScreenState extends State<GoogleSignInUI> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
    _checkForExistingUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Maintain padding around the content
        child: Center( // Center the content vertically and horizontally
          child: SingleChildScrollView( // Allows the content to be scrollable
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
              children: [
                if (_user == null) ...[
                  Text(
                    "Welcome to ZenLife360",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28, // Slightly larger text size
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: 32), // Increase spacing
                  Text(
                    "Sign in with Google to continue",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20, // Slightly larger text size
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 48), // Increase spacing
                  _googleSignInButton(),
                ] else ...[
                  _userInfo(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _googleSignInButton() {
    return SignInButton(
      Buttons.google,
      text: "Sign in with Google",
      onPressed: _handleGoogleSignIn,
      // Making the button expand to fill the width
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    );
  }

  Widget _userInfo() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(_user!.photoURL!),
            radius: 50,
          ),
          SizedBox(height: 8),
          Text(
            _user!.displayName ?? "",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            _user!.email!,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.red, // Button color
            ),
            onPressed: () async {
              await _auth.signOut();
            },
            child: Text("Sign Out"),
          ),
        ],
      ),
    );
  }

  void _handleGoogleSignIn() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final LoginViewController loginController = LoginViewController(); // Create an instance

    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential userCredential = await _auth.signInWithCredential(credential);
        final User? user = userCredential.user;

        setState(() {
          _user = user;
        });

        if (user != null) {
          // Now using loginController to send data
          await loginController.sendDataToAPI(context, user.displayName ?? user.email!, user.email!, user.uid);
          _checkForExistingUserId(); // Assuming you want to check user ID after successful API call
        }
      }
    } catch (error) {
      Utils.showSnackBar(context,"Failed to sign in with Google: $error");
    }
  }

  Future<void> _checkForExistingUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Check if 'user_id' exists in SharedPreferences
    if (prefs.getInt('user_id') != null) {
      // If exists, redirect to HomePage
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    }else{
      Utils.showSnackBar(context,"Failed to sign in with Google");
    }
  }

}