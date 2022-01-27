import 'package:flutter/material.dart';

class InitialText extends StatelessWidget {
  final String text1;
  final String text2;
  InitialText({this.text1, this.text2});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Center(
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.center,
        children: [
          Text(
            text1,
            style: TextStyle(
              color: Colors.white,
              fontSize: size.width * 0.10,
              fontWeight: FontWeight.bold,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              text2,
              style: TextStyle(
                color: Colors.white,
                fontSize: size.width * 0.04,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
