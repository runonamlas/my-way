import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_way/bloc/auth_bloc/auth.dart';
import 'package:my_way/constants.dart';
import 'package:my_way/model/city.dart';
import 'package:my_way/model/country.dart';
import 'package:my_way/model/place.dart';
import 'package:my_way/model/route.dart';
import 'package:my_way/components/profile_component/list_tile_component.dart';
import 'package:my_way/screens/profile/user_settings_screen.dart';
import 'package:my_way/screens/profile/password_change_screen.dart';
import 'package:my_way/screens/profile/my_tours_screen.dart';
import 'package:my_way/screens/profile/seen_places_screen.dart';
import 'package:my_way/screens/profile/seen_tours_screen.dart';
import 'package:my_way/screens/profile/app_settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var placeList = [
    PlaceModel('id', 'name', 'https://source.unsplash.com/1600x900/?varna,city', 'desc', 4, 1.1, 1.1,
        CityModel('id', 'name', 'image', CountryModel('id', 'name', 'flag'))),
    PlaceModel('id', 'name', 'https://source.unsplash.com/1600x900/?varna,city', 'desc', 4, 1.1, 1.1,
        CityModel('id', 'name', 'image', CountryModel('id', 'name', 'flag'))),
    PlaceModel('id', 'name', 'https://source.unsplash.com/1600x900/?varna,city', 'desc', 4, 1.1, 1.1,
        CityModel('id', 'name', 'image', CountryModel('id', 'name', 'flag'))),
    PlaceModel('id', 'name', 'https://source.unsplash.com/1600x900/?varna,city', 'desc', 4, 1.1, 1.1,
        CityModel('id', 'name', 'image', CountryModel('id', 'name', 'flag'))),
    PlaceModel('id', 'name', 'https://source.unsplash.com/1600x900/?varna,city', 'desc', 4, 1.1, 1.1,
        CityModel('id', 'name', 'image', CountryModel('id', 'name', 'flag'))),
  ];
  var routeList = [
    RouteModel('id', 'name', 'https://source.unsplash.com/1600x900/?city', CityModel('id', 'name', 'image', CountryModel('id', 'name', 'flag')), []),
    RouteModel('id', 'name', 'https://source.unsplash.com/1600x900/?city', CityModel('id', 'name', 'image', CountryModel('id', 'name', 'flag')), []),
    RouteModel('id', 'name', 'https://source.unsplash.com/1600x900/?city', CityModel('id', 'name', 'image', CountryModel('id', 'name', 'flag')), []),
    RouteModel('id', 'name', 'https://source.unsplash.com/1600x900/?city', CityModel('id', 'name', 'image', CountryModel('id', 'name', 'flag')), []),
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25.0, bottom: 5.0, top: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('salman', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  IconButton(
                      icon: Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text('Reminding'),
                            content: Text('Exit will be done.', style: TextStyle(fontSize: size.height * 0.02)),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context, 'Cancel'), child: Text('Cancel')),
                              TextButton(
                                onPressed: () {
                                  BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      })
                ],
              ),
            ),
            Container(
              height: size.height * 0.836,
              width: size.width,
              padding: EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
              ),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.center,
                // verticalDirection: VerticalDirection.down,
                // mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(child: ListTileComponent(listTileText: 'My Tours', nextScreen: MyToursScreen())),
                  Expanded(child: ListTileComponent(listTileText: 'Seen Places', nextScreen: SeenPlacesScreen())),
                  Expanded(child: ListTileComponent(listTileText: 'Seen Tours', nextScreen: SeenToursScreen())),
                  Expanded(child: ListTileComponent(listTileText: 'User Settings', nextScreen: UserSettingsScreen())),
                  Expanded(child: ListTileComponent(listTileText: 'Password Change', nextScreen: PasswordChangeScreen())),
                  Expanded(child: ListTileComponent(listTileText: 'App Settings', nextScreen: AppSettingsScreen())),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget profileRow(BuildContext context, Size size, List list, String header) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 15.0, top: 10.0, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                header,
                style: TextStyle(
                  fontSize: size.width * 0.04,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),
            ],
          ),
        ),
        Column(children: [
          SizedBox(
            height: size.height * 0.22,
            width: size.width * 1,
            child: GridView.count(
                crossAxisCount: 1,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(right: 10.0),
                childAspectRatio: 1.0,
                crossAxisSpacing: 2.0,
                mainAxisSpacing: 2.0,
                children: list.map((e) => routeItem(context, e)).toList()),
          )
        ])
      ],
    );
  }

  Widget routeItem(BuildContext context, route) {
    var size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom: 10, left: 10),
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 0.5,
            blurRadius: 10,
            offset: Offset(0, 5), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(alignment: Alignment.topCenter, children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image(
                image: NetworkImage(route.image),
                fit: BoxFit.fill,
              ),
            ),
          ]),
          Padding(
            padding: const EdgeInsets.only(top: 5.0, left: 5.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    route.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: size.width * 0.045),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
