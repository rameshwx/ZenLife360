import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenlife/config/app_config.dart';

import '../ui/home_page.dart';

class LoginViewController {
  Future<void> sendDataToAPI(BuildContext context, String name, String email, String googleAccountId) async {
    final Uri apiUri = Uri.parse('${AppConfig.baseUrl}/verify');
    try {
      final response = await http.post(
        apiUri,
        body: {
          'name': name,
          'email': email,
          'google_account_id': googleAccountId,
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['status'] == true) {
        // Store user_id, email, and token in SharedPreferences
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('user_id', responseData['user']['user_id']);
        await prefs.setString('name', responseData['user']['name']);
        await prefs.setString('email', responseData['user']['email']);
        await prefs.setString('token', responseData['token']);

        // Navigate to HomePage or update UI as needed
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage())); // Ensure you have a HomePage widget
      } else {
        // Show error message to the user
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to verify user: ${responseData['message']}')));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error sending data to API: $error')));
    }
  }
}

