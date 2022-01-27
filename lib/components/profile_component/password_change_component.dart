import 'package:flutter/material.dart';
import 'package:my_way/constants.dart';

class PasswordChangeComponent extends StatelessWidget {
  String title;
  PasswordChangeComponent({this.title});
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        Align(
            alignment: Alignment.topLeft,
            child: Text(title, style: TextStyle(fontSize: size.width * 0.04, color: kPrimaryColor, fontWeight: FontWeight.bold))),
        SizedBox(height: size.height * 0.01),
        Material(
          elevation: 10.0,
          child: TextFormField(
            cursorColor: kPrimaryColor,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(4.0),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor.withOpacity(0.7), width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2.0),
              ),
            ),
          ),
        ),
        SizedBox(height: size.height * 0.03),
      ],
    );
  }
}
