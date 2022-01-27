import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_way/model/city.dart';
import 'package:my_way/model/country.dart';
import 'package:my_way/model/place.dart';
import 'package:my_way/model/route.dart';
import 'package:my_way/model/route_response.dart';
import 'dart:convert';

class RouteRepository {
  static String mainUrl = 'https://my-way-app.herokuapp.com';
  var getRouteUrl = mainUrl + '/api/routes/';
  var getSavesRouteUrl = mainUrl + '/api/user/saved/';

  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final Dio _dio = Dio();

  // Future<void> writeRoute(RouteModel route) async {
  //   final _route = json.encode(route);
  //   await _storage.write(key: 'routes', value: _route);
  // }

  Future<RouteResponse> getRoutes() async {
    var token = await _storage.read(key: 'token');
    var city = await _storage.read(key: 'city');
    var cityModel = CityModel.fromJson(json.decode(city));
    _dio.options.headers['authorization'] = token;
    try {
      var response = await _dio
          .get(getRouteUrl, queryParameters: {'city_id': cityModel.id});
      return RouteResponse.fromJson(response.data['data']);
    } catch (error, stacktrace) {
      print('Exception occured: $error stackTrace: $stacktrace');
      return RouteResponse.withError(error);
    }
  }

  Future<bool> createRoute(String name, List<PlaceModel> places) async {
    var token = await _storage.read(key: 'token');
    var city = await _storage.read(key: 'city');
    var image = 'https://source.unsplash.com/1600x900/?' + name.toString();
    var placePostList = [];
    var cityModel = CityModel.fromJson(json.decode(city));
    _dio.options.headers['authorization'] = token;
    places.forEach((e) {
      var map = {};
      map['id'] = int.parse(e.id);
      placePostList.add(map);
    });
    print(',kkk');
    try {
      print('this burada');
      var response = await _dio.post(getRouteUrl, data: {
        'name': name,
        'image': image,
        'cityID': int.parse(cityModel.id),
        'places': placePostList,
      });
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (error, stacktrace) {
      print('Exception occured: $error stackTrace: $stacktrace');
      return false;
    }
  }

  Future<RouteResponse> getSavedRoutes() async {
    var token = await _storage.read(key: 'token');
    var country = await _storage.read(key: 'country');
    var countryModel = CountryModel.fromJson(json.decode(country));
    _dio.options.headers['authorization'] = token;
    try {
      var response = await _dio.get(getSavesRouteUrl,
          queryParameters: {'country_id': countryModel.id});
      if (response.data['data'] != null) {
        var routeResponse = RouteResponse.fromJson(response.data['data']);
        final _routesJson =
            jsonEncode(routeResponse.routes.map((e) => e.toJson()).toList());
        await _storage.write(key: 'saved', value: _routesJson);
        return routeResponse;
      }
      return RouteResponse([], 'null');
    } catch (error, stacktrace) {
      print('Exception occured: $error stackTrace: $stacktrace');
      return RouteResponse.withError(error);
    }
  }

  Future<RouteResponse> getLocalSavedRoutes() async {
    var saved = await _storage.read(key: 'saved');
    if (saved != null) {
      var savedResponseModel = RouteResponse.fromJson(json.decode(saved));
      return savedResponseModel;
    }
    return RouteResponse([], 'null');
  }

  Future<bool> addSaved(RouteModel route) async {
    var token = await _storage.read(key: 'token');
    _dio.options.headers['authorization'] = token;
    try {
      var response = await _dio.post(getSavesRouteUrl + route.id);
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (error, stacktrace) {
      print('Exception occured: $error stackTrace: $stacktrace');
      return false;
    }
  }

  Future<RouteResponse> deleteSavedRoute(RouteModel route) async {
    var token = await _storage.read(key: 'token');
    var value = await _storage.read(key: 'saved');
    var routes = RouteResponse.fromJson(json.decode(value));
    _dio.options.headers['authorization'] = token;
    try {
      var response = await _dio.delete(getSavesRouteUrl + route.id);
      if (response.statusCode == 200) {
        routes.routes.removeWhere((element) => element.id == route.id);
        final _routes = json.encode(routes.routes);
        await _storage.write(key: 'saved', value: _routes);
        return routes;
      }
      return routes;
    } catch (error, stacktrace) {
      print('Exception occured: $error stackTrace: $stacktrace');
      return RouteResponse.withError(error);
    }
  }
}
