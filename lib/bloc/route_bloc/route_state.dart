import 'package:equatable/equatable.dart';
import 'package:my_way/model/country.dart';
import 'package:my_way/model/route_response.dart';

abstract class RouteState extends Equatable {
  @override
  List<Object> get props => [];
}

class RouteInitial extends RouteState {}

class RouteLoading extends RouteState {}

class RouteSuccess extends RouteState {
  final RouteResponse routes;
  RouteSuccess(this.routes);
}

class CreateRouteSuccess extends RouteState {}
class CreateRouteFailure extends RouteState {}

class SavedRoutesSuccess extends RouteState {
  final RouteResponse routes;
  final CountryModel country;
  SavedRoutesSuccess(this.routes, this.country);
}

class AddSavedSuccess extends RouteState{}
class FailureAddSavedSuccess extends RouteState{}

class SavedRoutesFailure extends RouteState {}

class RouteFailure extends RouteState {}
