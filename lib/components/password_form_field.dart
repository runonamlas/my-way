import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_way/constants.dart';

//ignore: must_be_immutable
class PasswordFormField extends StatefulWidget {
  final String text;
  final IconData icon1;
  final IconData icon2;
  final IconData icon3;
  final validator;
  final controller;
  final onSaved;
  final TextInputType keyboardType;
  bool obscureText;
  PasswordFormField(
      {this.text, this.icon1, this.obscureText, this.icon2, this.icon3, this.controller, this.keyboardType, this.validator, this.onSaved});
  @override
  _PasswordFormFieldState createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.8,
      child: Stack(
        children: [
          TextFormField(
            keyboardType: widget.keyboardType,
            controller: widget.controller,
            enableSuggestions: false,
            validator: widget.validator,
            onSaved: widget.onSaved,
            autocorrect: false,
            cursorColor: kPrimaryColor,
            style: TextStyle(color: kPrimaryColor),
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2.0),
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: widget.text,
              hintStyle: TextStyle(color: kPrimaryColor),
              contentPadding: EdgeInsets.only(top: 15.0, bottom: 14.0),
              prefixIcon: Icon(
                widget.icon1,
                color: kPrimaryColor,
              ),
            ),
            textInputAction: TextInputAction.done,
            obscureText: widget.obscureText,
          ),
          Positioned(
            right: 5,
            child: IconButton(
                icon: Icon(
                  widget.obscureText ? Icons.visibility : Icons.visibility_off,
                  color: kPrimaryColor,
                ),
                onPressed: () {
                  setState(() {
                    widget.obscureText = !widget.obscureText;
                  });
                }),
          ),
        ],
      ),
    );
  }
}
