import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_way/bloc/favourite_bloc/favourite_bloc.dart';
import 'package:my_way/bloc/favourite_bloc/favourite_event.dart';
import 'package:my_way/bloc/favourite_bloc/favourite_state.dart';
import 'package:my_way/constants.dart';
import 'package:my_way/model/place.dart';
import 'package:my_way/repositories/country_repository.dart';
import 'package:my_way/repositories/place_repository.dart';
import 'package:my_way/screens/favourite/add_route_screen.dart';
import 'package:my_way/screens/home/home_choose_city_screen/cities_screen.dart';

class FavouriteScreen extends StatefulWidget {
  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> with SingleTickerProviderStateMixin {
  FavouriteBloc _favouriteBloc;
  final placeRepository = PlaceRepository();
  final countryRepository = CountryRepository();
  List<PlaceModel> placesRouteSelect = [];
  Map<dynamic, List<PlaceModel>> sourceFavourites = {};
  List<String> showCityList = [];
  bool isOpened = false;
  AnimationController _animationController;
  Animation<double> _translateButton;
  final Curve _curve = Curves.easeInOut;
  final double _fabHeight = 56.0;

  @override
  void initState() {
    _favouriteBloc = FavouriteBloc(placeRepository: placeRepository, countryRepository: countryRepository);
    _favouriteBloc..add(GetLocalFavourites())..add(GetFavourites());
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 200))
      ..addListener(() {
        setState(() {});
      });
    _translateButton = Tween<double>(begin: _fabHeight, end: -10.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void clickTick(PlaceModel place) {
    setState(() {
      if (placesRouteSelect.firstWhere((element) => place.id == element.id, orElse: () => null) == null) {
        if (placesRouteSelect.isEmpty || placesRouteSelect.first.city.name == place.city.name) {
          placesRouteSelect.add(place);
        } else {
          _showEmptyDialog('Not added diffrent city');
        }
      } else {
        placesRouteSelect.removeWhere((element) => element.id == place.id);
      }
    });
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

  Future<void> removePlaceFavourite(BuildContext context, PlaceModel place) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Are You Sure You Want To Unfavourite?')),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('This process be remove your favourite.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _favouriteBloc.add(DeleteFavourite(placeModel: place));
                setState(() {
                  if (placesRouteSelect.firstWhere((element) => place.id == element.id, orElse: () => null) != null) {
                    placesRouteSelect.removeWhere((element) => element.id == place.id);
                  }
                });
                Navigator.of(context).pop();
              },
              child: Text('Unfavourite'),
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

  void animate() {
    if (!isOpened) {
      _animationController.forward();
      isOpened = true;
    } else {
      if (placesRouteSelect.isEmpty) {
        _showEmptyDialog('Please Select Places');
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddRouteScreen(tourPlacesList: placesRouteSelect)));
      }
    }
  }

  void reverse() {
    _animationController.reverse();
    setState(() {
      placesRouteSelect.clear();
      isOpened = false;
    });
  }

  Widget cancel() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: reverse,
        tooltip: 'Cancel',
        child: Icon(Icons.close),
      ),
    );
  }

  Future<void> _showEmptyDialog(String text) async {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.bold),
        )));
  }

  Widget add() {
    return Container(
      child: FloatingActionButton(
          backgroundColor: kPrimaryColor,
          onPressed: animate,
          tooltip: 'Add Route',
          child: Icon(isOpened ? Icons.subdirectory_arrow_right : Icons.alt_route)),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: kPrimaryColor,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Transform(
              transform: Matrix4.translationValues(
                _translateButton.value,
                0.0,
                0.0,
              ),
              child: cancel(),
            ),
            add(),
          ],
        ),
        body: BlocProvider<FavouriteBloc>(
          create: (context) => _favouriteBloc,
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, bottom: 5.0),
                  child: BlocConsumer<FavouriteBloc, FavouriteState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        if (state is FavouriteSuccess) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Favourites in ${state.country.name}',
                                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                              IconButton(
                                  icon: Image.asset(
                                    'icons/flags/png/${state.country.flag}.png',
                                    package: 'country_icons',
                                  ),
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => CitiesScreen())).then((value) {
                                      _favouriteBloc..add(GetLocalFavourites())..add(GetFavourites());
                                    });
                                  }),
                            ],
                          );
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Favourites in Country', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            IconButton(
                                icon: Icon(Icons.flag, color: Colors.white),
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
                      placesRouteSelect.isNotEmpty
                          ? Column(children: [
                              Padding(
                                padding: EdgeInsets.only(left: 17.0, bottom: 5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Selected Places',
                                      style: TextStyle(fontSize: size.width * 0.035, color: kPrimaryColor, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Column(children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                                  child: Row(
                                      children: <Widget>[Wrap(spacing: 5, children: placesRouteSelect.map((e) => selectPlacesItems(e)).toList())]),
                                )
                              ])
                            ])
                          : Column(),
                      BlocConsumer<FavouriteBloc, FavouriteState>(listener: (context, state) {
                        if (state is FavouriteSuccess) {
                          var place = state.places.places;
                          sourceFavourites = groupBy(place, (obj) => obj.city.name);
                        }
                      }, builder: (context, state) {
                        return Column(
                          children: sourceFavourites.entries.isNotEmpty
                              ? sourceFavourites.entries.map((e) => cityRow(context, size, e.value)).toList()
                              : [Text('favourite empty')],
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
    List<PlaceModel> placeModel,
  ) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 17.0, bottom: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                placeModel.first.city.name,
                style: TextStyle(
                  fontSize: size.width * 0.045,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),
              Text(
                ' (${placeModel.length.toString()})',
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
                  showCityList.contains(placeModel.first.city.name) ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  size: size.width * 0.04,
                  color: kPrimaryColor,
                ),
                onPressed: () {
                  showCity(placeModel.first.city.name);
                },
              ),
            ],
          ),
        ),
        !showCityList.contains(placeModel.first.city.name)
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
                      children: placeModel.map((e) => placeItem(context, e)).toList()),
                )
              ])
            : Column()
      ],
    );
  }

  Widget placeItem(BuildContext context, PlaceModel place) {
    var size = MediaQuery.of(context).size;
    var _tick = placesRouteSelect.firstWhere((element) => place.id == element.id, orElse: () => null);
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
          Stack(alignment: Alignment.bottomCenter, children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image(
                height: size.width * 0.3,
                image: NetworkImage(place.image),
                fit: BoxFit.fill,
              ),
            ),
            isOpened
                ? Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () => {clickTick(place)},
                      child: Container(
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(
                            _tick != null ? Icons.check : null,
                            size: size.width * 0.045,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                  )
                : Align(),
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => {removePlaceFavourite(context, place)},
                child: Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Icon(Icons.favorite, size: size.width * 0.04, color: Colors.red),
                  ),
                ),
              ),
            ),
          ]),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              place.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: size.width * 0.04),
            ),
          )
        ],
      ),
    );
  }

  Widget selectPlacesItems(PlaceModel place) {
    // var size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey[300],
      ),
      padding: EdgeInsets.only(right: 7),
      child: Row(
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            icon: Icon(
              Icons.close,
              color: kPrimaryColor,
              size: 13,
            ),
            onPressed: () {
              clickTick(place);
            },
          ),
          Text(
            place.name,
            style: TextStyle(color: kPrimaryColor, fontSize: 13),
          )
        ],
      ),
    );
  }
}
