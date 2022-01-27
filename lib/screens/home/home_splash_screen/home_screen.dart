import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_way/bloc/favourite_bloc/favourite_bloc.dart';
import 'package:my_way/bloc/favourite_bloc/favourite_event.dart';
import 'package:my_way/bloc/favourite_bloc/favourite_state.dart';
import 'package:my_way/bloc/route_bloc/route.dart';
import 'package:my_way/components/build_loading_widget.dart';
import 'package:my_way/components/star_display.dart';
import 'package:my_way/constants.dart';
import 'package:my_way/components/search_textfield.dart';
import 'package:my_way/components/home_component/home_history_component.dart';
import 'package:my_way/model/place.dart';
import 'package:my_way/repositories/country_repository.dart';
import 'package:my_way/repositories/place_repository.dart';
import 'package:my_way/model/city.dart';
import 'package:my_way/screens/home/all_populer_destinations.dart';
import 'package:my_way/screens/home/home_tour_screen/tour_list_screen.dart';
import 'package:my_way/screens/home/home_choose_city_screen/cities_screen.dart';
import 'package:my_way/screens/home/place_detail_screen.dart';
import 'package:my_way/bloc/place_bloc/place.dart';
import 'package:my_way/model/route.dart';
import 'package:my_way/screens/home/home_tour_screen/tours_screen.dart';
import 'package:my_way/bloc/route_bloc/route_bloc.dart';
import 'package:my_way/repositories/route_repository.dart';

class HomeScreen extends StatefulWidget {
  final CityModel city;
  final RouteModel route;
  final PlaceModel place;
  final bool isFavourite;
  HomeScreen({this.city, this.route, this.place, this.isFavourite});
  @override
  _HomeScreenState createState() => _HomeScreenState(place, isFavourite);
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  _HomeScreenState(this.place, this.isFavourite);
  PlaceModel place;
  bool isFavourite = false;
  final placeRepository = PlaceRepository();
  final routeRepository = RouteRepository();
  final countryRepository = CountryRepository();
  FavouriteBloc _favouriteBloc;
  RouteBloc _routeBloc;
  PlaceBloc _placeBloc;
  List<PlaceModel> favouritesPlaceList = [];
  List<RouteModel> savedRoutesList = [];

  @override
  // implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _favouriteBloc = FavouriteBloc(placeRepository: placeRepository, countryRepository: countryRepository);
    _favouriteBloc.add(GetFavourites());
    _routeBloc = RouteBloc(routeRepository: routeRepository, countryRepository: countryRepository);
    _routeBloc..add(GetSavedRoutes())..add(GetRoutes());
    _placeBloc = PlaceBloc(placeRepository: placeRepository);
    _placeBloc.add(GetPlaces());
    super.initState();
  }

  // Future<bool> isHere(PlaceModel place) {
  //   setState(() {
  //     if (favouritesPlaceList.firstWhere((element) => place.id == element.id,
  //             orElse: () => null) ==
  //         null) {
  //       return false;
  //     }else{
  //       favouritesPlaceList.removeWhere((element) => element.id == place.id);
  //     }
  //   });
  //   return ;
  // }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var size = MediaQuery.of(context).size;
    return MultiBlocProvider(
      providers: [
        BlocProvider<PlaceBloc>(create: (context) => _placeBloc),
        BlocProvider<RouteBloc>(lazy: false, create: (context) => _routeBloc),
        BlocProvider<FavouriteBloc>(create: (context) => _favouriteBloc)
      ],
      child: Scaffold(
          backgroundColor: kPrimaryColor,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SearchTextField(
                      description: 'Search',
                      fontSize: size.width * 0.04,
                      iconButton: IconButton(
                          icon: Icon(
                            Icons.location_city,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CitiesScreen())).then((value) {
                              _favouriteBloc.add(GetFavourites());
                              _routeBloc..add(GetSavedRoutes())..add(GetRoutes());
                              _placeBloc.add(GetPlaces());
                            });
                          }),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.12,
                    child: ListView(
                      padding: EdgeInsets.only(left: 8.0, top: 8.0),
                      scrollDirection: Axis.horizontal,
                      children: [
                        HistoryComponent(
                          historyIcon: IconData(0xe900, fontFamily: 'museum'),
                          historyName: 'Museums',
                        ),
                        HistoryComponent(
                          historyIcon: IconData(0xe900, fontFamily: 'museum'),
                          historyName: 'Park',
                        ),
                        HistoryComponent(
                          historyIcon: IconData(0xe900, fontFamily: 'museum'),
                          historyName: 'Church',
                        ),
                        HistoryComponent(
                          historyIcon: IconData(0xe900, fontFamily: 'museum'),
                          historyName: 'Bridge',
                        ),
                        HistoryComponent(
                          historyIcon: IconData(0xe900, fontFamily: 'museum'),
                          historyName: 'Forest',
                        ),
                        HistoryComponent(
                          historyIcon: IconData(0xe900, fontFamily: 'museum'),
                          historyName: 'Museums',
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: size.height * 0.73,
                    decoration: BoxDecoration(
                        color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
                    child: Column(
                      children: [
                        Expanded(
                            child: Column(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 16.0, top: 8.0, right: 16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Populer places',
                                      style: TextStyle(fontSize: size.width * 0.045, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => AllPopulerDestinations()));
                                      },
                                      child: Text(
                                        'See All',
                                        style: TextStyle(
                                            fontSize: size.width * 0.04, fontWeight: FontWeight.bold, color: Color(0xFFF8CF60), letterSpacing: 1.0),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            BlocConsumer<PlaceBloc, PlaceState>(
                                listener: (context, state) {},
                                builder: (context, state) {
                                  if (state is PlaceSuccess) {
                                    var place = state.places.places;
                                    return BlocConsumer<FavouriteBloc, FavouriteState>(
                                      listener: (context, state) {},
                                      builder: (context, state) {
                                        if (state is FavouriteSuccess) {
                                          favouritesPlaceList.clear();
                                          favouritesPlaceList.addAll(state.places.places);
                                        }
                                        return Expanded(
                                          flex: 5,
                                          child: SizedBox(
                                              width: size.width * 1,
                                              child: GridView.count(
                                                  crossAxisCount: 1,
                                                  scrollDirection: Axis.horizontal,
                                                  padding: EdgeInsets.all(4.0),
                                                  childAspectRatio: 1.0,
                                                  crossAxisSpacing: 2.0,
                                                  mainAxisSpacing: 2.0,
                                                  children: place.map((e) => populerPlacesItems(e)).toList())
                                              // favouritesPlaceList.isNotEmpty
                                              //     ? place.map((e) => populerPlacesItems(e)).toList()
                                              //     : [Text('No favourite place ')]),
                                              ),
                                        );
                                      },
                                    );
                                  }
                                  return buildLoadingWidget();
                                })
                          ],
                        )),
                        Expanded(
                            child: Column(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Populer tours',
                                      style: TextStyle(fontSize: size.width * 0.045, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => ToursScreen()));
                                      },
                                      child: Text(
                                        'See All',
                                        style: TextStyle(
                                            fontSize: size.width * 0.04, fontWeight: FontWeight.bold, color: Color(0xFFF8CF60), letterSpacing: 1.0),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            BlocConsumer<RouteBloc, RouteState>(listener: (context, state) {
                              if (state is SavedRoutesSuccess) {
                                savedRoutesList.clear();
                                savedRoutesList.addAll(state.routes.routes);
                              }
                            }, builder: (context, state) {
                              if (state is RouteSuccess) {
                                var route = state.routes.routes;
                                return Expanded(
                                  flex: 5,
                                  child: SizedBox(
                                    width: size.width * 1,
                                    child: GridView.count(
                                        crossAxisCount: 1,
                                        scrollDirection: Axis.horizontal,
                                        padding: EdgeInsets.all(4.0),
                                        childAspectRatio: 1.0,
                                        crossAxisSpacing: 2.0,
                                        mainAxisSpacing: 2.0,
                                        children: route.map((e) => populerToursItems(e)).toList()
                                        //savedRoutesList.isNotEmpty ? route.map((e) => populerToursItems(e)).toList() : [Text('favourite empty')],
                                        ),
                                  ),
                                );
                              }
                              return buildLoadingWidget();
                            }),
                          ],
                        )),
                        SizedBox(
                          height: size.height * 0.038,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget populerPlacesItems(PlaceModel place) {
    var size = MediaQuery.of(context).size;
    var isFavourite = favouritesPlaceList.firstWhere((element) => place.id == element.id, orElse: () => null) != null ? true : false;

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PlaceDetailScreen(
                      place: place,
                      isFavourite: isFavourite,
                    )));
      },
      child: (Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5.0,
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image(
                    height: size.height * 0.20,
                    image: NetworkImage(place.image),
                    fit: BoxFit.fill,
                  ),
                ),
                Align(
                  alignment: Alignment(1.0, 0.0),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () => {
                        if (isFavourite)
                          {
                            _favouriteBloc.add(DeleteFavourite(placeModel: place)),
                            favouritesPlaceList.removeWhere((element) => element.id == place.id)
                          }
                        else
                          {
                            _favouriteBloc.add(AddFavourite(placeModel: place)),
                            if (favouritesPlaceList.firstWhere((element) => place.id == element.id, orElse: () => null) == null)
                              {favouritesPlaceList.add(place)}
                          }
                      },
                      child: CircleAvatar(
                          backgroundColor: Colors.white,
                          maxRadius: 14.0,
                          foregroundColor: Colors.red,
                          child: favouritesPlaceList.firstWhere((element) => place.id == element.id, orElse: () => null) != null
                              ? Icon(
                                  IconData(0xe900, fontFamily: 'heart'),
                                  size: size.width * 0.04,
                                )
                              : Icon(
                                  IconData(0xe900, fontFamily: 'heart-outline'),
                                  size: size.width * 0.04,
                                )),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0, left: 4.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        place.name,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: size.width * 0.04),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0, left: 4.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: IconTheme(
                        data: IconThemeData(
                          color: Colors.amber,
                          size: size.width * 0.035,
                        ),
                        child: StarDisplay(value: place.star, value2: 37.555),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }

  Widget populerToursItems(RouteModel route) {
    var size = MediaQuery.of(context).size;
    var isSaved = savedRoutesList.firstWhere((element) => route.id == element.id, orElse: () => null) != null ? true : false;
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Card(
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
          child: Stack(
            children: [
              Opacity(
                opacity: 0.7,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0), image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(route.image))),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        route.name,
                        style: TextStyle(color: Colors.white, fontSize: size.width * 0.06, fontFamily: 'yesteryear-regular', letterSpacing: 1.0),
                      ),
                    ],
                  )
                ],
              ),
              Align(
                  alignment: Alignment(1, -1.12),
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
                        height: size.height * 0.05,
                        width: size.width * 0.045,
                        child: savedRoutesList.firstWhere((element) => route.id == element.id, orElse: () => null) != null
                            ? Icon(
                                IconData(
                                  0xe900,
                                  fontFamily: 'bookmark',
                                ),
                                color: Color(0xFFF8CF60),
                                size: size.height * 0.04,
                              )
                            : Icon(
                                IconData(
                                  0xe901,
                                  fontFamily: 'bookmark-outline',
                                ),
                                color: Colors.white,
                                size: size.height * 0.04,
                              ),
                      ),
                    ),
                  )),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '45 dk',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: deviceHeight * 0.02, color: Colors.white),
                      ),
                      Text('${route.places.length} routes',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: deviceHeight * 0.02, color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
