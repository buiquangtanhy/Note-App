// We use name route
// All our routes will be available here
import 'package:flutter/cupertino.dart';
import 'package:note/screens/home/home_screen.dart';
import 'package:note/screens/note/note_screen.dart';

final Map<String, WidgetBuilder> routes = {
  Home.routeName: (context) => Home(),
  NoteScreen.routeName: (context) => NoteScreen(),
};