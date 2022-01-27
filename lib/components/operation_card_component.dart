import 'package:flutter/material.dart';

class OparationCardComponent extends StatelessWidget {
  final String operation;
  final String selectedIcon;
  final String unselectedIcon;
  final bool isSelected;

  OparationCardComponent(
      {this.operation,
      this.selectedIcon,
      this.unselectedIcon,
      this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 16.0),
      width: 123,
      height: 123,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.pink,
          blurRadius: 10,
          spreadRadius: 5,
          offset: Offset(8.0, 8.0),
        )
      ], borderRadius: BorderRadius.circular(15), color: Colors.black),
      child: Column(
        children: [Icon(Icons.home)],
      ),
    );
  }
}
