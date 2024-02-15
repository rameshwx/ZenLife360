import 'package:flutter/material.dart';
import 'package:zenlife/ui/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:zenlife/firebase_options.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZenLife360',
      theme: AppTheme.lightTheme,
      home: const GoogleSignInUI(),
    );
  }
}