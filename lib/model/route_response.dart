import 'package:my_way/model/route.dart';

class RouteResponse {
  final List<RouteModel> routes;
  final String error;

  RouteResponse(this.routes, this.error);

  RouteResponse.fromJson(List<dynamic> json)
      : routes = json .map((i) => RouteModel.fromJson(i)).toList(),
        error = '';

  RouteResponse.withError(String errorValue)
      : routes = [],
        error = errorValue;
}
