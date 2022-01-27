import 'package:flutter/material.dart';
import 'package:my_way/constants.dart';

class SeenPlacesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.height * 0.07),
        child: AppBar(
          title: Text('Seen Places'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
          brightness: Brightness.dark,
          elevation: 0.0,
        ),
      ),
      body: Container(
        height: size.height * 0.836,
        width: size.width,
        decoration:
            BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
      ),
    );
  }
}
