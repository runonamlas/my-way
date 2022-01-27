import 'package:flutter/material.dart';

//ignore: must_be_immutable
class ToursComponent extends StatelessWidget {
  final String toursText;
  double topPadding;
  double bottomPadding;
  final String toursImage;
  ToursComponent({this.toursText, this.topPadding, this.bottomPadding, this.toursImage});
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(top: topPadding, right: 16.0, left: 16.0, bottom: bottomPadding),
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [Colors.black87, Colors.black87],
          begin: Alignment.centerLeft,
          end: Alignment(1.0, 1.0),
        )),
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {},
              child: Opacity(
                opacity: 0.8,
                child: Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.black87,
                      spreadRadius: 3,
                      blurRadius: 3,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ], image: DecorationImage(image: AssetImage(toursImage), fit: BoxFit.fill)),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        toursText,
                        style: TextStyle(
                            fontFamily: 'yesteryear-regular', color: Colors.white, fontSize: size.width * 0.06),
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
