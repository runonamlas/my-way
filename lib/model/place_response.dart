import 'package:my_way/model/place.dart';

class PlaceResponse {
  final List<PlaceModel> places;
  final String error;

  PlaceResponse(this.places, this.error);

  PlaceResponse.fromJson(List<dynamic> json)
      : places = json.map((i) => PlaceModel.fromJson(i)).toList(),
        error = '';

  PlaceResponse.withError(String errorValue)
      : places = [],
        error = errorValue;
  
  Map<String, dynamic> toJson() {
    return {
      'places': places,
      'error': error
    };
  }
}
