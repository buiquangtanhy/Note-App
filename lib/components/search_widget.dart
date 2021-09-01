import 'package:flutter/material.dart';

class SearchSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchSectionState();
  }
}

class SearchSectionState extends State<SearchSection> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Search Notes',
        hintStyle: TextStyle(color: Color(0xff7b7b7b)),
        filled: true,
        fillColor: Color(0xff333333),
        prefixIcon: Icon(
          Icons.search,
          color: Colors.white,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
          borderRadius: const BorderRadius.all(const Radius.circular(15.0)),
        ),
      ),
    );
  }
}
