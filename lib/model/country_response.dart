import 'package:my_way/model/country.dart';

class CountryResponse {
  final List<CountryModel> countries;
  final String error;

  CountryResponse(this.countries, this.error);

  CountryResponse.fromJson(List<dynamic> json)
      : countries = json.map((i) => CountryModel.fromJson(i)).toList(),
        error = '';

  CountryResponse.withError(String errorValue)
      : countries = [],
        error = errorValue;
}
