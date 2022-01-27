import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class StarDisplay extends StatelessWidget {
  final double value;
  final double value2;
  const StarDisplay({Key key, this.value = 0, this.value2})
      : assert(value != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Row(
          children: [
            Text(value.toString(),
                style: TextStyle(fontSize: size.height * 0.015)),
            SizedBox(
              width: size.width * 0.01,
            ),
            Row(mainAxisSize: MainAxisSize.min, children: [
              SmoothStarRating(
                allowHalfRating: false,
                starCount: 5,
                rating: value,
                size: size.width * 0.03,
                color: Colors.amber,
                borderColor: Colors.amber,
                //spacing: 0.0,
              ),
            ]),
            SizedBox(
              width: size.width * 0.01,
            ),
            Text(
              '($value2)',
              style: TextStyle(fontSize: size.height * 0.015),
            ),
          ],
        ),
      ],
    );
  }
}
