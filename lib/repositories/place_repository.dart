import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_way/model/city.dart';
import 'package:my_way/model/country.dart';
import 'package:my_way/model/place.dart';
import 'package:my_way/model/place_response.dart';

class PlaceRepository {
  static String mainUrl = 'https://my-way-app.herokuapp.com';
  var getPlacesUrl = mainUrl + '/api/places';
  var getFavouritesPlacesUrl = mainUrl + '/api/user/favourite/';
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final Dio _dio = Dio();

  // Future<void> writeCity(String cityId) async {
  //   await _storage.write(key: 'city_id', value: cityId);
  // }

  Future<PlaceResponse> getPlaces() async {
    var token = await _storage.read(key: 'token');
    var city = await _storage.read(key: 'city');
    var cityModel = CityModel.fromJson(json.decode(city));
    _dio.options.headers['authorization'] = token;
    try {
      var response = await _dio
          .get(getPlacesUrl, queryParameters: {'city_id': cityModel.id});
      return PlaceResponse.fromJson(response.data['data']);
    } catch (error, stacktrace) {
      print('Exception occured: $error stackTrace: $stacktrace');
      return PlaceResponse.withError(error);
    }
  }

  Future<PlaceResponse> getFavourites() async {
    var token = await _storage.read(key: 'token');
    var country = await _storage.read(key: 'country');
    var countryModel = CountryModel.fromJson(json.decode(country));
    _dio.options.headers['authorization'] = token;
    try {
      var response = await _dio.get(getFavouritesPlacesUrl,
          queryParameters: {'country_id': countryModel.id});
      if (response.data['data'] != null) {
        var placeResponse = PlaceResponse.fromJson(response.data['data']);
        final _favoritesJson =
            jsonEncode(placeResponse.places.map((e) => e.toJson()).toList());
        await _storage.write(key: 'favourites', value: _favoritesJson);
        return placeResponse;
      }
      return PlaceResponse([], 'null');
    } catch (error, stacktrace) {
      print('Exception occured: $error stackTrace: $stacktrace');
      return PlaceResponse.withError(error);
    }
  }

  Future<PlaceResponse> getLocalFavourites() async {
    var favourites = await _storage.read(key: 'favourites');
    if (favourites != null) {
      var favouritesResponseModel =
        PlaceResponse.fromJson(json.decode(favourites));
      return favouritesResponseModel;
    } else {
      return PlaceResponse([], 'null');
    }
  }

  Future<bool> addFavourite(PlaceModel place) async {
    var token = await _storage.read(key: 'token');
    _dio.options.headers['authorization'] = token;
    try {
      var response = await _dio.post(getFavouritesPlacesUrl + place.id);
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (error, stacktrace) {
      print('Exception occured: $error stackTrace: $stacktrace');
      return false;
    }
  }

  Future<PlaceResponse> deleteFavourite(PlaceModel place) async {
    var token = await _storage.read(key: 'token');
    var value = await _storage.read(key: 'favourites');
    var places = PlaceResponse.fromJson(json.decode(value));
    _dio.options.headers['authorization'] = token;
    try {
      var response = await _dio.delete(getFavouritesPlacesUrl + place.id);
      if (response.statusCode == 200) {
        places.places.removeWhere((element) => element.id == place.id);
        final _places = json.encode(places.places);
        await _storage.write(key: 'favourites', value: _places);
        return places;
      }
      return places;
    } catch (error, stacktrace) {
      print('Exception occured: $error stackTrace: $stacktrace');
      return PlaceResponse.withError(error);
    }
  }
}
