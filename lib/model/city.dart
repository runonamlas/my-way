import 'package:my_way/model/country.dart';

class CityModel {
  final String id;
  final String name;
  final String image;
  final CountryModel country;

  CityModel(this.id, this.name, this.image, this.country);

  CityModel.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        name = json['name'],
        image = json['image'],
        country = CountryModel.fromJson(json['country']);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'country': country
    };
  }
}
