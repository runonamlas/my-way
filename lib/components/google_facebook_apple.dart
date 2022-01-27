import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GoogleFacebookApple extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {},
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: Colors.white,
              ),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              'assets/icons/google.svg',
              width: 20,
              height: 20,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: Colors.white,
              ),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              'assets/icons/facebook.svg',
              width: 20,
              height: 20,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: Colors.white,
              ),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              'assets/icons/apple.svg',
              width: 20,
              height: 20,
            ),
          ),
        )
      ],
    );
  }
}
