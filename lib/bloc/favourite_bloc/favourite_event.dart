import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:my_way/model/place.dart';

abstract class FavouriteEvent extends Equatable {
  const FavouriteEvent();

  @override
  List<Object> get props => [];
}

class GetFavourites extends FavouriteEvent {}
class GetLocalFavourites extends FavouriteEvent {}

class AddFavourite extends FavouriteEvent {
  final PlaceModel placeModel;
  const AddFavourite({@required this.placeModel});

  @override
  List<Object> get props => [placeModel];

  @override
  String toString() => 'AddFavourite {$placeModel}';
}

class DeleteFavourite extends FavouriteEvent {
  final PlaceModel placeModel;
  const DeleteFavourite({@required this.placeModel});

  @override
  List<Object> get props => [placeModel];

  @override
  String toString() => 'DeleteFavourite {$placeModel}';
}
