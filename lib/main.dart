import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  print("Firebase Connected Successfully!");
  runApp(const HairVerseApp());
}

class HairVerseApp extends StatelessWidget {
  const HairVerseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HairVerse AI',
      home: const SplashScreen(),
    );
  }
}