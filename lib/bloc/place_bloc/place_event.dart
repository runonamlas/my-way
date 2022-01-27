import 'package:equatable/equatable.dart';

abstract class PlaceEvent extends Equatable {
  const PlaceEvent();

  @override
  List<Object> get props => [];
}

class GetPlaces extends PlaceEvent {}


// class CityChanged extends PlaceEvent {}

// class PlaceSelect extends PlaceEvent {
//   final PlaceModel place;
//   const PlaceSelect({@required this.place});

//   @override
//   List<Object> get props => [place];

//   @override
//   String toString() => 'CitySelect {$place}';
// }