import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_way/constants.dart';
import 'package:my_way/model/place.dart';
import 'package:my_way/screens/favourite/favourite_screen.dart';
import 'package:my_way/screens/home/home_tour_screen/map_screen.dart';

// ignore: must_be_immutable
class TourListScreen extends StatefulWidget {
  String tourName;
  List<PlaceModel> tourPlaces;
  String tourMinute;
  TourListScreen({@required this.tourName, @required this.tourPlaces, this.tourMinute});
  @override
  _TourListScreenState createState() => _TourListScreenState();
}

class _TourListScreenState extends State<TourListScreen> {
  @override
  Widget build(BuildContext context) {
    var tourPlaces = widget.tourPlaces.map((e) => e.name).toList();
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            color: Colors.white,
            icon: Icon(Icons.arrow_back_ios),
          ),
          brightness: Brightness.dark,
          title: Text(widget.tourName, style: TextStyle(color: Colors.white, fontSize: size.height * 0.024)),
          actions: [
            IconButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FavouriteScreen())),
              icon: Icon(
                Icons.add_circle_outline,
              ),
              color: Colors.white,
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: widget.tourPlaces.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 10.0,
              child: Dismissible(
                direction: DismissDirection.endToStart,
                key: Key(index.toString()),
                background: _hiddenContainer(),
                onDismissed: (direction) {
                  if (direction == DismissDirection.endToStart) {
                    // ignore: deprecated_member_use
                    tourPlaces.removeAt(index);
                    print(tourPlaces);
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('Delete'),
                    ));
                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: ListTile(
                    subtitle: Text('10 min'),
                    trailing: Icon(
                      Icons.arrow_back_ios_outlined,
                      size: size.height * 0.02,
                    ),
                    leading: Container(
                      height: double.maxFinite,
                      width: 24.0,
                      color: Color(0xFFF8CF60),
                      child: Center(
                          child: Text(
                        (index + 1).toString(),
                        style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.025, fontWeight: FontWeight.bold),
                      )),
                    ),
                    title: Text(
                      tourPlaces[index],
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: size.height * 0.024),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: kPrimaryColor,
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MapScreen(
                        places: widget.tourPlaces,
                      ))),
          child: Icon(
            Icons.subdirectory_arrow_right,
            size: 26.0,
          ),
        ));
  }

  Widget _hiddenContainer() {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.red,
      child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(
              Icons.delete_outline_outlined,
              size: MediaQuery.of(context).size.height * 0.04,
            ),
          )),
    );
  }
}
