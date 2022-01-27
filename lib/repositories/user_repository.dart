import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_way/model/city.dart';

class UserRepository {
  static String mainUrl = 'https://my-way-app.herokuapp.com';
  var loginUrl = '/api/auth/login';
  var registerUrl = '/api/auth/register';

  final FlutterSecureStorage storage = FlutterSecureStorage();
  final Dio _dio = Dio();

  Future<bool> hasToken() async {
    var value = await storage.read(key: 'token');
    if (value != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<CityModel> hasCity() async {
    var value = await storage.read(key: 'city');
    if (value == null) {
      return null;
    }
    var city = CityModel.fromJson(json.decode(value));
    return city;
  }

  Future<void> writeToken(String token) async {
    await storage.write(key: 'token', value: token);
  }

  Future<void> firstOpenLogWrite() async {
    await storage.write(key: 'firstOpen', value: 'false');
  }

  Future<bool> firstOpen() async {
    var value = await storage.read(key: 'firstOpen');
    if (value == null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> deleteToken() async {
    await storage.delete(key: 'token');
  }

  Future<String> login(String email, String password) async {
    var response = await _dio.post(
      mainUrl + loginUrl,
      data: {'email': email, 'password': password},
    );
    return response.data['data']['token'];
  }

  Future<String> register(
      String username, String callNumber, String email, String password) async {
    var response = await _dio.post(
      mainUrl + registerUrl,
      data: {
        'username': username,
        'callNumber': callNumber,
        'email': email,
        'password': password
      },
    );
    return response.data['data']['token'];
  }
}
