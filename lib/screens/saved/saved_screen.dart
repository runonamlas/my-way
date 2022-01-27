import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_way/bloc/route_bloc/route.dart';
import 'package:my_way/constants.dart';
import 'package:my_way/model/route.dart';
import 'package:my_way/repositories/country_repository.dart';
import 'package:my_way/repositories/route_repository.dart';
import 'package:my_way/screens/home/home_choose_city_screen/cities_screen.dart';
import 'package:my_way/screens/home/home_tour_screen/tour_list_screen.dart';

class SavedScreen extends StatefulWidget {
  @override
  _SavedScreenState createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> with SingleTickerProviderStateMixin {
  RouteBloc _routeBloc;
  final routeRepository = RouteRepository();
  final countryRepository = CountryRepository();
  Map<dynamic, List<RouteModel>> sourceRoutes = {};
  List<String> showCityList = [];
  bool isOpened = false;

  @override
  void initState() {
    _routeBloc = RouteBloc(routeRepository: routeRepository, countryRepository: countryRepository);
    _routeBloc..add(GetLocalSavedRoutes())..add(GetSavedRoutes());
    super.initState();
  }

  void showCity(String name) {
    setState(() {
      if (!showCityList.contains(name)) {
        showCityList.add(name);
      } else {
        showCityList.remove(name);
      }
    });
  }

  Future<void> removeRouteSaves(BuildContext context, RouteModel route) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Are You Sure You Want To Unsave?')),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('This process be remove your saved.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _routeBloc.add(DeleteSaved(routeModel: route));
                Navigator.of(context).pop();
              },
              child: Text('Unsave'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: kPrimaryColor,
        body: BlocProvider<RouteBloc>(
          create: (context) => _routeBloc,
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, bottom: 5.0),
                  child: BlocConsumer<RouteBloc, RouteState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        if (state is SavedRoutesSuccess) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Saved in ${state.country.name}',
                                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                              IconButton(
                                  icon: Image.asset(
                                    'icons/flags/png/${state.country.flag}.png',
                                    package: 'country_icons',
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CitiesScreen()))
                                        .then((value) {
                                        _routeBloc..add(GetLocalSavedRoutes())..add(GetSavedRoutes());
                                    });
                                  }),
                            ],
                          );
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Saved in Country', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            IconButton(
                                icon: Icon(
                                  Icons.flag,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => CitiesScreen()));
                                }),
                          ],
                        );
                      }),
                ),
                Container(
                  height: size.height * 0.836,
                  width: size.width,
                  padding: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
                  ),
                  child: Column(
                    children: [
                      BlocConsumer<RouteBloc, RouteState>(listener: (context, state) {
                        if (state is SavedRoutesSuccess) {
                          var route = state.routes.routes;
                          sourceRoutes = groupBy(route, (obj) => obj.city.name);
                        }
                      }, builder: (context, state) {
                        return Column(
                          children: sourceRoutes.entries.isNotEmpty
                              ? sourceRoutes.entries.map((e) => cityRow(context, size, e.value)).toList()
                              : [Text('saved empty')],
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget cityRow(
    BuildContext context,
    Size size,
    List<RouteModel> routeModel,
  ) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16.0, bottom: 8.0, top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                routeModel.first.city.name,
                style: TextStyle(
                  fontSize: size.width * 0.045,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),
              Text(
                ' (${routeModel.length.toString()})',
                style: TextStyle(
                  fontSize: size.width * 0.04,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                icon: Icon(
                  showCityList.contains(routeModel.first.city.name) ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  size: size.width * 0.04,
                  color: kPrimaryColor,
                ),
                onPressed: () {
                  showCity(routeModel.first.city.name);
                },
              ),
            ],
          ),
        ),
        !showCityList.contains(routeModel.first.city.name)
            ? Column(children: [
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
                      children: routeModel.map((e) => routeItem(context, e)).toList()),
                )
              ])
            : Column()
      ],
    );
  }

  Widget routeItem(BuildContext context, RouteModel route) {
    var size = MediaQuery.of(context).size;
    return Card(
      margin: EdgeInsets.only(left: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5.0,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            gradient: LinearGradient(
              colors: [Colors.black87, Colors.black87],
              begin: Alignment.centerLeft,
              end: Alignment(1.0, 1.0),
            )),
        child: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => TourListScreen(tourName: route.name, tourPlaces: route.places)));
          },
          child: Stack(children: <Widget>[
            Opacity(
              opacity: 0.7,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0), image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(route.image))),
              ),
            ),
            Center(
              child: Text(
                route.name,
                style: TextStyle(color: Colors.white, fontSize: size.width * 0.06, fontFamily: 'yesteryear-regular', letterSpacing: 1.0),
              ),
            ),
            Align(
              alignment: Alignment(1.0, -1.15),
              child: Padding(
                padding: EdgeInsets.only(right: 12.0),
                child: GestureDetector(
                  onTap: () => {removeRouteSaves(context, route)},
                  child: Container(
                      height: size.height * 0.05,
                      width: size.width * 0.045,
                      child: Icon(
                        IconData(
                          0xe900,
                          fontFamily: 'bookmark',
                        ),
                        color: Color(0xFFF8CF60),
                        size: size.height * 0.04,
                      )),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
