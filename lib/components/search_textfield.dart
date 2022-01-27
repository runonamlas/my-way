import 'package:flutter/material.dart';

//ignore: must_be_immutable
class SearchTextField extends StatelessWidget {
  final String description;
  final IconButton iconButton;
  final TextEditingController controller;
  final Function changed;
  double fontSize;

  SearchTextField({this.description, this.iconButton, this.controller, this.changed, this.fontSize});
  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Colors.white,
      controller: controller,
      onChanged: changed,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(15),
          hintText: description,
          hintStyle: TextStyle(color: Colors.white, fontSize: fontSize, letterSpacing: 0.5),
          prefixIcon: Icon(Icons.search, color: Colors.white),
          suffixIcon: iconButton,
          border: InputBorder.none),
    );
  }
}
