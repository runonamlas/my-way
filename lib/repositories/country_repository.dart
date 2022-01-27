import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_way/model/country.dart';
import 'package:my_way/model/country_response.dart';

class CountryRepository {
  static String mainUrl = 'https://my-way-app.herokuapp.com';
  var getCountriesUrl = mainUrl + '/api/countries';

  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final Dio _dio = Dio();

  Future<bool> hasCountry() async {
    var value = await _storage.read(key: 'country');
    if (value != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<CountryModel> readCountry() async {
    var value = await _storage.read(key: 'country');
    var country = CountryModel.fromJson(json.decode(value));
    return country;
  }

  Future<void> writeCountry(CountryModel country) async {
    final _country = json.encode(country);
    await _storage.write(key: 'country', value: _country);
  }

  Future<CountryResponse> getCountries() async {
    var token = await _storage.read(key: 'token');
    _dio.options.headers['authorization'] = token;
    try {
      var response = await _dio.get(getCountriesUrl);
      return CountryResponse.fromJson(response.data['data']);
    } catch (error, stacktrace) {
      print('Exception occured: $error stackTrace: $stacktrace');
      return CountryResponse.withError(error);
    }
  }
}
