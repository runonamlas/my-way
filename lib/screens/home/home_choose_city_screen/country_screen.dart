import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_way/bloc/city_bloc/city.dart';
import 'package:my_way/components/build_loading_widget.dart';
import 'package:my_way/components/search_textfield.dart';
import 'package:my_way/model/country.dart';
import 'package:my_way/repositories/city_repository.dart';
import 'package:my_way/repositories/country_repository.dart';

class CountryScreen extends StatefulWidget {
  @override
  _CountryScreenState createState() => _CountryScreenState();
}

class _CountryScreenState extends State<CountryScreen> {
  final cityRepository = CityRepository();
  final countryRepository = CountryRepository();
  TextEditingController editingController = TextEditingController();
  TextEditingController editingCountryController = TextEditingController();
  List<CountryModel> countrySearchResult = [];
  List<CountryModel> countryList = [];
  bool countrySearchKey = true;

  void filterCountrySearchResults(String query, List<CountryModel> list) {
    query = query.toLowerCase();
    setState(() {
      countrySearchKey = false;
    });
    var dummySearchList = <CountryModel>[];
    dummySearchList.addAll(list);
    if (query.isNotEmpty) {
      var dummyListData = <CountryModel>[];
      dummySearchList.forEach((element) {
        if (element.name.toLowerCase().contains(query)) {
          dummyListData.add(element);
        }
      });
      setState(() {
        countrySearchResult.clear();
        countrySearchResult.addAll(dummyListData);
      });
      return;
    }
    setState(() {
      countrySearchResult.clear();
      countrySearchKey = true;
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    final blocCity = BlocProvider.of<CityBloc>(context);
    return BlocProvider.value(
      value: blocCity..add(GetCountries()),
      child: BlocConsumer<CityBloc, CityState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is CountrySuccess) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                titleSpacing: 1.5,
                brightness: Brightness.dark,
                title: SearchTextField(
                  description: 'Change country',
                  controller: editingCountryController,
                  changed: (value) {
                    filterCountrySearchResults(value, state.countries.countries);
                  },
                  iconButton: IconButton(
                    icon: Image.asset(
                      'icons/flags/png/${state.localCountry.flag}.png',
                      package: 'country_icons',
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
              body: countrySearchKey
                  ? ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      itemCount: state.countries.countries.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
                          child: Card(
                            elevation: 10,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              onTap: () {
                                blocCity.add(CountrySelect(country: state.countries.countries[index]));
                                blocCity.add(CountryChanged());
                                Navigator.of(context).pop();
                              },
                              title: Text(
                                state.countries.countries[index].name,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              leading: IconButton(
                                icon: Image.asset(
                                  'icons/flags/png/${state.countries.countries[index].flag}.png',
                                  package: 'country_icons',
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : countrySearchResult.isNotEmpty
                      ? ListView.builder(
                          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                          itemCount: countrySearchResult.length,
                          itemBuilder: (contextl, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
                              child: Card(
                                color: Colors.white.withOpacity(0.7),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: ListTile(
                                  onTap: () {
                                    blocCity.add(CountrySelect(country: countrySearchResult[index]));
                                    blocCity.add(CountryChanged());
                                    Navigator.of(context).pop();
                                  },
                                  title: Text(
                                    countrySearchResult[index].name,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  leading: IconButton(
                                    icon: Image.asset(
                                      'icons/flags/png/${countrySearchResult[index].flag}.png',
                                      package: 'country_icons',
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : Scaffold(
                          body: Text('sonuç yok'),
                        ),
            );
          }
          return buildLoadingWidget();
        },
      ),
    );
  }
}
