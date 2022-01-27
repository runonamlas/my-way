import 'package:my_way/model/city.dart';

class PlaceModel {
  final String id;
  final String name;
  final String image;
  final String desc;
  final double star;
  final double lat;
  final double long;
  final CityModel city;

  PlaceModel(this.id, this.name, this.image, this.desc, this.star, this.lat,
      this.long, this.city);

  PlaceModel.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        name = json['name'],
        image = json['image'],
        desc = json['desc'],
        star = json['star'],
        lat = json['lat'],
        long = json['long'],
        city = CityModel.fromJson(json['city']);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'desc': desc,
      'star': star,
      'lat': lat,
      'long': long,
      'city': city
    };
  }
}
