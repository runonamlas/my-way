import 'package:flutter/material.dart';

class SwitchBetweenScreensText extends StatelessWidget {
  final String text1;
  final String text2;
  final onTap;
  SwitchBetweenScreensText({this.text1, this.text2, this.onTap});
  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      direction: Axis.horizontal,
      children: [
        Text(
          text1,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            text2,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      ],
    );
  }
}
