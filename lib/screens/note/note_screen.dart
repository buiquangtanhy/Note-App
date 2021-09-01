import 'dart:async';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:note/database/models/note.dart';
import 'package:note/database/reponsitories/note_local_reponsitory.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class NoteScreen extends StatefulWidget {
  static String routeName = "/note";
  final Note? note;
  const NoteScreen({
    Key? key,
    this.note,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  late String title;
  late String content;
  late String uRIImage;
  late int color;
  late String urlWeb;

  DateTime dateTimeNow = DateTime.now();
  final format = new DateFormat('EEEE, dd MMMM yyyy hh:mm a');
  @override
  void initState() {
    super.initState();
    title = widget.note?.title ?? '';
    content = widget.note?.content ?? '';
    uRIImage = widget.note?.uriImage ?? '';
    urlWeb = widget.note?.webLink ?? '';
    color = widget.note?.typeColor ?? 0xff292929;
  }

  @override
  Widget build(BuildContext context) {
    Widget buildColor(int a) {
      return GestureDetector(
        onTap: () {
          setState(() {
            color = a;
          });
        },
        child: Container(
          alignment: Alignment.center,
          height: 30,
          width: 30,
          
          decoration:BoxDecoration(
            color: Color(a),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: 1,color: Colors.white)
          ),
          child: a == color? Icon(Icons.check,color: Colors.white,): Container(),
        ),
      );
    }

    Widget fineColor = new Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildColor(0xFF000000),
          buildColor(0xFFD32F2F),
          buildColor(0xFF4527A0),
          buildColor(0xFF3D5AFE),
          buildColor(0xFFFFEA00),
        ],
      ),
    );
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(color),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () async {
              if (title == '' && content == '') {
                Navigator.of(context).pop();
                print('''== Back don't save ==''');
              } else {
                addOrUpdateNote();
                Navigator.of(context).pop();
                print('''== Back and save ==''');
              }
            },
          ),
          title: Text(
            "Note",
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          color: Color(color),
          padding: EdgeInsets.all(15.0),
          child: ListView(
            children: <Widget>[
              textFormTitle(),
              SizedBox(height: 8),
              Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    format.format(dateTimeNow),
                    style: TextStyle(color: Colors.white),
                  )),
              fineColor,
              TextButton(
                  onPressed: () {
                    _showChoiceDialog(context);
                  },
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: 3),
                        child: Icon(
                          Icons.image,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Add image",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  )),
              TextButton(
                  onPressed: () {
                    _addUrl(context);
                  },
                  child: Row(
                    children: [
                      Container(
                        child: Icon(
                          Icons.language,
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.only(right: 3),
                      ),
                      Text(
                        "Add url",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  )),
              SizedBox(height: 8),
              textFormContent(),
              SizedBox(
                height: 5,
              ),
              showUrlWeb(),
              showImage(),
            ],
          ),
        )
        // ),
        );
  }

  Widget textFormTitle() {
    return TextFormField(
      initialValue: title,
      onChanged: (text) {
        title = text.trim();
      },
      // textAlign: TextAlign.right,
      style: TextStyle(
          color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
      decoration: InputDecoration.collapsed(
        hintText: "Note title",
        hintStyle: TextStyle(color: Color(0xffCECECE)),
      ),
    );
  }

  Widget textFormContent() {
    return TextFormField(
      initialValue: content,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      onChanged: (text) {
        content = text.trim();
      },
      style: TextStyle(
          color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
      decoration: InputDecoration.collapsed(
          hintText: "Enter Note Here",
          hintStyle: TextStyle(color: Color(0xffCECECE))),
    );
  }

// =======================================
  void addOrUpdateNote() async {
    if (widget.note != null) {
      await updateNote();
    } else {
      await addNote();
    }
  }

  Future updateNote() async {
    Note note;
    if (uRIImage == '') {
      note = widget.note!.copy(
          title: title, content: content, typeColor: color, webLink: urlWeb);
    } else {
      note = widget.note!.copy(
          title: title,
          content: content,
          typeColor: color,
          uriImage: uRIImage,
          webLink: urlWeb);
    }

    await NotesDatabase.instance.update(note);
  }

  Future addNote() async {
    Note note;
    if (uRIImage == '') {
      note = Note(
          title: title, content: content, typeColor: color, webLink: urlWeb);
    } else {
      note = Note(
          title: title,
          content: content,
          typeColor: color,
          uriImage: uRIImage,
          webLink: urlWeb);
    }

    await NotesDatabase.instance.create(note);
  }

  //====================================================================
  // =======================================

  Future<void> _saveImage(File file) async {
    Directory a = await getApplicationDocumentsDirectory();
    final String path = a.path;
    final fileName = basename(file.path);
    final File localImage = await file.copy('$path/$fileName');
    print("iamge file = $localImage");
    setState(() {
      uRIImage = localImage.path;
    });
  }

  _openGallery(BuildContext context) async {
    final picture = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picture != null) {
      setState(() {
        _saveImage(File(picture.path));
      });
    }
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    final picture = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picture != null) {
      setState(() {
        _saveImage(File(picture.path));
      });
    }
    Navigator.of(context).pop();
  }

  Future<void> _addUrl(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Paste url here: "),
            content: Container(
              child: textFormUrl(),
            ),
          );
        });
  }

  Widget textFormUrl() {
    return TextFormField(
      initialValue: urlWeb,
      onChanged: (text) {
        setState(() {
          urlWeb = text;
        });
      },
      style: TextStyle(
          color: Colors.blue,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic),
      decoration: InputDecoration.collapsed(
          hintText: "Enter Url Here",
          hintStyle: TextStyle(color: Color(0xffCECECE))),
    );
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Make a choice!"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: Text("Gallery"),
                    onTap: () {
                      _openGallery(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: Text("Camera"),
                    onTap: () {
                      _openCamera(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget showImage() {
    return uRIImage == ''
        ? Container()
        : Expanded(
            child: Container(
                padding: EdgeInsets.only(top: 10.0),
                child: ClipRRect(
                    child: Image.file(
                  File(uRIImage.toString()),
                  // width: 200,
                  // height: 200,
                  fit: BoxFit.cover,
                ))));
  }

  Widget showUrlWeb() {
    return urlWeb == ''
        ? Container()
        : Container(
            child: InkWell(
                child: Text(
                  urlWeb,
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic),
                ),
                onTap: () => launch(urlWeb)));
  }
}
