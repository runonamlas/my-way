import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_way/model/city.dart';
import 'package:my_way/model/city_response.dart';
import 'package:my_way/model/country.dart';

class CityRepository {
  static String mainUrl = 'https://my-way-app.herokuapp.com';
  var getCitiesUrl = mainUrl + '/api/cities';

  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final Dio _dio = Dio();

  Future<void> writeCity(CityModel city) async {
    final _city = json.encode(city);
    await _storage.write(key: 'city', value: _city);
  }

  Future<CityModel> hasCity() async {
    var value = await _storage.read(key: 'city');
    if (value == null) {
      return null;
    }
    var city = CityModel.fromJson(json.decode(value));
    return city;
  }

  Future<CityResponse> getCities() async {
    var token = await _storage.read(key: 'token');
    var value = await _storage.read(key: 'country');
    var country = CountryModel.fromJson(json.decode(value));

    _dio.options.headers['authorization'] = token;
    try {
      var response = await _dio.get(getCitiesUrl, queryParameters: {'country_id': country.id});
      var cityResponse = CityResponse.fromJson(response.data['data']);
      return cityResponse;
    } catch (error, stacktrace) {
      print('Exception occured: $error stackTrace: $stacktrace');
      return CityResponse.withError(error);
    }
  }
}
