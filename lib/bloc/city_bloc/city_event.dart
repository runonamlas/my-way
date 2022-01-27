import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:my_way/model/city.dart';
import 'package:my_way/model/country.dart';

abstract class CityEvent extends Equatable {
  const CityEvent();

  @override
  List<Object> get props => [];
}

class GetCities extends CityEvent {}

class GetCountries extends CityEvent {}
class GetCountry extends CityEvent {}
class CountryChanged extends CityEvent {}

class CitySelect extends CityEvent {
  final CityModel city;
  const CitySelect({@required this.city});

  @override
  List<Object> get props => [city];

  @override
  String toString() => 'CitySelect {$city}';
}

class CountrySelect extends CityEvent {
  final CountryModel country;
  const CountrySelect({@required this.country});

  @override
  List<Object> get props => [country];

  @override
  String toString() => 'CountrySelect {$country}';
}
