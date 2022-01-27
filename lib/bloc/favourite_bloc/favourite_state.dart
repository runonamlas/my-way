import 'package:equatable/equatable.dart';
import 'package:my_way/model/country.dart';
import 'package:my_way/model/place_response.dart';

abstract class FavouriteState extends Equatable {
  @override
  List<Object> get props => [];
}

class FavouriteInitial extends FavouriteState {}

class FavouriteLoading extends FavouriteState {}

class FavouriteSuccess extends FavouriteState {
  final PlaceResponse places;
  final CountryModel country;
  FavouriteSuccess(this.places, this.country);
}

class AddFavouriteSuccess extends FavouriteState{}
class FailureFavouriteSuccess extends FavouriteState{}

class FavouriteFailure extends FavouriteState {}
