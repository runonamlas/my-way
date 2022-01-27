import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_way/bloc/favourite_bloc/favourite_bloc.dart';
import 'package:my_way/bloc/favourite_bloc/favourite_event.dart';
import 'package:my_way/bloc/favourite_bloc/favourite_state.dart';
import 'package:my_way/bloc/place_bloc/place.dart';
import 'package:my_way/components/build_loading_widget.dart';
import 'package:my_way/components/search_textfield.dart';
import 'package:my_way/constants.dart';
import 'package:my_way/components/star_display.dart';
import 'package:my_way/repositories/country_repository.dart';
import 'package:my_way/repositories/place_repository.dart';
import 'package:my_way/screens/home/place_detail_screen.dart';
import 'package:my_way/model/place.dart';

class AllPopulerDestinations extends StatefulWidget {
  @override
  _AllPopulerDestinationsState createState() => _AllPopulerDestinationsState();
}

class _AllPopulerDestinationsState extends State<AllPopulerDestinations> {
  FavouriteBloc _favouriteBloc;
  PlaceBloc _placeBloc;
  final placeRepository = PlaceRepository();
  final countryRepository = CountryRepository();
  List<PlaceModel> favouritesPlaceList = [];

  @override
  void initState() {
    _favouriteBloc = FavouriteBloc(placeRepository: placeRepository, countryRepository: countryRepository);
    _favouriteBloc.add(GetFavourites());
    _placeBloc = PlaceBloc(placeRepository: placeRepository);
    _placeBloc.add(GetPlaces());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return MultiBlocProvider(
      providers: [BlocProvider<PlaceBloc>(create: (context) => _placeBloc), BlocProvider<FavouriteBloc>(create: (context) => _favouriteBloc)],
      child: Scaffold(
          backgroundColor: kPrimaryColor,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(size.height * 0.07),
            child: AppBar(
              titleSpacing: -5.0,
              //automaticallyImplyLeading: false,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.pop(context),
              ),
              brightness: Brightness.dark,
              elevation: 0.0,
              title: SearchTextField(
                description: 'Search place',
                fontSize: size.width * 0.04,
              ),
            ),
          ),
          body: BlocConsumer<PlaceBloc, PlaceState>(
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
                    return Column(
                      children: [
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.only(top: 10.0),
                          decoration: BoxDecoration(
                              color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
                          child: GridView.count(
                            crossAxisCount: 2,
                            padding: EdgeInsets.all(4.0),
                            childAspectRatio: 1.0,
                            crossAxisSpacing: 2.0,
                            mainAxisSpacing: 2.0,
                            children: place.map((e) => populerDestinationsItems(e)).toList(),
                          ),
                        )),
                      ],
                    );
                  },
                );
              }
              return buildLoadingWidget();
            },
          )),
    );
  }

  Widget populerDestinationsItems(PlaceModel place) {
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
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image(
                      image: NetworkImage(place.image),
                      height: size.height * 0.21,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Align(
                    alignment: Alignment(1.0, -1.0),
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
            ),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, left: 4.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        place.name,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: size.width * 0.04),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, left: 4.0),
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
                  )
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
