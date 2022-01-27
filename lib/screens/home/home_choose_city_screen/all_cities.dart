import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_way/bloc/city_bloc/city_bloc.dart';
import 'package:my_way/bloc/city_bloc/city_event.dart';
import 'package:my_way/model/city.dart';
import 'package:my_way/screens/home/home_splash_screen/home_screen.dart';

class AllCities extends StatefulWidget {
  final List<CityModel> cityModel;
  AllCities({Key key, @required this.cityModel}) : super(key: key);
  @override
  _AllCitiesState createState() => _AllCitiesState(cityModel);
}

class _AllCitiesState extends State<AllCities>
    with AutomaticKeepAliveClientMixin {
  final List<CityModel> cityModel;
  _AllCitiesState(this.cityModel);

  @override
  Widget build(BuildContext context) {
    cityModel
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    super.build(context);
    return GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(4.0),
        childAspectRatio: 1.0,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        children: cityModel.map((e) => myGridItems(e)).toList());
  }

  Widget myGridItems(CityModel city) {
    final blocCity = BlocProvider.of<CityBloc>(context);
    var size = MediaQuery.of(context).size;
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
                        fontSize: size.width * 0.06,
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
  bool get wantKeepAlive =>
      true; //geri geldiğinde eski bırakılan yerin gözükmesini sağlar.
}
