import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

  // Widget _googleSignInButton() {
  //   return Center(
  //     child: SignInButton(
  //       Buttons.google,
  //       text: "Sign in with Google",
  //       onPressed: _handleGoogleSignIn,
  //     ),
  //   );
  // }

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
          print("Google Account ID: ${user.uid}"); // This is the unique ID provided by Google
          // You can now use this UID for your cloud operations
        }
      }
    } catch (error) {
      print("Failed to sign in with Google: $error");
    }
  }

  Future<void> _sendDataToAPI(String name, String email, String googleAccountId) async {
    final Uri apiUri = Uri.parse('http://127.0.0.1:8000/api/auth/verify');
    try {
      final response = await http.post(apiUri, body: {
        'name': name,
        'email': email,
        'google_account_id': googleAccountId,
      });

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['status'] == true) {
          // Store user_id, email, and token in SharedPreferences
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setInt('user_id', responseData['user']['user_id']);
          await prefs.setString('email', responseData['user']['email']);
          await prefs.setString('token', responseData['token']);
          _checkForExistingUserId();
          // Navigate to the next page or update UI as needed
        } else {
          // Handle the case where the API response status is not true
          print('Failed to verify user: ${responseData['message']}');
        }
      } else {
        // Handle HTTP error
        print('Failed to load data. Server responded with status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle errors from the API request
      print('Error sending data to API: $error');
    }
  }

  Future<void> _checkForExistingUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Check if 'user_id' exists in SharedPreferences
    if (prefs.getInt('user_id') != null) {
      // If exists, redirect to HomePage
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

}