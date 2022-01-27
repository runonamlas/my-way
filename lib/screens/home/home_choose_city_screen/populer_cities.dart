import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_way/bloc/city_bloc/city_bloc.dart';
import 'package:my_way/bloc/city_bloc/city_event.dart';
import 'package:my_way/constants.dart';
import 'package:my_way/model/city.dart';
import 'package:my_way/screens/home/home_splash_screen/home_screen.dart';

class PopulerCities extends StatefulWidget {
  final List<CityModel> cityModel;
  PopulerCities({Key key, @required this.cityModel}) : super(key: key);
  @override
  _PopulerCitiesState createState() => _PopulerCitiesState(cityModel);
}

class _PopulerCitiesState extends State<PopulerCities>
    with AutomaticKeepAliveClientMixin {
  final List<CityModel> cityModel;
  _PopulerCitiesState(this.cityModel);

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    cityModel.sort((a, b) => a.id.compareTo(b.id));
    super.build(context);
    return GridView.count(
        crossAxisCount: 1,
        padding: EdgeInsets.only(bottom: 8.0),
        childAspectRatio: 1.9,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        children: cityModel.map((e) => myGridItems(e)).toList());
  }

  Widget myGridItems(CityModel city) {
    final blocCity = BlocProvider.of<CityBloc>(context);
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [Colors.black87, Colors.black87],
        begin: Alignment.centerLeft,
        end: Alignment(1.0, 1.0),
      )),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              blocCity.add(CitySelect(city: city));
              Navigator.of(context).pop();
            },
            child: Opacity(
              opacity: 0.8,
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(city.image), fit: BoxFit.fill)),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    city.name,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: deviceWidth * 0.08,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
