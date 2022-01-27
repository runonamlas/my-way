import 'package:flutter/material.dart';
import 'package:my_way/constants.dart';

// ignore: must_be_immutable
class HistoryComponent extends StatelessWidget {
  IconData historyIcon;
  String historyName;
  HistoryComponent({@required this.historyIcon, @required this.historyName});
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          maxRadius: size.width * 0.05,
          child: Icon(
            historyIcon,
            color: kPrimaryColor,
            size: size.width * 0.07,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            historyName,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 0.4, fontSize: size.height * 0.015),
          ),
        )
      ],
    );
  }
}
