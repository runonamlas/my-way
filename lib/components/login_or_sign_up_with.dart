import 'package:flutter/material.dart';

class LoginOrSignUpWith extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Divider(
            color: Color(0xFFD9D9D9),
            height: 1.5,
            indent: 40.0,
            endIndent: 10.0,
          ),
        ),
        Text(
          'OR',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        Flexible(
          child: Divider(
            color: Color(0xFFD9D9D9),
            height: 1.5,
            indent: 10.0,
            endIndent: 40.0,
          ),
        )
      ],
    );
  }
}
