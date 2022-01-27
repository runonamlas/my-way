import 'package:my_way/model/city.dart';
import 'package:my_way/model/place.dart';
class RouteModel {
  final String id;
  final String name;
  final String image;
  final CityModel city;
  final List<PlaceModel> places;

  RouteModel(this.id, this.name, this.image, this.city,
      this.places);

  RouteModel.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        name = json['name'],
        image = json['image'],
        city = CityModel.fromJson(json['city']),
        places = (json['places'] as List).map((i) => PlaceModel.fromJson(i)).toList();
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'city': city,
      'places': places
    };
  }
}
