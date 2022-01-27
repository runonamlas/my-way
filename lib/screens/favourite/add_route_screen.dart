import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_way/bloc/route_bloc/route.dart';
import 'package:my_way/components/star_display.dart';
import 'package:my_way/constants.dart';
import 'package:my_way/model/place.dart';
import 'package:my_way/repositories/country_repository.dart';
import 'package:my_way/repositories/route_repository.dart';
import 'package:my_way/screens/home/home_tour_screen/tour_list_screen.dart';

class AddRouteScreen extends StatefulWidget {
  List<PlaceModel> tourPlacesList;
  AddRouteScreen({@required this.tourPlacesList, key}) : super(key: key);

  @override
  _AddRouteScreenState createState() => _AddRouteScreenState(tourPlacesList);
}

class _AddRouteScreenState extends State<AddRouteScreen> {
  TextEditingController nameController = TextEditingController();
  _AddRouteScreenState(this.tourPlacesList);
  List<PlaceModel> tourPlacesList;
  RouteBloc _routeBloc;
  final routeRepository = RouteRepository();
  final countryRepository = CountryRepository();

  @override
  void initState() {
    _routeBloc = RouteBloc(
        routeRepository: routeRepository, countryRepository: countryRepository);
    super.initState();
  }

  Future<void> _showEmptyDialog(String text) async {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.bold),
        )));
  }

  void deletePlace(PlaceModel place) {
    setState(() {
      tourPlacesList.removeWhere((element) => element.id == place.id);
    });
  }

  void createRoute() {
    _routeBloc.add(
        CreateRoutes(routeName: nameController.text, places: tourPlacesList));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocProvider<RouteBloc>(
      create: (context) => _routeBloc,
      child: BlocConsumer<RouteBloc, RouteState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is CreateRouteSuccess) {
            print('createroute');
            _showEmptyDialog('sasasa');
          }
          return Scaffold(
              backgroundColor: kPrimaryColor,
              body: SafeArea(
                  child: SingleChildScrollView(
                child: Column(children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 15.0, bottom: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            color: Colors.white,
                            icon: Icon(Icons.arrow_back_ios),
                          ),
                          Text('Create Route',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ],
                      )),
                  Container(
                      height: size.height * 0.95,
                      width: size.width,
                      padding: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0)),
                      ),
                      child: Column(
                        children: [
                          Flexible(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: TextField(
                                decoration: InputDecoration(
                                  fillColor: kPrimaryColor.withOpacity(0.3),
                                  filled: true,
                                  hintText: 'Tour Name',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 2.0)),
                                  labelStyle: TextStyle(color: Colors.red),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0.0, horizontal: 10.0),
                                ),
                                style: TextStyle(fontSize: size.width * 0.04),
                                controller: nameController,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: size.height * 0.54,
                            child: GridView.count(
                              crossAxisCount: 2,
                              children: tourPlacesList
                                  .map((e) => placeItem(e))
                                  .toList(),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                      width: size.width * 0.45,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border:
                                              Border.all(color: kPrimaryColor),
                                          color: Colors.white),
                                      child: TextButton(
                                        onPressed: () =>
                                            {Navigator.pop(context)},
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(
                                              color: kPrimaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      )),
                                  Container(
                                      width: size.width * 0.45,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: kPrimaryColor),
                                      child: TextButton(
                                        onPressed: () => {
                                          if (tourPlacesList.isEmpty)
                                            {
                                              _showEmptyDialog(
                                                  'Not Selected Places'),
                                              Navigator.pop(context)
                                            }
                                          else
                                            {
                                              if (nameController.text.isEmpty)
                                                {
                                                  _showEmptyDialog(
                                                      'Please Route Name Write')
                                                }
                                              else
                                                {
                                                  createRoute(),
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              TourListScreen(
                                                                tourName:
                                                                    nameController
                                                                        .text
                                                                        .toString(),
                                                                tourMinute:
                                                                    '10',
                                                                tourPlaces:
                                                                    tourPlacesList,
                                                              )))
                                                }
                                            }
                                        },
                                        child: Text(
                                          'Create',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          )
                        ],
                      ))
                ]),
              )));
        },
      ),
    );
  }

  Widget placeItem(PlaceModel place) {
    var size = MediaQuery.of(context).size;
    return Card(
      margin: EdgeInsets.all(10),
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
                  height: size.height * 0.2,
                  image: NetworkImage(place.image),
                  fit: BoxFit.fill,
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text('Atention'),
                        content: Text('You will remove the selected place!',
                            style: TextStyle(fontSize: size.height * 0.02)),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: Text('Cancel')),
                          TextButton(
                            onPressed: () {
                              deletePlace(place);
                              Navigator.pop(context, 'OK');
                            },
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Icon(
                        Icons.cancel,
                        size: size.width * 0.045,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 4.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      place.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: size.width * 0.04),
                    ),
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
