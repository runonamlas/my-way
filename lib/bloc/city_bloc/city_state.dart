import 'package:equatable/equatable.dart';
import 'package:my_way/model/city_response.dart';
import 'package:my_way/model/country.dart';
import 'package:my_way/model/country_response.dart';

abstract class CityState extends Equatable {
  @override
  List<Object> get props => [];
}

class CityInitial extends CityState {}

class CityLoading extends CityState {}

class CitySuccess extends CityState {
  final CountryModel country;
  final CityResponse cities;
  CitySuccess(this.cities, this.country);
}

class CityFailure extends CityState {}

class CountryLoading extends CityState {}

class CountrySuccess extends CityState {
  final CountryResponse countries;
  final CountryModel localCountry;

  CountrySuccess(this.countries, this.localCountry);
}

class CountryFailure extends CityState {}

class GetCountrySucces extends CityState {
  final CountryModel country;
  GetCountrySucces(this.country);
}
