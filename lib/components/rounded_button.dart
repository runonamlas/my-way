import 'package:flutter/material.dart';
import 'package:my_way/constants.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  final double fontSize;
  const RoundedButton({
    Key key,
    this.text,
    this.press,
    this.color = kPrimaryColor,
    this.textColor = Colors.white,
    this.fontSize = 18.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Size size = MediaQuery.of(context).size;
    return Container(
        width: size.width * 0.8,
        //height: size.height * 0.05,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: TextButton(
          onPressed: press,
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 1.0, fontWeight: FontWeight.bold),
          ),
        ));
  }
}
