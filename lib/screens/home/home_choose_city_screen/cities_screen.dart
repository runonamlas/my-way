import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_way/bloc/city_bloc/city.dart';
import 'package:my_way/components/build_loading_widget.dart';
import 'package:my_way/components/search_textfield.dart';
import 'package:my_way/constants.dart';
import 'package:my_way/model/city.dart';
import 'package:my_way/model/country.dart';
import 'package:my_way/repositories/city_repository.dart';
import 'package:my_way/repositories/country_repository.dart';
import 'package:my_way/screens/home/home_choose_city_screen/all_cities.dart';
import 'package:my_way/screens/home/home_choose_city_screen/populer_cities.dart';
import 'package:my_way/screens/home/home_choose_city_screen/country_screen.dart';

class CitiesScreen extends StatefulWidget {
  @override
  _CitiesScreenState createState() => _CitiesScreenState();
}

class _CitiesScreenState extends State<CitiesScreen> {
  final cityRepository = CityRepository();
  final countryRepository = CountryRepository();
  TextEditingController editingController = TextEditingController();
  TextEditingController editingCountryController = TextEditingController();
  List<CityModel> citySearchResult = [];
  List<CityModel> cityList = [];
  List<CountryModel> countrySearchResult = [];
  List<CountryModel> countryList = [];
  bool citySearchKey = true;
  bool countrySearchKey = true;
  bool clicked = false;

  void filterCitySearchResults(String query, List<CityModel> list) {
    query = query.toLowerCase();
    setState(() {
      citySearchKey = false;
    });
    var dummySearchList = <CityModel>[];
    dummySearchList.addAll(list);
    if (query.isNotEmpty) {
      var dummyListData = <CityModel>[];
      dummySearchList.forEach((element) {
        if (element.name.toLowerCase().contains(query)) {
          dummyListData.add(element);
        }
      });
      setState(() {
        citySearchResult.clear();
        citySearchResult.addAll(dummyListData);
      });
      return;
    }
    setState(() {
      citySearchResult.clear();
      citySearchKey = true;
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) {
        return CityBloc(
            cityRepository: cityRepository,
            countryRepository: countryRepository)
          ..add(GetCities());
      },
      child: DefaultTabController(
          length: 2,
          child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(size.height * 0.13),
                child: AppBar(
                  titleSpacing: 5.5,
                  brightness: Brightness.dark,
                  actions: [
                    BlocConsumer<CityBloc, CityState>(
                        listener: (context, state) {},
                        builder: (context, state) {
                          if (state is CitySuccess) {
                            return IconButton(
                                icon: Image.asset(
                                  'icons/flags/png/${state.country.flag}.png',
                                  package: 'country_icons',
                                ),
                                onPressed: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (_) => BlocProvider.value(
                                                value:
                                                    BlocProvider.of<CityBloc>(
                                                        context),
                                                child: CountryScreen(),
                                              )))
                                      .then((value) {
                                    BlocProvider.of<CityBloc>(context)
                                        .add(GetCities());
                                  });
                                });
                          }
                          return buildLoadingWidget();
                        }),
                  ],
                  backgroundColor: kPrimaryColor,
                  title: BlocConsumer<CityBloc, CityState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      if (state is CitySuccess) {
                        return SearchTextField(
                          description: 'Where do you want to go?',
                          controller: editingController,
                          changed: (value) {
                            filterCitySearchResults(value, state.cities.cities);
                          },
                        );
                      }
                      return buildLoadingWidget();
                    },
                  ),
                  bottom: TabBar(
                    indicatorWeight: 4.0,
                    indicatorColor: Colors.white,
                    onTap: (index) {
                      // setState(() {});
                    },
                    tabs: [
                      Tab(
                        child: Container(
                            child: Text(
                          'Populer cities',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size.width * 0.04,
                          ),
                        )),
                      ),
                      Tab(
                        child: Container(
                            child: Text(
                          'All cities',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size.width * 0.04,
                          ),
                        )),
                      )
                    ],
                  ),
                ),
              ),
              body: citySearchKey
                  ? BlocConsumer<CityBloc, CityState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        if (state is CitySuccess) {
                          var cities = state.cities.cities;
                          return TabBarView(
                            children: [
                              PopulerCities(cityModel: cities),
                              AllCities(cityModel: cities),
                            ],
                          );
                        }
                        return buildLoadingWidget();
                      },
                    )
                  : citySearchResult.isNotEmpty
                      ? PopulerCities(cityModel: citySearchResult)
                      : Scaffold(
                          body: Text('sonuç yok'),
                        ))),
    );
  }
}
