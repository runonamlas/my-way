import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_way/bloc/place_bloc/place.dart';
import 'package:my_way/model/city.dart';
import 'package:my_way/model/country.dart';
import 'package:my_way/repositories/city_repository.dart';
import 'package:my_way/repositories/place_repository.dart';

class PlaceBloc extends Bloc<PlaceEvent, PlaceState> {
  final PlaceRepository placeRepository;

  PlaceBloc({@required this.placeRepository})
      : assert(placeRepository != null),
        super(null);

  PlaceState get initialState => PlaceInitial();

  @override
  Stream<PlaceState> mapEventToState(PlaceEvent event) async* {
    if (event is GetPlaces) {
      yield PlaceLoading();
      var hasCity = await CityRepository().hasCity();
      if (hasCity == null) {
        await CityRepository().writeCity(CityModel('id', 'name', 'image', CountryModel('id', 'name', 'flag')));
      }
      final places = await placeRepository.getPlaces();
      yield PlaceSuccess(places);
    }
  }
}

final placeBloc = PlaceBloc(placeRepository: null);
