import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note/components/search_widget.dart';
import 'package:note/components/gridview_widget.dart';
import 'package:note/database/models/note.dart';
import 'package:note/database/reponsitories/note_local_reponsitory.dart';
import 'package:note/screens/note/note_screen.dart';

import '../../routes.dart';

class Home extends StatefulWidget {
  static String routeName = "/home";

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<Note> notes;
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshNotes();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();

    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    this.notes = await NotesDatabase.instance.readAllNote();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Home',
      home: Scaffold(
        backgroundColor: Color(0xff292929),
        appBar: AppBar(
          backgroundColor: Color(0xff292929),
          elevation: 0,
          title: Text(
            'Home',
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          child: Stack(
            children: [
              Container(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    SearchSection(),
                    Center(
                      child: isLoading
                          ? CircularProgressIndicator()
                          : notes.isEmpty
                              ? Text(
                                  'No Notes',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 24),
                                )
                              : GridViewNotes(
                                  notes: notes,
                                ),
                    ),
                  ],
                ),
              ),
              Positioned(
                child: FlatButton(
                  onPressed: ()async {
                       await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => NoteScreen()),
            );

            refreshNotes();
                  },
                  child: Icon(
                    Icons.add,
                    size: 50,
                    color: Colors.black,
                  ),
                  color: Color(0xfffdbe3b),
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(10),
                ),
                bottom: 30,
                right: 0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
