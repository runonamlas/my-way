import 'package:flutter/material.dart';
import 'package:my_way/constants.dart';

//ignore: must_be_immutable
class ConstTextFormField extends StatefulWidget {
  final String text;
  final IconData icon1;
  final controller;
  final validator;
  final onSaved;
  final TextInputType keyboardType;
  bool obscureText;
  ConstTextFormField({this.text, this.icon1, this.controller, this.obscureText, this.onSaved, this.validator, this.keyboardType});
  @override
  _ConstTextFormFieldState createState() => _ConstTextFormFieldState();
}

class _ConstTextFormFieldState extends State<ConstTextFormField> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.8,
      child: TextFormField(
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        onSaved: widget.onSaved,
        controller: widget.controller,
        cursorColor: kPrimaryColor,
        style: TextStyle(color: kPrimaryColor),
        obscureText: widget.obscureText,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: 14.0, bottom: 14.0),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(
            widget.icon1,
            color: kPrimaryColor,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kPrimaryColor, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2.0),
          ),
          hintText: widget.text,
          hintStyle: TextStyle(color: kPrimaryColor),
        ),
      ),
    );
  }
}
