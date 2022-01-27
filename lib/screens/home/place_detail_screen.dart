import 'package:flutter/material.dart';
import 'package:my_way/constants.dart';
import 'package:my_way/model/place.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceDetailScreen extends StatefulWidget {
  final PlaceModel place;
  final bool isFavourite;
  PlaceDetailScreen({@required this.place, this.isFavourite});
  @override
  _PlaceDetailScreenState createState() => _PlaceDetailScreenState(place, isFavourite);
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  _PlaceDetailScreenState(this.place, this.isFavourite);
  PlaceModel place;
  bool isFavourite = false;
  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(body: myGridItems());
  }

  Widget myGridItems() {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: double.infinity,
              height: deviceHeight * 0.3,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0.0, 5.0),
                        blurRadius: 5.0)
                  ]),
              child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0)),
                  child: Image(
                      fit: BoxFit.cover,
                      image: NetworkImage(place.image))),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                color: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Positioned(
              left: size.width * 0.8,
              right: 16.0,
              bottom: 16.0,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                maxRadius: 18.0,
                foregroundColor: Colors.red,
                child: isFavourite? 
                             Icon(
                                IconData(0xe900, fontFamily: 'heart'),
                                size: size.width * 0.04,
                              ):
                             Icon(
                              IconData(0xe900, fontFamily: 'heart-outline'),
                              size: size.width * 0.04,
                            )
              ),
            ),
          ],
        ),
        SizedBox(
          height: size.height * 0.02,
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                place.name,
                style: TextStyle(
                    fontSize: deviceHeight * 0.03, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: deviceHeight * 0.01,
              ),
              Text('HISTORY',
                  style: TextStyle(
                      fontSize: deviceHeight * 0.02,
                      fontWeight: FontWeight.bold)),
              SizedBox(
                height: deviceHeight * 0.01,
              ),
              Divider(
                height: deviceHeight * 0.01,
                thickness: 2.0,
                color: Colors.black,
                indent: deviceWidth * 0.05,
                endIndent: deviceWidth * 0.05,
              ),
              Container(
                margin:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                height: size.height * 0.48,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.start,
                    children: [
                      Text(
                        place.desc,
                        style: TextStyle(fontSize: deviceWidth * 0.045),
                      ),
                      // ignore: deprecated_member_use
                      InkWell(
                        onTap: () => _openUrl('https://flutter.dev '),
                        child: Text(
                          'Wikipedia',
                          style: TextStyle(
                              fontSize: deviceWidth * 0.04,
                              color: Color(0XFF0066CC)),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

Future _openUrl(String link) async {
  if (await canLaunch(link)) {
    await launch(link);
  } else {
    debugPrint('Link açılmadı.');
  }
}
