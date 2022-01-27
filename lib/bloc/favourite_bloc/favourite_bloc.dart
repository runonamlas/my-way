import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_way/bloc/favourite_bloc/favourite_event.dart';
import 'package:my_way/bloc/favourite_bloc/favourite_state.dart';
import 'package:my_way/repositories/country_repository.dart';
import 'package:my_way/repositories/place_repository.dart';

class FavouriteBloc extends Bloc<FavouriteEvent, FavouriteState> {
  final PlaceRepository placeRepository;
  final CountryRepository countryRepository;

  FavouriteBloc(
      {@required this.placeRepository, @required this.countryRepository})
      : assert(placeRepository != null, countryRepository != null),
        super(null);

  FavouriteState get initialState => FavouriteInitial();

  @override
  Stream<FavouriteState> mapEventToState(FavouriteEvent event) async* {
    final country = await countryRepository.readCountry();
    if (event is GetFavourites) {
      yield FavouriteLoading();
      final places = await placeRepository.getFavourites();
      yield FavouriteSuccess(places, country);
    }
    if (event is GetLocalFavourites) {
      yield FavouriteLoading();
      final places = await placeRepository.getLocalFavourites();
      yield FavouriteSuccess(places, country);
    }
    if (event is AddFavourite) {
      yield FavouriteLoading();
      final success = await placeRepository.addFavourite(event.placeModel);
      if (success) {
        yield AddFavouriteSuccess();
      } else {
        yield FailureFavouriteSuccess();
      }
    }
    if (event is DeleteFavourite) {
      yield FavouriteLoading();
      final places = await placeRepository.deleteFavourite(event.placeModel);
      yield FavouriteSuccess(places, country);
    }
  }
}

final placeBloc = FavouriteBloc(placeRepository: null, countryRepository: null);
