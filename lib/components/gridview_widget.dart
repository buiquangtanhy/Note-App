import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:note/database/models/note.dart';
import 'package:note/database/reponsitories/note_local_reponsitory.dart';
import 'package:note/screens/note/note_screen.dart';

class GridViewNotes extends StatefulWidget {
  final List<Note> notes;
  GridViewNotes({Key? key, required this.notes}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return GridViewNotesState();
  }
}

class GridViewNotesState extends State<GridViewNotes> {
  late List<Note> notes;
  bool isLoading = false;

  _onSelect(int id) async {
    final note = await NotesDatabase.instance.readNote(id);
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => NoteScreen(
        note: note,
      ),
    ));
    refreshNotes();
  }

  @override
  void initState() {
    super.initState();
    this.notes = widget.notes;
    // refreshNotes();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    this.notes = await NotesDatabase.instance.readAllNote();

    setState(() => isLoading = false);
  }



  List<Widget> note_builder(List<Note> notes) {
    var items = notes.map(
      (Note) => InkWell(
      
          onTap: () {
            _onSelect(Note.id!);
          },
          onLongPress: () {
            _showChoiceDialog(Note.id!);
          },
          child: Container(
            width: 190.0,
            decoration: BoxDecoration(
              border: Border.all(width: 0, style: BorderStyle.none),
              borderRadius: BorderRadius.circular(15),
              color: Color(Note.typeColor),
            ),
            child: Column(
              children: [
                Note.uriImage == null
                    ? Container()
                    : Expanded(
                        child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)),
                        child: Image.file(
                          File(Note.uriImage.toString()),
                          width: 190,
                          height: 400,
                          fit: BoxFit.fill,
                        ),
                      )),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Note.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        Note.content,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Note.webLink == null
                          ? Container()
                          : Text(
                              Note.webLink ?? '',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
    return items.toList();
  }

  List<StaggeredTile> staggered_tile_builder(List<Note> notes) {
    var items = notes.map((Note) {
      if (Note.uriImage == null)
        return StaggeredTile.extent(1, 120);
      else
        return StaggeredTile.extent(1, 350);
    });
    return items.toList();
  }

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 16,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(vertical: 10),
      physics: NeverScrollableScrollPhysics(),
      children: note_builder(notes),
      staggeredTiles: staggered_tile_builder(notes),
    );
  }

  Future<void> _showChoiceDialog(int id) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Make a choice!"),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  child: Text("Delete"),
                  onTap: () {
                    NotesDatabase.instance.delete(id);
                    refreshNotes();
                    Navigator.of(context).pop();
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text("Cancel"),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }
}
