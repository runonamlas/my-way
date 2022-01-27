import 'package:my_way/model/city.dart';

class CityResponse {
  final List<CityModel> cities;
  final String error;

  CityResponse(this.cities, this.error);

  CityResponse.fromJson(List<dynamic> json)
      : cities = json.map((i) => CityModel.fromJson(i)).toList(),
        error = '';

  CityResponse.withError(String errorValue)
      : cities = [],
        error = errorValue;
}
