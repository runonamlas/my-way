import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_way/components/build_loading_widget.dart';
import 'package:my_way/constants.dart';
import 'package:my_way/bloc/route_bloc/route.dart';
import 'package:my_way/model/route.dart';
import 'package:my_way/repositories/country_repository.dart';
import 'package:my_way/repositories/route_repository.dart';
import 'package:my_way/screens/home/home_tour_screen/tour_list_screen.dart';
import 'package:my_way/bloc/route_bloc/route_bloc.dart';

class ToursScreen extends StatefulWidget {
  @override
  _ToursScreenState createState() => _ToursScreenState();
}

class _ToursScreenState extends State<ToursScreen> {
  final routeRepository = RouteRepository();
  final countryRepository = CountryRepository();
  List<RouteModel> savedRoutesList = [];
  RouteBloc _routeBloc;
  @override
  void initState() {
    _routeBloc = RouteBloc(routeRepository: routeRepository, countryRepository: countryRepository);
    _routeBloc..add(GetSavedRoutes())..add(GetRoutes());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => _routeBloc,
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(deviceHeight * 0.06),
            child: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                'Tours',
                style: TextStyle(fontSize: deviceHeight * 0.024),
              ),
              brightness: Brightness.dark,
            ),
          ),
          body: BlocConsumer<RouteBloc, RouteState>(listener: (context, state) {
            if (state is SavedRoutesSuccess) {
              savedRoutesList.clear();
              savedRoutesList.addAll(state.routes.routes);
            }
          }, builder: (context, state) {
            if (state is RouteSuccess) {
              var route = state.routes.routes;
              return GridView.count(
                  crossAxisCount: 1,
                  padding: EdgeInsets.only(bottom: 8.0),
                  childAspectRatio: 2,
                  mainAxisSpacing: 5.0,
                  children: route.map((e) => tourItems(e)).toList());
            }
            return buildLoadingWidget();
          })),
    );
  }

  Widget tourItems(RouteModel route) {
    var isSaved = savedRoutesList.firstWhere((element) => route.id == element.id, orElse: () => null) != null ? true : false;

    return GestureDetector(
      onTap: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => TourListScreen(
                    tourName: route.name,
                    tourPlaces: route.places,
                  ))),
      child: Card(
          elevation: 5.0,
          child: Stack(
            children: [
              Container(
                height: deviceHeight * 0.22,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black87, Colors.black87],
                    begin: Alignment.centerLeft,
                    end: Alignment(1.0, 1.0),
                  ),
                ),
                child: Opacity(
                  opacity: 0.7,
                  child: Container(
                    decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(route.image), fit: BoxFit.fill)),
                  ),
                ),
              ),
              Align(
                alignment: Alignment(1.0, -1.12),
                child: Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: GestureDetector(
                    onTap: () {
                      if (isSaved) {
                        _routeBloc.add(DeleteSaved(routeModel: route));
                        savedRoutesList.removeWhere((element) => element.id == route.id);
                        _routeBloc.add(GetRoutes());
                      } else {
                        _routeBloc.add(AddSaved(routeModel: route));
                        if (savedRoutesList.firstWhere((element) => route.id == element.id, orElse: () => null) == null) {
                          savedRoutesList.add(route);
                        }
                        _routeBloc.add(GetRoutes());
                      }
                    },
                    child: Container(
                      height: deviceHeight * 0.05,
                      width: deviceWidth * 0.045,
                      child: savedRoutesList.firstWhere((element) => route.id == element.id, orElse: () => null) != null
                          ? Icon(
                              IconData(
                                0xe900,
                                fontFamily: 'bookmark',
                              ),
                              color: Color(0xFFF8CF60),
                              size: deviceHeight * 0.04,
                            )
                          : Icon(
                              IconData(
                                0xe901,
                                fontFamily: 'bookmark-outline',
                              ),
                              color: Colors.white,
                              size: deviceHeight * 0.04,
                            ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        route.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontFamily: 'yesteryear-regular', color: Colors.white, fontSize: deviceHeight * 0.045, letterSpacing: 1.1),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black12.withOpacity(0.3),
                        ),
                        child: Text(
                          '${route.places.map((e) => e.name)}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: deviceHeight * 0.02),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ' dk',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: deviceHeight * 0.02),
                      ),
                      Text('${route.places.length} routes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: deviceHeight * 0.02)),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
