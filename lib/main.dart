import 'package:flutter/material.dart';
import 'package:note/routes.dart';
import 'package:note/screens/home/home_screen.dart';

void main() {
  runApp(NoteApp());
}

class NoteApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note App',
      // home: SplashScreen(),
      // We use routeName so that we dont need to remember the name
      initialRoute: Home.routeName,
      routes: routes,
    );
  }
}

