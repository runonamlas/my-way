import 'package:equatable/equatable.dart';
import 'package:my_way/model/place_response.dart';

abstract class PlaceState extends Equatable {
  @override
  List<Object> get props => [];
}

class PlaceInitial extends PlaceState { }

class PlaceLoading extends PlaceState { }

class PlaceSuccess extends PlaceState {
  final PlaceResponse places;
  PlaceSuccess(this.places);
}

class PlaceFailure extends PlaceState { }