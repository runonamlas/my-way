import 'package:flutter/material.dart';
import 'package:my_way/constants.dart';

class ListTileComponent extends StatelessWidget {
  String listTileText;
  Widget nextScreen;
  ListTileComponent({this.listTileText, this.nextScreen});
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => nextScreen)),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Card(
          elevation: 15.0,
          child: ListTile(
            contentPadding: EdgeInsets.only(left: 8.0),
            title: Text(listTileText, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 18)),
            trailing: Icon(Icons.navigate_next_outlined, size: size.height * 0.04, color: kPrimaryColor),
          ),
        ),
      ),
    );
  }
}
