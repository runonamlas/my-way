import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_way/model/place.dart';
import 'package:my_way/model/route.dart';

abstract class RouteEvent extends Equatable {
  const RouteEvent();

  @override
  List<Object> get props => [];
}

class GetRoutes extends RouteEvent {}

class CreateRoutes extends RouteEvent {
  final String routeName;
  final List<PlaceModel> places;

  const CreateRoutes({@required this.routeName, @required this.places});

  @override
  List<Object> get props => [routeName, places];

  @override
  String toString() => 'CreateRoutes {$routeName} Places: $places';
}

class GetSavedRoutes extends RouteEvent {}
class GetLocalSavedRoutes extends RouteEvent {}

class AddSaved extends RouteEvent {
  final RouteModel routeModel;
  const AddSaved({@required this.routeModel});

  @override
  List<Object> get props => [routeModel];

  @override
  String toString() => 'AddSaved {$routeModel}';
}

class DeleteSaved extends RouteEvent {
  final RouteModel routeModel;
  const DeleteSaved({@required this.routeModel});

  @override
  List<Object> get props => [routeModel];

  @override
  String toString() => 'DeleteSaved {$routeModel}';
}
